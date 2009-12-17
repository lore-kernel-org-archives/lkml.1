Return-Path: <linux-kernel-owner+w=401wt.eu-S964848AbZLQEip@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964848AbZLQEip (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 23:38:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763055AbZLQEEL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 23:04:11 -0500
Received: from kroah.org ([198.145.64.141]:55448 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762993AbZLQEEH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 23:04:07 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Dec 16 19:56:48 2009
Message-Id: <20091217035648.501745098@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Dec 2009 19:55:40 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Hendrik Brueckner <brueckner@linux.vnet.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [043/151] [S390] s390: clear high-order bits of registers after sam64
In-Reply-To: <20091217040208.GA26571@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>

commit cf87b7439ec81b9374e7772e44e9cb2eb9e57160 upstream.

When the kernel is IPLed without the CLEAR option and switches
to 64-bit, the high-order half of the registers might contain
random values.  This can cause addressing exceptions and the
kernel enters an interrupt loop.

Initialize the high-order half of the general purpose registers
with zeros after switching to 64-bit mode.

Signed-off-by: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/s390/kernel/head64.S |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/s390/kernel/head64.S
+++ b/arch/s390/kernel/head64.S
@@ -83,6 +83,8 @@ startup_continue:
 	slr	%r0,%r0 		# set cpuid to zero
 	sigp	%r1,%r0,0x12		# switch to esame mode
 	sam64				# switch to 64 bit mode
+	llgfr	%r13,%r13		# clear high-order half of base reg
+	lmh	%r0,%r15,.Lzero64-.LPG1(%r13)	# clear high-order half
 	lctlg	%c0,%c15,.Lctl-.LPG1(%r13)	# load control registers
 	lg	%r12,.Lparmaddr-.LPG1(%r13)	# pointer to parameter area
 					# move IPL device to lowcore
@@ -127,6 +129,7 @@ startup_continue:
 .L4malign:.quad 0xffffffffffc00000
 .Lscan2g:.quad	0x80000000 + 0x20000 - 8	# 2GB + 128K - 8
 .Lnop:	.long	0x07000700
+.Lzero64:.fill	16,4,0x0
 #ifdef CONFIG_ZFCPDUMP
 .Lcurrent_cpu:
 	.long 0x0


