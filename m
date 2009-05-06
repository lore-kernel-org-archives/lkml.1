Return-Path: <linux-kernel-owner+w=401wt.eu-S1750848AbZEFE1s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750848AbZEFE1s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 00:27:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755534AbZEFEZ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 00:25:27 -0400
Received: from wf-out-1314.google.com ([209.85.200.168]:58942 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756486AbZEFEZX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 00:25:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=MJtN9fz5fDxaNoYpjCBi3lg9wCbsCWe67Cxh382h9mvA9zsBtTEw20feJfxOK/f1WD
         GUbnQ2Kp50grkhFW1RbbWiWUccmdra78OzOCMYnaWPsHvyQPXld/rugrm3C1SEaas7mJ
         kRyW64mb+W6TlDbw9xvrZVEjfXiKre7fOyC+w=
MIME-Version: 1.0
In-Reply-To: <20090504145700.GA875@avionic-design.de>
References: <1241006627-22811-1-git-send-email-thierry.reding@avionic-design.de>
	 <5d5443650904290623n3712cd7dja653a139cff2cf6d@mail.gmail.com>
	 <483a38b80904291835p51044741p9bd83d33a40031c@mail.gmail.com>
	 <20090504113751.GA22603@avionic-design.de>
	 <5d5443650905040503n501e3b47qc890dc4c71a85b1c@mail.gmail.com>
	 <20090504145700.GA875@avionic-design.de>
Date: Wed, 6 May 2009 13:25:23 +0900
Message-ID: <483a38b80905052125r76358182g7ce6b890c921b655@mail.gmail.com>
Subject: Re: [PATCH] input: Add support for the TSC2003 controller.
From: Kwangwoo Lee <kwangwoo.lee@gmail.com>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Trilok Soni <soni.trilok@gmail.com>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thierry,

On Mon, May 4, 2009 at 11:57 PM, Thierry Reding
<thierry.reding@avionic-design.de> wrote:
> * Trilok Soni wrote:
>> Hi Thierry,
>>
>> On Mon, May 4, 2009 at 5:07 PM, Thierry Reding
>> <thierry.reding@avionic-design.de> wrote:
>> > * Kwangwoo Lee wrote:
>> >> Hi Thierry and Trilok,
>> >>
>> >> On Wed, Apr 29, 2009 at 10:23 PM, Trilok Soni <soni.trilok@gmail.com> wrote:
>> >> > Hi Thierry,
>> >> >
>> >> > I have added linux-omap community. How different is this chip from
>> >> > tsc2007. It looks to me that this chip is not much different from
>> >> > tsc2007 (this is just quick look at the driver). If they
>> >> > are similar please consider using i2c_device_id feature in tsc2007 to
>> >> > accommodate this chip.
>> >>
>> >> I agree with the Trilok's opinion.
>> > [snip]
>> >
>> > I only noticed the tsc2007 driver some time ago, when the tsc2003 was already
>> > finished (it's actually pretty old, I just never got around to submitting
>> > it). However I never got the tsc2007 to work on my platform because it uses
>> > sleeping functions inside the timer handler, which results in an oops right
>> > after the first touchscreen interrupt.
>> >
>> > I guess I could try and fix the tsc2007 properly instead of having a second,
>> > pretty similar driver in the tree.
>> >
>>
>> This could be because of improper locking? If you share a crash we can
>> have look at it.
>
> Attached is a patch that fixes things for me. The problem was that the I2C
> transfers were done in interrupt context which fails for the controller I use
> (PXA270). The attached patch uses a struct work_struct to schedule the I2C
> transfers so they are executed in non-interrupt context.

Thanks for the patch. It looks good. :)
The code in the patch is already merged in the main kernel tree.

@@ -235,7 +245,7 @@ static irqreturn_t tsc2007_irq(int irq, void *handle)
 	spin_lock_irqsave(&ts->lock, flags);

 	if (likely(ts->get_pendown_state())) {
-		disable_irq(ts->irq);
+		disable_irq_nosync(ts->irq);
 		hrtimer_start(&ts->timer, ktime_set(0, TS_POLL_DELAY),
 					HRTIMER_MODE_REL);
 	}

Thanks.

> I've tested the patch on a minimal system with tslib and it work fine with
> ts_calibrate and friends.
>
> Thierry

-- 
Kwangwoo Lee <kwangwoo.lee@gmail.com>
