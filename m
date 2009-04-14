Return-Path: <linux-kernel-owner+w=401wt.eu-S1757333AbZDNP55@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757333AbZDNP55 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 11:57:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756430AbZDNPyx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 11:54:53 -0400
Received: from pipapo.org ([217.140.77.75]:60294 "EHLO mail.pipapo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756773AbZDNPyt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 11:54:49 -0400
Message-ID: <49E4B1C5.2070109@pipapo.org>
Date: Tue, 14 Apr 2009 17:54:45 +0200
From: Christian Thaeter <ct@pipapo.org>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [BUG?] vfs_cache_pressure=0 does not free inode caches
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some time ago I found out that setting vfs_cache_pressure to 0 gives a
decent performance boost on my laptop (4200prm 1.8" disk). In most cases
metadata intensive/seeking applications (git, make, ..) wont even need
to spin up the disk (ls -R / takes 4 seconds from cache). Thats great
and I am using that since some time now. My first observation (looking
at 'top') was that caches get still freed when memory is demanded otherwise.

But now I hit the wall with really huge directory traversals on a
smaller server. Some testing revealed that the inode caches (tested with
ext4 and xfs) of the file system are not freed at all. The server is
going to die a slow death, all user space memory is swapped out, then
all processes are OOM killed until it dies from complete memory exhaustion.

Looking at the source (fs/inode.c):

static int shrink_icache_memory(int nr, gfp_t gfp_mask)
{
  ...
  return (inodes_stat.nr_unused / 100) * sysctl_vfs_cache_pressure;
}

makes me no wonder, I didn't investigated this further. Just trying with
 vfs_cache_pressure=1 gives the desired result and the inode caches are
freed on demand, case settled.

But still this has some bad taste, a cache is supposed to be a cache and
not a memory hog. The documentation doesn't cover this case. It is
argueable if this now can be considered as bug or as feature. I think
the formula for cache shrinking should be fixed to free memory even in
this extreme cases, others may argue that turning this cache off is a
feature, but then it should be documented at least.


	Christian

