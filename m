Return-Path: <linux-kernel-owner+w=401wt.eu-S1755110AbZBWLMm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755110AbZBWLMm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 06:12:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754879AbZBWLMM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 06:12:12 -0500
Received: from brick.kernel.dk ([93.163.65.50]:28452 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753295AbZBWLML (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 06:12:11 -0500
Date: Mon, 23 Feb 2009 12:09:37 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "coldwell@redhat.com" <coldwell@redhat.com>
Subject: Re: [GIT PULL] block bits for 2.6.29-rc5
Message-ID: <20090223110936.GY29783@kernel.dk>
References: <20090218144105.GZ30821@kernel.dk> <20090219170715.47781cc2.akpm@linux-foundation.org> <20090220164055.GZ29783@kernel.dk> <0F5B06BAB751E047AB5C87D1F77A77885CA670E6F8@GVW0547EXC.americas.hpqcorp.net> <20090220165354.GB29783@kernel.dk> <0F5B06BAB751E047AB5C87D1F77A77885CA670E82F@GVW0547EXC.americas.hpqcorp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0F5B06BAB751E047AB5C87D1F77A77885CA670E82F@GVW0547EXC.americas.hpqcorp.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 20 2009, Miller, Mike (OS Dev) wrote:
> Jens wrote:
> 
> > > > Perhaps we should shrink it to something a little more 
> > tolerable and 
> > > > put it in the noop loop instead. 30 seconds is insane...
> > > 
> > > Some of these controllers do take a long time to recover from the 
> > > reset because the firmware has to re-initialize. The firmware guys 
> > > claim that's only a few seconds but that's not true.
> > > 
> > > Granted, the 5i is old as dirt. Don't know how many are still out 
> > > there running newer kernels.
> > 
> > So a small improvement would be to do that delay only for 5i. 
> > Or how about just being a little more relaxed, ala the below? 
> > It's still 30 seconds in total, but that's now worst case. 
> > Will the 5i crap itself if we attempt to talk to it too soon?
> > 
> > diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c 
> > index d2cb67b..b5a0611 100644
> > --- a/drivers/block/cciss.c
> > +++ b/drivers/block/cciss.c
> > @@ -3611,11 +3611,15 @@ static int __devinit 
> > cciss_init_one(struct pci_dev *pdev,
> >  		schedule_timeout_uninterruptible(30*HZ);
> >  
> >  		/* Now try to get the controller to respond to 
> > a no-op */
> > -		for (i=0; i<12; i++) {
> > +		for (i=0; i<30; i++) {
> >  			if (cciss_noop(pdev) == 0)
> >  				break;
> > -			else
> > -				printk("cciss: no-op 
> > failed%s\n", (i < 11 ? "; re-trying" : ""));
> > +
> > +			schedule_timeout_uninterruptible(HZ);
> > +		}
> > +		if (i == 30) {
> > +			printk(KERN_ERR "cciss: controller 
> > seems dead\n");
> > +			return -EBUSY;
> >  		}
> >  	}
> 
> The controller won't crap the bed, it will just ignore any requests
> until it becomes ready. I don't see any problem with this change.

OK, then it should be safe enough. I've added the patch to the upstream
queue, with your reviewed-by tag.

-- 
Jens Axboe

