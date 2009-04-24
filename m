Return-Path: <linux-kernel-owner+w=401wt.eu-S1754211AbZDXUnl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754211AbZDXUnl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 16:43:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753180AbZDXUna
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 16:43:30 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:36220 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752751AbZDXUn3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 16:43:29 -0400
Date: Fri, 24 Apr 2009 21:43:17 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Christoph Hellwig <hch@infradead.org>
Cc: Fr?d?ric Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Alessio Igor Bogani <abogani@texware.it>,
       Jonathan Corbet <corbet@lwn.net>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>,
       LFSDEV <linux-fsdevel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 1/1] vfs: umount_begin BKL pushdown v2
Message-ID: <20090424204317.GR8633@ZenIV.linux.org.uk>
References: <1240556813-8739-1-git-send-email-abogani@texware.it> <1240556813-8739-2-git-send-email-abogani@texware.it> <20090424071312.GE8633@ZenIV.linux.org.uk> <20090424071853.GG8633@ZenIV.linux.org.uk> <20090424080634.GG24912@elte.hu> <20090424085017.GB28592@infradead.org> <c62985530904240216j2760e3dbvca5b8e9da22d009f@mail.gmail.com> <20090424175025.GA30091@infradead.org> <20090424185524.GO8633@ZenIV.linux.org.uk> <20090424190201.GA420@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090424190201.GA420@infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 24, 2009 at 03:02:01PM -0400, Christoph Hellwig wrote:
> On Fri, Apr 24, 2009 at 07:55:24PM +0100, Al Viro wrote:
> > Nah, it's not that.  I can hold that in a separate branch and keep it
> > anchored.  The question is, what else will end up there?
> > 	* the work inside the methods on BKL _removal_
> > 	* things like merging that ->write_super() call into ->put_super(),
> > etc.
> > 	* probably parts of work on s_flags mess and ro (tied to remout)
> 
> 	* moving lock_super from callers into ->write_super and
> 	  ->remount_fs.  No need to only push one lock down when we
> 	  touch them anyway.

Aye.  We want lock_super() dead anyway, and the most obvious way to do that
is to shove it down to filesystems and let them kill it one by one.

We might want to switch sync_supers() et.al. to down_write() and do
similar thing in callers of fsync_super/__fsync_super() (i.e. instead
of get_super() use a variant that would lock for write), while we are
at it; OTOH, that'll need careful thinking about - things like
shrink_dcache() currently don't care about write_super done in parallel
and we might add contention where it hurts.

It's worth investigating, though - switching s_umount to mutex is attractive
per se and we might simplify locking e.g. in freeze/thaw on that.
