Return-Path: <linux-kernel-owner+w=401wt.eu-S1752559AbZIIA1G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752559AbZIIA1G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 20:27:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752349AbZIIA1F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 20:27:05 -0400
Received: from bitwagon.com ([74.82.39.175]:56256 "HELO bitwagon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752279AbZIIA1E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 20:27:04 -0400
Message-ID: <4AA6F653.1010007@bitwagon.com>
Date: Tue, 08 Sep 2009 17:26:59 -0700
From: John Reiser <jreiser@bitwagon.com>
Organization: -
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Alexander Viro <viro@zeniv.linux.org.uk>, James Morris <jmorris@namei.org>,
       Roland McGrath <roland@redhat.com>, David Howells <dhowells@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
CC: linux-fsdevel@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: binfmt_elf PT_INTERP gets EFAULT if no PROT_WRITE
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In fs/binfmt_elf.c, routine load_elf_interp() calls padzero() for .bss
even if the PT_LOAD has no PROT_WRITE and no .bss.  This generates EFAULT.
One easy way to avoid trouble is that a PT_LOAD with no PROT_WRITE
should skip the .bss calculation entirely.

Here is a small test case.  (Yes, there are other, useful PT_INTERP
which have only .text and no .data/.bss.)

----- ptinterp.S
_start: .globl _start
         nop
         int3
-----
$ gcc -m32 -nostartfiles -nostdlib -o ptinterp ptinterp.S
$ gcc -m32 -Wl,--dynamic-linker=ptinterp -o hello hello.c
$ ./hello
Segmentation fault  # during execve() itself

After applying the patch:
$ ./hello
Trace trap  # user-mode execution after execve() finishes

Signed-off-by: John Reiser <jreiser@BitWagon.com>


diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index b7c1603..3b9a097 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -488,7 +488,7 @@ static unsigned long load_elf_interp(struct elfhdr *interp_elf_ex,
			 * keep track of the largest address we see for this.
			 */
			k = load_addr + eppnt->p_vaddr + eppnt->p_filesz;
-			if (k > elf_bss)
+			if (k > elf_bss && PROT_WRITE & elf_prot)
				elf_bss = k;

			/*
@@ -496,7 +496,7 @@ static unsigned long load_elf_interp(struct elfhdr *interp_elf_ex,
			 * elf_bss and last_bss is the bss section.
			 */
			k = load_addr + eppnt->p_memsz + eppnt->p_vaddr;
-			if (k > last_bss)
+			if (k > last_bss && PROT_WRITE & elf_prot)
				last_bss = k;
		}
	}

-- 
