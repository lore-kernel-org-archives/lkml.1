Return-Path: <linux-kernel-owner+w=401wt.eu-S1762359AbYD3LeB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762359AbYD3LeB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 07:34:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756793AbYD3Ldw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 07:33:52 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:48422 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755753AbYD3Ldw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 07:33:52 -0400
Date: Wed, 30 Apr 2008 12:33:53 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
cc: Ross Biro <rossb@google.com>, linux-mm@kvack.org,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: Page Faults slower in 2.6.25-rc9 than 2.6.23
In-Reply-To: <20080430135035.b0b02533.kamezawa.hiroyu@jp.fujitsu.com>
Message-ID: <Pine.LNX.4.64.0804301215080.4651@blonde.site>
References: <d43160c70804290610t2135a271hd9b907529e89e74e@mail.gmail.com>
 <20080430135035.b0b02533.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Apr 2008, KAMEZAWA Hiroyuki wrote:
> On Tue, 29 Apr 2008 09:10:36 -0400
> "Ross Biro" <rossb@google.com> wrote:
> > I don't know if this has been noticed before.  I was benchmarking my
> > page table relocation code and I noticed that on 2.6.25-rc9 page
> > faults take 10% more time than on 2.6.22.  This is using lmbench
> > running on an intel x86_64 system.  The good news is that the page
> > table relocation code now only adds a 1.6% slow down to page faults.
> 
> It seems lmbench's pagefault program uses 'page fault by READ'.
> Then, this patch affects. (this patch was added at 2.6.24-rc?.)
> ==
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=557ed1fa2620dc119adb86b34c614e152a629a80
> ==
> By it, ZERO_PAGE is not used for page fault in anonymous mapping.

I'd wondered about that one too, but no: lmbench lat_pagefault uses
a shared mmap of an ordinary file (not /dev/zero), so the ZERO_PAGE
changes should have no effect on it whatsoever.

I notice that test is expecting msync(,,MS_INVALIDATE) to do something
it's never done on Linux (a kind of drop caches for the range).  We've
never done anything with MS_INVALIDATE, beyond permitting the flag:
I think you find problems however you try to go about implementing
it (and it might even originate from a UNIX which couldn't do shared
mmap coherently).  So I wonder if that test is erratic because of it.

Hugh
