Return-Path: <linux-kernel-owner+w=401wt.eu-S1758079AbYG1PGU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758079AbYG1PGU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 11:06:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754217AbYG1PGB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 11:06:01 -0400
Received: from mta23.gyao.ne.jp ([125.63.38.249]:27277 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753780AbYG1PGA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 11:06:00 -0400
Date: Tue, 29 Jul 2008 00:05:21 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: David Howells <dhowells@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-sh@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] binfmt_elf_fdpic: Wire up AT_EXECFD, AT_EXECFN, AT_SECURE.
Message-ID: <20080728150521.GD16555@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	David Howells <dhowells@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>, linux-sh@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <20080728150359.GA16555@linux-sh.org> <20080728150430.GB16555@linux-sh.org> <20080728150501.GC16555@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080728150501.GC16555@linux-sh.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These auxvec entries are the only ones left unhandled out of the current
base implementation. This syncs up binfmt_elf_fdpic with linux/auxvec.h
and current binfmt_elf.

Signed-off-by: Paul Mundt <lethal@linux-sh.org>

---

 fs/binfmt_elf_fdpic.c |   14 +++++++++++++-
 1 files changed, 13 insertions(+), 1 deletions(-)

diff --git a/fs/binfmt_elf_fdpic.c b/fs/binfmt_elf_fdpic.c
index bc64f5f..f0dd83c 100644
--- a/fs/binfmt_elf_fdpic.c
+++ b/fs/binfmt_elf_fdpic.c
@@ -25,6 +25,7 @@
 #include <linux/fcntl.h>
 #include <linux/slab.h>
 #include <linux/pagemap.h>
+#include <linux/security.h>
 #include <linux/highmem.h>
 #include <linux/highuid.h>
 #include <linux/personality.h>
@@ -562,11 +563,14 @@ static int create_elf_fdpic_tables(struct linux_binprm *bprm,
 	}
 
 	/* force 16 byte _final_ alignment here for generality */
-#define DLINFO_ITEMS 13
+#define DLINFO_ITEMS 15
 
 	nitems = 1 + DLINFO_ITEMS + (k_platform ? 1 : 0) + \
 		(k_base_platform ? 1 : 0) + AT_VECTOR_SIZE_ARCH;
 
+	if (bprm->interp_flags & BINPRM_FLAGS_EXECFD)
+		nitems++;
+
 	csp = sp;
 	sp -= nitems * 2 * sizeof(unsigned long);
 	sp -= (bprm->envc + 1) * sizeof(char *);	/* envv[] */
@@ -604,6 +608,12 @@ static int create_elf_fdpic_tables(struct linux_binprm *bprm,
 			    (elf_addr_t) (unsigned long) u_base_platform);
 	}
 
+	if (bprm->interp_flags & BINPRM_FLAGS_EXECFD) {
+		nr = 0;
+		csp -= 2 * sizeof(unsigned long);
+		NEW_AUX_ENT(AT_EXECFD, bprm->interp_data);
+	}
+
 	nr = 0;
 	csp -= DLINFO_ITEMS * 2 * sizeof(unsigned long);
 	NEW_AUX_ENT(AT_HWCAP,	hwcap);
@@ -619,6 +629,8 @@ static int create_elf_fdpic_tables(struct linux_binprm *bprm,
 	NEW_AUX_ENT(AT_EUID,	(elf_addr_t) current->euid);
 	NEW_AUX_ENT(AT_GID,	(elf_addr_t) current->gid);
 	NEW_AUX_ENT(AT_EGID,	(elf_addr_t) current->egid);
+	NEW_AUX_ENT(AT_SECURE,	security_bprm_secureexec(bprm));
+	NEW_AUX_ENT(AT_EXECFN,	bprm->exec);
 
 #ifdef ARCH_DLINFO
 	nr = 0;
