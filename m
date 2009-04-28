Return-Path: <linux-kernel-owner+w=401wt.eu-S1757106AbZD1Jsf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757106AbZD1Jsf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 05:48:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754021AbZD1JsY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 05:48:24 -0400
Received: from cantor.suse.de ([195.135.220.2]:45754 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752756AbZD1JsX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 05:48:23 -0400
Date: Tue, 28 Apr 2009 11:48:21 +0200
From: Nick Piggin <npiggin@suse.de>
To: Christoph Hellwig <hch@infradead.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [patch 00/27] [rfc] vfs scalability patchset
Message-ID: <20090428094821.GC9442@wotan.suse.de>
References: <20090425012020.457460929@suse.de> <20090425041829.GX8633@ZenIV.linux.org.uk> <20090425080143.GA29033@infradead.org> <20090425080649.GA8633@ZenIV.linux.org.uk> <20090428090930.GA14638@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090428090930.GA14638@infradead.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 28, 2009 at 05:09:30AM -0400, Christoph Hellwig wrote:
> On Sat, Apr 25, 2009 at 09:06:49AM +0100, Al Viro wrote:
> > Maybe...  What Eric proposed is essentially a reuse of s_list for per-inode
> > list of struct file.  Presumably with something like i_lock for protection.
> > So that's not a conflict.
> 
> But what do we actually want it for?  Right now it's only used for
> ttys, which Nick has split out, and for remount r/o.  For the normal
> remount r/o case it will go away once we have proper per-sb writer
> counts.  And the fource remount r/o from sysrq is completely broken.
> 
> A while ago Peter had patches for files_lock scalability that went even
> further than Nicks, and if I remember the arguments correctly just
> splitting the lock wasn't really enough and he required additional
> batching because there just were too many lock roundtrips.  (Peter, do
> you remember the defails?)

Hmm, Peter's patch seemed like it was overkill to me. It avoids
the need for per-cpu files lists in the sb, but the cost is the
locked lists, the batching, etc. But even then it would still
generate more cacheline bounces because it needs to flush batches
back to the per-sb list.

Actually it should not be a problem to avoid the memory overhead
of my patch if we are willing to make the slowpath even slower.
Just have a global per-cpu list, and just test for sb equality
when walking the lists.

Anyway, I'll just continue to maintain this patch and if something
gets done with the file list first, then all the better.
