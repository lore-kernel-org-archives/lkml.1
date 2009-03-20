Return-Path: <linux-kernel-owner+w=401wt.eu-S1760126AbZCTWpW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760126AbZCTWpW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 18:45:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753150AbZCTWpE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 18:45:04 -0400
Received: from thunk.org ([69.25.196.29]:44986 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753590AbZCTWpD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 18:45:03 -0400
Date: Fri, 20 Mar 2009 18:44:58 -0400
From: Theodore Tso <tytso@mit.edu>
To: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: Lockdep problem involving sysfs_mutex in ext4 in linux-next
Message-ID: <20090320224458.GC4559@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@suse.de>,
	Kay Sievers <kay.sievers@vrfy.org>
References: <E1LiURX-0000jG-Lx@closure.thunk.org> <1237071908.8939.788.camel@laptop> <20090320222522.GB4559@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090320222522.GB4559@mit.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 20, 2009 at 06:25:22PM -0400, Theodore Tso wrote:
> So if I'm reading this right, the problem is happening because
> someplace in the kernel, fs/sysfs code is grabbing mmap_sem while it
> is holding sysfs_mutex, right?  But I can't see where that might be
> happening...

Never mind, I see it.  sysfs_readdir() calls filldir() while holding
sysfs_mutex, and filldir() in turn calls copy_to_user(), which can
grab mmap_sem.

The problem is that in other code paths, mmap_sem() is grabbed while
we grab inode->i_alloc_sem() (in ext4_page_mkwrite), and that in turns
has a dependency on jbd2_handle, which has a dependency on s_lock, and
hence lock_super().  Ugh.  What a mess.

							- Ted
