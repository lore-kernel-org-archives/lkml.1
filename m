Return-Path: <linux-kernel-owner+w=401wt.eu-S1753619AbZBPVZj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753619AbZBPVZj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 16:25:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750727AbZBPVZa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 16:25:30 -0500
Received: from mx1.redhat.com ([66.187.233.31]:44723 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750718AbZBPVZa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 16:25:30 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Martin Michlmayr <tbm@cyrius.com>
X-Fcc: ~/Mail/linus
Cc: linux-kernel@vger.kernel.org, Ralf Baechle <ralf@linux-mips.org>
Subject: Re: "elf core dump: fix get_user use" breaks mips compilation
In-Reply-To: Martin Michlmayr's message of  Monday, 16 February 2009 13:01:36 +0100 <20090216120136.GA9057@deprecation.cyrius.com>
References: <20090216120136.GA9057@deprecation.cyrius.com>
Emacs: the prosecution rests its case.
Message-Id: <20090216212515.B62C5FC3E4@magilla.sf.frob.com>
Date: Mon, 16 Feb 2009 13:25:15 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

That is either a compiler problem or a problem with how the asm magic used
inside get_user() informs the compiler.  The dynamics of the code are not
actually much different than before the change.  

I imagine this would work around it:

--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -1211,7 +1211,7 @@ static unsigned long vma_dump_size(struc
 	if (FILTER(ELF_HEADERS) &&
 	    vma->vm_pgoff == 0 && (vma->vm_flags & VM_READ)) {
 		u32 __user *header = (u32 __user *) vma->vm_start;
-		u32 word;
+		u32 word = 0;
 		mm_segment_t fs = get_fs();
 		/*
 		 * Doing it this way gets the constant folded by GCC.
