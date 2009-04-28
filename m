Return-Path: <linux-kernel-owner+w=401wt.eu-S1759920AbZD1K6p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759920AbZD1K6p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 06:58:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754677AbZD1K6e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 06:58:34 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:46037 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754625AbZD1K6d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 06:58:33 -0400
Subject: Re: [patch 00/27] [rfc] vfs scalability patchset
From: Peter Zijlstra <peterz@infradead.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, npiggin@suse.de,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20090428090930.GA14638@infradead.org>
References: <20090425012020.457460929@suse.de>
	 <20090425041829.GX8633@ZenIV.linux.org.uk>
	 <20090425080143.GA29033@infradead.org>
	 <20090425080649.GA8633@ZenIV.linux.org.uk>
	 <20090428090930.GA14638@infradead.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 28 Apr 2009 12:58:30 +0200
Message-Id: <1240916310.7620.147.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-04-28 at 05:09 -0400, Christoph Hellwig wrote:
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

Suppose you have some task doing open/close on one filesystem (rather
common scenario) then having the lock split on superblock level doesn't
help you.

My patches were admittedly somewhat over the top, and they could cause
more cacheline bounces but significantly reduce the contention,
delivering an over-all improvement, as can be seen from the
micro-benchmark results posted in that thread.

Anyway, your solution of simply removing all uses of the global files
list still seems like the most attractive option.
