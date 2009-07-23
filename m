Return-Path: <linux-kernel-owner+w=401wt.eu-S1753169AbZGWSWH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753169AbZGWSWH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 14:22:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752961AbZGWSWG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 14:22:06 -0400
Received: from cobra.newdream.net ([66.33.216.30]:37336 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752282AbZGWSWF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 14:22:05 -0400
Date: Thu, 23 Jul 2009 11:22:04 -0700 (PDT)
From: Sage Weil <sage@newdream.net>
To: Andi Kleen <andi@firstfloor.org>
cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 08/19] ceph: address space operations
In-Reply-To: <874ot33ddd.fsf@basil.nowhere.org>
Message-ID: <Pine.LNX.4.64.0907231115190.2930@cobra.newdream.net>
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

I fixed the bad GFP_KERNEL/uncheck kmalloc.  Which was just a struct 
pagevec, which we added a while ago to reduce stack usage.  Maybe the 
stack is a better place for it though?  (cifs puts it on the stack...)

> There were some changes to make this problem less severe (e.g. better
> dirty pages accounting), but I don't think anyone has really declared
> it solved yet. The standard workaround for this is to use mempools 
> for anything allocated in the writeout path, then you are at least
> guaranteed to make forward progress.

There are two other memory allocations during writeout: a vector of pages 
to be written, and the message we're sending to the OSD.  If I use a 
mempool for those to guarantee as least some writeout will occur, how do I 
safely defer when allocations do fail?  Will pdflush (or it's replacement) 
eventually come back and try ->writepages() again?

Thanks-
sage
