Return-Path: <linux-kernel-owner+w=401wt.eu-S1759421AbYGJRI0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759421AbYGJRI0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 13:08:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757795AbYGJRH4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 13:07:56 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:36126 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757629AbYGJRHu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 13:07:50 -0400
Subject: Re: [PATCH 05/15] regulator: regulator framework core
From: Liam Girdwood <lg@opensource.wolfsonmicro.com>
To: pHilipp Zabel <philipp.zabel@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       arm kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
In-Reply-To: <74d0deb30807100904o404be423s314cc206a963396c@mail.gmail.com>
References: <1215703578.13431.61.camel@odin>
	 <74d0deb30807100904o404be423s314cc206a963396c@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 10 Jul 2008 18:07:48 +0100
Message-Id: <1215709668.13431.83.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-07-10 at 18:04 +0200, pHilipp Zabel wrote:
> On Thu, Jul 10, 2008 at 5:26 PM, Liam Girdwood
> <lg@opensource.wolfsonmicro.com> wrote:

> > +
> > +/* current constraint check */
> > +static int regulator_check_current_limit(struct regulator_dev *rdev,
> > +                                       int *min_uA, int *max_uA)
> > +{
> > +       BUG_ON(*min_uA > *max_uA);
> > +
> > +       if (!rdev->constraints) {
> > +               printk(KERN_ERR "%s: no constraints for %s\n", __func__,
> > +                      rdev->desc->name);
> > +               return -ENODEV;
> > +       }
> > +       if (!(rdev->constraints->valid_ops_mask & REGULATOR_CHANGE_CURRENT)) {
> > +               printk(KERN_ERR "%s: operation not allowed for %s\n",
> > +                      __func__, rdev->desc->name);
> > +               return -EPERM;
> > +       }
> > +
> > +       if (*max_uA > rdev->constraints->max_uA ||
> > +           *min_uA < rdev->constraints->min_uA) {
> > +               printk(KERN_ERR "%s: invalid current range %d-%duA for %s\n",
> > +                      __func__, *min_uA, *max_uA, rdev->desc->name);
> > +               return -EINVAL;
> > +       }
> > +
> > +       *min_uA = max(*min_uA, rdev->constraints->min_uA);
> > +       *max_uA = min(*max_uA, rdev->constraints->max_uA);
> 
> I don't understand this part. If max_uA > constraints->max_uA or
> min_uA < constraints->min_uA, we returned with -EINVAL above. So in
> this place
> I'd expect min_uA to be >= constraints->min_uA and max_uA <=
> constraints->max_uA, in which case the last two statements are no-ops.
> 

It looks like the limit check with printk was added post min()/max()
here and does indeed make them no-ops. I'll remove.

> In comparison, regulator_check_voltage silently fixes the requested
> voltage range to fit into the constraints. Should
> regulator_check_current_limit do the same?

Yes, current should do the same and make sure the our consumers
requested current window fits into the system constraints like voltage.
Atm it just rejects it.

Thanks

Liam


