Return-Path: <linux-kernel-owner+w=401wt.eu-S1752388Ab0ABVqA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752388Ab0ABVqA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jan 2010 16:46:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752078Ab0ABVp7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jan 2010 16:45:59 -0500
Received: from gate.crashing.org ([63.228.1.57]:43841 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752039Ab0ABVp7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jan 2010 16:45:59 -0500
Subject: Re: [RFC PATCH] asynchronous page fault.
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "minchan.kim@gmail.com" <minchan.kim@gmail.com>,
       cl@linux-foundation.org
In-Reply-To: <20091225105140.263180e8.kamezawa.hiroyu@jp.fujitsu.com>
References: <20091225105140.263180e8.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 03 Jan 2010 08:45:33 +1100
Message-ID: <1262468733.2173.251.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-12-25 at 10:51 +0900, KAMEZAWA Hiroyuki wrote:
> Speculative page fault v3.
> 
> This version is much simpler than old versions and doesn't use mm_accessor
> but use RCU. This is based on linux-2.6.33-rc2.
> 
> This patch is just my toy but shows...
>  - Once RB-tree is RCU-aware and no-lock in readside, we can avoid mmap_sem
>    in page fault. 
> So, what we need is not mm_accessor, but RCU-aware RB-tree, I think.
> 
> But yes, I may miss something critical ;)
> 
> After patch, statistics perf show is following. Test progam is attached.

One concern I have with this, not that it can't be addressed but we'll
have to be extra careful, is that the mmap_sem in the page fault path
tend to protect more than just the VMA tree.

One example on powerpc is the slice map used to keep track of page
sizes. I would also need some time to convince myself that I don't have
some bits of the MMU hash code that doesn't assume that holding the
mmap_sem for writing prevents a PTE from being changed from !present to
present.

I wouldn't be surprised if there were more around fancy users of
->fault(), things like spufs, the DRM, etc...

Cheers,
Ben.
 

