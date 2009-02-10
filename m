Return-Path: <linux-kernel-owner+w=401wt.eu-S1756250AbZBJTFG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756250AbZBJTFG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 14:05:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754672AbZBJTDa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 14:03:30 -0500
Received: from kroah.org ([198.145.64.141]:53616 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754619AbZBJTD2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 14:03:28 -0500
Date: Tue, 10 Feb 2009 10:59:48 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Tony Battersby <tonyb@cybernetics.com>,
       Jiri Kosina <jkosina@suse.cz>, Hugh Dickins <hugh@veritas.com>
Subject: [patch 04/53] shm: fix shmctl(SHM_INFO) lockup with !CONFIG_SHMEM
Message-ID: <20090210185948.GE14308@kroah.com>
References: <20090210185337.000769713@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="shm-fix-shmctl-lockup-with-config_shmem.patch"
In-Reply-To: <20090210185924.GA14308@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.
------------------

From: Tony Battersby <tonyb@cybernetics.com>

commit a68e61e8ff2d46327a37b69056998b47745db6fa upstream.

shm_get_stat() assumes that the inode is a "struct shmem_inode_info",
which is incorrect for !CONFIG_SHMEM (see fs/ramfs/inode.c:
ramfs_get_inode() vs.  mm/shmem.c: shmem_get_inode()).

This bad assumption can cause shmctl(SHM_INFO) to lockup when
shm_get_stat() tries to spin_lock(&info->lock).  Users of !CONFIG_SHMEM
may encounter this lockup simply by invoking the 'ipcs' command.

Reported by Jiri Olsa back in February 2008:
http://lkml.org/lkml/2008/2/29/74

Signed-off-by: Tony Battersby <tonyb@cybernetics.com>
Cc: Jiri Kosina <jkosina@suse.cz>
Reported-by: Jiri Olsa <olsajiri@gmail.com>
Cc: Hugh Dickins <hugh@veritas.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 ipc/shm.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/ipc/shm.c
+++ b/ipc/shm.c
@@ -565,11 +565,15 @@ static void shm_get_stat(struct ipc_name
 			struct hstate *h = hstate_file(shp->shm_file);
 			*rss += pages_per_huge_page(h) * mapping->nrpages;
 		} else {
+#ifdef CONFIG_SHMEM
 			struct shmem_inode_info *info = SHMEM_I(inode);
 			spin_lock(&info->lock);
 			*rss += inode->i_mapping->nrpages;
 			*swp += info->swapped;
 			spin_unlock(&info->lock);
+#else
+			*rss += inode->i_mapping->nrpages;
+#endif
 		}
 
 		total++;

