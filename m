Return-Path: <linux-kernel-owner+w=401wt.eu-S1763304AbXLMHD0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763304AbXLMHD0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 02:03:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761619AbXLMG4W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 01:56:22 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:55177 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761605AbXLMG4U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 01:56:20 -0500
Date: Wed, 12 Dec 2007 22:51:53 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       kvm-devel@lists.sourceforge.net, Avi Kivity <avi@qumranet.com>,
       Aurelien Jarno <aurelien@aurel32.net>
Subject: [patch 18/60] KVM: x86 emulator: fix access registers for
	instructions with ModR/M byte and Mod = 3
Message-ID: <20071213065153.GS6867@kroah.com>
References: <20071213064518.328162328@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="kvm-x86-emulator-fix-access-registers-for-instructions-with-modr-m-byte-and-mod-3.patch"
In-Reply-To: <20071213065039.GA6867@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.23-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Aurelien Jarno <aurelien@aurel32.net>

patch 4e62417bf317504c0b85e0d7abd236f334f54eaf in mainline.

The patch belows changes the access type to register from memory for
instructions that are declared as SrcMem or DstMem, but have a
ModR/M byte with Mod = 3.

It fixes (at least) the lmsw and smsw instructions on an AMD64 CPU,
which are needed for FreeBSD.

Signed-off-by: Aurelien Jarno <aurelien@aurel32.net>
Signed-off-by: Avi Kivity <avi@qumranet.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/kvm/x86_emulate.c |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

--- a/drivers/kvm/x86_emulate.c
+++ b/drivers/kvm/x86_emulate.c
@@ -773,6 +773,14 @@ done_prefixes:
 	case SrcMem:
 		src.bytes = (d & ByteOp) ? 1 : op_bytes;
 	      srcmem_common:
+		/*
+		 * For instructions with a ModR/M byte, switch to register
+		 * access if Mod = 3.
+		 */
+		if ((d & ModRM) && modrm_mod == 3) {
+			src.type = OP_REG;
+			break;
+		}
 		src.type = OP_MEM;
 		src.ptr = (unsigned long *)cr2;
 		if ((rc = ops->read_emulated((unsigned long)src.ptr,
@@ -839,6 +847,15 @@ done_prefixes:
 		dst.type = OP_MEM;
 		dst.ptr = (unsigned long *)cr2;
 		dst.bytes = (d & ByteOp) ? 1 : op_bytes;
+		dst.val = 0;
+		/*
+		 * For instructions with a ModR/M byte, switch to register
+		 * access if Mod = 3.
+		 */
+		if ((d & ModRM) && modrm_mod == 3) {
+			dst.type = OP_REG;
+			break;
+		}
 		if (d & BitOp) {
 			unsigned long mask = ~(dst.bytes * 8 - 1);
 

-- 
