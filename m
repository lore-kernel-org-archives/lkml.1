Return-Path: <linux-kernel-owner+w=401wt.eu-S1754017AbZA1PFA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754017AbZA1PFA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 10:05:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751501AbZA1PEu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 10:04:50 -0500
Received: from mx2.redhat.com ([66.187.237.31]:37017 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751334AbZA1PEt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 10:04:49 -0500
Message-ID: <49807405.2060606@redhat.com>
Date: Wed, 28 Jan 2009 16:04:37 +0100
From: Gerd Hoffmann <kraxel@redhat.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: mtk.manpages@gmail.com
CC: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       linux-api@vger.kernel.org, aarcange@redhat.com
Subject: Re: [PATCH v7 3/5] Add preadv and pwritev system calls.
References: <1232976389-13021-1-git-send-email-kraxel@redhat.com>	 <1232976389-13021-4-git-send-email-kraxel@redhat.com> <cfd18e0f0901261542x2d29e790tad3e940f1aed134f@mail.gmail.com>
In-Reply-To: <cfd18e0f0901261542x2d29e790tad3e940f1aed134f@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------070003090501050709060709"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070003090501050709060709
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Michael Kerrisk wrote:
>> The application-visible interface provided by glibc should look like
>> this to be compatible to the existing implementations in the *BSD family:
>>
>>  ssize_t preadv(int d, const struct iovec *iov, int iovcnt, off_t offset);
>>  ssize_t pwritev(int d, const struct iovec *iov, int iovcnt, off_t offset);
> 
> I earlier asked if you could provide some userspace example code using
> this API.  If there was a response, I missed it.  Could you please
> provide some working test using this interface.

I had some ptrs in the patch series intro text.
Standalone test app is attached now.

cheers,
  Gerd

--------------070003090501050709060709
Content-Type: text/x-csrc;
 name="preadv.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="preadv.c"

#if 0
set -x
gcc -Wall -O2 -o preadv $0
exit 0
#endif
/*
 * preadv demo / test
 *
 * (c) 2008 Gerd Hoffmann <kraxel@redhat.com>
 *
 * build with "sh $thisfile"
 */

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <errno.h>
#include <inttypes.h>
#include <sys/uio.h>

/* ----------------------------------------------------------------- */
/* syscall windup                                                    */

#include <sys/syscall.h>
#if 0
/* WARNING: Be sure you know what you are doing if you enable this.
 * linux syscall code isn't upstream yet, syscall numbers are subject
 * to change */
# ifndef __NR_preadv
#  ifdef __i386__
#   define __NR_preadv  333
#   define __NR_pwritev 334
#  endif
#  ifdef __x86_64__
#   define __NR_preadv  295
#   define __NR_pwritev 296
#  endif
# endif
#endif
#ifndef __NR_preadv
# error preadv/pwritev syscall numbers are unknown
#endif

static ssize_t preadv(int fd, const struct iovec *iov, int iovcnt, off_t offset)
{
    uint32_t pos_high = (offset >> 32) & 0xffffffff;
    uint32_t pos_low  =  offset        & 0xffffffff;

    return syscall(__NR_preadv, fd, iov, iovcnt, pos_high, pos_low);
}

static ssize_t pwritev(int fd, const struct iovec *iov, int iovcnt, off_t offset)
{
    uint32_t pos_high = (offset >> 32) & 0xffffffff;
    uint32_t pos_low  =  offset        & 0xffffffff;

    return syscall(__NR_pwritev, fd, iov, iovcnt, pos_high, pos_low);
}

/* ----------------------------------------------------------------- */
/* demo/test app                                                     */

static char filename[] = "/tmp/preadv-XXXXXX";
static char outbuf[11] = "0123456789";
static char inbuf[11]  = "----------";

static struct iovec ovec[2] = {{
        .iov_base = outbuf + 5,
        .iov_len  = 5,
    },{
        .iov_base = outbuf + 0,
        .iov_len  = 5,
    }};

static struct iovec ivec[3] = {{
        .iov_base = inbuf + 6,
        .iov_len  = 2,
    },{
        .iov_base = inbuf + 4,
        .iov_len  = 2,
    },{
        .iov_base = inbuf + 2,
        .iov_len  = 2,
    }};

void cleanup(void)
{
    unlink(filename);
}

int main(int argc, char **argv)
{
    int fd, rc;

    fd = mkstemp(filename);
    if (-1 == fd) {
        perror("mkstemp");
        exit(1);
    }
    atexit(cleanup);

    /* write to file: "56789-01234" */
    rc = pwritev(fd, ovec, 2, 0);
    if (rc < 0) {
        perror("pwritev");
        exit(1);
    }

    /* read from file: "78-90-12" */
    rc = preadv(fd, ivec, 3, 2);
    if (rc < 0) {
        perror("preadv");
        exit(1);
    }

    printf("result  : %s\n", inbuf);
    printf("expected: %s\n", "--129078--");
    exit(0);
}

--------------070003090501050709060709--
