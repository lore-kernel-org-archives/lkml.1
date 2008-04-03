Return-Path: <linux-kernel-owner+w=401wt.eu-S1759856AbYDCT1M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759856AbYDCT1M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 15:27:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755905AbYDCT1A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 15:27:00 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:33008 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755583AbYDCT07 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 15:26:59 -0400
Date: Thu, 3 Apr 2008 20:26:54 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Erez Zadok <ezk@cs.sunysb.edu>
cc: "Josef 'Jeff' Sipek" <jeffpc@josefsipek.net>, akpm@linux-foundation.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Al Viro <viro@zeniv.linux.org.uk>, hch@infradead.org
Subject: Re: fs_stack/eCryptfs: remove 3rd arg of copy_attr_all, add locking
 to copy_inode_size 
In-Reply-To: <200804031907.m33J70fQ025437@agora.fsl.cs.sunysb.edu>
Message-ID: <Pine.LNX.4.64.0804032014350.4616@blonde.site>
References: <200804031907.m33J70fQ025437@agora.fsl.cs.sunysb.edu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Apr 2008, Erez Zadok wrote:
> In message <20080403182001.GB30189@josefsipek.net>, "Josef 'Jeff' Sipek" writes:
> > I think you need to check CONFIG_PREEMPT as well.
> 
> I'm not sure if it's needed in case of CONFIG_PREEMPT.  Anyone?  The code
> for i_size_write (below), and the comment at the top of the function,
> suggest that the spinlock is needed only to prevent the lots seqcount.

Correct.

> BTW, some time ago I reviewed all callers of i_size_write.  I did so again
> just now, and the results were the same:
> 
> - a LOT of callers of i_size_write don't take any lock

They mostly know that i_mutex is already held (as i_size_write comment
mentions); but I believe that's up to the individual filesystem.

> - some take another spinlock in a different data structure
> - those that do take the spinlock, do so unconditionally
> - only unionfs and fs/stack.c wrap the spinlock in
> 
> 	#if BITS_PER_LONG == 32 && defined(CONFIG_SMP)

I chose to follow the #ifdeffery of i_size_write(),
but you could do it unconditionally if you prefer:
just a little more overhead when it's not needed.

As I've said elsewhere, I don't think the result can be entirely
safe against concurrent changes in the lower filesystem, using
different locking; but I don't know how resilient unionfs is
expected to be against messing directly with lower at the same
time as upper level.

Hugh
