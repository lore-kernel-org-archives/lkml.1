Return-Path: <linux-kernel-owner+w=401wt.eu-S1759850AbYGPWGP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759850AbYGPWGP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 18:06:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756039AbYGPWF6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 18:05:58 -0400
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:37898 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757600AbYGPWF5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 18:05:57 -0400
Date: Wed, 16 Jul 2008 18:05:56 -0400
To: Soumyadip Das Mahapatra <soumya.linux@yahoo.com>
Cc: peterz@infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] : A better approach to compute int_sqrt in lib/int_sqrt.c
Message-ID: <20080716220556.GI31126@csclub.uwaterloo.ca>
References: <848307.13278.qm@web59505.mail.ac4.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <848307.13278.qm@web59505.mail.ac4.yahoo.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 16, 2008 at 02:35:56PM -0700, Soumyadip Das Mahapatra wrote:
> Thanks Peter for noticing :-)
> Sorry, I should have it explained before. Really sorry
> for that. Here are they...
> 
> 0 It is better because 
>          o it uses only one loop instead of two
>          o contains no division operator (older version has two)
>             which are surely comparatively slow task in computer
> 
> 0 Currently find . -name '*.[ch]' | xargs grep int_sqrt gives me this
>         ....
>         ./fs/nfs/write.c:       nfs_congestion_kb = (16*int_sqrt(totalram_pages)) << (PAGE_SHIFT-10);
>         ./drivers/video/fbmon.c:        h_period = int_sqrt(h_period);
>         ./mm/page_alloc.c:      min_free_kbytes = int_sqrt(lowmem_kbytes * 16);
>         ./mm/oom_kill.c:        s = int_sqrt(cpu_time);
>         ./mm/oom_kill.c:        s = int_sqrt(int_sqrt(run_time));
>         ....
>   So this function works in critical computing sections like frame-buffer, paging.
>   Which means betterment of this function should not be ignored.
>   Besides, if there is a better way to do things then why should not we do that ?
> 
> Anyways thanks :-)

It is also very inaccurate:

int_sqrt(9380489) returns 3062 with the old code and 146574 with the new
code.  I wonder which one is closer to right.  It seems as soon as the
input is 2^22 or higher, the new code goes all to hell and starts
returning 2^16-1 or similarly silly values rather than 2^11-1 or
similar.

Here is how I tested:

(compiled with gcc -Wall -O2 -std=c99)

#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>

#define BITS_PER_LONG 32

unsigned long old_int_sqrt(unsigned long x) {
	unsigned long op, res, one;

	op = x;
	res = 0;

	one = 1UL << (BITS_PER_LONG - 2);
	while (one > op)
		one >>= 2;

	while (one != 0) {
		if (op >= res + one) {
			op = op - (res + one);
			res = res +  2 * one;
		}
		res /= 2;
		one /= 4;
	}
	return res;
}

unsigned long new_int_sqrt(unsigned long x) {
	unsigned long ub, lb, m;
	lb = 1;				/* lower bound */
	ub = (x >> 5) + 8;		/* upper bound */
	do {
		m = (ub + lb) >>  1;	/* middle value */
		if((m * m) > x)
			ub = m - 1;
		else
			lb = m + 1;
	} while(ub >= lb);

	return lb - 1;
}

int main() {
	unsigned long i;
	unsigned long old;
	unsigned long new;
	for(i=0;i<10000000;i++) {
		old=old_int_sqrt(i);
		new=new_int_sqrt(i);
		if(new!=old) {
			printf("sqrt(%lu)= %lu(new)->%llu %lu(old)->%llu",i,new,(unsigned long long)new*(unsigned long long)new,old,(unsigned long long)old*(unsigned long long)old);
			if(llabs((unsigned long long)new*(unsigned long long)new - (unsigned long long)i) < llabs((unsigned long long)old*(unsigned long long)old - (unsigned long long)i)) {
				printf(" (new is best)\n");
			} else {
				printf(" (old is best)\n");
			}
		}
	}
	return 0;
}

Example output:
sqrt(9380468)= 146574(new)->21483937476 3062(old)->9375844 (old is best)
sqrt(9380469)= 146574(new)->21483937476 3062(old)->9375844 (old is best)
sqrt(9380470)= 146574(new)->21483937476 3062(old)->9375844 (old is best)
sqrt(9380471)= 146574(new)->21483937476 3062(old)->9375844 (old is best)
sqrt(9380472)= 146574(new)->21483937476 3062(old)->9375844 (old is best)
sqrt(9380473)= 146574(new)->21483937476 3062(old)->9375844 (old is best)
sqrt(9380474)= 146574(new)->21483937476 3062(old)->9375844 (old is best)
sqrt(9380475)= 146574(new)->21483937476 3062(old)->9375844 (old is best)
sqrt(9380476)= 146574(new)->21483937476 3062(old)->9375844 (old is best)
sqrt(9380477)= 146574(new)->21483937476 3062(old)->9375844 (old is best)
sqrt(9380478)= 146574(new)->21483937476 3062(old)->9375844 (old is best)

-- 
Len Sorensen
