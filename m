Return-Path: <linux-kernel-owner+w=401wt.eu-S1762979AbXLMHEM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762979AbXLMHEM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 02:04:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761064AbXLMG4a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 01:56:30 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:55210 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761269AbXLMG41 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 01:56:27 -0500
Date: Wed, 12 Dec 2007 22:51:58 -0800
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
       kvm-devel@lists.sourceforge.net, Avi Kivity <avi@qumranet.com>
Subject: [patch 20/60] KVM: SVM: Intercept the invd and wbinvd instructions
Message-ID: <20071213065158.GU6867@kroah.com>
References: <20071213064518.328162328@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="kvm-svm-intercept-the-invd-and-wbinvd-instructions.patch"
In-Reply-To: <20071213065039.GA6867@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.23-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Avi Kivity <avi@qumranet.com>

patch cf5a94d1331b411b84414c13e43f578260942d6b in mainline.

'invd' can destroy host data, and 'wbinvd' allows the guest to induce
long (milliseconds) latencies.

Noted by Ben Serebrin.

Signed-off-by: Avi Kivity <avi@qumranet.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/kvm/svm.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/kvm/svm.c
+++ b/drivers/kvm/svm.c
@@ -506,6 +506,7 @@ static void init_vmcb(struct vmcb *vmcb)
 		 */
 		/*              (1ULL << INTERCEPT_SELECTIVE_CR0) | */
 				(1ULL << INTERCEPT_CPUID) |
+				(1ULL << INTERCEPT_INVD) |
 				(1ULL << INTERCEPT_HLT) |
 				(1ULL << INTERCEPT_INVLPGA) |
 				(1ULL << INTERCEPT_IOIO_PROT) |
@@ -519,6 +520,7 @@ static void init_vmcb(struct vmcb *vmcb)
 				(1ULL << INTERCEPT_STGI) |
 				(1ULL << INTERCEPT_CLGI) |
 				(1ULL << INTERCEPT_SKINIT) |
+				(1ULL << INTERCEPT_WBINVD) |
 				(1ULL << INTERCEPT_MONITOR) |
 				(1ULL << INTERCEPT_MWAIT);
 
@@ -1319,6 +1321,7 @@ static int (*svm_exit_handlers[])(struct
 	[SVM_EXIT_VINTR]			= interrupt_window_interception,
 	/* [SVM_EXIT_CR0_SEL_WRITE]		= emulate_on_interception, */
 	[SVM_EXIT_CPUID]			= cpuid_interception,
+	[SVM_EXIT_INVD]                         = emulate_on_interception,
 	[SVM_EXIT_HLT]				= halt_interception,
 	[SVM_EXIT_INVLPG]			= emulate_on_interception,
 	[SVM_EXIT_INVLPGA]			= invalid_op_interception,
@@ -1333,6 +1336,7 @@ static int (*svm_exit_handlers[])(struct
 	[SVM_EXIT_STGI]				= invalid_op_interception,
 	[SVM_EXIT_CLGI]				= invalid_op_interception,
 	[SVM_EXIT_SKINIT]			= invalid_op_interception,
+	[SVM_EXIT_WBINVD]                       = emulate_on_interception,
 	[SVM_EXIT_MONITOR]			= invalid_op_interception,
 	[SVM_EXIT_MWAIT]			= invalid_op_interception,
 };

-- 
