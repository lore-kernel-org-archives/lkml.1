Return-Path: <linux-kernel-owner+w=401wt.eu-S1754762AbZEZGLX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754762AbZEZGLX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 02:11:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753361AbZEZGLP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 02:11:15 -0400
Received: from hera.kernel.org ([140.211.167.34]:34239 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753278AbZEZGLO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 02:11:14 -0400
Date: Tue, 26 May 2009 06:09:50 GMT
From: tip-bot for Tejun Heo <tj@kernel.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       JBeulich@novell.com, tj@kernel.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tj@kernel.org, JBeulich@novell.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4A1B8150.40702@kernel.org>
References: <4A1B8150.40702@kernel.org>
Subject: [tip:x86/urgent] x86, relocs: ignore R_386_NONE in kernel relocation entries
Message-ID: <tip-46176b4f6bac19454b7b5c35f68594b85850a600@git.kernel.org>
Git-Commit-ID: 46176b4f6bac19454b7b5c35f68594b85850a600
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 26 May 2009 06:09:51 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  46176b4f6bac19454b7b5c35f68594b85850a600
Gitweb:     http://git.kernel.org/tip/46176b4f6bac19454b7b5c35f68594b85850a600
Author:     Tejun Heo <tj@kernel.org>
AuthorDate: Tue, 26 May 2009 14:42:40 +0900
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Mon, 25 May 2009 22:52:49 -0700

x86, relocs: ignore R_386_NONE in kernel relocation entries

For relocatable 32bit kernels, boot/compressed/relocs.c processes
relocation entries in the kernel image and appends it to the kernel
image such that boot/compressed/head_32.S can relocate the kernel.
The kernel image is one statically linked object and only uses two
relocation types - R_386_PC32 and R_386_32, of the two only the latter
needs massaging during kernel relocation and thus handled by relocs.
R_386_PC32 is ignored and all other relocation types are considered
error.

When the target of a relocation resides in a discarded section,
binutils doesn't throw away the relocation record but nullifies it by
changing it to R_386_NONE, which unfortunately makes relocs fail.

The problem was triggered by yet out-of-tree x86 stack unwind patches
but given the binutils behavior, ignoring R_386_NONE is the right
thing to do.

The problem has been tracked down to binutils behavior by Jan Beulich.

[ Impact: fix build with certain binutils by ignoring R_386_NONE ]

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Jan Beulich <JBeulich@novell.com>
Cc: Ingo Molnar <mingo@elte.hu>
LKML-Reference: <4A1B8150.40702@kernel.org>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>


---
 arch/x86/boot/compressed/relocs.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/x86/boot/compressed/relocs.c b/arch/x86/boot/compressed/relocs.c
index 857e492..bbeb0c3 100644
--- a/arch/x86/boot/compressed/relocs.c
+++ b/arch/x86/boot/compressed/relocs.c
@@ -504,8 +504,11 @@ static void walk_relocs(void (*visit)(Elf32_Rel *rel, Elf32_Sym *sym))
 			if (sym->st_shndx == SHN_ABS) {
 				continue;
 			}
-			if (r_type == R_386_PC32) {
-				/* PC relative relocations don't need to be adjusted */
+			if (r_type == R_386_NONE || r_type == R_386_PC32) {
+				/*
+				 * NONE can be ignored and and PC relative
+				 * relocations don't need to be adjusted.
+				 */
 			}
 			else if (r_type == R_386_32) {
 				/* Visit relocations that need to be adjusted */
