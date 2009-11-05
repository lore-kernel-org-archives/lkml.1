Return-Path: <linux-kernel-owner+w=401wt.eu-S1753342AbZKEKac@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753342AbZKEKac (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 05:30:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751517AbZKEKac
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 05:30:32 -0500
Received: from gw1.cosmosbay.com ([212.99.114.194]:44625 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751288AbZKEKab (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 05:30:31 -0500
Message-ID: <4AF2A929.3000201@gmail.com>
Date: Thu, 05 Nov 2009 11:30:01 +0100
From: Eric Dumazet <eric.dumazet@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Max Kellermann <mk@cm4all.com>
CC: linux-kernel@vger.kernel.org, jens.axboe@oracle.com, max@duempel.org,
       Linux Netdev List <netdev@vger.kernel.org>
Subject: Re: [PATCH] tcp: set SPLICE_F_NONBLOCK after first buffer has been
 spliced
References: <20091105095947.32131.99768.stgit@rabbit.intern.cm-ag>
In-Reply-To: <20091105095947.32131.99768.stgit@rabbit.intern.cm-ag>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Thu, 05 Nov 2009 11:30:02 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Max Kellermann a écrit :
> When splicing a large amount of bytes from a TCP socket to a pipe
> (more than PIPE_BUFFERS), splice() can block, even though the pipe was
> empty.  The correct behavior would be to copy as much as possible, and
> return without blocking.  Block only if nothing can be transferred.
> When the destination pipe is (initially) writable, splice() should do
> the same with or without SPLICE_F_NONBLOCK.
> 
> The cause is the loop in tcp_splice_read(): it calls
> __tcp_splice_read() (and thus skb_splice_bits() and splice_to_pipe())
> again and again, until the requested number of bytes has been
> transferred, or an error occurs.  In the first iteration, up to 64 kB
> is copied, and the second iteration will block, because
> splice_to_pipe() is called again and sees the pipe is already full.
> 
> This patch adds SPLICE_F_NONBLOCK to the splice flags after the first
> iteration has finished successfully.  This prevents the second
> splice_to_pipe() call from blocking.  The resulting EAGAIN error is
> handled gracefully, and tcp_splice_read() returns the number of bytes
> successfully moved.
> ---
> 
>  net/ipv4/tcp.c |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
> 
> diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> index 9114524..0f8b01f 100644
> --- a/net/ipv4/tcp.c
> +++ b/net/ipv4/tcp.c
> @@ -628,6 +628,11 @@ ssize_t tcp_splice_read(struct socket *sock, loff_t *ppos,
>  		    (sk->sk_shutdown & RCV_SHUTDOWN) ||
>  		    signal_pending(current))
>  			break;
> +
> +		/* the following splice_to_pipe() calls should not
> +		   block, because we have already successfully
> +		   transferred at least one buffer */
> +		tss.flags |= SPLICE_F_NONBLOCK;
>  	}
>  
>  	release_sock(sk);
> 

CC netdev

I dont think this patch is correct. Could you describe your use case ?

If you dont want to block on output pipe, you should set this NONBLOCK 
flag before calling splice(SPLICE_F_NONBLOCK) syscall.

ie : Use the socket in blocking mode, but output pipe in non-blocking mode.

Some application could have a thread working in full blocking mode, and have another
thread reading the pipe (and eventually unblocking first thread)

Thanks
