Return-Path: <linux-kernel-owner+w=401wt.eu-S1761614AbXLMGpx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761614AbXLMGpx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 01:45:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759579AbXLMGhz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 01:37:55 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:56507 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759535AbXLMGhy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 01:37:54 -0500
Date: Wed, 12 Dec 2007 22:35:03 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, bunk@kernel.org,
       davem@davemloft.net
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Florian Zumbiehl <florz@florz.de>,
       Herbert Xu <herbert@gondor.apana.org.au>
Subject: [patch 23/36] UNIX: EOF on non-blocking SOCK_SEQPACKET
Message-ID: <20071213063503.GX25301@kroah.com>
References: <20071213062511.265908583@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="unix-eof-on-non-blocking-sock_seqpacket.patch"
In-Reply-To: <20071213063308.GA25301@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.22-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Florian Zumbiehl <florz@florz.de>

[UNIX]: EOF on non-blocking SOCK_SEQPACKET

[ Upstream commit: 0a11225887fe6cbccd882404dc36ddc50f47daf9 ]

I am not absolutely sure whether this actually is a bug (as in: I've got
no clue what the standards say or what other implementations do), but at
least I was pretty surprised when I noticed that a recv() on a
non-blocking unix domain socket of type SOCK_SEQPACKET (which is connection
oriented, after all) where the remote end has closed the connection
returned -1 (EAGAIN) rather than 0 to indicate end of file.

This is a test case:

| #include <sys/types.h>
| #include <unistd.h>
| #include <sys/socket.h>
| #include <sys/un.h>
| #include <fcntl.h>
| #include <string.h>
| #include <stdlib.h>
|
| int main(){
| 	int sock;
| 	struct sockaddr_un addr;
| 	char buf[4096];
| 	int pfds[2];
|
| 	pipe(pfds);
| 	sock=socket(PF_UNIX,SOCK_SEQPACKET,0);
| 	addr.sun_family=AF_UNIX;
| 	strcpy(addr.sun_path,"/tmp/foobar_testsock");
| 	bind(sock,(struct sockaddr *)&addr,sizeof(addr));
| 	listen(sock,1);
| 	if(fork()){
| 		close(sock);
| 		sock=socket(PF_UNIX,SOCK_SEQPACKET,0);
| 		connect(sock,(struct sockaddr *)&addr,sizeof(addr));
| 		fcntl(sock,F_SETFL,fcntl(sock,F_GETFL)|O_NONBLOCK);
| 		close(pfds[1]);
| 		read(pfds[0],buf,sizeof(buf));
| 		recv(sock,buf,sizeof(buf),0); // <-- this one
| 	}else accept(sock,NULL,NULL);
| 	exit(0);
| }

If you try it, make sure /tmp/foobar_testsock doesn't exist.

The marked recv() returns -1 (EAGAIN) on 2.6.23.9. Below you find a
patch that fixes that.

Signed-off-by: Florian Zumbiehl <florz@florz.de>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/unix/af_unix.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -1608,8 +1608,15 @@ static int unix_dgram_recvmsg(struct kio
 	mutex_lock(&u->readlock);
 
 	skb = skb_recv_datagram(sk, flags, noblock, &err);
-	if (!skb)
+	if (!skb) {
+		unix_state_lock(sk);
+		/* Signal EOF on disconnected non-blocking SEQPACKET socket. */
+		if (sk->sk_type == SOCK_SEQPACKET && err == -EAGAIN &&
+		    (sk->sk_shutdown & RCV_SHUTDOWN))
+			err = 0;
+		unix_state_unlock(sk);
 		goto out_unlock;
+	}
 
 	wake_up_interruptible(&u->peer_wait);
 

-- 
