Return-Path: <linux-kernel-owner+w=401wt.eu-S1754944AbYCMMoq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754944AbYCMMoq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 08:44:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752841AbYCMMoi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 08:44:38 -0400
Received: from E23SMTP05.au.ibm.com ([202.81.18.174]:50439 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752357AbYCMMoi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 08:44:38 -0400
Date: Thu, 13 Mar 2008 18:14:24 +0530
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Alexander van Heukelum <heukelum@mailshack.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       heukelum@fastmail.fm
Subject: Re: [PATCH] x86: Change x86 to use generic find_next_bit
Message-ID: <20080313124424.GA18774@skywalker>
References: <20080309200103.GA895@mailshack.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080309200103.GA895@mailshack.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 09, 2008 at 09:01:04PM +0100, Alexander van Heukelum wrote:
> x86: Change x86 to use the generic find_next_bit implementation
> 
> The versions with inline assembly are in fact slower on the machines I
> tested them on (in userspace) (Athlon XP 2800+, p4-like Xeon 2.8GHz, AMD
> Opteron 270). The i386-version needed a fix similar to 06024f21 to avoid
> crashing the benchmark.
> 
> Benchmark using: gcc -fomit-frame-pointer -Os. For each bitmap size 
> 1...512, for each possible bitmap with one bit set, for each possible 
> offset: find the position of the first bit starting at offset. If you 
> follow ;). Times include setup of the bitmap and checking of the 
> results.
> 
> 		Athlon		Xeon		Opteron 32/64bit
> x86-specific:	0m3.692s	0m2.820s	0m3.196s / 0m2.480s
> generic:	0m2.622s	0m1.662s	0m2.100s / 0m1.572s
> 
> If the bitmap size is not a multiple of BITS_PER_LONG, and no set 
> (cleared) bit is found, find_next_bit (find_next_zero_bit) returns a 
> value outside of the range [0,size]. The generic version always returns 
> exactly size. The generic version also uses unsigned long everywhere, 
> while the x86 versions use a mishmash of int, unsigned (int), long and 
> unsigned long.
> 

This problem is observed on x86_64 and powerpc also. We need a long
aligned address for test_bit, set_bit find_bit etc.  In ext4 we have
to make sure we align the address passed to

ext4_test_bit
ext4_set_bit
ext4_find_next_zero_bit
ext4_find_next_bit

fs/ext4/mballoc.c have some examples.

-aneesh
