Return-Path: <linux-kernel-owner+w=401wt.eu-S1756186AbZBWPBa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756186AbZBWPBa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 10:01:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755448AbZBWPBF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 10:01:05 -0500
Received: from g4t0017.houston.hp.com ([15.201.24.20]:48061 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755376AbZBWPBE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 10:01:04 -0500
From: "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>
To: Jens Axboe <jens.axboe@oracle.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "coldwell@redhat.com" <coldwell@redhat.com>
Date: Mon, 23 Feb 2009 15:00:44 +0000
Subject: RE: [GIT PULL] block bits for 2.6.29-rc5
Thread-Topic: [GIT PULL] block bits for 2.6.29-rc5
Thread-Index: AcmVp5QlmOyy+zInQGmt11tr4MpuWgAH+QEw
Message-ID: <0F5B06BAB751E047AB5C87D1F77A77885CA670ED2E@GVW0547EXC.americas.hpqcorp.net>
References: <20090218144105.GZ30821@kernel.dk>
 <20090219170715.47781cc2.akpm@linux-foundation.org>
 <20090220164055.GZ29783@kernel.dk>
 <0F5B06BAB751E047AB5C87D1F77A77885CA670E6F8@GVW0547EXC.americas.hpqcorp.net>
 <20090220165354.GB29783@kernel.dk>
 <0F5B06BAB751E047AB5C87D1F77A77885CA670E82F@GVW0547EXC.americas.hpqcorp.net>
 <20090223110936.GY29783@kernel.dk>
In-Reply-To: <20090223110936.GY29783@kernel.dk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 

> -----Original Message-----
> From: Jens Axboe [mailto:jens.axboe@oracle.com] 
> Sent: Monday, February 23, 2009 5:10 AM
> To: Miller, Mike (OS Dev)
> Cc: Andrew Morton; torvalds@linux-foundation.org; 
> linux-kernel@vger.kernel.org; coldwell@redhat.com
> Subject: Re: [GIT PULL] block bits for 2.6.29-rc5
> 
> On Fri, Feb 20 2009, Miller, Mike (OS Dev) wrote:
> > Jens wrote:
> > 
> > > > > Perhaps we should shrink it to something a little more
> > > tolerable and
> > > > > put it in the noop loop instead. 30 seconds is insane...
> > > > 
> > > > Some of these controllers do take a long time to 
> recover from the 
> > > > reset because the firmware has to re-initialize. The 
> firmware guys 
> > > > claim that's only a few seconds but that's not true.
> > > > 
> > > > Granted, the 5i is old as dirt. Don't know how many are 
> still out 
> > > > there running newer kernels.
> > > 
> > > So a small improvement would be to do that delay only for 5i. 
> > > Or how about just being a little more relaxed, ala the below? 
> > > It's still 30 seconds in total, but that's now worst case. 
> > > Will the 5i crap itself if we attempt to talk to it too soon?
> > > 
> > > diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c index 
> > > d2cb67b..b5a0611 100644
> > > --- a/drivers/block/cciss.c
> > > +++ b/drivers/block/cciss.c
> > > @@ -3611,11 +3611,15 @@ static int __devinit 
> cciss_init_one(struct 
> > > pci_dev *pdev,
> > >  		schedule_timeout_uninterruptible(30*HZ);
> > >  
> > >  		/* Now try to get the controller to respond to 
> a no-op */
> > > -		for (i=0; i<12; i++) {
> > > +		for (i=0; i<30; i++) {
> > >  			if (cciss_noop(pdev) == 0)
> > >  				break;
> > > -			else
> > > -				printk("cciss: no-op 
> > > failed%s\n", (i < 11 ? "; re-trying" : ""));
> > > +
> > > +			schedule_timeout_uninterruptible(HZ);
> > > +		}
> > > +		if (i == 30) {
> > > +			printk(KERN_ERR "cciss: controller
> > > seems dead\n");
> > > +			return -EBUSY;
> > >  		}
> > >  	}
> > 
> > The controller won't crap the bed, it will just ignore any requests 
> > until it becomes ready. I don't see any problem with this change.
> 
> OK, then it should be safe enough. I've added the patch to 
> the upstream queue, with your reviewed-by tag.
> 
> --
> Jens Axboe
> 

Thanks, Jens.
> 