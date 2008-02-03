Return-Path: <linux-kernel-owner+w=401wt.eu-S964800AbYBCDdk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964800AbYBCDdk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 22:33:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933240AbYBCDdc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 22:33:32 -0500
Received: from host36-195-149-62.serverdedicati.aruba.it ([62.149.195.36]:44820
	"EHLO mx.cpushare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933231AbYBCDdb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 22:33:31 -0500
Date: Sun, 3 Feb 2008 04:33:18 +0100
From: Andrea Arcangeli <andrea@qumranet.com>
To: Jack Steiner <steiner@sgi.com>
Cc: Christoph Lameter <clameter@sgi.com>, Robin Holt <holt@sgi.com>,
       Avi Kivity <avi@qumranet.com>, Izik Eidus <izike@qumranet.com>,
       kvm-devel@lists.sourceforge.net,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, daniel.blueman@quadrics.com
Subject: Re: [PATCH] mmu notifiers #v5
Message-ID: <20080203033318.GE7185@v2.random>
References: <20080131045750.855008281@sgi.com> <20080131171806.GN7185@v2.random> <Pine.LNX.4.64.0801311207540.25477@schroedinger.engr.sgi.com> <Pine.LNX.4.64.0801311508080.23624@schroedinger.engr.sgi.com> <20080131234101.GS7185@v2.random> <Pine.LNX.4.64.0801311738570.24297@schroedinger.engr.sgi.com> <20080201120955.GX7185@v2.random> <Pine.LNX.4.64.0802011118060.18163@schroedinger.engr.sgi.com> <20080203021704.GC7185@v2.random> <20080203031457.GA16127@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080203031457.GA16127@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 02, 2008 at 09:14:57PM -0600, Jack Steiner wrote:
> Also, most (but not all) applications that use the GRU do not usually do
> anything that requires frequent flushing (fortunately). The GRU is intended
> for HPC-like applications. These don't usually do frequent map/unmap
> operations or anything else that requires a lot of flushes.
> 
> I expect that KVM is a lot different.

I don't think so. invalidate_page/pages/range_start,end is a slow and
unfrequent path for KVM (or alternatively the ranges are very small in
which case _range_start/end won't payoff compared to _pages). Whenever
invalidate_page[s] become a fast path, we're generally I/O
bound. get_user_pages is always the fast path instead. I thought it
was much more important that get_user_pages scale as well as it does
now and that the KVM page fault isn't serialized with a mutex, than
whatever invalidate side optimization. get_user_pages may run
frequently from all vcpus even if there are no invalidates and no
memory pressure and I don't mean only during startup.

> I have most of the GRU code working with the latest mmuops patch. I still
> have a list of loose ends that I'll get to next week. The most important is
> the exact handling of the range invalidates. The code that I currently have
> works (mostly) but has a few endcases that will cause problems. Once I
> finish, I'll be glad to send you snippets of the code (or all of it) if you
> would like to take a look.

Sure.
