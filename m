Return-Path: <linux-kernel-owner+w=401wt.eu-S1755391AbZJRWXS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755391AbZJRWXS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Oct 2009 18:23:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753197AbZJRWXR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Oct 2009 18:23:17 -0400
Received: from mailout-hades.uni-duesseldorf.de ([134.99.128.34]:54274 "EHLO
	mail.rz.uni-duesseldorf.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751017AbZJRWXQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Oct 2009 18:23:16 -0400
X-Greylist: delayed 3602 seconds by postgrey-1.27 at vger.kernel.org; Sun, 18 Oct 2009 18:23:16 EDT
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; charset=US-ASCII
Date: Sun, 18 Oct 2009 23:14:32 +0200 (CEST)
From: Michael Schmitz <schmitz@biophys.uni-duesseldorf.de>
Subject: Re: Fwd: [PATCH] [RFC] ataflop: remove buggy IRQ disable from
 do_fd_request()
In-reply-to: <alpine.LSU.2.00.0910121106330.19284@wotan.suse.de>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
       linux-m68k <linux-m68k@vger.kernel.org>, Tejun Heo <tj@kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org
Message-id: <alpine.DEB.2.00.0910182126120.6395@zirkon.biophys.uni-duesseldorf.de>
References: <alpine.LSU.2.00.0910091141150.19284@wotan.suse.de>
 <10f740e80910100201n30367714uc57ec3c9c39b92af@mail.gmail.com>
 <alpine.DEB.2.00.0910110846420.20140@zirkon.biophys.uni-duesseldorf.de>
 <alpine.LSU.2.00.0910121106330.19284@wotan.suse.de>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

trying for a somewhat more coherent opinion: 

> > > If you look at the code long enough, you will notioce that the
> > > local_irq_disable() call is actually commented out. This has been
> > > introduced back in 2002 in [1], but as you can see, the same bug has been
> > > there even before, with the sti() call being commented out in the very
> > > same way :)

The substitution of sti() by local_irq_disable() had me a bit confused here. The 
last time I worked on this driver was when we still had a big kernel lock, so 
the  sti() might have been crucial there. 

The code does evidently work fine without it, and redo_fd_request as well as 
do_fd_action do not need to reenable local interupts or otherwise change the 
interrupt level anymore. After a bit more pondering over the code I now 
understand why this is ... 

> > The surounding code probably hasn't been touched in ages. The floppy driver in 
> > its current state does work. If redo_fd_request could alter timers ot queues, 
> > rmoving the locking would be dangerous, no?
> 
> The patch is not removing any locking. It only
> 
> 1) removes the local_irq_disable() that has been commented out for many 
>    years already anyway
> 2) removes the saving and restoring of CPU flags around do_fd_request(), 
>    which is rather clearly a nop than any kind of "locking"
> 
> > > [1] http://lkml.org/lkml/2002/12/27/58
> > > 
> > > Signed-off-by: Jiri Kosina <jkosina@suse.cz>
> > 
> > NAck for my part. 
> 
> Please elaborate a little bit more which of the two points above you base 
> your NACK on.

The removal of local_irq_disable() (which should have been local_irq_enable()) 
just raised a flag, and I didn't immediately see why the interrupt enable had 
been commented out. 

With a bit of further thought on the matter I am satisfied that this patch will 
not impact on driver function at all, and do not wish to sustain my objection.

IOW: Ack, and my sincere apologies for wasting your time. 

	Michael

