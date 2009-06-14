Return-Path: <linux-kernel-owner+w=401wt.eu-S1762132AbZFNPvp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762132AbZFNPvp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 11:51:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753374AbZFNPvi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 11:51:38 -0400
Received: from waste.org ([66.93.16.53]:55113 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752968AbZFNPvh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 11:51:37 -0400
Subject: Re: issue with /dev/random? gets depleted very quick
From: Matt Mackall <mpm@selenic.com>
To: Folkert van Heusden <folkert@vanheusden.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <20090614125138.GZ7272@vanheusden.com>
References: <20090614125138.GZ7272@vanheusden.com>
Content-Type: text/plain
Date: Sun, 14 Jun 2009 10:51:09 -0500
Message-Id: <1244994669.4496.229.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[cc:ed to lkml]

On Sun, 2009-06-14 at 14:51 +0200, Folkert van Heusden wrote:
> Hi,
> 
> On an idle system (no gui, no daemons, nothing) system, /dev/random gets
> empty in a matter of 20 seconds with a 2.6.26 kernel.
> 
> My test:
> 
> add 1000 bits to the device:
> 
> zolder:/tmp# cat test-RNDADDENTROPY.c 
> #include <sys/types.h>
> #include <sys/stat.h>
> #include <fcntl.h>
> #include <sys/ioctl.h>
> #include <stdio.h>
> #include <stdlib.h>
> #include <asm/types.h>
> #include <linux/random.h>
> 
> int main(int argc, char *argv[])
> {
>         struct rand_pool_info *output;
>         int fd = open("/dev/random", O_WRONLY);
> 
>         output = (struct rand_pool_info *)malloc(10000);
>         output -> entropy_count = 1000;
>         output -> buf_size      = 8000;
> 
>         printf("%d\n", ioctl(fd, RNDADDENTROPY, output));
> 
>         return 0;
> }
> 
> and then check whayt is in it:
> 
> zolder:/tmp# ./a.out ; while true ; do echo `date` `cat /proc/sys/kernel/random/entropy_avail` ; sleep 1 ; done
> 0
> Sun Jun 14 14:50:44 CEST 2009 1117
> Sun Jun 14 14:50:45 CEST 2009 989
> Sun Jun 14 14:50:46 CEST 2009 925
> Sun Jun 14 14:50:47 CEST 2009 797
> Sun Jun 14 14:50:48 CEST 2009 733
> Sun Jun 14 14:50:49 CEST 2009 605
> Sun Jun 14 14:50:50 CEST 2009 541
> Sun Jun 14 14:50:51 CEST 2009 413
> Sun Jun 14 14:50:52 CEST 2009 349
> Sun Jun 14 14:50:53 CEST 2009 221
> Sun Jun 14 14:50:54 CEST 2009 157
> Sun Jun 14 14:50:55 CEST 2009 157
> 
> Is there something wrong with it?

Does it go below 128? If not, that's the behavior of something depleting
the pool down to the anti-starvation threshold via either /dev/urandom
or get_random_bytes.

On my system, I'm seeing that behavior as well. fuser reports a bunch of
processes hold /dev/urandom open, but stracing them doesn't reveal a
culprit. Which means there's now probably something in the kernel
calling get_random_bytes continuously.

Is this a problem? It really shouldn't be. Everyone should be
using /dev/urandom anyway. And the anti-starvation threshold guarantees
that if there's entropy being collected, readers of /dev/random can
always make forward progress.

-- 
http://selenic.com : development and support for Mercurial and Linux


