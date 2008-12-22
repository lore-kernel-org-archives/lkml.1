Return-Path: <linux-kernel-owner+w=401wt.eu-S1754025AbYLVHc0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754025AbYLVHc0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 02:32:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752443AbYLVHcS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 02:32:18 -0500
Received: from rn-out-0910.google.com ([64.233.170.187]:47905 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752091AbYLVHcQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 02:32:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=R1PZDV1Q0peOVqJt+InjAPcdHMGIqv4fmtzMI2X0tr/XWmdD8XLMt6pw30/aWjSYBN
         Z7Qs+RrENuvpyXaBnrxKRqhxJySH6eTGbC3xRVROqveM40/Qn6JUJ82KdXfBxEj6xzTR
         Hucd3C8GlYClnIyaNXpLTPAdi1+IG27tzIYhU=
Message-ID: <36ca99e90812212332l3067e911v89de96638734ea38@mail.gmail.com>
Date: Mon, 22 Dec 2008 08:32:15 +0100
From: "Bert Wesarg" <bert.wesarg@googlemail.com>
To: "Sebastian Andrzej Siewior" <sebastian@breakpoint.cc>
Subject: Re: [PATCH v2] add man-page for pthread_mutexattr_setrobust_np()
Cc: mtk.manpages@gmail.com, linux-man@vger.kernel.org,
       linux-kernel@vger.kernel.org, "Thomas Gleixner" <tglx@linutronix.de>,
       "Ulrich Drepper" <drepper@redhat.com>
In-Reply-To: <20081221205941.GA11805@Chamillionaire.breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081201213458.GA18973@Chamillionaire.breakpoint.cc>
	 <cfd18e0f0812070844t349b6026n6e2b0a2b4826fa66@mail.gmail.com>
	 <20081221205941.GA11805@Chamillionaire.breakpoint.cc>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 21, 2008 at 21:59, Sebastian Andrzej Siewior
<sebastian@breakpoint.cc> wrote:
> * Michael Kerrisk | 2008-12-07 11:44:54 [-0500]:
>
>>Sebastian,
> Michael,
Sebastian, Michael,

> +.SH EXAMPLE
> +The code example shows how to share a lock between two applications without
> +System V IPC.
> +An advantage over System V semaphores is that the kernel is not invoked in
> +case the lock is not hold.
> +If one of the applications dies while holding the lock or the system reboots
> +unexpectedly, the new owner of lock marks the lock state consistent.
> +In this example the lock owner does not need to perform any validation of the
> +resource protected by the lock.
> +
> +.nf
> +#define _GNU_SOURCE
> +
> +#include <errno.h>
> +#include <fcntl.h>
> +#include <pthread.h>
> +#include <stdio.h>
> +#include <stdlib.h>
> +#include <string.h>
> +#include <unistd.h>
> +
> +#include <sys/mman.h>
> +#include <sys/stat.h>
> +#include <sys/types.h>
> +
> +static const char *lock_name = "/dev/shm/limi_lock";
> +static pthread_mutex_t *limi_mutex;
> +
> +static int open_existing_lock(void)
> +{
> +    int fd;
> +    int ret;
> +    struct stat buf;
> +    int retry = 5;
> +
> +    fd = open(lock_name, O_RDWR);
> +    if (fd < 0)
> +        return fd;
> +    do {
> +        ret = fstat(fd, &buf);
> +        if (ret < 0)
Isn't here a close(2) missing?

> +            return ret;
> +
> +        if (buf.st_size == sizeof(*limi_mutex))
> +            return fd;
> +
> +        close(fd);
Isn't this close(2) wrong here?

> +        sleep(1);
> +        retry\-\-;
> +    } while (retry);
> +
> +    close(fd);
> +    return \-1;
> +}
> +
> +static int create_new_lock(void)
> +{
> +    int fd;
> +    pthread_mutex_t cmutex = PTHREAD_MUTEX_INITIALIZER;
> +    pthread_mutexattr_t attr;
> +    int ret;
> +
> +    pthread_mutexattr_init(&attr);
> +    pthread_mutexattr_setrobust_np(&attr, PTHREAD_MUTEX_ROBUST_NP);
> +    pthread_mutex_init(&cmutex, &attr);
> +
> +    fd = open(lock_name, O_RDWR | O_CREAT | O_EXCL, S_IRUSR | S_IWUSR |
> +            S_IRGRP | S_IWGRP);
> +    if (fd < 0)
> +        return fd;
> +
> +    ret = write(fd, &cmutex, sizeof(cmutex));
I think its undefined behavior if you copy a struct pthread_mutex. You
should use mmap here too.

> +    if (ret < 0) {
> +        fprintf(stderr, "Write to %s failed: %s\\n",
> +                lock_name, strerror(errno));
> +        exit(1);
> +    }
> +    return fd;
> +}
