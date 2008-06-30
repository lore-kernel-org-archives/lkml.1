Return-Path: <linux-kernel-owner+w=401wt.eu-S1759434AbYF3KPw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759434AbYF3KPw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 06:15:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755243AbYF3KPo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 06:15:44 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:41424 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753709AbYF3KPn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 06:15:43 -0400
Date: Mon, 30 Jun 2008 12:15:14 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Anders H Kaseorg <andersk@MIT.EDU>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86_64: Patch paravirt inline replacements when
	loading modules
Message-ID: <20080630101514.GA31497@elte.hu>
References: <alpine.DEB.1.10.0806280431510.31023@vinegar-pot.mit.edu> <4866BBC0.3000503@zytor.com> <alpine.DEB.1.10.0806281836020.31023@vinegar-pot.mit.edu> <4866C62A.2060808@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4866C62A.2060808@zytor.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* H. Peter Anvin <hpa@zytor.com> wrote:

> Anders H Kaseorg wrote:
>> On Sat, 28 Jun 2008, H. Peter Anvin wrote:
>>> Not having looked at this in detail, is this a *current* problem or a 
>>> *future* problem, i.e. does it fix a bug that's currently in the 
>>> kernel?
>>
>> It's a current problem.  The current situation is that 
>> .parainstructions are patched into the kernel core and modules on i386, 
>> but only the kernel core on x86_64.  This results in a slight 
>> performance regression in x86_64 modules, compared to the situation 
>> before .parainstructions existed.  My patch restores full performance 
>> of x86_64 modules.
>
> OK, it's a performance regression.  I don't think it makes sense for 
> 2.6.26, but it should definitely go into 2.6.27.

applied to tip/x86/modules - thanks Anders.

( Note: the patch had diff context tabs converted to spaces and other
  whitespace damage, i fixed that up by hand for the patch to apply. See 
  Documentation/email-clients.txt about how to avoid it with future
  patches. See the commit below in its final form. )

	Ingo

---------->
commit 5e5a29bf2624a5984e1c36c3a2481ee91249ec9c
Author: Anders H Kaseorg <andersk@MIT.EDU>
Date:   Sat Jun 28 18:25:41 2008 -0400

    x86, 64-bit: patch paravirt inline replacements when loading modules
    
    small speedup.
    
    Paravirt replacements were added to the i386 module loader by commit
    139ec7c416248b9ea227d21839235344edfee1e0.  This adds the same code to
    the x86_64 module loader.
    
    Signed-off-by: Anders Kaseorg <andersk@mit.edu>
    Acked-by: "H. Peter Anvin" <hpa@zytor.com>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

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
 
