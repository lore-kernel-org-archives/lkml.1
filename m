Return-Path: <linux-kernel-owner+w=401wt.eu-S1755045AbYIQWuT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755045AbYIQWuT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 18:50:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753249AbYIQWuF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 18:50:05 -0400
Received: from lazybastard.de ([212.112.238.170]:59163 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752380AbYIQWuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 18:50:04 -0400
Date: Thu, 18 Sep 2008 00:49:53 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, kihara.seiji@lab.ntt.co.jp,
       amagai.yoshiji@lab.ntt.co.jp
Subject: Re: [PATCH 25/27] nilfs2: block cache for garbage collection
Message-ID: <20080917224953.GB14644@logfs.org>
References: <1221419304-18572-25-git-send-email-konishi.ryusuke@lab.ntt.co.jp> <1221419304-18572-26-git-send-email-konishi.ryusuke@lab.ntt.co.jp> <20080917144146.GD8750@logfs.org> <20080918.040945.32654226.ryusuke@osrg.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080918.040945.32654226.ryusuke@osrg.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 September 2008 04:09:45 +0900, Ryusuke Konishi wrote:
> 
> > Using dummy inodes is... unusual.  Why can you not use the actual inodes
> > those blocks belong to?
> 
> Because we have to treat blocks that belong to a same file but have
> different checkpoint numbers.  (NILFS2 keeps up multiple
> checkpoints/snapshots across GC)
> 
> Of course, if the standard inode hash is applicable, I prefer it.
> ilookup5 or its variant may be applicable for this.

If that is possible I would definitely prefer it.

> If so, the remaining problem would be the lock dependencies as you
> mentioned before.

You should have the same problem already - in some shape or another.  If
you can have two data structures for the same content, a real inode and
a dummy inode, you have a race condition.  Quite possibly one involving
data corruption.

Well, one way to avoid both the race and the locking complexity is by
stopping all writes during GC and destroying all dummy inodes before
writes resume.  But that would be inefficient in several cases.  When
GC'ing data that is dirty in the caches, you move the old stale data
during GC and write the new data soon after.  And you always flush the
caches after GC, even if your machine has no better use for the memory.

So unless I missed something important, I believe the locking is well
worth the effort.

BTW: Some of the explanation you just gave me would do well as
documentation in the source file as well.  That's the sort of background
information new developers can spend month of mistakes and reverse
engineering on. :)

Jörn

-- 
Those who come seeking peace without a treaty are plotting.
-- Sun Tzu
