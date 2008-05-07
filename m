Return-Path: <linux-kernel-owner+w=401wt.eu-S1762824AbYEGQ4H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762824AbYEGQ4H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 12:56:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751765AbYEGQzt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 12:55:49 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56706 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752751AbYEGQzr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 12:55:47 -0400
Date: Wed, 7 May 2008 09:55:18 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Matthew Wilcox <matthew@wil.cx>
cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       "J. Bruce Fields" <bfields@citi.umich.edu>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Alexander Viro <viro@ftp.linux.org.uk>, linux-fsdevel@vger.kernel.org
Subject: Re: AIM7 40% regression with 2.6.26-rc1
In-Reply-To: <20080507163811.GY19219@parisc-linux.org>
Message-ID: <alpine.LFD.1.10.0805070948250.3024@woody.linux-foundation.org>
References: <1210052904.3453.30.camel@ymzhang> <20080506114449.GC32591@elte.hu> <20080506120934.GH19219@parisc-linux.org> <20080506162332.GI19219@parisc-linux.org> <20080506102153.5484c6ac.akpm@linux-foundation.org>
 <20080507163811.GY19219@parisc-linux.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 7 May 2008, Matthew Wilcox wrote:
> 
> If heavily contended, it could do this.

It doesn' have to be heavily contended - if it's just hot and a bit lucky, 
it would potentially never schedule at all, because it would never take 
the spinlock and serialize the callers.

It doesn't even need "unfairness" to work that way. The old semaphore 
implementation was very much designed to be lock-free, and if you had one 
CPU doing a lock while another did an unlock, the *common* situation was 
that the unlock would succeed first, because the unlocker was also the 
person who had the spinlock exclusively in its cache!

The above may count as "lucky", but the hot-cache-line thing is a big 
deal. It likely "lucky" into something that isn't a 50:50 chance, but 
something that is quite possible to trigger consistently if you just have 
mostly short holders of the lock.

Which, btw, is probably true. The BKL is normally held for short times, 
and released (by that thread) for relatively much longer times. Which 
is when spinlocks tend to work the best, even when they are fair (because 
it's not so much a fairness issue, it's simply a cost-of-taking-the-lock 
issue!)

			Linus
