Return-Path: <linux-kernel-owner+w=401wt.eu-S1752887AbZLaSj7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752887AbZLaSj7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Dec 2009 13:39:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752474AbZLaSj6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Dec 2009 13:39:58 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36568 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751536AbZLaSj6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Dec 2009 13:39:58 -0500
Date: Thu, 31 Dec 2009 10:39:41 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Yuhong Bao <yuhongbao_386@hotmail.com>
cc: mingo@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: Ubuntu 32-bit, 32-bit PAE, 64-bit Kernel Benchmarks
In-Reply-To: <SNT125-W41CEF6892DBE0B1FD99B4AC3780@phx.gbl>
Message-ID: <alpine.LFD.2.00.0912311019580.11961@localhost.localdomain>
References: <SNT125-W41CEF6892DBE0B1FD99B4AC3780@phx.gbl>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 30 Dec 2009, Yuhong Bao wrote:
> 
> Given that Linus was once talking about the performance penalties of PAE 
> and HIGHMEM64G, perhaps you'd find these benchmarks done by Phoronix of 
> interest:
>   http://www.phoronix.com/scan.php?page=article&item=ubuntu_32_pae

PAE has no negative impact on user-land loads (aside from a potentially 
really _tiny_ effect from just bigger page tables), and obviously means 
that you actually have more RAM available, so it can be a big win.

The "25% cost" is purely kernel-side work when the kernel needs to 
kmap/kunmap - which it only needs to do when it touches highmem pages 
itself directly. Which is pretty rare - but when it happens a lot, it's 
extremely expensive.

The worst load I've ever seen (which was the 25%+ case) needed btrfs 
and heavy meta-data workloads (ie things like file creates/deletes, or 
uncached lookups), because btrfs puts all its radix trees in highmem pages 
and thus needs to kmap/kunmap them all. So that's one way to see heavy 
kmap/kunmap loads.

(In the meantime, I complained to the btrfs people about the CPU hogging 
behavior, and afaik btrfs has improved since I did my kernel profiles of 
the benchmarks, but I haven't re-done them)

Theres' a potential secondary issue: my test-bed for that btrfs setup was 
a netbook using Intel Atom. The performance profile of an Atom chip is 
pretty different from any of the better out-of-order CPU's.

Extra instructions cost a lot more. For example, out-of-order is 
particularly good at handling "nonsense" instructions that aren't on a 
critical path and aren't important for actual semantics - things like the 
stack frame modifications etc are often almost "free" on out-of-order 
CPU's because they only tend to have trivial dependencies that can be 
worked around with things like the "stack engine" etc. So I seem to 
remember that the "omit stack frame" option was a much bigger deal on Atom 
than on a Core 2 Duo CPU, for example.

So it's entirely possible that the TLB flushing (and eventual misses, of 
course) involved with kmap()/kunmap() is much more expensive on Atom than 
it is on a Core2 system. So it's possible that my 25% cost thing was for 
pretty much a pessimal situation, due to a combination of heavy kernel 
loads (I used "git status" as one of the btrfs/atom benchmarks - pretty 
much _all_ it does is pathname lookups and readdir) with btrfs and atom.

		Linus
