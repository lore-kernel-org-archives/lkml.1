Return-Path: <linux-kernel-owner+w=401wt.eu-S1760631AbYGQSAY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760631AbYGQSAY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 14:00:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757493AbYGQSAM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 14:00:12 -0400
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:59362 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756305AbYGQSAK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 14:00:10 -0400
Date: Thu, 17 Jul 2008 14:00:09 -0400
To: Soumyadip Das Mahapatra <soumya.linux@yahoo.com>
Cc: peterz@infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] : A better approach to compute int_sqrt in lib/int_sqrt.c
Message-ID: <20080717180008.GK31126@csclub.uwaterloo.ca>
References: <848307.13278.qm@web59505.mail.ac4.yahoo.com> <20080716220556.GI31126@csclub.uwaterloo.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080716220556.GI31126@csclub.uwaterloo.ca>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 16, 2008 at 06:05:56PM -0400, Lennart Sorensen wrote:
> It is also very inaccurate:
> 
> int_sqrt(9380489) returns 3062 with the old code and 146574 with the new
> code.  I wonder which one is closer to right.  It seems as soon as the
> input is 2^22 or higher, the new code goes all to hell and starts
> returning 2^16-1 or similarly silly values rather than 2^11-1 or
> similar.
> 
> Here is how I tested:
> 
> (compiled with gcc -Wall -O2 -std=c99)
> 
> #include <stdio.h>
> #include <unistd.h>
> #include <stdlib.h>
> 
> #define BITS_PER_LONG 32
> 
> unsigned long old_int_sqrt(unsigned long x) {
> 	unsigned long op, res, one;
> 
> 	op = x;
> 	res = 0;
> 
> 	one = 1UL << (BITS_PER_LONG - 2);
> 	while (one > op)
> 		one >>= 2;
> 
> 	while (one != 0) {
> 		if (op >= res + one) {
> 			op = op - (res + one);
> 			res = res +  2 * one;
> 		}
> 		res /= 2;
> 		one /= 4;
> 	}
> 	return res;
> }
> 
> unsigned long new_int_sqrt(unsigned long x) {
> 	unsigned long ub, lb, m;
> 	lb = 1;				/* lower bound */
> 	ub = (x >> 5) + 8;		/* upper bound */
> 	do {
> 		m = (ub + lb) >>  1;	/* middle value */
> 		if((m * m) > x)
This line overflows while the result is good if changed to:
 		if(((unsigned long long)m * (unsigned long long)m) > (unsigned long long)x)

Perhaps there is a better way to do this.

> 			ub = m - 1;
> 		else
> 			lb = m + 1;
> 	} while(ub >= lb);
> 
> 	return lb - 1;
> }
> 

-- 
Len Sorensen
