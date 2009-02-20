Return-Path: <linux-kernel-owner+w=401wt.eu-S1756574AbZBTQ4c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756574AbZBTQ4c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 11:56:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753241AbZBTQ4X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 11:56:23 -0500
Received: from brick.kernel.dk ([93.163.65.50]:1924 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752851AbZBTQ4X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 11:56:23 -0500
Date: Fri, 20 Feb 2009 17:53:54 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "coldwell@redhat.com" <coldwell@redhat.com>
Subject: Re: [GIT PULL] block bits for 2.6.29-rc5
Message-ID: <20090220165354.GB29783@kernel.dk>
References: <20090218144105.GZ30821@kernel.dk> <20090219170715.47781cc2.akpm@linux-foundation.org> <20090220164055.GZ29783@kernel.dk> <0F5B06BAB751E047AB5C87D1F77A77885CA670E6F8@GVW0547EXC.americas.hpqcorp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0F5B06BAB751E047AB5C87D1F77A77885CA670E6F8@GVW0547EXC.americas.hpqcorp.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 20 2009, Miller, Mike (OS Dev) wrote:
>  
> 
> > -----Original Message-----
> > From: Jens Axboe [mailto:jens.axboe@oracle.com] 
> > Sent: Friday, February 20, 2009 10:41 AM
> > To: Andrew Morton
> > Cc: torvalds@linux-foundation.org; 
> > linux-kernel@vger.kernel.org; Miller, Mike (OS Dev)
> > Subject: Re: [GIT PULL] block bits for 2.6.29-rc5
> > 
> > On Thu, Feb 19 2009, Andrew Morton wrote:
> > > On Wed, 18 Feb 2009 15:41:06 +0100
> > > Jens Axboe <jens.axboe@oracle.com> wrote:
> > > 
> > > > @@ -3404,6 +3601,24 @@ static int __devinit 
> > cciss_init_one(struct pci_dev *pdev,
> > > >  	int dac, return_code;
> > > >  	InquiryData_struct *inq_buff = NULL;
> > > >  
> > > > +	if (reset_devices) {
> > > > +		/* Reset the controller with a PCI power-cycle */
> > > > +		if (cciss_hard_reset_controller(pdev) || 
> > cciss_reset_msi(pdev))
> > > > +			return -ENODEV;
> > > > +
> > > > +		/* Some devices (notably the HP Smart Array 5i 
> > Controller)
> > > > +		   need a little pause here */
> > > > +		schedule_timeout_uninterruptible(30*HZ);
> > > 
> > > little!
> > 
> > That does qualify as the understatement of the day :-)
> > 
> > > Perhaps we should do a printk("no, your machine is not dead") here.
> > 
> > Perhaps we should shrink it to something a little more 
> > tolerable and put it in the noop loop instead. 30 seconds is insane...
> 
> Some of these controllers do take a long time to recover from the
> reset because the firmware has to re-initialize. The firmware guys
> claim that's only a few seconds but that's not true.
> 
> Granted, the 5i is old as dirt. Don't know how many are still out
> there running newer kernels. 

So a small improvement would be to do that delay only for 5i. Or how
about just being a little more relaxed, ala the below? It's still 30
seconds in total, but that's now worst case. Will the 5i crap itself if
we attempt to talk to it too soon?

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index d2cb67b..b5a0611 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -3611,11 +3611,15 @@ static int __devinit cciss_init_one(struct pci_dev *pdev,
 		schedule_timeout_uninterruptible(30*HZ);
 
 		/* Now try to get the controller to respond to a no-op */
-		for (i=0; i<12; i++) {
+		for (i=0; i<30; i++) {
 			if (cciss_noop(pdev) == 0)
 				break;
-			else
-				printk("cciss: no-op failed%s\n", (i < 11 ? "; re-trying" : ""));
+
+			schedule_timeout_uninterruptible(HZ);
+		}
+		if (i == 30) {
+			printk(KERN_ERR "cciss: controller seems dead\n");
+			return -EBUSY;
 		}
 	}
 

-- 
Jens Axboe

