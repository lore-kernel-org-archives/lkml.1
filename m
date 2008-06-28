Return-Path: <linux-kernel-owner+w=401wt.eu-S1758450AbYF1W00@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758450AbYF1W00 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2008 18:26:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752285AbYF1W0Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jun 2008 18:26:16 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:63930 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752147AbYF1W0P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2008 18:26:15 -0400
Date: Sat, 28 Jun 2008 18:25:41 -0400 (EDT)
From: Anders H Kaseorg <andersk@MIT.EDU>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
cc: linux-kernel@vger.kernel.org
Subject: [PATCH] x86_64: Patch paravirt inline replacements when loading
 modules
Message-ID: <alpine.DEB.1.10.0806280431510.31023@vinegar-pot.mit.edu>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paravirt replacements were added to the i386 module loader by commit
139ec7c416248b9ea227d21839235344edfee1e0.  This adds the same code to
the x86_64 module loader.

Signed-off-by: Anders Kaseorg <andersk@mit.edu>
---
  arch/x86/kernel/module_64.c |   10 +++++++++-
  1 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/module_64.c b/arch/x86/kernel/module_64.c
index a888e67..0e86767 100644
--- a/arch/x86/kernel/module_64.c
+++ b/arch/x86/kernel/module_64.c
@@ -150,7 +150,8 @@ int module_finalize(const Elf_Ehdr *hdr,
                      const Elf_Shdr *sechdrs,
                      struct module *me)
  {
-	const Elf_Shdr *s, *text = NULL, *alt = NULL, *locks = NULL;
+	const Elf_Shdr *s, *text = NULL, *alt = NULL, *locks = NULL,
+		*para = NULL;
  	char *secstrings = (void *)hdr + sechdrs[hdr->e_shstrndx].sh_offset;

  	for (s = sechdrs; s < sechdrs + hdr->e_shnum; s++) {
@@ -160,6 +161,8 @@ int module_finalize(const Elf_Ehdr *hdr,
  			alt = s;
  		if (!strcmp(".smp_locks", secstrings + s->sh_name))
  			locks= s;
+		if (!strcmp(".parainstructions", secstrings + s->sh_name))
+			para = s;
  	}

  	if (alt) {
@@ -175,6 +178,11 @@ int module_finalize(const Elf_Ehdr *hdr,
  					    tseg, tseg + text->sh_size);
  	}

+	if (para) {
+		void *pseg = (void *)para->sh_addr;
+		apply_paravirt(pseg, pseg + para->sh_size);
+	}
+
  	return module_bug_finalize(hdr, sechdrs, me);
  }

-- 
1.5.4.3

