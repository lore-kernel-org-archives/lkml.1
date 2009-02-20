Return-Path: <linux-kernel-owner+w=401wt.eu-S1754396AbZBTSxS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754396AbZBTSxS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 13:53:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752094AbZBTSxF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 13:53:05 -0500
Received: from g1t0026.austin.hp.com ([15.216.28.33]:12957 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751846AbZBTSxE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 13:53:04 -0500
From: "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>
To: Jens Axboe <jens.axboe@oracle.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "coldwell@redhat.com" <coldwell@redhat.com>
Date: Fri, 20 Feb 2009 18:51:52 +0000
Subject: RE: [GIT PULL] block bits for 2.6.29-rc5
Thread-Topic: [GIT PULL] block bits for 2.6.29-rc5
Thread-Index: AcmTfCnXiMrW/ZfGRduOuFKAfa/enQAD5e0Q
Message-ID: <0F5B06BAB751E047AB5C87D1F77A77885CA670E82F@GVW0547EXC.americas.hpqcorp.net>
References: <20090218144105.GZ30821@kernel.dk>
 <20090219170715.47781cc2.akpm@linux-foundation.org>
 <20090220164055.GZ29783@kernel.dk>
 <0F5B06BAB751E047AB5C87D1F77A77885CA670E6F8@GVW0547EXC.americas.hpqcorp.net>
 <20090220165354.GB29783@kernel.dk>
In-Reply-To: <20090220165354.GB29783@kernel.dk>
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

Jens wrote:

> > > Perhaps we should shrink it to something a little more 
> tolerable and 
> > > put it in the noop loop instead. 30 seconds is insane...
> > 
> > Some of these controllers do take a long time to recover from the 
> > reset because the firmware has to re-initialize. The firmware guys 
> > claim that's only a few seconds but that's not true.
> > 
> > Granted, the 5i is old as dirt. Don't know how many are still out 
> > there running newer kernels.
> 
> So a small improvement would be to do that delay only for 5i. 
> Or how about just being a little more relaxed, ala the below? 
> It's still 30 seconds in total, but that's now worst case. 
> Will the 5i crap itself if we attempt to talk to it too soon?
> 
> diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c 
> index d2cb67b..b5a0611 100644
> --- a/drivers/block/cciss.c
> +++ b/drivers/block/cciss.c
> @@ -3611,11 +3611,15 @@ static int __devinit 
> cciss_init_one(struct pci_dev *pdev,
>  		schedule_timeout_uninterruptible(30*HZ);
>  
>  		/* Now try to get the controller to respond to 
> a no-op */
> -		for (i=0; i<12; i++) {
> +		for (i=0; i<30; i++) {
>  			if (cciss_noop(pdev) == 0)
>  				break;
> -			else
> -				printk("cciss: no-op 
> failed%s\n", (i < 11 ? "; re-trying" : ""));
> +
> +			schedule_timeout_uninterruptible(HZ);
> +		}
> +		if (i == 30) {
> +			printk(KERN_ERR "cciss: controller 
> seems dead\n");
> +			return -EBUSY;
>  		}
>  	}

The controller won't crap the bed, it will just ignore any requests until it becomes ready. I don't see any problem with this change.

Reviewed-by: Mike Miller <mike.miller@hp.com>

-- mikem