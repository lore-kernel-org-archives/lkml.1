Return-Path: <linux-kernel-owner+w=401wt.eu-S1752131AbYJTPAS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752131AbYJTPAS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 11:00:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750895AbYJTPAB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 11:00:01 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60834 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751209AbYJTPAA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 11:00:00 -0400
Message-ID: <48FC9CCC.3040006@linux-foundation.org>
Date: Mon, 20 Oct 2008 09:59:24 -0500
From: Christoph Lameter <cl@linux-foundation.org>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Miklos Szeredi <miklos@szeredi.hu>
CC: penberg@cs.helsinki.fi, nickpiggin@yahoo.com.au, hugh@veritas.com,
       linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: SLUB defrag pull request?
References: <1223883004.31587.15.camel@penberg-laptop> <1223883164.31587.16.camel@penberg-laptop> <Pine.LNX.4.64.0810131227120.20511@blonde.site> <200810132354.30789.nickpiggin@yahoo.com.au> <E1KpNwq-0003OW-8f@pomaz-ex.szeredi.hu> <E1KpOOL-0003Vf-9y@pomaz-ex.szeredi.hu> <48F378C6.7030206@linux-foundation.org> <E1KpOjX-0003dt-AY@pomaz-ex.szeredi.hu>
In-Reply-To: <E1KpOjX-0003dt-AY@pomaz-ex.szeredi.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Miklos Szeredi wrote:
> 
>>> It should be the other way round: first make sure nothing is
>>> referencing the inode, and _then_ start cleaning it up with
>>> appropriate locks held.  See prune_icache().

The code was initially taken from prune_icache.

>> kick_inodes() only works on inodes that first have undergone 
>> get_inodes() where we establish a refcount under inode_lock(). The final 
>> cleanup in kick_inodes() is done under iprune_mutex. You are looking at 
>> the loop that does writeback and invalidates attached dentries. This can 
>> fail for various reasons.
> 
> Yes, but I'm not at all sure that calling remove_inode_buffers() or
> invalidate_mapping_pages() is OK on a live inode.  They should be done
> after checking the refcount, just like prune_icache() does.

Dont we do the same on a truncate?

> Also, while d_invalidate() is not actually wrong here, because you
> check S_ISDIR(), but it's still the wrong function to use.  You really
> just want to shrink the children.  Invalidation means: the filesystem
> found out that the cached inode is invalid, so we want to throw it
> away.  In the future it might actually be able to do it for
> directories as well, but currently it cannot because of possible
> mounts on the dentry.

Thats the same issue as with the dentries. The new function could deal with
both situations?


