Return-Path: <linux-kernel-owner+w=401wt.eu-S1754589AbZHaUDm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754589AbZHaUDm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 16:03:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754409AbZHaUDm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 16:03:42 -0400
Received: from xenotime.net ([72.52.64.118]:52474 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752470AbZHaUDl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 16:03:41 -0400
Date: Mon, 31 Aug 2009 13:03:42 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: lkml <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>,
       Mike Miller <mike.miller@hp.com>, iss_storagedev@hp.com
Subject: Re: [PATCH] cciss: fix schedule_timeout() parameters
Message-Id: <20090831130342.a5f3d821.rdunlap@xenotime.net>
In-Reply-To: <4A9C156D.5080701@gmail.com>
References: <4A9ADECE.7050900@xenotime.net>
	<4A9C156D.5080701@gmail.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 31 Aug 2009 20:24:45 +0200 Marcin Slusarz wrote:

> Randy Dunlap wrote:
> > From: Randy Dunlap <randy.dunlap@oracle.com>
> > 
> > Change schedule_timeout() parameter to not be specific to HZ=1000.
> > 
> > Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> > Cc: Mike Miller <mike.miller@hp.com>
> > Cc: iss_storagedev@hp.com
> > ---
> >  drivers/block/cciss.c |    5 +++--
> >  1 file changed, 3 insertions(+), 2 deletions(-)
> > 
> > --- lnx-2631-rc7.orig/drivers/block/cciss.c
> > +++ lnx-2631-rc7/drivers/block/cciss.c
> > @@ -36,6 +36,7 @@
> >  #include <linux/proc_fs.h>
> >  #include <linux/seq_file.h>
> >  #include <linux/init.h>
> > +#include <linux/jiffies.h>
> >  #include <linux/hdreg.h>
> >  #include <linux/spinlock.h>
> >  #include <linux/compat.h>
> > @@ -3489,7 +3490,7 @@ static int __devinit cciss_pci_init(ctlr
> >  		if (scratchpad == CCISS_FIRMWARE_READY)
> >  			break;
> >  		set_current_state(TASK_INTERRUPTIBLE);
> > -		schedule_timeout(HZ / 10);	/* wait 100ms */
> > +		schedule_timeout(msecs_to_jiffies(100));	/* wait 100ms */
> >  	}
> >  	if (scratchpad != CCISS_FIRMWARE_READY) {
> >  		printk(KERN_WARNING "cciss: Board not ready.  Timed out.\n");
> > @@ -3615,7 +3616,7 @@ static int __devinit cciss_pci_init(ctlr
> >  			break;
> >  		/* delay and try again */
> >  		set_current_state(TASK_INTERRUPTIBLE);
> > -		schedule_timeout(10);
> > +		schedule_timeout(msecs_to_jiffies(1));
> 
> shouldn't it be msecs_to_jiffies(10)?

Hm, thanks, that's a good observation -- and possibly correct.


The reason that I used (1) was that I looked at the loop:

	for (i = 0; i < MAX_CONFIG_WAIT; i++) {
		if (!(readl(c->vaddr + SA5_DOORBELL) & CFGTBL_ChangeReq))
			break;
		/* delay and try again */
		set_current_state(TASK_INTERRUPTIBLE);
		schedule_timeout(msecs_to_jiffies(1));
	}

and this:
/* How long to wait (in milliseconds) for board to go into simple mode */
#define MAX_CONFIG_WAIT 30000

and then I tried to make the loop run for a max. of 30000 milliseconds.

Mike M., any comments here?


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
