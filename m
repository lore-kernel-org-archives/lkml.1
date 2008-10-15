Return-Path: <linux-kernel-owner+w=401wt.eu-S1753243AbYJOPw6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753243AbYJOPw6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 11:52:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754700AbYJOPv1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 11:51:27 -0400
Received: from mx2.redhat.com ([66.187.237.31]:46715 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754671AbYJOPv0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 11:51:26 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 7/7] binfmt_elf_fdpic: Wire up AT_EXECFD, AT_EXECFN, AT_SECURE.
To: torvalds@osdl.org
Cc: linux-kernel@vger.kernel.org, Paul Mundt <lethal@linux-sh.org>,
       David Howells <dhowells@redhat.com>
Date: Wed, 15 Oct 2008 16:51:19 +0100
Message-ID: <20081015155119.2158.69525.stgit@warthog.procyon.org.uk>
In-Reply-To: <20081015155048.2158.35981.stgit@warthog.procyon.org.uk>
References: <20081015155048.2158.35981.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Mundt <lethal@linux-sh.org>

These auxvec entries are the only ones left unhandled out of the current
base implementation. This syncs up binfmt_elf_fdpic with linux/auxvec.h
and current binfmt_elf.

Signed-off-by: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/binfmt_elf_fdpic.c |   14 +++++++++++++-
 1 files changed, 13 insertions(+), 1 deletions(-)


diff --git a/fs/binfmt_elf_fdpic.c b/fs/binfmt_elf_fdpic.c
index f8c1469..b42a8db 100644
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
@@ -560,11 +561,14 @@ static int create_elf_fdpic_tables(struct linux_binprm *bprm,
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
@@ -602,6 +606,12 @@ static int create_elf_fdpic_tables(struct linux_binprm *bprm,
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
@@ -617,6 +627,8 @@ static int create_elf_fdpic_tables(struct linux_binprm *bprm,
 	NEW_AUX_ENT(AT_EUID,	(elf_addr_t) current->euid);
 	NEW_AUX_ENT(AT_GID,	(elf_addr_t) current->gid);
 	NEW_AUX_ENT(AT_EGID,	(elf_addr_t) current->egid);
+	NEW_AUX_ENT(AT_SECURE,	security_bprm_secureexec(bprm));
+	NEW_AUX_ENT(AT_EXECFN,	bprm->exec);
 
 #ifdef ARCH_DLINFO
 	nr = 0;

