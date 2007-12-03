Return-Path: <linux-kernel-owner+w=401wt.eu-S1754239AbXLCTe1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754239AbXLCTe1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 14:34:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752580AbXLCTeU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 14:34:20 -0500
Received: from mx1.redhat.com ([66.187.233.31]:37754 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751667AbXLCTeT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 14:34:19 -0500
To: Zach Brown <zach.brown@oracle.com>, akpm@linux-foundation.org
Cc: Miklos Szeredi <miklos@szeredi.hu>, torvalds@linux-foundation.org,
       jdike@addtoit.com, user-mode-linux-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6.24 BUG] 100% iowait on host while UML is running
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
References: <E1IzDHv-0003xj-Af@dorka.pomaz.szeredi.hu>
	<x49ir3fhg5n.fsf@segfault.boston.devel.redhat.com>
	<475450A1.9000103@oracle.com>
From: Jeff Moyer <jmoyer@redhat.com>
Date: Mon, 03 Dec 2007 14:33:06 -0500
In-Reply-To: <475450A1.9000103@oracle.com> (Zach Brown's message of "Mon\, 03 Dec 2007 10\:53\:21 -0800")
Message-ID: <x49zlwrfua5.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Zach Brown <zach.brown@oracle.com> writes:

>> We could check ctx->reqs_active before scheduling to determine whether
>> or not we are waiting for I/O, but this would require taking the
>> context lock in order to be accurate.  Given that the test would be
>> only for the sake of book keeping, it might be okay to do it outside
>> of the lock.
>> 
>> Zach, what are your thoughts on this?
>
> I agree that it'd be OK to test it outside the lock, though we'll want
> some commentary:
>
> 	/* Try to only show up in io wait if there are ops in flight */
> 	if (ctx->reqs_active)
> 		io_schedule();
> 	else
> 		schedule();
>
> It's cheap, safe, and accurate the overwhelming majority of the time :).
>
> We only need it in read_events().  The other two io_schedule() calls are
> only reached to wait on pending reqs specifically.
>
> It still won't make sense for iocbs which aren't performing IO, but I
> guess that's one more bridge to cross when we come to it.
>
> Do you want to throw this tiny patch together and submit it?

Sure.  I tested this on a system that I used to reproduce the problem,
and it shows I/O Wait back at normal levels on an idle system with 1
uml guest running.

Andrew, do you need a separate email with a [patch] heading or will
this do?

Cheers,

Jeff

Only account I/O wait time in read_events if there are active
requests.

Signed-off-by: Jeff Moyer <jmoyer@redhat.com>

diff --git a/fs/aio.c b/fs/aio.c
index f12db41..9dec7d2 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -1161,7 +1161,12 @@ retry:
 			ret = 0;
 			if (to.timed_out)	/* Only check after read evt */
 				break;
-			io_schedule();
+			/* Try to only show up in io wait if there are ops
+			 *  in flight */
+			if (ctx->reqs_active)
+				io_schedule();
+			else
+				schedule();
 			if (signal_pending(tsk)) {
 				ret = -EINTR;
 				break;

