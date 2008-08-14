Return-Path: <linux-kernel-owner+w=401wt.eu-S1755084AbYHNW2V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755084AbYHNW2V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 18:28:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752282AbYHNW2N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 18:28:13 -0400
Received: from gate.crashing.org ([63.228.1.57]:35880 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752212AbYHNW2N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 18:28:13 -0400
Subject: Re: [PATCH 2.6.27] [POWERPC] Invalidate all TLB entries in a
	specified range
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Rocky Craig <rocky.craig@hp.com>
Cc: linuxppc-dev@ozlabs.org, paulus@samba.org,
       Linux Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <48A42F1A.6080903@hp.com>
References: <48A42F1A.6080903@hp.com>
Content-Type: text/plain
Date: Fri, 15 Aug 2008 08:28:01 +1000
Message-Id: <1218752881.8041.261.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-08-14 at 07:11 -0600, Rocky Craig wrote:
> From: Rocky Craig <rocky.craig@hp.com>
> 
> The apparent intent of "flush_tlbs" is to invalidate TLB entries that
> might match in the address range 0 to 0x00400000.  A loop counter is 
> set up at the high value and decremented by page size.  However, the 
> loop is only done once as the sense of the conditional branch at the
> loop end does not match the setup/decrement.
> 
> Signed-off-by: Rocky Craig <rocky.craig@hp.com>
> ---
> 
> Source is from 2.6.27 development, but the bug appears as far back as 2.4.0.
> The small user-space program below demonstrates the loop behavior.  It was
> compiled via crosstool gcc 3.4.5 / glibc 2.3.6 for an MPC8347 target.

Heh nice, that's a bug as old as the port I would say :-)

Ben.
 
> int main()
> {
> 	long endval;				// 16(r31)
> 
> 	__asm__ __volatile__(
> 		"	lis 10,0x40\n"
> 		"1:	addic. 10,10,-0x1000\n"
> 		"	bgt 1b\n"
> 		"	stw 10,16(31)\n");	// endval
> 
> 	printf("end value = 0x%08lx\n", endval);
> }
> 
> This might win the prize for "Smallest actual code patch ever".
> 
> --- a/arch/powerpc/kernel/head_32.S.orig	2008-07-24 19:25:09.000000000 -0600
> +++ a/arch/powerpc/kernel/head_32.S	2008-07-24 19:25:22.000000000 -0600
> @@ -1155,7 +1155,7 @@ flush_tlbs:
>  	lis	r10, 0x40
>  1:	addic.	r10, r10, -0x1000
>  	tlbie	r10
> -	blt	1b
> +	bgt	1b
>  	sync
>  	blr
>  
> 
> 

