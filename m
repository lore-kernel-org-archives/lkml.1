Return-Path: <linux-kernel-owner+w=401wt.eu-S1751131AbYDWHjC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751131AbYDWHjC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 03:39:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751593AbYDWHit
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 03:38:49 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:47711 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751226AbYDWHir (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 03:38:47 -0400
Date: Wed, 23 Apr 2008 10:38:45 +0300 (EEST)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: Pete Zaitcev <zaitcev@redhat.com>
cc: Ingo Molnar <mingo@elte.hu>, Frans Pop <elendil@planet.nl>,
       linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org, gregkh@suse.de
Subject: Re: [sched-devel/latest] WARNING: at mm/slub.c:2443
In-Reply-To: <20080422235148.c49dc6b7.zaitcev@redhat.com>
Message-ID: <Pine.LNX.4.64.0804231038210.26134@sbz-30.cs.Helsinki.FI>
References: <200804212310.41729.elendil@planet.nl> <20080422134034.GF7311@elte.hu>
 <20080422235148.c49dc6b7.zaitcev@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Apr 2008, Pete Zaitcev wrote:
> > Cc:-ing USB folks as the kmem_cache_destroy() comes from 
> > drivers/usb/mon/mon_text.c.
> 
> I looked at this whole day today, but found nothing.
> 
> The code analysis for usbmon shows nothing. Anyone wants to have
> a look?

So something like the following totally untested patch.

		Pekka

diff --git a/drivers/usb/mon/mon_text.c b/drivers/usb/mon/mon_text.c
index 5e3e4e9..c6fdc6e 100644
--- a/drivers/usb/mon/mon_text.c
+++ b/drivers/usb/mon/mon_text.c
@@ -449,6 +449,7 @@ static struct mon_event_text *mon_text_read_wait(struct mon_reader_text *rp,
 		if (file->f_flags & O_NONBLOCK) {
 			set_current_state(TASK_RUNNING);
 			remove_wait_queue(&rp->wait, &waita);
+			kmem_cache_free(rp->e_slab, ep);
 			return ERR_PTR(-EWOULDBLOCK);
 		}
 		/*
@@ -458,6 +459,7 @@ static struct mon_event_text *mon_text_read_wait(struct mon_reader_text *rp,
 		schedule();
 		if (signal_pending(current)) {
 			remove_wait_queue(&rp->wait, &waita);
+			kmem_cache_free(rp->e_slab, ep);
 			return ERR_PTR(-EINTR);
 		}
 		set_current_state(TASK_INTERRUPTIBLE);
