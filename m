Return-Path: <linux-kernel-owner+w=401wt.eu-S1752168AbZJUIGv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752168AbZJUIGv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 04:06:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751718AbZJUIGu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 04:06:50 -0400
Received: from icculus.org ([67.106.77.212]:40277 "EHLO icculus.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750896AbZJUIGt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 04:06:49 -0400
Date: Wed, 21 Oct 2009 04:06:33 -0400 (EDT)
From: "Ryan C. Gordon" <icculus@icculus.org>
X-X-Sender: icculus@andre.icculuslan
To: =?ISO-8859-15?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 2/2] binfmt_elf: FatELF support for kernel
 modules.
In-Reply-To: <2375c9f90910200133g51c70ce2x8f90cd79885096a4@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.0910210401480.19091@andre.icculuslan>
References: <alpine.DEB.2.00.0910190422090.13303@andre.icculuslan> <2375c9f90910200133g51c70ce2x8f90cd79885096a4@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> As for 'Elf_Ehdr', isn't 'Fatelf_hdr' better? :)

Yeah, I struggled with that for awhile...the structs around it in elf.h 
were all lowercase (elf32_hdr), but I moved it somewhere more appropriate 
and fixed the case.

These were all good suggestions, so here's an updated version of the patch 
with the changes you noted. Thank you for taking the time to review my 
work!

--ryan.



>From 38cbb068c3970e9981549578c20207458a2b6659 Mon Sep 17 00:00:00 2001
From: Ryan C. Gordon <icculus@icculus.org>
Date: Tue, 20 Oct 2009 20:36:05 -0400
Subject: [PATCH] binfmt_elf: FatELF support for kernel modules.

Allows kernel modules to be FatELF binaries.

Details, rationale, tools, and patches for handling FatELF binaries can be
found at http://icculus.org/fatelf/

Please note that this requires an updated depmod and modprobe to be truly
effective, but an unmodified insmod can work with FatELF binaries.

Signed-off-by: Ryan C. Gordon <icculus@icculus.org>
---
 kernel/module.c |   65 ++++++++++++++++++++++++++++++++++++++++++++++++++----
 1 files changed, 60 insertions(+), 5 deletions(-)

diff --git a/kernel/module.c b/kernel/module.c
index 8b7d880..e8b2e8f 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -2066,13 +2066,62 @@ static inline void kmemleak_load_module(struct module *mod, Elf_Ehdr *hdr,
 }
 #endif
 
+/*
+ * See if we're a valid FatELF binary, find the right record, and
+ *  return the offset of that record within the binary. Returns NULL if there's
+ *  a problem, or a pointer to the real ELF header if we're okay.
+ *  If we don't see the FatELF magic number, we assume this is a regular ELF
+ *  binary and let the regular ELF checks handle it.
+ *
+ * This is a simplified version of examine_fatelf in fs/binfmt_elf.c
+ */
+static Elf_Ehdr *examine_fatelf_module(const unsigned char *hdr,
+				       const unsigned long len)
+{
+	Elf_Ehdr elf;
+	int records, i;
+	const Fatelf_hdr *fatelf = (const Fatelf_hdr *) hdr;
+
+	if (likely(le32_to_cpu(fatelf->magic) != FATELF_MAGIC))
+		return (Elf_Ehdr *) hdr;  /* not FatELF; not an error. */
+	else if (unlikely(le16_to_cpu(fatelf->version) != 1))
+		return NULL; /* Unrecognized format version. */
+
+	memset(&elf, 0, sizeof (elf));
+
+	records = (int) fatelf->num_records;  /* uint8, no byteswap needed */
+	for (i = 0; i < records; i++) {
+		const Fatelf_record *record = &fatelf->records[i];
+
+		/* Fill in the data elf_check_arch() might care about. */
+		elf.e_ident[EI_OSABI] = record->osabi;
+		elf.e_ident[EI_CLASS] = record->word_size;
+		elf.e_ident[EI_DATA] = record->byte_order;
+		elf.e_machine = le16_to_cpu(record->machine);
+
+		if (unlikely(elf_check_arch(&elf))) {
+			const __u64 rec_offset = le64_to_cpu(record->offset);
+			const __u64 rec_size = le64_to_cpu(record->size);
+			const __u64 end_offset = rec_offset + rec_size;
+			const unsigned long uloff = (unsigned long) rec_offset;
+
+			/* check for overflow and past-EOF before choosing this record */
+			if (likely((end_offset >= rec_offset) && (end_offset <= len)))
+				return (Elf_Ehdr *) (hdr + uloff);
+		}
+	}
+
+	return NULL;  /* no binaries we could use. */
+}
+
 /* Allocate and load the module: note that size of section 0 is always
    zero, and we rely on this for optional sections. */
 static noinline struct module *load_module(void __user *umod,
 				  unsigned long len,
 				  const char __user *uargs)
 {
-	Elf_Ehdr *hdr;
+	Elf_Ehdr *hdr_alloc;  /* returned from vmalloc */
+	Elf_Ehdr *hdr;  /* adjusted hdr_alloc for FatELF */
 	Elf_Shdr *sechdrs;
 	char *secstrings, *args, *modmagic, *strtab = NULL;
 	char *staging;
@@ -2094,14 +2143,20 @@ static noinline struct module *load_module(void __user *umod,
 
 	/* Suck in entire file: we'll want most of it. */
 	/* vmalloc barfs on "unusual" numbers.  Check here */
-	if (len > 64 * 1024 * 1024 || (hdr = vmalloc(len)) == NULL)
+	if (len > 64 * 1024 * 1024 || (hdr_alloc = vmalloc(len)) == NULL)
 		return ERR_PTR(-ENOMEM);
 
-	if (copy_from_user(hdr, umod, len) != 0) {
+	if (copy_from_user(hdr_alloc, umod, len) != 0) {
 		err = -EFAULT;
 		goto free_hdr;
 	}
 
+	hdr = examine_fatelf_module((unsigned char *) hdr_alloc, len);
+	if (hdr == NULL) {
+		err = -ENOEXEC;
+		goto free_hdr;
+	}
+
 	/* Sanity checks against insmoding binaries or wrong arch,
            weird elf version */
 	if (memcmp(hdr->e_ident, ELFMAG, SELFMAG) != 0
@@ -2505,7 +2560,7 @@ static noinline struct module *load_module(void __user *umod,
 	add_notes_attrs(mod, hdr->e_shnum, secstrings, sechdrs);
 
 	/* Get rid of temporary copy */
-	vfree(hdr);
+	vfree(hdr_alloc);
 
 	trace_module_load(mod);
 
@@ -2538,7 +2593,7 @@ static noinline struct module *load_module(void __user *umod,
 	kfree(args);
 	kfree(strmap);
  free_hdr:
-	vfree(hdr);
+	vfree(hdr_alloc);
 	return ERR_PTR(err);
 
  truncated:
-- 
1.6.0.4

