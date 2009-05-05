Return-Path: <linux-kernel-owner+w=401wt.eu-S1758879AbZEEV2t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758879AbZEEV2t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 17:28:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757722AbZEEV2J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 17:28:09 -0400
Received: from mx2.redhat.com ([66.187.237.31]:55319 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756297AbZEEV2H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 17:28:07 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 3/3] NOMMU: Make the initial mmap allocation excess behaviour
	Kconfig configurable
To: torvalds@osdl.org, akpm@linux-foundation.org, npiggin@suse.de
Cc: gerg@snapgear.com, linux-kernel@vger.kernel.org,
       David Howells <dhowells@redhat.com>
Date: Tue, 05 May 2009 22:26:48 +0100
Message-ID: <20090505212648.17034.18375.stgit@warthog.procyon.org.uk>
In-Reply-To: <20090505212638.17034.10989.stgit@warthog.procyon.org.uk>
References: <20090505212638.17034.10989.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

NOMMU mmap() has an option controlled by a sysctl variable that determines
whether the allocations made by do_mmap_private() should have the excess space
trimmed off and returned to the allocator.  Make the initial setting of this
variable a Kconfig configuration option.

The reason there can be excess space is that the allocator only allocates in
power-of-2 size chunks, but mmap()'s can be made in sizes that aren't a power
of 2.

There are two alternatives:

 (1) Keep the excess as dead space.  The dead space then remains unused for the
     lifetime of the mapping.  Mappings of shared objects such as libc, ld.so
     or busybox's text segment may retain their dead space forever.

 (2) Return the excess to the allocator.  This means that the dead space is
     limited to less than a page per mapping, but it means that for a transient
     process, there's more chance of fragmentation as the excess space may be
     reused fairly quickly.

During the boot process, a lot of transient processes are created, and this can
cause a lot of fragmentation as the pagecache and various slabs grow greatly
during this time.

By turning off the trimming of excess space during boot and disabling batching
of frees, Coldfire can manage to boot.

A better way of doing things might be to have /sbin/init turn this option off.
By that point libc, ld.so and init - which are all long-duration processes -
have all been loaded and trimmed.

Reported-by: Lanttor Guo <lanttor.guo@freescale.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Tested-by: Lanttor Guo <lanttor.guo@freescale.com>
---

 mm/Kconfig |   28 ++++++++++++++++++++++++++++
 mm/nommu.c |    2 +-
 2 files changed, 29 insertions(+), 1 deletions(-)


diff --git a/mm/Kconfig b/mm/Kconfig
index 57971d2..c2b57d8 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -225,3 +225,31 @@ config HAVE_MLOCKED_PAGE_BIT
 
 config MMU_NOTIFIER
 	bool
+
+config NOMMU_INITIAL_TRIM_EXCESS
+	int "Turn on mmap() excess space trimming before booting"
+	depends on !MMU
+	default 1
+	help
+	  The NOMMU mmap() frequently needs to allocate large contiguous chunks
+	  of memory on which to store mappings, but it can only ask the system
+	  allocator for chunks in 2^N*PAGE_SIZE amounts - which is frequently
+	  more than it requires.  To deal with this, mmap() is able to trim off
+	  the excess and return it to the allocator.
+
+	  If trimming is enabled, the excess is trimmed off and returned to the
+	  system allocator, which can cause extra fragmentation, particularly
+	  if there are a lot of transient processes.
+
+	  If trimming is disabled, the excess is kept, but not used, which for
+	  long-term mappings means that the space is wasted.
+
+	  Trimming can be dynamically controlled through a sysctl option
+	  (/proc/sys/vm/nr_trim_pages) which specifies the minimum number of
+	  excess pages there must be before trimming should occur, or zero if
+	  no trimming is to occur.
+
+	  This option specifies the initial value of this option.  The default
+	  of 1 says that all excess pages should be trimmed.
+
+	  See Documentation/nommu-mmap.txt for more information.
diff --git a/mm/nommu.c b/mm/nommu.c
index 41dc127..cdc6f60 100644
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -66,7 +66,7 @@ struct percpu_counter vm_committed_as;
 int sysctl_overcommit_memory = OVERCOMMIT_GUESS; /* heuristic overcommit */
 int sysctl_overcommit_ratio = 50; /* default is 50% */
 int sysctl_max_map_count = DEFAULT_MAX_MAP_COUNT;
-int sysctl_nr_trim_pages = 1; /* page trimming behaviour */
+int sysctl_nr_trim_pages = CONFIG_NOMMU_INITIAL_TRIM_EXCESS;
 int heap_stack_gap = 0;
 
 atomic_long_t mmap_pages_allocated;

