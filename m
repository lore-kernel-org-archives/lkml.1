Return-Path: <linux-kernel-owner+w=401wt.eu-S1758762AbXFGG6B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758762AbXFGG6B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 02:58:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751777AbXFGG5y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 02:57:54 -0400
Received: from gw1.cosmosbay.com ([86.65.150.130]:49159 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752103AbXFGG5x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 02:57:53 -0400
Message-ID: <4667AB97.8090603@cosmosbay.com>
Date: Thu, 07 Jun 2007 08:54:15 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 1.5.0.12 (Windows/20070509)
MIME-Version: 1.0
To: Davide Libenzi <davidel@xmailserver.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Ulrich Drepper <drepper@redhat.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 1/8] fdmap v2 - fdmap core
References: <send-serie.davidel@xmailserver.org.4625.1181169031.1>
In-Reply-To: <send-serie.davidel@xmailserver.org.4625.1181169031.1>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [86.65.150.130]); Thu, 07 Jun 2007 08:54:21 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Davide Libenzi a écrit :
 > Core code for the fdmap implementation. Random allocation, exact allocation,
 > de-allocation and lookup are all O(1) operations. It also support the "legacy"
 > sequential (compact) file descriptor allocation, that is O(N) like the old
 > fdtable implementation.
 > Like the old "struct fdtable", fdmap is RCU friendly too.
 >

Hi Davide

I just took a 10 minutes look before running away this morning, I'll try to 
test this to get performance numbers in about 12 hours.



> + */
> +int fdmap_newfd_seq(struct fd_map *fmap, unsigned int start,
> +		    unsigned int limit, unsigned long flags)
> +{
> +	int fd;
> +
> +	if (unlikely(start))
> +		start = start - fmap->base;
> +	if (likely(start < fmap->fdnext))
> +		start = fmap->fdnext;
> +	fd = find_next_zero_bit(fmap->map, fmap->size, start);
> +	if (unlikely(fd >= limit))
> +		return -EMFILE;
> +	if (unlikely(fd >= fmap->size))
> +		return -ENOSPC;

> +	fmap->fdnext = fd + 1;

Here you broke POSIX I'm afraid.

You might need some test like

     if (start <= fmap->fdnext)
         fmap->fdnext = fd + 1;

Also I'm not sure the first unlikely() and likely() are worth it.

They probably match the user code you wrote yourself :)

Best thing is probably let the compiler generate a 50/50 code and let CPU uses 
its predictors.


> +
> +	return fdmap_alloc_tail(fmap, fd, flags);
> +}

/*
  * untested prog
  * should not fail if/when (ulimit -n 1024)
  */
#include <fcntl.h>
int main()
{
int highfd = fcntl(0, F_DUPFD, 1023);
int fd = open("/dev/null", O_RDONLY);
if (fd == -1) {
     perror("open /dev/null");
     return 1;
     }
return 0;
}
