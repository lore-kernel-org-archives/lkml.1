Return-Path: <linux-kernel-owner+w=401wt.eu-S1752897AbZGWS0N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752897AbZGWS0N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 14:26:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752059AbZGWS0M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 14:26:12 -0400
Received: from cobra.newdream.net ([66.33.216.30]:51166 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751999AbZGWS0L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 14:26:11 -0400
Date: Thu, 23 Jul 2009 11:26:12 -0700 (PDT)
From: Sage Weil <sage@newdream.net>
To: linux-fsdevel@vger.kernel.org
cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 08/19] ceph: address space operations
In-Reply-To: <874ot33ddd.fsf@basil.nowhere.org>
Message-ID: <Pine.LNX.4.64.0907231122070.2930@cobra.newdream.net>
References: <1248292313-31326-1-git-send-email-sage@newdream.net>
 <1248292313-31326-2-git-send-email-sage@newdream.net>
 <1248292313-31326-3-git-send-email-sage@newdream.net>
 <1248292313-31326-4-git-send-email-sage@newdream.net>
 <1248292313-31326-5-git-send-email-sage@newdream.net>
 <1248292313-31326-6-git-send-email-sage@newdream.net>
 <1248292313-31326-7-git-send-email-sage@newdream.net>
 <1248292313-31326-8-git-send-email-sage@newdream.net>
 <1248292313-31326-9-git-send-email-sage@newdream.net> <874ot33ddd.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A related question I had on writepages failures: what is the 'right' thing 
to do if we get a server error on writeback?  If we believe it may be 
transient (say, ENOSPC), should we redirty pages and hope for better luck 
next time?

What if we decide it's a fatal error?

sage


On Thu, 23 Jul 2009, Andi Kleen wrote:

> Sage Weil <sage@newdream.net> writes:
> 
> > The ceph address space methods are concerned primarily with managing
> > the dirty page accounting in the inode, which (among other things)
> > must keep track of which snapshot context each page was dirtied in,
> > and ensure that dirty data is written out to the OSDs in snapshort
> > order.
> >
> > A writepage() on a page that is not currently writeable due to
> > snapshot writeback ordering constraints is ignored (it was presumably
> > called from kswapd).
> 
> Not a detailed review. You would need to get one from someone who
> knows the VFS interfaces very well (unfortunately those people are hard
> to find). I just read through it.
> 
> One thing I noticed is that you seem to do a lot of memory allocation
> in the write out paths (some of it even GFP_KERNEL, not GFP_NOFS) 
> 
> The traditional wisdom is that you should not allocate memory in block
> writeout, because that can deadlock. The worst case is swapfile
> on it, but it can happen with mmap too (e.g. one process using
> most memory with a file mmap from your fs)  GFP_KERNEL can also recurse,
> which can cause other problems in your fs.
> 
> There were some changes to make this problem less severe (e.g. better
> dirty pages accounting), but I don't think anyone has really declared
> it solved yet. The standard workaround for this is to use mempools 
> for anything allocated in the writeout path, then you are at least
> guaranteed to make forward progress.
> 
> You also had at least one unchecked kmalloc I think.
> 
> -Andi
> 
> -- 
> ak@linux.intel.com -- Speaking for myself only.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
