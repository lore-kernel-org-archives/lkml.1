Return-Path: <linux-kernel-owner+w=401wt.eu-S1754158AbZBQSbU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754158AbZBQSbU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 13:31:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753221AbZBQSbK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 13:31:10 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:56266 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752892AbZBQSbI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 13:31:08 -0500
X-AuthUser: davidel@xmailserver.org
Date: Tue, 17 Feb 2009 10:31:07 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Valdis.Kletnieks@vt.edu
cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       mm-commits@vger.kernel.org
Subject: Re: mmotm 2009-02-14-00-49 uploaded -epoll busted.
In-Reply-To: <7379.1234881458@turing-police.cc.vt.edu>
Message-ID: <alpine.DEB.1.10.0902171023400.21510@alien.or.mcafeemobile.com>
References: <200902140851.n1E8pfIN030501@imap1.linux-foundation.org> <7379.1234881458@turing-police.cc.vt.edu>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Feb 2009, Valdis.Kletnieks@vt.edu wrote:

> On Sat, 14 Feb 2009 00:51:41 PST, akpm@linux-foundation.org said:
> > The mm-of-the-moment snapshot 2009-02-14-00-49 has been uploaded to
> 
> The epoll patch series breaks nscd in some odd way.  After it's started
> in the /etc/rc* scripts, the rest of boot proceeds very slowly, smells like
> nscd calls are hitting timeouts.  Boot time went from ~1 minute to ~10 mins.
> 
> nscd is Fedora Rawhide nscd-2.9.90-3.x86_64, in case that matters...
> 
> Also, the series isn't bisectable right where it matters most, complaining
> about implicit definitions of wake_up_nested...
> 
> epoll-keyed-wakeups-v2-add-__wake_up_locked_key-and-__wake_up_sync_key.patch
> epoll-keyed-wakeups-v2-introduce-new-_poll-wakeup-macros.patch  GOOD
> epoll-keyed-wakeups-v3-introduce-new-_poll-wakeup-macros.patch  BISECT BUSTED
> epoll-keyed-wakeups-v2-make-sockets-use-keyed-wakeups.patch
> epoll-keyed-wakeups-v2-teach-epoll-about-hints-coming-with-the-wakeup-key.patch
> epoll-keyed-wakeups-v2-teach-epoll-about-hints-coming-with-the-wakeup-key-update.patch  BAD

Alright, I took a peek at nscd and noticed it waits only for RDNORM.
Inside the socket code, the full flags computation is performed inside the 
poll function, and ATM socket code has simple signaling of IN/OUT/ERR. We 
could changethe socket code to allow more fine grained event signaling, 
but IMO is not worth it. Epoll ends up calling the device poll anyway, and 
since this is an optimization patch, a simple change to post a full IN/OUT 
mask is enough.
Andrew, the patch below replaced the one you have under the name:

epoll-keyed-wakeups-v2-make-sockets-use-keyed-wakeups.patch



Signed-off-by: Davide Libenzi <davidel@xmailserver.org>


- Davide


---
 net/core/sock.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

Index: linux-2.6.mod/net/core/sock.c
===================================================================
--- linux-2.6.mod.orig/net/core/sock.c	2009-02-17 10:14:56.000000000 -0800
+++ linux-2.6.mod/net/core/sock.c	2009-02-17 10:21:43.000000000 -0800
@@ -1630,7 +1630,7 @@ static void sock_def_error_report(struct
 {
 	read_lock(&sk->sk_callback_lock);
 	if (sk->sk_sleep && waitqueue_active(sk->sk_sleep))
-		wake_up_interruptible(sk->sk_sleep);
+		wake_up_interruptible_poll(sk->sk_sleep, POLLERR);
 	sk_wake_async(sk, SOCK_WAKE_IO, POLL_ERR);
 	read_unlock(&sk->sk_callback_lock);
 }
@@ -1639,7 +1639,8 @@ static void sock_def_readable(struct soc
 {
 	read_lock(&sk->sk_callback_lock);
 	if (sk->sk_sleep && waitqueue_active(sk->sk_sleep))
-		wake_up_interruptible_sync(sk->sk_sleep);
+		wake_up_interruptible_sync_poll(sk->sk_sleep, POLLIN |
+						POLLRDNORM | POLLRDBAND);
 	sk_wake_async(sk, SOCK_WAKE_WAITD, POLL_IN);
 	read_unlock(&sk->sk_callback_lock);
 }
@@ -1653,7 +1654,8 @@ static void sock_def_write_space(struct 
 	 */
 	if ((atomic_read(&sk->sk_wmem_alloc) << 1) <= sk->sk_sndbuf) {
 		if (sk->sk_sleep && waitqueue_active(sk->sk_sleep))
-			wake_up_interruptible_sync(sk->sk_sleep);
+			wake_up_interruptible_sync_poll(sk->sk_sleep, POLLOUT |
+							POLLWRNORM | POLLWRBAND);
 
 		/* Should agree with poll, otherwise some programs break */
 		if (sock_writeable(sk))
