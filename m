Return-Path: <linux-kernel-owner+w=401wt.eu-S1763410AbXLMHGG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763410AbXLMHGG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 02:06:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762038AbXLMG4n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 01:56:43 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:55280 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761476AbXLMG4m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 01:56:42 -0500
Date: Wed, 12 Dec 2007 22:52:09 -0800
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
Subject: [patch 24/60] KVM: Skip pio instruction when it is emulated, not
	executed
Message-ID: <20071213065209.GY6867@kroah.com>
References: <20071213064518.328162328@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="kvm-skip-pio-instruction-when-it-is-emulated-not-executed.patch"
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

patch 0967b7bf1c22b55777aba46ff616547feed0b141 in mainline.

If we defer updating rip until pio instructions are executed, we have a
problem with reset:  a pio reset updates rip, and when the instruction
completes we skip the emulated instruction, pointing rip somewhere completely
unrelated.

Fix by updating rip when we see decode the instruction, not after emulation.

Signed-off-by: Avi Kivity <avi@qumranet.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/kvm/kvm_main.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -1757,8 +1757,6 @@ static int complete_pio(struct kvm_vcpu 
 	io->count -= io->cur_count;
 	io->cur_count = 0;
 
-	if (!io->count)
-		kvm_arch_ops->skip_emulated_instruction(vcpu);
 	return 0;
 }
 
@@ -1804,6 +1802,7 @@ int kvm_setup_pio(struct kvm_vcpu *vcpu,
 
 	pio_dev = vcpu_find_pio_dev(vcpu, port);
 	if (!string) {
+		kvm_arch_ops->skip_emulated_instruction(vcpu);
 		kvm_arch_ops->cache_regs(vcpu);
 		memcpy(vcpu->pio_data, &vcpu->regs[VCPU_REGS_RAX], 4);
 		kvm_arch_ops->decache_regs(vcpu);
@@ -1850,6 +1849,9 @@ int kvm_setup_pio(struct kvm_vcpu *vcpu,
 	vcpu->run->io.count = now;
 	vcpu->pio.cur_count = now;
 
+	if (now == count)
+		kvm_arch_ops->skip_emulated_instruction(vcpu);
+
 	for (i = 0; i < nr_pages; ++i) {
 		spin_lock(&vcpu->kvm->lock);
 		page = gva_to_page(vcpu, address + i * PAGE_SIZE);

-- 
