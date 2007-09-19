Return-Path: <linux-kernel-owner+w=401wt.eu-S1757339AbXISWha@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757339AbXISWha (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 18:37:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753322AbXISWhL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 18:37:11 -0400
Received: from web53703.mail.re2.yahoo.com ([206.190.37.24]:20026 "HELO
	web53703.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753154AbXISWhK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 18:37:10 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=2pBWK1VSYFBm175w1WiP3FPh7Vtz/18LGU4KzKkep8ic3G4VBqIg0wh/TbrEmgR+HlCLPtDxAN3lLzFV1Tv/TlNk4//hF7sdHDXnnnq0iDTqYPIXzzB5EDA/VddErUxyU7ZzQO3Cnq/HVSOZDPvCWdAv0UpZO67YyBsHoIzs8R4=;
X-YMail-OSG: ZTHo78EVM1mUo.GfeiTS..dJHzwK7sl6WA.OYc18i_TZSafZScBthyehsXcizvSl68CmcLsB2yVmNXyVpUqCwkGfZ8YuAD6qcRoZ3ag2lxd6LH366_ZJB1skFSQoiQ--
Date: Wed, 19 Sep 2007 15:37:09 -0700 (PDT)
From: Nagendra Tomar <tomer_iisc@yahoo.com>
Subject: [PATCH 2.6.23-rc6 Resending] NETWORKING : Edge Triggered EPOLLOUT events get missed for TCP sockets
To: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, davem@davemloft.net,
       Davide Libenzi <davidel@xmailserver.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <130356.85796.qm@web53703.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The tcp_check_space() function calls tcp_new_space() only if the
SOCK_NOSPACE bit is set in the socket flags. This is causing Edge Triggered
EPOLLOUT events to be missed for TCP sockets, as the ep_poll_callback() 
is not called from the wakeup routine.

        The SOCK_NOSPACE bit indicates the user's intent to perform writes
on that socket (set in tcp_sendmsg and tcp_poll). I believe the idea 
behind the SOCK_NOSPACE check is to optimize away the tcp_new_space call
in cases when user is not interested in writing to the socket. These two
take care of all possible scenarios in which a user can convey his intent
to write on that socket.

Case 1: tcp_sendmsg detects lack of sndbuf space
Case 2: tcp_poll returns not writable

This is fine if we do not deal with epoll's Edge Triggered events (EPOLLET).
With ET events we can have a scenario where the SOCK_NOSPACE bit is not set,
as the user has neither done a sendmsg nor a poll/epoll call that returned
with the POLLOUT condition not set. 

        In this case the user will _never_ get an ET POLLOUT event since 
tcp_check_space() will not call tcp_new_space() (as the SOCK_NOSPACE bit is 
not set), which does the real work. THIS IS AGAINST THE EPOLL ET PROMISE OF
DELIVERING AN EVENT WHENEVER THE EVENT ACTUALLY HAPPENS. 

This ET event will be very helpful to implement user level memory management
for mmap+sendfile zero copy Tx. So typically the application does this

void *alloc_sendfile_buf(void)
{
        while(!next_free_buffer)
        {
                /*
                 * No free buffers (all are dispatched to sendfile and are 
                 * in use). Wait for one or more buffers to become free
                 * The socket fd is registered with EPOLLET|EPOLLOUT events.
                 * EPOLLET enables us to check for SIOCOUTQ only when some
                 * more space becomes available.
                 *
                 * One would expect the ET EPOLLOUT event to be notified 
                 * when TCP space is freed due to some ack coming in. 
                 */
                epoll_wait(...); /* wait for some incoming ack to free some
                                    buffer from the retransmit queue */
                ioctl(fd, SIOCOUTQ, &in_outq);
                /*
                 * see if we can mark some more "complete" buffers free
                 * If it can mark one or more buffer free, it will set
                 * next_free_buffer to point to the available buffer to use
                 */
                rehash_free_buffers(in_outq);
        }
        return next_free_buffer;
}

With the SOCK_NOSPACE check in tcp_check_space(), this epoll_wait call will 
not return, even when the incoming acks free the buffers.
        Note that this patch assumes that the SOCK_NOSPACE check in
tcp_check_space is a trivial optimization which can be safely removed.

Thanx,
Tomar
        

Signed-off-by: Nagendra Singh Tomar <nagendra_tomar@adaptec.com>
---

--- linux-2.6.23-rc6/net/ipv4/tcp_input.c.orig	2007-09-19 13:58:44.000000000 +0530
+++ linux-2.6.23-rc6/net/ipv4/tcp_input.c	2007-09-19 10:17:36.000000000 +0530
@@ -3929,8 +3929,7 @@ static void tcp_check_space(struct sock 
 {
 	if (sock_flag(sk, SOCK_QUEUE_SHRUNK)) {
 		sock_reset_flag(sk, SOCK_QUEUE_SHRUNK);
-		if (sk->sk_socket &&
-		    test_bit(SOCK_NOSPACE, &sk->sk_socket->flags))
+		if (sk->sk_socket)
 			tcp_new_space(sk);
 	}
 }


      ___________________________________________________________
Yahoo! Answers - Got a question? Someone out there knows the answer. Try it
now.
http://uk.answers.yahoo.com/ 
