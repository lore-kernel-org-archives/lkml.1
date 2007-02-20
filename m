Return-Path: <linux-kernel-owner+w=401wt.eu-S932210AbXBSNFF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932210AbXBSNFF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 08:05:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932216AbXBSNFF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 08:05:05 -0500
Received: from ug-out-1314.google.com ([66.249.92.169]:16136 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932210AbXBSNFC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 08:05:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:content-transfer-encoding:in-reply-to:user-agent:sender;
        b=VVdgLC3yNOmZr2zGXrDnMrAZcdYkadx1K/4i1632UEfLNs0czfa4JBxo9SatzGhihpJsBdQmHfbAfn9eHY7eMMTgCJooO4z7w8JyxbVy78jPFWQH8SOVzGNzsEsYkc8RdJA4PIr1sLu17caS298IvsqMZbn4QekmyCn3akIvaf4=
Date: Tue, 20 Feb 2007 13:04:08 +0000
From: Frederik Deweerdt <deweerdt@free.fr>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Mattia Dongili <malattia@linux.it>,
       Laurent Riffard <laurent.riffard@free.fr>, linux-kernel@vger.kernel.org,
       axboe@kernel.dk
Subject: [-mm patch] fix locking in __make_request (was Re: 2.6.20-mm2: Oops in generic_make_request)
Message-ID: <20070220130408.GB566@slug>
References: <20070217215146.30e7ffa3.akpm@linux-foundation.org> <45D84F73.8060904@free.fr> <20070218175805.GB5567@inferi.kami.home> <20070218114903.a8160301.akpm@linux-foundation.org> <6bffcb0e0702181205v5755fc0es284c5be32f85d304@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6bffcb0e0702181205v5755fc0es284c5be32f85d304@mail.gmail.com>
User-Agent: mutt-ng/devel-r804 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 18, 2007 at 09:05:33PM +0100, Michal Piotrowski wrote:
> On 18/02/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> >On Sun, 18 Feb 2007 18:58:05 +0100 Mattia Dongili <malattia@linux.it> wrote:
> >
> >> On Sun, Feb 18, 2007 at 02:06:59PM +0100, Laurent Riffard wrote:
> >> > Le 18.02.2007 06:51, Andrew Morton a écrit :
> >> > >Temporarily at
> >> > >
> >> > >  http://userweb.kernel.org/~akpm/2.6.20-mm2/
> >> > >
> >> > >Will appear later at
> >> > >
> >> > > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.20/2.6.20-mm2/
> >> >
> >> > Hello, I've got a fully reproducible Oops. I just have to boot to
> >> > runlevel 2 and wait less than one minute.
> >>
> >> Maybe this oops is related too?
> >
> >Looks that way.
> >
Hi Michal,

This seems to be a locking problem in __make_request, check_plug_merge()
should be called with the q->queue_lock held.
Could you try the following patch? It silenced the oops for me.

Regards,
Frederik

Signed-off-by: Frederik Deweerdt <frederik.deweerdt@gmail.com>

diff --git a/block/ll_rw_blk.c b/block/ll_rw_blk.c
index 577f448..666f34e 100644
--- a/block/ll_rw_blk.c
+++ b/block/ll_rw_blk.c
@@ -2919,14 +2919,14 @@ static int __make_request(request_queue_
 	 */
 	blk_queue_bounce(q, &bio);
 
+	spin_lock_irq(q->queue_lock);
 	/*
 	 * Check if we can merge with the plugged list before grabbing
 	 * any locks.
 	 */
 	if (!check_plug_merge(q, ioc, bio))
-		goto out;
+		goto out_unlock;
 
-	spin_lock_irq(q->queue_lock);
 	el_ret = elv_merge(q, &req, bio);
 	if (el_ret == ELEVATOR_BACK_MERGE) {
 		if (bio_attempt_back_merge(q, req, bio)) {
@@ -2984,7 +2984,6 @@ out_unlock:
 		list_add_tail(&req->queuelist, &ioc->plugged_list);
 	}
 
-out:
 	return 0;
 
 end_io_eopnotsupp:
