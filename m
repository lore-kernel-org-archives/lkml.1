Return-Path: <linux-kernel-owner+w=401wt.eu-S1760131AbZAMXjQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760131AbZAMXjQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 18:39:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755882AbZAMXiz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 18:38:55 -0500
Received: from gw1.cosmosbay.com ([86.65.150.130]:54600 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752722AbZAMXiy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 18:38:54 -0500
Message-ID: <496D25F8.2080505@cosmosbay.com>
Date: Wed, 14 Jan 2009 00:38:32 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Volker.Lendecke@SerNet.DE, linux-kernel@vger.kernel.org,
       Steven French <sfrench@us.ibm.com>, Jens Axboe <jens.axboe@oracle.com>,
       netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
Subject: Re: maximum buffer size for splice(2) tcp->pipe?
References: <E1LKrp3-004Tub-IR@intern.SerNet.DE> <20090113123702.ad29cd13.akpm@linux-foundation.org> <496D2078.9080302@cosmosbay.com>
In-Reply-To: <496D2078.9080302@cosmosbay.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Wed, 14 Jan 2009 00:38:33 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Dumazet a écrit :
> Andrew Morton a écrit :
>> (cc's added)
>>
>> On Thu, 8 Jan 2009 11:13:51 +0100
>> Volker Lendecke <Volker.Lendecke@SerNet.DE> wrote:
>>
>>> Hi!
>>>
>>> While implementing splice support in Samba for better
>>> performance I found it blocking when trying to pull data off
>>> tcp into a pipe when the recvq was full. Attached find a
>>> test program that shows this behaviour, on another host I
>>> started
>>>
>>> netcat 192.168.19.10 4711 < /dev/zero
>>>
>>> vlendec@lenny:~$ uname -a
>>> Linux lenny 2.6.28-06857-g5cbd04a #7 Wed Jan 7 10:10:42 CET 2009 x86_64 = GNU/Linux
>>> vlendec@lenny:~$ gcc -o splicetest /host/home/vlendec/splicetest.c -O3 -Wall
>>> vlendec@lenny:~$ ./splicetest out 65536 &
>>> [1] 697
>>> vlendec@lenny:~$ strace -p 697
>>> Process 697 attached - interrupt to quit
>>> splice(0x3, 0, 0x5, 0, 0x56a0, 0x1)     = 22176
>>> splice(0x7, 0, 0x4, 0, 0x10000, 0x1^C <unfinished ...>
> 
> Volker, your splice() is a blocking one, from tcp socket to a pipe ?
> 
> If no other thread is reading the pipe, then you might block forever
> in splice_to_pipe() as soon pipe is full (16 pages).
> 
> As pages are not necessarly full (each skb will use at least one page, even if 
> its length is small), it is not really possible to use splice() like this.
> 
> In your case, only safe way with current kernel would be to call splice()
> asking for no more than 16 bytes, that would be really insane for your needs.
> 
> You may prefer a non blocking mode, at least when calling splice_to_pipe()
> 
> Maybe SPLICE_F_NONBLOCK splice() flag should only apply on pipe side.
> tcp_splice_read() should not use this flag to select a blocking/nonbloking
> mode on the source socket, but underlying file flag.
> 
> This way, your program could let socket in blocking mode, yet call splice()
> with SPLICE_F_NONBLOCK flag to not block on pipe.
> 

This patch, coupled with the previous one from Willy Tarreau 
(tcp: splice as many packets as possible at once)
gives expected result.

[PATCH] net: splice() from tcp to socket should take into account O_NONBLOCK

Instead of using SPLICE_F_NONBLOCK to select a non blocking mode both on
source tcp socket and pipe destination, we use the underlying file flag (O_NONBLOCK)
for selecting a non blocking socket.

Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>

diff --git a/include/linux/net.h b/include/linux/net.h
index 4515efa..10e38d1 100644
--- a/include/linux/net.h
+++ b/include/linux/net.h
@@ -185,7 +185,7 @@ struct proto_ops {
 				      struct vm_area_struct * vma);
 	ssize_t		(*sendpage)  (struct socket *sock, struct page *page,
 				      int offset, size_t size, int flags);
-	ssize_t 	(*splice_read)(struct socket *sock,  loff_t *ppos,
+	ssize_t 	(*splice_read)(struct file *file,  loff_t *ppos,
 				       struct pipe_inode_info *pipe, size_t len, unsigned int flags);
 };
 
diff --git a/include/net/tcp.h b/include/net/tcp.h
index 218235d..e8e7f80 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -309,7 +309,7 @@ extern int			tcp_twsk_unique(struct sock *sk,
 
 extern void			tcp_twsk_destructor(struct sock *sk);
 
-extern ssize_t			tcp_splice_read(struct socket *sk, loff_t *ppos,
+extern ssize_t			tcp_splice_read(struct file *file, loff_t *ppos,
 					        struct pipe_inode_info *pipe, size_t len, unsigned int flags);
 
 static inline void tcp_dec_quickack_mode(struct sock *sk,
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index ce572f9..c777d88 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -548,10 +548,11 @@ static int __tcp_splice_read(struct sock *sk, struct tcp_splice_state *tss)
  *    Will read pages from given socket and fill them into a pipe.
  *
  **/
-ssize_t tcp_splice_read(struct socket *sock, loff_t *ppos,
+ssize_t tcp_splice_read(struct file *file, loff_t *ppos,
 			struct pipe_inode_info *pipe, size_t len,
 			unsigned int flags)
 {
+	struct socket *sock = file->private_data;
 	struct sock *sk = sock->sk;
 	struct tcp_splice_state tss = {
 		.pipe = pipe,
@@ -572,7 +573,7 @@ ssize_t tcp_splice_read(struct socket *sock, loff_t *ppos,
 
 	lock_sock(sk);
 
-	timeo = sock_rcvtimeo(sk, flags & SPLICE_F_NONBLOCK);
+	timeo = sock_rcvtimeo(sk, file->f_flags & O_NONBLOCK);
 	while (tss.len) {
 		ret = __tcp_splice_read(sk, &tss);
 		if (ret < 0)

