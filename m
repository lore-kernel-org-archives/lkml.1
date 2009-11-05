Return-Path: <linux-kernel-owner+w=401wt.eu-S1753656AbZKEKLy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753656AbZKEKLy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 05:11:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752749AbZKEKLx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 05:11:53 -0500
Received: from s2.homepagix.de ([91.199.241.131]:51856 "EHLO fry.cm4all.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752018AbZKEKLx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 05:11:53 -0500
Date: Thu, 5 Nov 2009 11:12:11 +0100
From: Max Kellermann <mk@cm4all.com>
To: linux-kernel@vger.kernel.org
Cc: jens.axboe@oracle.com, max@duempel.org
Subject: Re: [PATCH] tcp: set SPLICE_F_NONBLOCK after first buffer has been
	spliced
Message-ID: <20091105101211.GA431@rabbit.intern.cm-ag>
References: <20091105095947.32131.99768.stgit@rabbit.intern.cm-ag>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="2oS5YaxWCcQjTEyO"
Content-Disposition: inline
In-Reply-To: <20091105095947.32131.99768.stgit@rabbit.intern.cm-ag>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--2oS5YaxWCcQjTEyO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

here is a small test program for the bug.  The last splice() blocks.
Interestingly, if you close the client socket before splice(), it does
not block, and the number of bytes transferred is smaller.

In my patch submission, I forgot the Signed-off-by line - please use
the attached patch file instead.

Max

--2oS5YaxWCcQjTEyO
Content-Type: text/x-csrc; charset=us-ascii
Content-Disposition: attachment; filename="splice-block.c"

/*
 * This program demonstrates how a splice() from a TCP socket blocks,
 * even though the destination pipe is empty.
 *
 * Copyright 2009 Content Management AG, Cologne, Germany
 * Author: Max Kellermann <mk@cm4all.com>
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License as
 * published by the Free Software Foundation; version 2 of the
 * License.
 */

#define _GNU_SOURCE
#include <fcntl.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <stdio.h>
#include <errno.h>
#include <unistd.h>
#include <stdbool.h>
#include <stdlib.h>
#include <string.h>

static size_t fill_socket(int fd, size_t max_fill)
{
    static char buffer[4096];
    ssize_t nbytes;
    size_t sent = 0;

    do {
        nbytes = send(fd, buffer, sizeof(buffer), MSG_DONTWAIT);
        if (nbytes >= 0)
            sent += (size_t)nbytes;
        else if (errno == EAGAIN)
            /* the socket buffer is full */
            break;
        else {
            perror("send() failed");
            exit(1);
        }
    } while (sent < max_fill);

    printf("sent %zu bytes\n", sent);
    return sent;
}

static void run(size_t max_fill, size_t max_splice, unsigned splice_flags,
                bool early_close)
{
    int i, listen_socket, client_socket, server_socket, pipefds[2];
    struct sockaddr_in sa;
    size_t sent;
    ssize_t nbytes;

    /* set up socket and pipe */

    memset(&sa, 0, sizeof(sa));
    sa.sin_family = AF_INET;
    sa.sin_addr.s_addr = htonl(INADDR_LOOPBACK);
    sa.sin_port = htons(1234);

    listen_socket = socket(AF_INET, SOCK_STREAM, 0);
    i = 1;
    if (listen_socket < 0 ||
        setsockopt(listen_socket, SOL_SOCKET, SO_REUSEADDR, &i, sizeof(i)) ||
        bind(listen_socket, (const struct sockaddr *)&sa, sizeof(sa)) < 0 ||
        listen(listen_socket, 1) < 0) {
        perror("failed to listen");
        exit(1);
    }

    client_socket = socket(AF_INET, SOCK_STREAM, 0);
    if (client_socket < 0 ||
        connect(client_socket, (const struct sockaddr *)&sa, sizeof(sa)) < 0) {
        perror("failed to connect");
        exit(1);
    }

    server_socket = accept(listen_socket, NULL, 0);
    if (server_socket < 0) {
        perror("failed to accept");
        exit(1);
    }

    close(listen_socket);

    if (pipe(pipefds) < 0) {
        perror("pipe() failed");
        exit(1);
    }

    /* fill the socket buffer */

    sent = fill_socket(client_socket, max_fill);

    printf("%sclosing client socket\n", early_close ? "" : "not ");
    if (early_close)
        close(client_socket);

    /* now splice from the socket into the pipe, as much as
       possible */

    if (max_splice == 0)
        max_splice = sent;

    printf("invoking splice(%zu, 0x%x)\n",
           max_splice, splice_flags);

    nbytes = splice(server_socket, NULL, pipefds[1], NULL,
                    max_splice, splice_flags);
    if (nbytes >= 0)
        printf("splice(%zu, 0x%x) = %zi\n",
               max_splice, splice_flags, nbytes);
    if (nbytes < 0)
        printf("splice(%zu, 0x%x) failed: %s\n",
               max_splice, splice_flags, strerror(errno));

    if (!early_close)
        close(client_socket);

    close(server_socket);
    close(pipefds[0]);
    close(pipefds[1]);
}

int main(int argc, char **argv)
{
    (void)argc; (void)argv;

    run(4096, 0, 0, true);
    run(262144, 4096, 0, true);
    run(262144, 0, SPLICE_F_NONBLOCK, true);
    /* when closing the client socket, this does not block! */
    run(262144, 0, 0, true);

    run(4096, 0, 0, false);
    run(262144, 4096, 0, false);
    run(262144, 0, SPLICE_F_NONBLOCK, false);

    /* this will block (2.6.31, 2.6.32-rc6) */
    run(262144, 0, 0, false);

    return 0;
}

--2oS5YaxWCcQjTEyO
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-tcp-set-SPLICE_F_NONBLOCK-after-first-buffer-has-be.patch"

>From 084ea2c0a1efdde6a1dc7f4bcabc32733fbac0ba Mon Sep 17 00:00:00 2001
From: Max Kellermann <mk@cm4all.com>
Date: Thu, 5 Nov 2009 11:05:25 +0100
Subject: [PATCH] tcp: set SPLICE_F_NONBLOCK after first buffer has been spliced

When splicing a large amount of bytes from a TCP socket to a pipe
(more than PIPE_BUFFERS), splice() can block, even though the pipe was
empty.  The correct behavior would be to copy as much as possible, and
return without blocking.  Block only if nothing can be transferred.
When the destination pipe is (initially) writable, splice() should do
the same with or without SPLICE_F_NONBLOCK.

The cause is the loop in tcp_splice_read(): it calls
__tcp_splice_read() (and thus skb_splice_bits() and splice_to_pipe())
again and again, until the requested number of bytes has been
transferred, or an error occurs.  In the first iteration, up to 64 kB
is copied, and the second iteration will block, because
splice_to_pipe() is called again and sees the pipe is already full.

This patch adds SPLICE_F_NONBLOCK to the splice flags after the first
iteration has finished successfully.  This prevents the second
splice_to_pipe() call from blocking.  The resulting EAGAIN error is
handled gracefully, and tcp_splice_read() returns the number of bytes
successfully moved.

Signed-off-by: Max Kellermann <mk@cm4all.com>
---
 net/ipv4/tcp.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 9114524..0f8b01f 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -628,6 +628,11 @@ ssize_t tcp_splice_read(struct socket *sock, loff_t *ppos,
 		    (sk->sk_shutdown & RCV_SHUTDOWN) ||
 		    signal_pending(current))
 			break;
+
+		/* the following splice_to_pipe() calls should not
+		   block, because we have already successfully
+		   transferred at least one buffer */
+		tss.flags |= SPLICE_F_NONBLOCK;
 	}
 
 	release_sock(sk);
-- 
1.5.6.5


--2oS5YaxWCcQjTEyO--
