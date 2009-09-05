Return-Path: <linux-kernel-owner+w=401wt.eu-S1751527AbZIEM7q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751527AbZIEM7q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Sep 2009 08:59:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751166AbZIEM7n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Sep 2009 08:59:43 -0400
Received: from THUNK.ORG ([69.25.196.29]:50911 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751053AbZIEM7n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Sep 2009 08:59:43 -0400
Date: Sat, 5 Sep 2009 08:59:30 -0400
From: Theodore Tso <tytso@mit.edu>
To: Nicolas Pitre <nico@cam.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-ext4@vger.kernel.org,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ext2: fix unbalanced kmap()/kunmap()
Message-ID: <20090905125930.GF16217@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Nicolas Pitre <nico@cam.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-ext4@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
References: <alpine.LFD.2.00.0909042343540.6044@xanadu.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0909042343540.6044@xanadu.home>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 05, 2009 at 12:25:37AM -0400, Nicolas Pitre wrote:
> In ext2_rename(), dir_page is acquired through ext2_dotdot().  It is 
> then released through ext2_set_link() but only if old_dir != new_dir. 
> Failing that, the pkmap reference count is never decremented and the 
> page remains pinned forever.  Repeat that a couple times with highmem 
> pages and all pkmap slots get exhausted, and every further kmap() calls 
> end up stalling on the pkmap_map_wait queue at which point the whole 
> system comes to a halt.
> 
> Signed-off-by: Nicolas Pitre <nico@marvell.com>

Acked-by: "Theodore Ts'o" <tytso@mit.edu>

> I ran into this issue while testing highmem on ARM by running the git 
> test suite in a loop with 3 parallel instances.  Using the right mv 
> sequence in a script would constitute a pretty simple recipe for a 
> local DoS on systems running ext2 and highmem.  No idea if ext3 or ext4 
> have the same issue.

This is an ext2-only issue; for journalling reasons ext3 and ext4 read
and write the directory via buffer heads.  So this issue won't apply
for ext3 or ext4.

						- Ted
