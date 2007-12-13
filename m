Return-Path: <linux-kernel-owner+w=401wt.eu-S1763270AbXLMHC5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763270AbXLMHC5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 02:02:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761607AbXLMG4U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 01:56:20 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:55170 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760919AbXLMG4S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 01:56:18 -0500
Date: Wed, 12 Dec 2007 22:51:50 -0800
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
       kvm-devel@lists.sourceforge.net, Sheng Yang <sheng.yang@intel.com>,
       Avi Kivity <avi@qumranet.com>
Subject: [patch 17/60] KVM: x86 emulator: implement movnti mem, reg
Message-ID: <20071213065150.GR6867@kroah.com>
References: <20071213064518.328162328@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="kvm-x86-emulator-implement-movnti-mem-reg.patch"
In-Reply-To: <20071213065039.GA6867@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.23-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Sheng Yang <sheng.yang@intel.com>

patch a012e65aee48379a7a87eadafa74f878b61522b9 in mainline.

Implement emulation of instruction:
    movnti m32/m64, r32/r64
    opcode: 0x0f 0xc3

Needed to support Linux 2.6.16 as guest (used for mmio).

Signed-off-by: Sheng Yang <sheng.yang@intel.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/kvm/x86_emulate.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/kvm/x86_emulate.c
+++ b/drivers/kvm/x86_emulate.c
@@ -198,7 +198,8 @@ static u16 twobyte_table[256] = {
 	0, 0, ByteOp | DstReg | SrcMem | ModRM | Mov,
 	    DstReg | SrcMem16 | ModRM | Mov,
 	/* 0xC0 - 0xCF */
-	0, 0, 0, 0, 0, 0, 0, ImplicitOps | ModRM, 0, 0, 0, 0, 0, 0, 0, 0,
+	0, 0, 0, DstMem | SrcReg | ModRM | Mov, 0, 0, 0, ImplicitOps | ModRM,
+	0, 0, 0, 0, 0, 0, 0, 0,
 	/* 0xD0 - 0xDF */
 	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
 	/* 0xE0 - 0xEF */
@@ -1324,6 +1325,10 @@ twobyte_insn:
 		dst.bytes = op_bytes;
 		dst.val = (d & ByteOp) ? (s8) src.val : (s16) src.val;
 		break;
+	case 0xc3:		/* movnti */
+		dst.bytes = op_bytes;
+		dst.val = (op_bytes == 4) ? (u32) src.val : (u64) src.val;
+		break;
 	}
 	goto writeback;
 

-- 
