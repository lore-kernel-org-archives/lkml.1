Return-Path: <linux-kernel-owner+w=401wt.eu-S1752355AbYKKTg1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752355AbYKKTg1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 14:36:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751183AbYKKTgS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 14:36:18 -0500
Received: from mx2.redhat.com ([66.187.237.31]:53924 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750929AbYKKTgR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 14:36:17 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: "Vitaly V. Bursov" <vitalyb@telenet.dn.ua>, linux-kernel@vger.kernel.org,
       jlayton@redhat.com
Subject: Re: Slow file transfer speeds with CFQ IO scheduler in some cases
References: <x493ahzsn8p.fsf@segfault.boston.devel.redhat.com>
	<20081110135618.GI26778@kernel.dk> <49186C5A.5020809@telenet.dn.ua>
	<20081110173504.GL26778@kernel.dk> <49187D05.9050407@telenet.dn.ua>
	<x491vxjqmg0.fsf@segfault.boston.devel.redhat.com>
	<20081111093426.GS26778@kernel.dk> <20081111093540.GT26778@kernel.dk>
	<20081111115227.GU26778@kernel.dk> <4919B884.5000604@telenet.dn.ua>
	<20081111180659.GC26778@kernel.dk>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Tue, 11 Nov 2008 14:36:07 -0500
In-Reply-To: <20081111180659.GC26778@kernel.dk> (Jens Axboe's message of "Tue,
	11 Nov 2008 19:06:59 +0100")
Message-ID: <x49vduunjh4.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe <jens.axboe@oracle.com> writes:

> OK, that looks better. Can I talk you into just trying this little
> patch, just to see what kind of performance that yields? Remove the cfq
> patch first. I would have patched nfsd only, but this is just a quick'n
> dirty.

I went ahead and gave it a shot.  The updated CFQ patch with no I/O
context sharing does about 40MB/s reading a 1GB file.  Backing that
patch out, and then adding the patch to share io_context's between
kthreads yields 45MB/s.

By the way, in looking at the copy_io function, I noticed what appears
to be a (minor) bug:

        if (clone_flags & CLONE_IO) {
                tsk->io_context = ioc_task_link(ioc);
                if (unlikely(!tsk->io_context))
                        return -ENOMEM;

According to comments in ioc_task_link, tsk->io_context == NULL means:
        /*
         * if ref count is zero, don't allow sharing (ioc is going away, it's
         * a race).
         */

It seems more appropriate to just create a new I/O context at this
point, don't you think?  (Sorry, I know it's off-topic!)

Cheers,

Jeff

diff --git a/kernel/fork.c b/kernel/fork.c
index f608356..483d95c 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -723,10 +723,17 @@ static int copy_io(unsigned long clone_flags, struct task_struct *tsk)
 	 * Share io context with parent, if CLONE_IO is set
 	 */
 	if (clone_flags & CLONE_IO) {
+		/*
+		 * If ioc_task_link fails, it just means that we raced
+		 * with io context cleanup.  Continue on to allocate
+		 * a new context in this case.
+		 */
 		tsk->io_context = ioc_task_link(ioc);
-		if (unlikely(!tsk->io_context))
-			return -ENOMEM;
-	} else if (ioprio_valid(ioc->ioprio)) {
+		if (likely(tsk->io_context))
+			return 0;
+	}
+
+	if (ioprio_valid(ioc->ioprio)) {
 		tsk->io_context = alloc_io_context(GFP_KERNEL, -1);
 		if (unlikely(!tsk->io_context))
 			return -ENOMEM;
