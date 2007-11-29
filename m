Return-Path: <linux-kernel-owner+w=401wt.eu-S1763194AbXK2RK5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763194AbXK2RK5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 12:10:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762735AbXK2RKr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 12:10:47 -0500
Received: from mo11.iij4u.or.jp ([210.138.174.79]:37849 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762734AbXK2RKq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 12:10:46 -0500
Date: Fri, 30 Nov 2007 02:09:52 +0900
To: anders.henke@1und1.de
Cc: tomof@acm.org, jack@ucw.cz, fujita.tomonori@lab.ntt.co.jp,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: broken dpt_i2o in 2.6.23 (was: ext2_check_page: bad entry in
 directory) (fwd)
From: FUJITA Tomonori <tomof@acm.org>
In-Reply-To: <20071129164557.GD30957@1und1.de>
References: <20071129130319.GA2642@atrey.karlin.mff.cuni.cz>
	<20071129235813Y.tomof@acm.org>
	<20071129164557.GD30957@1und1.de>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20071130021226T.tomof@acm.org>
X-Dispatcher: imput version 20040704(IM147)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Nov 2007 17:45:57 +0100
Anders Henke <anders.henke@1und1.de> wrote:

> On Nov 29 2007, FUJITA Tomonori wrote:
> > On Thu, 29 Nov 2007 14:03:19 +0100
> > Jan Kara <jack@ucw.cz> wrote:
> > 
> > >   Adding relevant people and lists to CC...
> > > 
> > > 									Honza
> > > 
> > > ----- Forwarded message from Anders Henke <anders.henke@1und1.de> -----
> > > 
> > > Date:	Thu, 29 Nov 2007 13:31:50 +0100
> > > From: Anders Henke <anders.henke@1und1.de>
> > > To: linux-kernel@vger.kernel.org
> > > Subject: Re: broken dpt_i2o in 2.6.23 (was: ext2_check_page: bad entry in directory)
> > > User-Agent: Mutt/1.5.13 (2006-08-11)
> > > 
> > > On November 28 2007, Anders Henke wrote:
> > > > As "everything is reported as being zero" is quite odd an Jan took a
> > > > guess that it might be block-layer or driver-related, I've assumed
> > > > that the driver is responsible for this; just out of the curiousity, 
> > > > I've manually replaced the dpt_i2o driver by the 2.6.19 one by copying 
> > > > driver/scsi/dpt_i2o.c driver/scsi/dpti.h and driver/scsi/dpt/ into a 
> > > > vanilla 2.6.23.1. kernel; using this kernel fixed the issue for me.
> > > > 
> > > > I haven't yet fine-tested from which kernel release on the dpt_i2o driver 
> > > > behaves like this and spews out zeroed blocks when trying to mount
> > > > the rootfs. Maybe this is just some timing issue.
> > > 
> > > I've started the fine-tests and can say so far that dpt_i2o from 
> > > 2.6.22 is still fine. Test is simple:
> > > 
> > > anders@ista:/usr/src/linux-2.6.22/drivers/scsi/dpt$ cp -r dpt/ dpt_i2o.c dpti.h /usr/src/linux-2.6.23.1/drivers/scsi/
> > > 
> > > ... recompile the kernel, reboot: works.
> > > 
> > > 2.6.22 and 2.6.23 differ in terms of the dpt_i2o driver by two different
> > > patch sets:
> > > -one 2 Kb small set of patches from 2.6.22 to 2.6.22-rc1
> > > -one 7 Kb set of patches from 2.6.23-rc2 to 2.6.23-rc3
> > > -one 162 Kb set of patches from 2.6.23-rc9 to 2.6.23-rc10.
> > > 
> > > When applying the 2.6.23-rc1-based driver to "my" 2.6.31.1 kernel,
> > > the "zero blocks"-symptom show up, so it's the "lucky" situation
> > > that the smallest patch actually seams to be the broken one.
> > > 
> > > According to the 2.6.23-rc1 short-form changelog, there is
> > > one major edit on the dpt_i2o driver:
> > > 
> > > FUJITA Tomonori 
> > > 
> > >       [SCSI] dpt_i2o: convert to use the data buffer accessors
> > > 
> > > Stephen Rothwell 
> > >       dpt_i2o depends on virt_to_bus
> > > 
> > > Fujita, would you please take a look at this?
> > 
> > Sorry about the bug. Can you try this?
> > 
> > 
> > diff --git a/drivers/scsi/dpt_i2o.c b/drivers/scsi/dpt_i2o.c
> > index 8258506..1255b26 100644
> > --- a/drivers/scsi/dpt_i2o.c
> > +++ b/drivers/scsi/dpt_i2o.c
> > @@ -3295,7 +3295,7 @@ static struct scsi_host_template adpt_template = {
> >  	.this_id		= 7,
> >  	.cmd_per_lun		= 1,
> >  	.use_clustering		= ENABLE_CLUSTERING,
> > -	.use_sg_chaining	= ENABLE_SG_CHAINING,
> > +	.use_sg_chaining	= DISABLE_SG_CHAINING,
> >  };
> >  
> >  static s32 adpt_scsi_register(adpt_hba* pHba)
> 
> The structure to patch does look different and doesn't include an
> tag "use_sg_chaining":

Sorry, I misread your bug report. If you use 2.6.23, the sg chaining
is unrelated.

What architecture do you use?
