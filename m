Return-Path: <linux-kernel-owner+w=401wt.eu-S1754112AbXKSNXY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754112AbXKSNXY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 08:23:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752610AbXKSNXR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 08:23:17 -0500
Received: from styx.suse.cz ([82.119.242.94]:47165 "EHLO elijah.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752547AbXKSNXQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 08:23:16 -0500
Subject: Re: [linux-cifs-client] [PATCH] get rid of spurious session
	reconnects
From: Petr Tesarik <ptesarik@suse.cz>
To: Jeff Layton <jlayton@redhat.com>
Cc: linux-cifs-client@lists.samba.org, Steve French <smfrench@gmail.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20071119064205.419e0758@tleilax.poochiereds.net>
References: <1195464645.29063.12.camel@elijah.suse.cz>
	 <20071119064205.419e0758@tleilax.poochiereds.net>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: SuSE CR
Date: Mon, 19 Nov 2007 14:23:13 +0100
Message-Id: <1195478593.29063.24.camel@elijah.suse.cz>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.0 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-11-19 at 06:42 -0500, Jeff Layton wrote:
> On Mon, 19 Nov 2007 10:30:45 +0100
> Petr Tesarik <ptesarik@suse.cz> wrote:
> 
> > Hi,
> > 
> > while merging commits f01d5e14e764b14b6bf5512678523d009254b209 and
> > 638b250766272fcaaa0f7ed2776f58f4ac701914 into SLES10, I've noticed
> > that there's apparently a bug. The code currently looks like this:
> > 
> > 		pdu_length = 4; /* enough to get RFC1001 header */
> > incomplete_rcv:
> > 		length =
> > 		    kernel_recvmsg(csocket, &smb_msg,
> > 				&iov, 1, pdu_length, 0 /* BB other
> > flags? */);
> > 
> > /* ... some irrelevant code left out ... */
> > 
> > 		} else if (length < 4) {	/* <----- HERE IS THE
> > PROBLEM cFYI(1, ("less than four bytes received (%d bytes)",
> > 			      length));
> > 			pdu_length -= length;
> > 			msleep(1);
> > 			goto incomplete_rcv;
> > 		}
> > 
> > I think we should be checking for length < pdu_length, not for length
> > < 4, because if we read 2 bytes in the first run and 2 bytes in the
> > second un, CIFS will still treat the second run as incomplete (and
> > possibly run in an infinite loop). Am I missing something obvious?
> > 
> 
> I think you're right that the logic there is wrong, but I don't see an
> infinite loop happening. It looks like in this situation, that the next
> call to kernel_recvmsg will be called a size of 0, which should
> eventually return 0. It'll then fall into the previous condition -- do
> a reconnect and then go around the big loop again.
> 
> A patch to clean that up would probably be a good thing. We likely
> don't need to do a reconnect here.

OK, here we go:

When retrying kernel_recvmsg() because of a short read, check returned
length against the remaining length, not against total length. This
avoids unneeded session reconnects which would otherwise occur when
kernel_recvmsg() finally returns zero when asked to read zero bytes.

Signed-off-by: Petr Tesarik <ptesarik@suse.cz>

 connect.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index c52a76f..f972ec9 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -438,7 +438,7 @@ incomplete_rcv:
 			csocket = server->ssocket;
 			wake_up(&server->response_q);
 			continue;
-		} else if (length < 4) {
+		} else if (length < pdu_length) {
 			cFYI(1, ("less than four bytes received (%d bytes)",
 			      length));
 			pdu_length -= length;

