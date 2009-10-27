Return-Path: <linux-kernel-owner+w=401wt.eu-S1756213AbZJ0GIH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756213AbZJ0GIH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 02:08:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755588AbZJ0GIG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 02:08:06 -0400
Received: from gw1.cosmosbay.com ([212.99.114.194]:60914 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755451AbZJ0GIF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 02:08:05 -0400
Message-ID: <4AE68E23.20205@gmail.com>
Date: Tue, 27 Oct 2009 07:07:31 +0100
From: Eric Dumazet <eric.dumazet@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Stephen Hemminger <stephen.hemminger@vyatta.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Octavian Purdila <opurdila@ixiacom.com>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH] dcache: better name hash function
References: <19864844.24581256620784317.JavaMail.root@tahiti.vyatta.com>
In-Reply-To: <19864844.24581256620784317.JavaMail.root@tahiti.vyatta.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Tue, 27 Oct 2009 07:07:33 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Hemminger a écrit :
> One of the root causes of slowness in network usage
> was my original choice of power of 2 for hash size, to avoid
> a mod operation. It turns out if size is not a power of 2
> the original algorithm works fairly well.

Interesting, but I suspect all users have power of 2 tables :(

> 
> On slow cpu; with 10million entries and 211 hash size
> 
>
> 
> How important is saving the one division, versus getting better
> distribution.


unsigned int fold1(unsigned hash)
{
	return hash % 211;
}

Compiler uses a reciprocal divide because of 211 being a constant.

And you also could try following that contains one multiply only,
and check if hash distribution properties are still OK

unsigned int fold2(unsigned hash)
{
	return ((unsigned long long)hash * 211) >> 32;
}

fold1:
        movl    4(%esp), %ecx
        movl    $-1689489505, %edx
        movl    %ecx, %eax
        mull    %edx
        shrl    $7, %edx
        imull   $211, %edx, %edx
        subl    %edx, %ecx
        movl    %ecx, %eax
        ret

fold2:
        movl    $211, %eax
        mull    4(%esp)
        movl    %edx, %eax
        ret


