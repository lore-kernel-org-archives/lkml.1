Return-Path: <linux-kernel-owner+w=401wt.eu-S1756413AbZJ0Guv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756413AbZJ0Guv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 02:50:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756289AbZJ0Guu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 02:50:50 -0400
Received: from gw1.cosmosbay.com ([212.99.114.194]:60674 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756191AbZJ0Guu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 02:50:50 -0400
Message-ID: <4AE69829.9070207@gmail.com>
Date: Tue, 27 Oct 2009 07:50:17 +0100
From: Eric Dumazet <eric.dumazet@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Stephen Hemminger <stephen.hemminger@vyatta.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Octavian Purdila <opurdila@ixiacom.com>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH] dcache: better name hash function
References: <19864844.24581256620784317.JavaMail.root@tahiti.vyatta.com> <4AE68E23.20205@gmail.com>
In-Reply-To: <4AE68E23.20205@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Tue, 27 Oct 2009 07:50:19 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Dumazet a écrit :
> unsigned int fold2(unsigned hash)
> {
> 	return ((unsigned long long)hash * 211) >> 32;
> }
> 

I tried this reciprocal thing with 511 and 1023 values and got on a PIII 550 MHz, gcc-3.3.2 :

# ./hashtest 100000 511 
jhash_string         0.033123       1.01       234   1.06
fnv32                0.033911       1.02       254   1.38
# ./hashtest 1000000 511
jhash_string         0.331155       1.00      2109   1.10
fnv32                0.359346       1.00      2151   1.65
# ./hashtest 10000000 511
jhash_string         3.383340       1.00     19985   1.03
fnv32                3.849359       1.00     20198   1.53

# ./hashtest 100000 1023
jhash_string         0.033123       1.03       134   1.01
fnv32                0.034260       1.03       142   1.32
# ./hashtest 1000000 1023
jhash_string         0.332329       1.00      1075   1.06
fnv32                0.422035       1.00      1121   1.59
# ./hashtest 10000000 1023
jhash_string         3.417559       1.00     10107   1.01
fnv32                3.747563       1.00     10223   1.35


511 value on 64bit, and 1023 on 32bit arches are nice because
hashsz * sizeof(pointer) <= 4096, wasting space for one pointer only.

Conclusion : jhash and 511/1023 hashsize for netdevices,
no divides, only one multiply for the fold.

