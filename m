Return-Path: <linux-kernel-owner+w=401wt.eu-S1757635AbXEOUEa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757635AbXEOUEa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 16:04:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756047AbXEOUEP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 16:04:15 -0400
Received: from mu-out-0910.google.com ([209.85.134.184]:5278 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755857AbXEOUEN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 16:04:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=nBpDli81vekTEy9PydegijCPCC/tYq9+SZw1b/N6FW4wUXuUFjQPF9bLCug/4t4S3U/XjnLK3lcx6HfI4LwumP7iTx/AIe6RydslURT3LBMr/dE7O0+ew9Fw0J09ORewmAAAaBkZmbNrEqD05sZkbgpXWzFRcW2AZTL1QD4gAps=
Message-ID: <367a23780705151304s49734da1u778ab1ea96b3e9ed@mail.gmail.com>
Date: Tue, 15 May 2007 22:04:10 +0200
From: "Kacper Wysocki" <kacperw@online.no>
To: linux-kernel@vger.kernel.org, ck@vds.kolivas.org
Subject: Re: [ck] Swap prefetch tester
In-Reply-To: <200705141217.57142.kernel@kolivas.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200705141210.43614.kernel@kolivas.org>
	 <200705141217.57142.kernel@kolivas.org>
X-Google-Sender-Auth: 106d4f3fb2c5bcdd
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/14/07, Con Kolivas <kernel@kolivas.org> wrote:
> On Monday 14 May 2007 12:10, Con Kolivas wrote:
> > I've had a few requests for a standalone patch implementing swap prefetch
> > for mainline.
> >
> > Here is a patch that is a current rollup that should apply and work for
> > vanilla 2.6.21 (ie not a -ck kernel):
> >
> > http://ck.kolivas.org/patches/swap-prefetch/2.6.21-swap_prefetch-38.patch

> Oh and here is the swap prefetch tester:
> http://ck.kolivas.org/patches/swap-prefetch/sp_tester.c

Some results on my 5-year-old dual AMD2400+ with 1GB mem:
***This one done while in X, 2.6.21.1-reiser4-ck1, sp ON
Ram 1034228000  Swap 1959920000
Total ram to be malloced: 1551342000 bytes
Starting first malloc of 775671000 bytes
Starting 1st read of first malloc
Touching this much ram takes 6333 milliseconds
Starting second malloc of 775671000 bytes
Completed second malloc and free
Sleeping for 600 seconds
Important part - starting reread of first malloc
Completed read of first malloc
Timed portion 103277 milliseconds

***This one done while in X, 2.6.21.1-reiser4-ck-sp38, sp ON
Ram 1034228000  Swap 1959920000
Total ram to be malloced: 1551342000 bytes
Starting first malloc of 775671000 bytes
Starting 1st read of first malloc
Touching this much ram takes 11674 milliseconds
Starting second malloc of 775671000 bytes
Completed second malloc and free
Sleeping for 600 seconds
Important part - starting reread of first malloc
Completed read of first malloc
Timed portion 24660 milliseconds

...a nice order of magnitude better! Very happy you fixed this Con.
But the time to touch was so different (11674 vs 6333ms) that I
decided to get out of X, and also check the difference when SP is off.
# ./sp_tester; echo 0 > /proc/sys/vm/swap_prefetch ; ./sp_tester


***This one done in the console at runlevel 2, 2.6.21.1-reiser4-ck-sp38, sp ON
Ram 1034228000  Swap 1959920000
Total ram to be malloced: 1551342000 bytes
Starting first malloc of 775671000 bytes
Starting 1st read of first malloc
Touching this much ram takes 5709 milliseconds
Starting second malloc of 775671000 bytes
Completed second malloc and free
Sleeping for 600 seconds
Important part - starting reread of first malloc
Completed read of first malloc
Timed portion 22243 milliseconds

***This one done in the console at runlevel 2, 2.6.21.1-reiser4-ck-sp38, sp OFF
Ram 1034228000  Swap 1959920000
Total ram to be malloced: 1551342000 bytes
Starting first malloc of 775671000 bytes
Starting 1st read of first malloc
Touching this much ram takes 5816 milliseconds
Starting second malloc of 775671000 bytes
Completed second malloc and free
Sleeping for 600 seconds
Important part - starting reread of first malloc
Completed read of first malloc
Timed portion 28641 milliseconds

Have I understood correctly that there are more prefetch improvements
in ck2 than just the sp38 patch?

I'll post more results if I ever manage to tear myself from the
computer for 10 minutes when I'm home - it looks like I have a yiff
daemon running at 7% cpu all the time which might have affected the
results.

Speaking of "feel", the net effect of swap prefetch for me seems to be
that I don't notice it - that is, I don't notice my programs behaving
sluggishly when I come back to the computer. Excellent!

-K
