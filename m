Return-Path: <linux-kernel-owner+w=401wt.eu-S1946015AbXDEHJz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946015AbXDEHJz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 03:09:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946023AbXDEHJz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 03:09:55 -0400
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:49257
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1946015AbXDEHJy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 03:09:54 -0400
Message-Id: <4614BD10.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.1 
Date: Thu, 05 Apr 2007 08:10:40 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: "Jeremy Fitzhardinge" <jeremy@goop.org>
Cc: "Ingo Molnar" <mingo@elte.hu>, "Andrew Morton" <akpm@linux-foundation.org>,
       <virtualization@lists.osdl.org>, "Roland McGrath" <roland@redhat.com>,
       "Andi Kleen" <ak@suse.de>, "lkml" <linux-kernel@vger.kernel.org>,
       "Zachary Amsden" <zach@vmware.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [patch 1/2] Relocate VDSO ELF headers to match mapped
	location with COMPAT_VDSO
References: <20070405045825.511024444@goop.org>
 <20070405045843.333498131@goop.org>
In-Reply-To: <20070405045843.333498131@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>+static __cpuinit void reloc_dyn(Elf32_Ehdr *ehdr, unsigned offset)
>+{
>+	Elf32_Dyn *dyn = (void *)ehdr + offset;
>+
>+	for(; dyn->d_tag != DT_NULL; dyn++)
>+		switch(dyn->d_tag) {
>+		case DT_PLTGOT:
>+		case DT_HASH:
>+		case DT_STRTAB:
>+		case DT_SYMTAB:
>+		case DT_RELA:
>+		case DT_INIT:
>+		case DT_FINI:
>+		case DT_REL:
>+		case DT_JMPREL:
>+		case DT_VERSYM:
>+		case DT_VERDEF:
>+		case DT_VERNEED:
>+			dyn->d_un.d_val += VDSO_HIGH_BASE;
>+		}
>+}

While there's a certain level of control on what DT_* may appear in the
vDSO, not even considering other than the above types seems fragile to
me. Since future additions to the set are supposedly following a fixed
scheme (distinguishing pointers and values via the low bit when below
OLD_DT_LOOS, and using sub-ranges when between DT_HIOS and
OLD_DT_HIOS), at least also handling those would seem like a good
idea, as would warning about unrecognized types.

Also, even though it shouldn't matter for the final result, if doing things
spec-conforming here you should use d_un.d_ptr.

In addition to Roland's remarks about missing symbol table relocation, I
would also assume section headers, if present, should be relocated.

Jan
