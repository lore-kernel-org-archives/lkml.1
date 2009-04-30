Return-Path: <linux-kernel-owner+w=401wt.eu-S1752368AbZD3E5J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752368AbZD3E5J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 00:57:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751399AbZD3E4z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 00:56:55 -0400
Received: from 1wt.eu ([62.212.114.60]:4185 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751254AbZD3E4y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 00:56:54 -0400
Date: Thu, 30 Apr 2009 06:56:47 +0200
From: Willy Tarreau <w@1wt.eu>
To: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: splice() on two pipes
Message-ID: <20090430045645.GF570@1wt.eu>
References: <20090429103308.GA23684@squirrel.roonstrasse.net> <87my9zpjqe.fsf@basil.nowhere.org> <20090429194254.GA7956@squirrel.roonstrasse.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="y0ulUmNC+osPPQO6"
Content-Disposition: inline
In-Reply-To: <20090429194254.GA7956@squirrel.roonstrasse.net>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--y0ulUmNC+osPPQO6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Apr 29, 2009 at 09:42:55PM +0200, Max Kellermann wrote:
> On 2009/04/29 17:23, Andi Kleen <andi@firstfloor.org> wrote:
> > I don't think splice is about handling all possible cases,
> > but just cases where the kernel can do better than user space.
> > I don't think that's the case here.
> 
> If splice() is about passing pointers of a pipe buffer, what's more
> trivial (and natural) than passing that pointer between two pipes?
> 
> > > when I read about the splice() system call, I thought it was obvious
> > > that it could copy data between two pipes. 
> > 
> > It would be more efficient if you used fd passing to pass the fd
> > around to the other process and let it read directly.
> 
> That's not so easy in my case.  The header output of the one process
> has to be parsed before the rest of it (or part of the rest) is going
> to be forwarded to the second one.  My master process would lose
> control over the transfer.  splice() looks like the perfect solution.

indeed, that could make sense. From what I have seen in the splicing
code, I think tht implementing pipe to pipe should not be *that* hard,
starting from existing code (eg: net to pipe). Maybe you could try to
implement it since you have the code which makes use of it ? I think
it is the kind of feature which can only improve step by step based
on application needs.

BTW, I like your test program. Simple and easy. I have completed it to
test tcp and udp, you can find it attached.

Regards,
Willy


--y0ulUmNC+osPPQO6
Content-Type: text/plain; charset=us-ascii
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
    { .name = "reg", },
    { .name = "chr", },
    { .name = "unix", },
    { .name = "tcp", },
    { .name = "udp", },
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
    fds[1].in = mkstemp(template1);
    fds[1].out = mkstemp(template2);
    fds[2].in = open("/dev/zero", O_RDONLY);
    fds[2].out = open("/dev/null", O_WRONLY);
    fds[3].in = socketpair(AF_UNIX, SOCK_STREAM, 0, f) >= 0 ? f[0] : -1;
    fds[3].out = socketpair(AF_UNIX, SOCK_STREAM, 0, f) >= 0 ? f[0] : -1;
    fds[4].in  = socket(AF_INET, SOCK_STREAM, 0);
    fds[4].out = socket(AF_INET, SOCK_STREAM, 0);
    fds[5].in  = socket(AF_INET, SOCK_DGRAM, 0);
    fds[5].out = socket(AF_INET, SOCK_DGRAM, 0);

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
            if (ret >= 0 || errno == EAGAIN || errno == EWOULDBLOCK
		|| errno == ENOTCONN)
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

--y0ulUmNC+osPPQO6--
