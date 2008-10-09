Return-Path: <linux-kernel-owner+w=401wt.eu-S1758111AbYJIG6X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758111AbYJIG6X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 02:58:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752767AbYJIG6K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 02:58:10 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:9901 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751457AbYJIG6I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 02:58:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=JC47bwuZTEi1tQBA6jO5Yj5mlbV39jw4EkMbWX6FnI2rjxCHH7JZodkBv/bIpWeU0A
         2uU9Mb8BRSsVZsQm9p5DN5NumB6dckCOkMLDQ06HtkEGrmojYH5u75rpj5OQxAovwbZz
         CmPkOwntrU1pA8HAMp0XFnW8oQD1gQ2/VcmXk=
Message-ID: <520f0cf10810082358t274a46afy7d9c5bbc5ca56de7@mail.gmail.com>
Date: Thu, 9 Oct 2008 08:58:08 +0200
From: "John Kacur" <jkacur@gmail.com>
To: "Bryan Wu" <cooloney@kernel.org>, alsa-devel@alsa-project.org,
       linux-kernel@vger.kernel.org, "Cliff Cai" <cliff.cai@analog.com>
Subject: Fwd: [PATCH 7/9] ASoC: Blackfin: I2S CPU DAI driver
In-Reply-To: <520f0cf10810082353r2694535evc3edbcb2b3c76796@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1220516528-20301-1-git-send-email-cooloney@kernel.org>
	 <1220516528-20301-8-git-send-email-cooloney@kernel.org>
	 <20080904144343.GB32531@rakim.wolfsonmicro.main>
	 <520f0cf10810082353r2694535evc3edbcb2b3c76796@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 4, 2008 at 4:43 PM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
>
> On Thu, Sep 04, 2008 at 04:22:06PM +0800, Bryan Wu wrote:
> > From: Cliff Cai <cliff.cai@analog.com>
> >
> > Signed-off-by: Cliff Cai <cliff.cai@analog.com>
> > Signed-off-by: Bryan Wu <cooloney@kernel.org>
>
> Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
>
> Please fix the minor issues below as incremental patches for ease of
> review.
>
> > +     switch (fmt & SND_SOC_DAIFMT_FORMAT_MASK) {
> > +     case SND_SOC_DAIFMT_I2S:
> > +             break;
> > +     case SND_SOC_DAIFMT_LEFT_J:
> > +             ret = -EINVAL;
> > +             break;
> > +     }
>
> The SND_SOC_DAFIMT_LEFT_J: ought to be default: instead - there's more
> DAI formats than just that.
>
> > +     if (!bf5xx_i2s.master) {
> > +     /*
> > +      * TX and RX are not independent,they are enabled at the same time,
> > +      * even if only one side is running.So,we need to configure both of
> > +      * them in advance.
> > +      *
> > +      * CPU DAI format:I2S, slave mode.
> > +      */

+       switch (fmt & SND_SOC_DAIFMT_MASTER_MASK) {
+       case SND_SOC_DAIFMT_CBS_CFS:
+               ret = -EINVAL;
+               break;
+       case SND_SOC_DAIFMT_CBM_CFS:
+               ret = -EINVAL;
+               break;
+       case SND_SOC_DAIFMT_CBM_CFM:
+               break;
+       case SND_SOC_DAIFMT_CBS_CFM:
+               ret = -EINVAL;
+               break;
+       default:
+               break;
+       }

My eyes fell upon this switch statement, probably I have similar
criticisms as to what has already been said, but:
1. Surely the default case is also an -EINVAL
2. Why not let all the EINVALS fall through, it will shorten up the
code, and IMO make it more readable, something like this?
+       switch (fmt & SND_SOC_DAIFMT_MASTER_MASK) {
+       case SND_SOC_DAIFMT_CBM_CFM: /* Passing Case */
+               break;
+       case SND_SOC_DAIFMT_CBS_CFS: /* Failing Cases */
+       case SND_SOC_DAIFMT_CBM_CFS:
+       case SND_SOC_DAIFMT_CBS_CFM:
+               ret = -EINVAL;
+               break;
+       default:
+               printk(KERN_INFO "Unknown SND_SOC_DAIFMT kind\n");
+               ret = -EINVAL;
+               break;
+       }
