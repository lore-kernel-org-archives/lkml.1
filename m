Return-Path: <linux-kernel-owner+w=401wt.eu-S1753532AbZEZFnS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753532AbZEZFnS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 01:43:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752771AbZEZFnE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 01:43:04 -0400
Received: from hera.kernel.org ([140.211.167.34]:60232 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752685AbZEZFnD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 01:43:03 -0400
Message-ID: <4A1B8150.40702@kernel.org>
Date: Tue, 26 May 2009 14:42:40 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Linux Kernel <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       the arch/x86 maintainers <x86@kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH x86/tip] x86: ignore R_386_NONE in kernel relocation entries
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 26 May 2009 05:42:44 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

The problem has been tracke down to binutils behavior by Jan Beulich.

[ Impact: relocs now ignores R_386_NONE ]

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Jan Beulich <JBeulich@novell.com>
Cc: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/boot/compressed/relocs.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

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
