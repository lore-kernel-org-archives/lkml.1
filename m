Return-Path: <linux-kernel-owner+w=401wt.eu-S1756622AbYKMWPC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756622AbYKMWPC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 17:15:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756392AbYKMWOS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 17:14:18 -0500
Received: from rv-out-0506.google.com ([209.85.198.235]:10000 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756389AbYKMWOO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 17:14:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references;
        b=QzOeiP8SZ76uUiCOVZr+UrvCyZVkyhtZPhYtPTDlhyXqdo0wnh0uCSgU9zD1GisCdV
         cBsFZtqBpts2Rcgsx082kSpzNOkEaAzWaWy9neWPLN+0l21niD/ifu3XW52QyTMPCH3Q
         R+Kj7uitvkm5nprm5LYD9FenhtyUEoAMh1lv4=
Message-ID: <cfd18e0f0811131414k7edfa2fw7c7d5581845f3742@mail.gmail.com>
Date: Thu, 13 Nov 2008 17:14:13 -0500
From: "Michael Kerrisk" <mtk.manpages@googlemail.com>
Reply-To: mtk.manpages@gmail.com
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH] reintroduce accept4
Cc: "Subrata Modak" <subrata@linux.vnet.ibm.com>, linux-arch@vger.kernel.org,
       "Ulrich Drepper" <drepper@redhat.com>, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, linux-api@vger.kernel.org,
       linux-man@vger.kernel.org, "Davide Libenzi" <davidel@xmailserver.org>,
       netdev <netdev@vger.kernel.org>, "Roland McGrath" <roland@redhat.com>,
       "Oleg Nesterov" <oleg@tv-sign.ru>, "Christoph Hellwig" <hch@lst.de>,
       "David Miller" <davem@davemloft.net>, "Alan Cox" <alan@redhat.com>,
       "Jakub Jelinek" <jakub@redhat.com>
In-Reply-To: <cfd18e0f0811131411o5b47175dl36b022bc762181e5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200810261641.m9QGfotr024285@hs20-bc2-1.build.redhat.com>
	 <517f3f820811131351l1305b2d2u43ab4e0601d97f93@mail.gmail.com>
	 <cfd18e0f0811131402j7ec6a60cq462916cc9715b9aa@mail.gmail.com>
	 <cfd18e0f0811131411o5b47175dl36b022bc762181e5@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew,

There was a couplke of crufty printf()'s in the preceding version that
I didn't notice until just after I hit send.  Paste this version into
the changelog instead.

Cheers,

Michael
/* test_accept4.c

   Copyright (C) 2008, Linux Foundation, written by Michael Kerrisk
        <mtk.manpages@gmail.com>

   Licensed under the GNU GPLv2 or later.
*/
#define _GNU_SOURCE
#include <unistd.h>
#include <sys/syscall.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <stdlib.h>
#include <fcntl.h>
#include <stdio.h>
#include <string.h>

#define PORT_NUM 33333

#define die(msg) do { perror(msg); exit(EXIT_FAILURE); } while (0)

/**********************************************************************/

/* The following is what we need until glibc gets a wrapper for
   accept4() */

/* Flags for socket(), socketpair(), accept4() */
#ifndef SOCK_CLOEXEC
#define SOCK_CLOEXEC    O_CLOEXEC
#endif
#ifndef SOCK_NONBLOCK
#define SOCK_NONBLOCK   O_NONBLOCK
#endif

#ifdef __x86_64__
#define SYS_accept4 288
#elif __i386__
#define USE_SOCKETCALL 1
#define SYS_ACCEPT4 18
#else
#error "Sorry -- don't know the syscall # on this architecture"
#endif

static int
accept4(int fd, struct sockaddr *sockaddr, socklen_t *addrlen, int flags)
{
    printf("Calling accept4(): flags = %x", flags);
    if (flags != 0) {
        printf(" (");
        if (flags & SOCK_CLOEXEC)
            printf("SOCK_CLOEXEC");
        if ((flags & SOCK_CLOEXEC) && (flags & SOCK_NONBLOCK))
            printf(" ");
        if (flags & SOCK_NONBLOCK)
            printf("SOCK_NONBLOCK");
        printf(")");
    }
    printf("\n");

#if USE_SOCKETCALL
    long args[6];

    args[0] = fd;
    args[1] = (long) sockaddr;
    args[2] = (long) addrlen;
    args[3] = flags;

    return syscall(SYS_socketcall, SYS_ACCEPT4, args);
#else
    return syscall(SYS_accept4, fd, sockaddr, addrlen, flags);
#endif
}

/**********************************************************************/


static int
do_test(int lfd, struct sockaddr_in *conn_addr,
        int closeonexec_flag, int nonblock_flag)
{
    int connfd, acceptfd;
    int fdf, flf, fdf_pass, flf_pass;
    struct sockaddr_in claddr;
    socklen_t addrlen;

    printf("=======================================\n");

    connfd = socket(AF_INET, SOCK_STREAM, 0);
    if (connfd == -1)
        die("socket");
    if (connect(connfd, (struct sockaddr *) conn_addr,
                sizeof(struct sockaddr_in)) == -1)
        die("connect");

    addrlen = sizeof(struct sockaddr_in);
    acceptfd = accept4(lfd, (struct sockaddr *) &claddr, &addrlen,
                       closeonexec_flag | nonblock_flag);
    if (acceptfd == -1) {
        perror("accept4()");
        close(connfd);
        return 0;
    }

    fdf = fcntl(acceptfd, F_GETFD);
    if (fdf == -1)
        die("fcntl:F_GETFD");
    fdf_pass = ((fdf & FD_CLOEXEC) != 0) ==
               ((closeonexec_flag & SOCK_CLOEXEC) != 0);
    printf("Close-on-exec flag is %sset (%s); ",
            (fdf & FD_CLOEXEC) ? "" : "not ",
            fdf_pass ? "OK" : "failed");

    flf = fcntl(acceptfd, F_GETFL);
    if (flf == -1)
        die("fcntl:F_GETFD");
    flf_pass = ((flf & O_NONBLOCK) != 0) ==
               ((nonblock_flag & SOCK_NONBLOCK) !=0);
    printf("nonblock flag is %sset (%s)\n",
            (flf & O_NONBLOCK) ? "" : "not ",
            flf_pass ? "OK" : "failed");

    close(acceptfd);
    close(connfd);

    printf("Test result: %s\n", (fdf_pass && flf_pass) ? "PASS" : "FAIL");
    return fdf_pass && flf_pass;
}


static int
create_listening_socket(int port_num)
{
    struct sockaddr_in svaddr;
    int lfd;
    int optval;

    memset(&svaddr, 0, sizeof(struct sockaddr_in));
    svaddr.sin_family = AF_INET;
    svaddr.sin_addr.s_addr = htonl(INADDR_ANY);
    svaddr.sin_port = htons(port_num);

    lfd = socket(AF_INET, SOCK_STREAM, 0);
    if (lfd == -1)
        die("socket");

    optval = 1;
    if (setsockopt(lfd, SOL_SOCKET, SO_REUSEADDR, &optval,
                   sizeof(optval)) == -1)
        die("setsockopt");

    if (bind(lfd, (struct sockaddr *) &svaddr,
             sizeof(struct sockaddr_in)) == -1)
        die("bind");

    if (listen(lfd, 5) == -1)
        die("listen");

    return lfd;
}


int
main(int argc, char *argv[])
{
    struct sockaddr_in conn_addr;
    int lfd;
    int port_num;
    int passed;

    passed = 1;

    port_num = (argc > 1) ? atoi(argv[1]) : PORT_NUM;

    memset(&conn_addr, 0, sizeof(struct sockaddr_in));
    conn_addr.sin_family = AF_INET;
    conn_addr.sin_addr.s_addr = htonl(INADDR_LOOPBACK);
    conn_addr.sin_port = htons(port_num);

    lfd = create_listening_socket(port_num);

    if (!do_test(lfd, &conn_addr, 0, 0))
        passed = 0;
    if (!do_test(lfd, &conn_addr, SOCK_CLOEXEC, 0))
        passed = 0;
    if (!do_test(lfd, &conn_addr, 0, SOCK_NONBLOCK))
        passed = 0;
    if (!do_test(lfd, &conn_addr, SOCK_CLOEXEC, SOCK_NONBLOCK))
        passed = 0;

    close(lfd);

    exit(passed ? EXIT_SUCCESS : EXIT_FAILURE);
}
