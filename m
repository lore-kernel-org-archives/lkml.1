Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754627Ab0CDDa2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 22:30:28 -0500
Received: from cantor.suse.de ([195.135.220.2]:35663 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753953Ab0CDDaV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 22:30:21 -0500
Date: Thu, 4 Mar 2010 14:30:17 +1100
From: Nick Piggin <npiggin@suse.de>
To: Miao Xie <miaox@cn.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>,
       Paul Menage <menage@google.com>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       Linux-MM <linux-mm@kvack.org>
Subject: Re: [PATCH 4/4] cpuset,mm: use rwlock to protect task->mempolicy
 and mems_allowed
Message-ID: <20100304033017.GN8653@laptop>
References: <4B8E3F77.6070201@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B8E3F77.6070201@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 03, 2010 at 06:52:39PM +0800, Miao Xie wrote:
> if MAX_NUMNODES > BITS_PER_LONG, loading/storing task->mems_allowed or mems_allowed in
> task->mempolicy are not atomic operations, and the kernel page allocator gets an empty
> mems_allowed when updating task->mems_allowed or mems_allowed in task->mempolicy. So we
> use a rwlock to protect them to fix this probelm.

Thanks for working on this. However, rwlocks are pretty nasty to use
when you have short critical sections and hot read-side (they're twice
as heavy as even spinlocks in that case).

It's being used in the page allocator path, so I would say rwlocks are
almost a showstopper. Wouldn't it be possible to use a seqlock for this?
