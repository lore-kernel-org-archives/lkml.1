Return-Path: <linux-kernel-owner+w=401wt.eu-S1763629AbXFBWuA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763629AbXFBWuA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2007 18:50:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761670AbXFBWtx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jun 2007 18:49:53 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40015 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760729AbXFBWtx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2007 18:49:53 -0400
Date: Sat, 2 Jun 2007 15:49:42 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, Jan Kara <jack@suse.cz>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] Fix possible leakage of blocks in UDF
Message-Id: <20070602154942.cc4f9818.akpm@linux-foundation.org>
In-Reply-To: <20070602200146.GC8518@cvg>
References: <4660FD7F.4090302@sandeen.net>
	<20070601224339.c803e04e.akpm@linux-foundation.org>
	<20070602063403.GA8387@cvg>
	<20070601235422.fdc1f750.akpm@linux-foundation.org>
	<20070602065923.GB8387@cvg>
	<20070602000645.508ddf93.akpm@linux-foundation.org>
	<20070602140619.GA10303@cvg>
	<20070602103203.e39d25ed.akpm@linux-foundation.org>
	<20070602185707.GA8518@cvg>
	<20070602121616.37ffce9e.akpm@linux-foundation.org>
	<20070602200146.GC8518@cvg>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 3 Jun 2007 00:01:46 +0400 Cyrill Gorcunov <gorcunov@gmail.com> wrote:

> [Andrew Morton - Sat, Jun 02, 2007 at 12:16:16PM -0700]
> [...snip...]
> | 
> | No, the problem is that the patch caused the kernel to take inode_lock
> | within the newly-added drop_inode(), btu drop_inode() is already called
> | under inode_lock.
> | 
> | It has nothing to do with lock_kernel() and it has nothing to do with
> | sleeping.
> | 
> 
> Andrew, the only call that could leading to subseq. inode_lock lock
> is mark_inode_dirty() I guess (and that is snown by Eric's dump)
> but as I shown you in my dbg print without SMP it's OK. So
> is it SMP who lead to lock? How it depends on it? (I understand
> that is a stupid question for you but if you have time explain
> me this please ;)
> 

When CONFIG_SMP=n, spin_lock() is a no-op.  (Except with CONFIG_PREEMPT=y,
in which case spin_lock() will disable kernel preemption on SMP and non-SMP
kernels)

When CONFIG_SMP=y, spin_lock() really does take a lock.  But if this thread
already holds this lock, we'll deadlock.

