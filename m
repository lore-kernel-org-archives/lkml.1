Return-Path: <linux-kernel-owner+w=401wt.eu-S1753911AbZIATn5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753911AbZIATn5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 15:43:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752767AbZIATn4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 15:43:56 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:9804 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752597AbZIATnz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 15:43:55 -0400
From: "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>
To: Randy Dunlap <rdunlap@xenotime.net>,
       Marcin Slusarz <marcin.slusarz@gmail.com>
CC: lkml <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>,
       ISS StorageDev <iss_storagedev@hp.com>
Date: Tue, 1 Sep 2009 19:43:17 +0000
Subject: RE: [PATCH] cciss: fix schedule_timeout() parameters
Thread-Topic: [PATCH] cciss: fix schedule_timeout() parameters
Thread-Index: AcoqdiejUhcZCQOcS3yLBAvk9XXCAwAxXu4Q
Message-ID: <0F5B06BAB751E047AB5C87D1F77A77886952DFA043@GVW0547EXC.americas.hpqcorp.net>
References: <4A9ADECE.7050900@xenotime.net>	<4A9C156D.5080701@gmail.com>
 <20090831130342.a5f3d821.rdunlap@xenotime.net>
In-Reply-To: <20090831130342.a5f3d821.rdunlap@xenotime.net>
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
> From: Randy Dunlap [mailto:rdunlap@xenotime.net] 
> Sent: Monday, August 31, 2009 3:04 PM
> To: Marcin Slusarz
> Cc: lkml; akpm; Miller, Mike (OS Dev); ISS StorageDev
> Subject: Re: [PATCH] cciss: fix schedule_timeout() parameters
> 
> On Mon, 31 Aug 2009 20:24:45 +0200 Marcin Slusarz wrote:
> 
> > Randy Dunlap wrote:
> > > From: Randy Dunlap <randy.dunlap@oracle.com>
> > > 
> > > Change schedule_timeout() parameter to not be specific to HZ=1000.
> > > 
> > > Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> > > Cc: Mike Miller <mike.miller@hp.com>
> > > Cc: iss_storagedev@hp.com
> > > ---
> > >  drivers/block/cciss.c |    5 +++--
> > >  1 file changed, 3 insertions(+), 2 deletions(-)
> > > 
> > > --- lnx-2631-rc7.orig/drivers/block/cciss.c
> > > +++ lnx-2631-rc7/drivers/block/cciss.c
> > > @@ -36,6 +36,7 @@
> > >  #include <linux/proc_fs.h>
> > >  #include <linux/seq_file.h>
> > >  #include <linux/init.h>
> > > +#include <linux/jiffies.h>
> > >  #include <linux/hdreg.h>
> > >  #include <linux/spinlock.h>
> > >  #include <linux/compat.h>
> > > @@ -3489,7 +3490,7 @@ static int __devinit cciss_pci_init(ctlr
> > >  		if (scratchpad == CCISS_FIRMWARE_READY)
> > >  			break;
> > >  		set_current_state(TASK_INTERRUPTIBLE);
> > > -		schedule_timeout(HZ / 10);	/* wait 100ms */
> > > +		schedule_timeout(msecs_to_jiffies(100));	
> /* wait 100ms */
> > >  	}
> > >  	if (scratchpad != CCISS_FIRMWARE_READY) {
> > >  		printk(KERN_WARNING "cciss: Board not ready.  
> Timed out.\n"); @@ 
> > > -3615,7 +3616,7 @@ static int __devinit cciss_pci_init(ctlr
> > >  			break;
> > >  		/* delay and try again */
> > >  		set_current_state(TASK_INTERRUPTIBLE);
> > > -		schedule_timeout(10);
> > > +		schedule_timeout(msecs_to_jiffies(1));
> > 
> > shouldn't it be msecs_to_jiffies(10)?
> 
> Hm, thanks, that's a good observation -- and possibly correct.
> 
> 
> The reason that I used (1) was that I looked at the loop:
> 
> 	for (i = 0; i < MAX_CONFIG_WAIT; i++) {
> 		if (!(readl(c->vaddr + SA5_DOORBELL) & 
> CFGTBL_ChangeReq))
> 			break;
> 		/* delay and try again */
> 		set_current_state(TASK_INTERRUPTIBLE);
> 		schedule_timeout(msecs_to_jiffies(1));
> 	}
> 
> and this:
> /* How long to wait (in milliseconds) for board to go into 
> simple mode */ #define MAX_CONFIG_WAIT 30000
> 
> and then I tried to make the loop run for a max. of 30000 
> milliseconds.
> 
> Mike M., any comments here?

Sorry to take so long to respond. I've been playing around with msecs_to_jiffies figuring out what it means to me. :) 1 is the correct value. If we loop 30000 times with a value of 10 it takes 5 minutes. I can't think of anything that would take that much time. 

-- mikem

> 
> 
> ---
> ~Randy
> *** Remember to use Documentation/SubmitChecklist when 
> testing your code ***
> 