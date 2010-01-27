Return-Path: <linux-kernel-owner+w=401wt.eu-S1755991Ab0A0SOq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755991Ab0A0SOq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 13:14:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755958Ab0A0SOo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 13:14:44 -0500
Received: from mail2.shareable.org ([80.68.89.115]:46213 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755867Ab0A0SOm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 13:14:42 -0500
Date: Wed, 27 Jan 2010 18:14:24 +0000
From: Jamie Lokier <jamie@shareable.org>
To: Chris Frost <frost@cs.ucla.edu>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Benny Halevy <bhalevy@panasas.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org,
       Steve VanDeBogart <vandebo-lkml@nerdbox.net>
Subject: Re: [PATCH] fs: add fincore(2) (mincore(2) for file descriptors)
Message-ID: <20100127181424.GA21585@shareable.org>
References: <20100120215712.GO27212@frostnet.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100120215712.GO27212@frostnet.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Frost wrote:
> We introduced this system call while modifying SQLite and the GIMP to
> request large prefetches for what would otherwise be non-sequential reads.
> As a macrobenchmark, we see a 125s SQLite query (72s system time) reduced
> to 75s (18s system time) by using fincore() instead of mincore(). This
> speedup of course varies by benchmark and benchmarks size; we've seen
> both minimal speedups and 1000x speedups. More on these benchmarks in the
> publication _Reducing Seek Overhead with Application-Directed Prefetching_
> in USENIX ATC 2009 and at http://libprefetch.cs.ucla.edu/.

My first thought was:

Why is calling fincore() and then issuing reads better than simply
calling readahead() on the same range?  I.e. why is readahead() (or
POSIX_FADV_WILLNEED) unsuitable to give the same result?  Or even
issuing lots of AIO requests.

I knew that I was missing something, so I read the paper ;-) I don't
fully understand it, but *think* that it says fincore() is used to
detect when the kernel is evicting pages faster than libprefetch had
planned for, implying memory pressure, so it adjusts its planning in
response.

Interesting idea, though I wonder if it wouldn't be even better to
have a direct way to ask the kernel "tell me when there is memory
pressure causing my file to be evicted".

-- Jamie
