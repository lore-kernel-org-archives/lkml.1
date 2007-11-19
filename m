Return-Path: <linux-kernel-owner+w=401wt.eu-S1754146AbXKSOrm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754146AbXKSOrm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 09:47:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753149AbXKSOrf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 09:47:35 -0500
Received: from mx1.redhat.com ([66.187.233.31]:34331 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752987AbXKSOre (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 09:47:34 -0500
Date: Mon, 19 Nov 2007 09:47:15 -0500
From: Jeff Layton <jlayton@redhat.com>
To: Petr Tesarik <ptesarik@suse.cz>
Cc: Steve French <smfrench@gmail.com>, linux-cifs-client@lists.samba.org,
       linux-kernel@vger.kernel.org
Subject: Re: [linux-cifs-client] [PATCH] get rid of spurious session
 reconnects
Message-ID: <20071119094715.59b3bacd@tleilax.poochiereds.net>
In-Reply-To: <1195478593.29063.24.camel@elijah.suse.cz>
References: <1195464645.29063.12.camel@elijah.suse.cz>
	<20071119064205.419e0758@tleilax.poochiereds.net>
	<1195478593.29063.24.camel@elijah.suse.cz>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Nov 2007 14:23:13 +0100
Petr Tesarik <ptesarik@suse.cz> wrote:

> On Mon, 2007-11-19 at 06:42 -0500, Jeff Layton wrote:
> > On Mon, 19 Nov 2007 10:30:45 +0100
> > Petr Tesarik <ptesarik@suse.cz> wrote:
> > 
> > > Hi,
> > > 
> > > while merging commits f01d5e14e764b14b6bf5512678523d009254b209 and
> > > 638b250766272fcaaa0f7ed2776f58f4ac701914 into SLES10, I've noticed
> > > that there's apparently a bug. The code currently looks like this:
> > > 
> > > 		pdu_length = 4; /* enough to get RFC1001 header */
> > > incomplete_rcv:
> > > 		length =
> > > 		    kernel_recvmsg(csocket, &smb_msg,
> > > 				&iov, 1, pdu_length, 0 /* BB other
> > > flags? */);
> > > 
> > > /* ... some irrelevant code left out ... */
> > > 
> > > 		} else if (length < 4) {	/* <----- HERE IS
> > > THE PROBLEM cFYI(1, ("less than four bytes received (%d bytes)",
> > > 			      length));
> > > 			pdu_length -= length;
> > > 			msleep(1);
> > > 			goto incomplete_rcv;
> > > 		}
> > > 
> > > I think we should be checking for length < pdu_length, not for
> > > length < 4, because if we read 2 bytes in the first run and 2
> > > bytes in the second un, CIFS will still treat the second run as
> > > incomplete (and possibly run in an infinite loop). Am I missing
> > > something obvious?
> > > 
> > 
> > I think you're right that the logic there is wrong, but I don't see
> > an infinite loop happening. It looks like in this situation, that
> > the next call to kernel_recvmsg will be called a size of 0, which
> > should eventually return 0. It'll then fall into the previous
> > condition -- do a reconnect and then go around the big loop again.
> > 
> > A patch to clean that up would probably be a good thing. We likely
> > don't need to do a reconnect here.
> 
> OK, here we go:
> 
> When retrying kernel_recvmsg() because of a short read, check returned
> length against the remaining length, not against total length. This
> avoids unneeded session reconnects which would otherwise occur when
> kernel_recvmsg() finally returns zero when asked to read zero bytes.
> 
> Signed-off-by: Petr Tesarik <ptesarik@suse.cz>
> 

Looks good (nice catch on this problem, btw). How about we fix up the
cFYI at the same time? Note that this should probably be tested, even
though it seems logical.

Signed-off-by: Jeff Layton <jlayton@redhat.com>

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index c4b32b7..b6ed933 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -438,9 +438,9 @@ incomplete_rcv:
 			csocket = server->ssocket;
 			wake_up(&server->response_q);
 			continue;
-		} else if (length < 4) {
-			cFYI(1, ("less than four bytes received (%d bytes)",
-			      length));
+		} else if (length < pdu_length) {
+			cFYI(1, ("less than %d bytes received (%d bytes)",
+			      pdu_length, length));
 			pdu_length -= length;
 			msleep(1);
 			goto incomplete_rcv;
