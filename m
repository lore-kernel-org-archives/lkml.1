Return-Path: <linux-kernel-owner+w=401wt.eu-S1753080AbYJRHxT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753080AbYJRHxT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2008 03:53:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751293AbYJRHxM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Oct 2008 03:53:12 -0400
Received: from one.firstfloor.org ([213.235.205.2]:50487 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751281AbYJRHxL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2008 03:53:11 -0400
To: Chris Snook <csnook@redhat.com>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [Slightly off topic] A question about R/B trees.
From: Andi Kleen <andi@firstfloor.org>
References: <48F904FA.6090102@gmail.com> <48F90E96.3060800@redhat.com>
Date: Sat, 18 Oct 2008 09:53:10 +0200
In-Reply-To: <48F90E96.3060800@redhat.com> (Chris Snook's message of "Fri, 17 Oct 2008 18:15:50 -0400")
Message-ID: <87myh2jq55.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Snook <csnook@redhat.com> writes:

> Maxim Levitsky wrote:
>> I am working on my small project, and I need a fast container to
>> hold a large sparse array.
>> Balanced trees seem to fit perfectly.
>
> Balanced trees take O(log n) to perform a great many operations, and
> traversing a binary tree is a particularly bad case for branch
> prediction.  Hash tables will perform much better, unless you get them
> horribly wrong.

That seems like a unfair generalization.

The problem with hash tables is that if they're big enough
or if the rest of the workload is memory intensive
each hit will be a cache miss. And you can do a lot of branch
mispredicts in the time of a single cache miss.

In general trees can be much better for cache usage, although
it's generally better to use some tree that has nodes near 
the cache line size. Binary trees like RB are too small for that.

The other advantage of trees is that they scale naturally.
For hash tables you either have it being sized for the worst
case (usually wasting a lot of memory[1] and making the cache miss
problem worse) or you need to do dynamic rehashing which 
is complex and difficult to get right especially in multi threaded
situations.

That is why the trend in Linux at least is to move away from
hash tables.

[1] Just take a look at how much memory that various hash 
tables in Linux use: dmesg | grep hash

> The kernel is written in a dialect of C that makes several assumptions
> about the compiler, among them that the compiler won't screw this up
> unless you tell it to.  Any compiler that has alignment problems with
> the rbtree code is going to have similar problems in lots of other
> places too.  We don't support those compilers.

At least upto 4 bytes or so it's generally a safe assumption
that objects will be naturally aligned. Also except for tree 
root the objects are typically allocated with malloc() (or
equivalent kmalloc) anyways and malloc()s guarantee
worst case alignment.


-Andi
-- 
ak@linux.intel.com
