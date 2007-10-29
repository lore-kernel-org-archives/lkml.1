Return-Path: <linux-kernel-owner+w=401wt.eu-S1759266AbXJ2RCU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759266AbXJ2RCU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 13:02:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758980AbXJ2RB7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 13:01:59 -0400
Received: from hancock.steeleye.com ([71.30.118.248]:55309 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758217AbXJ2RB5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 13:01:57 -0400
Subject: Re: [PATCH v4 1/2] SCSI: Asynchronous
	event	notification	infrastructure
From: James Bottomley <James.Bottomley@SteelEye.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Linux-SCSI <linux-scsi@vger.kernel.org>, akpm@linux-foundation.org
In-Reply-To: <47260A65.7040008@garzik.org>
References: <15624bab8dc0206e384ac8314257a900e60127c1.1193668176.git.jeff@garzik.org>
	 <20071029144208.676251F8168@havoc.gtf.org>
	 <1193673088.3383.34.camel@localhost.localdomain>
	 <47260546.9090508@garzik.org>
	 <1193674627.3383.45.camel@localhost.localdomain>
	 <47260A65.7040008@garzik.org>
Content-Type: text/plain
Date: Mon, 29 Oct 2007 12:01:55 -0500
Message-Id: <1193677315.3383.59.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-10-29 at 12:29 -0400, Jeff Garzik wrote:
> James Bottomley wrote:
> > On Mon, 2007-10-29 at 12:07 -0400, Jeff Garzik wrote:
> >> James Bottomley wrote:
> >>> This still doesn't solve the fundamental corruption problem:
> >>> sdev->event_work has to contain the work entry until the workqueue has
> >>> finished executing it (which is some unspecified time in the future).
> >>> As soon as you drop the sdev->list_lock, the system thinks
> >>> sdev->event_work is available for reuse.  If we fire another event
> >>> before the work queue finished processing the prior event, the queue
> >>> will be corrupted.
> >> I think you're misunderstanding the workqueue code?  You can call 
> >> schedule_work(&sdev->event_work) from anywhere, any time you like, as 
> >> many times as you like.
> > 
> > OK, take me through it slowly then ... I think schedule_work(work)
> > inserts work->entry onto the workqueue list (in
> > workqueue.c:insert_work()).  If the event hasn't fired, it will already
> > be on the list, so adding the same entry to a list twice causes a list
> > corruption problem.
> 
> It does a test_and_set_bit() first thing in queue_work().  Similar 
> exclusivity logic is found in net device land.  Ah, the fun of locking 
> without locks that benh grumbles about :)

Ah, OK, sorry ... I was actually looking at __queue_work().

> > Plus, unfortunately, the CC/UA events are going to have to carry extra
> > sense data; they're not simply going to be triggers saying something
> > happened.
> 
> OK this is a fair criticism.
> 
> If additional data must be carried, then I must ditch the beloved bitmap 
> implementation and go back to a list (with associated GFP_ATOMIC alloc).
> 
> I will fix this, unless I receive email to the contrary...

Yes, unfortunately, thanks.  If all events were a simple number, it's
easy, but the CC/UA events carry data as well.

James

