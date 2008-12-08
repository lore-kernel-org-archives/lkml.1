Return-Path: <linux-kernel-owner+w=401wt.eu-S1753851AbYLHWXl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753851AbYLHWXl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 17:23:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752848AbYLHWXb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 17:23:31 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47238 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752626AbYLHWXa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 17:23:30 -0500
Date: Mon, 8 Dec 2008 14:22:26 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Theodore Tso <tytso@mit.edu>
Cc: dada1@cosmosbay.com, linux-kernel@vger.kernel.org, davem@davemloft.net,
       a.p.zijlstra@chello.nl, cmm@us.ibm.com, linux-ext4@vger.kernel.org
Subject: Re: [PATCH] percpu_counter: Fix __percpu_counter_sum()
Message-Id: <20081208142226.c7b46f04.akpm@linux-foundation.org>
In-Reply-To: <20081208221241.GA2501@mit.edu>
References: <4936D287.6090206@cosmosbay.com>
	<4936EB04.8000609@cosmosbay.com>
	<20081206202233.3b74febc.akpm@linux-foundation.org>
	<493BCF60.1080409@cosmosbay.com>
	<20081207092854.f6bcbfae.akpm@linux-foundation.org>
	<493C0F40.7040304@cosmosbay.com>
	<20081207205250.dbb7fe4b.akpm@linux-foundation.org>
	<20081208221241.GA2501@mit.edu>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 8 Dec 2008 17:12:41 -0500
Theodore Tso <tytso@mit.edu> wrote:

> Actually, if all popular architectures had a hardware-implemented
> atomic_t, I wonder how much ext4 really needs the percpu counter,
> especially given ext4's multiblock allocator; with ext3, given that
> each block allocation required taking a per-filesystem spin lock,
> optimizing away that spinlock was far more important for improving
> ext3's scalability.  But with the multiblock allocator, it may that
> we're going through a lot more effort than what is truly necessary.

I expect that the performance numbers for the percpu counters in the
superblock are buried away in the historical git changelogs somewhere. 
I don't recall how much difference it made.

An atomic_inc() of an fs-wide counter will have similar cost to
spin_lock() of an fs-wide lock.

If the multiblock allocator can avoid doing one atomic_inc() for each
block and can instead do atomic_add(large_value, &counter) then yes,
I'm sure that an fs-wide atomic_long_t would be OK.

Of course, similar changes should be made in trucate, etc.
