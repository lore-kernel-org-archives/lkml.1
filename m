Return-Path: <linux-kernel-owner+w=401wt.eu-S1760036AbZD2LC6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760036AbZD2LC6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 07:02:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759773AbZD2LBs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 07:01:48 -0400
Received: from smtp2.netcologne.de ([194.8.194.112]:58716 "EHLO
	smtp2.netcologne.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759920AbZD2LBr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 07:01:47 -0400
X-Greylist: delayed 1717 seconds by postgrey-1.27 at vger.kernel.org; Wed, 29 Apr 2009 07:01:46 EDT
Date: Wed, 29 Apr 2009 12:33:08 +0200
From: Max Kellermann <max@duempel.org>
To: linux-kernel@vger.kernel.org
Subject: splice() on two pipes
Message-ID: <20090429103308.GA23684@squirrel.roonstrasse.net>
Mail-Followup-To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="rwEMma7ioTxnRzrJ"
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--rwEMma7ioTxnRzrJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

when I read about the splice() system call, I thought it was obvious
that it could copy data between two pipes.  I was surprised that this
assumption is wrong, it's not possible on 2.6.29, I get EINVAL.  Can
anybody please explain this limitation?

Background: I want to forward data between two subprocesses, which are
connected to me with a pipe().

I have attached a small test program which prints a table of supported
splice operations.  Here's the output on 2.6.29.1:

 in\out  pipe    sock    reg     chr
 pipe    no      yes     yes     yes
 sock    no      no      no      no
 reg     yes     no      no      no
 chr     no      no      no      no

Max

--rwEMma7ioTxnRzrJ
Content-Type: text/x-csrc; charset=us-ascii
Content-Disposition: attachment; filename="test_splice.c"

/*
 * Copyright (C) 2009 Max Kellermann <max@duempel.org>
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 *
 * - Redistributions of source code must retain the above copyright
 * notice, this list of conditions and the following disclaimer.
 *
 * - Redistributions in binary form must reproduce the above copyright
 * notice, this list of conditions and the following disclaimer in the
 * documentation and/or other materials provided with the
 * distribution.
 */

/*
 * This tiny program prints a matrix: which file descriptor
 * combinations are supported by splice()?
 */

#define _GNU_SOURCE
#include <fcntl.h>
#include <errno.h>
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/socket.h>

static struct {
    const char *const name;
    int in, out;
} fds[] = {
    { .name = "pipe", },
    { .name = "sock", },
    { .name = "reg", },
    { .name = "chr", },
};

enum {
    NUM_FDS = sizeof(fds) / sizeof(fds[0]),
};

int main(int argc, char **argv)
{
    int f[2], ret;
    unsigned x, y;
    char template1[] = "/tmp/test_splice.XXXXXX";
    char template2[] = "/tmp/test_splice.XXXXXX";

    (void)argc;
    (void)argv;

    /* open two file descriptors of each kind */

    fds[0].in = pipe(f) >= 0 ? f[0] : -1;
    fds[0].out = pipe(f) >= 0 ? f[1] : -1;
    fds[1].in = socketpair(AF_UNIX, SOCK_STREAM, 0, f) >= 0 ? f[0] : -1;
    fds[1].out = socketpair(AF_UNIX, SOCK_STREAM, 0, f) >= 0 ? f[0] : -1;
    fds[2].in = mkstemp(template1);
    fds[2].out = mkstemp(template2);
    fds[3].in = open("/dev/zero", O_RDONLY);
    fds[3].out = open("/dev/null", O_WRONLY);

    /* print table header */

    printf("in\\out");
    for (x = 0; x < NUM_FDS; ++x)
        printf("\t%s", fds[x].name);
    putchar('\n');

    for (y = 0; y < NUM_FDS; ++y) {
        fputs(fds[y].name, stdout);

        for (x = 0; x < NUM_FDS; ++x) {
            putchar('\t');

            if (fds[x].out < 0 || fds[y].in < 0) {
                fputs("n/a", stdout);
                continue;
            }

            ret = splice(fds[y].in, NULL, fds[x].out, NULL, 1,
                         SPLICE_F_NONBLOCK);
            if (ret >= 0 || errno == EAGAIN || errno == EWOULDBLOCK)
                /* EAGAIN or EWOULDBLOCK means that the kernel has
                   accepted this combination, but can't move pages
                   right now */
                fputs("yes", stdout);
            else if (errno == EINVAL)
                /* the kernel doesn't support this combination */
                fputs("no", stdout);
            else if (errno == ENOSYS)
                /* splice() isn't supported at all */
                fputs("ENOSYS", stdout);
            else
                /* an unexpected error code */
                fputs("err", stdout);
        }

        putchar('\n');
    }

    unlink(template1);
    unlink(template2);
}

--rwEMma7ioTxnRzrJ--
