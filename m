Return-Path: <linux-kernel-owner+w=401wt.eu-S1763475AbXLMHEw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763475AbXLMHEw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 02:04:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760237AbXLMG4g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 01:56:36 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:55247 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761026AbXLMG4e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 01:56:34 -0500
Date: Wed, 12 Dec 2007 22:52:04 -0800
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
       kvm-devel@lists.sourceforge.net,
       Marko Kohtala <marko.kohtala@gmail.com>, Avi Kivity <avi@qumranet.com>
Subject: [patch 22/60] KVM: Fix hang on uniprocessor
Message-ID: <20071213065204.GW6867@kroah.com>
References: <20071213064518.328162328@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="kvm-fix-hang-on-uniprocessor.patch"
In-Reply-To: <20071213065039.GA6867@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.23-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Marko Kohtala <marko.kohtala@gmail.com>

This is not in mainline, as it was fixed differently in that tree.

first_cpu(cpus) returns the only CPU when NR_CPUS is 1 regardless of
the cpus mask. Therefore we avoid a kernel hang in
KVM_SET_MEMORY_REGION ioctl on uniprocessor by not entering the loop at
all.

Signed-off-by: Marko Kohtala <marko.kohtala@gmail.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/kvm/kvm_main.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -273,6 +273,11 @@ void kvm_flush_remote_tlbs(struct kvm *k
 			}
 	}
 
+	/* Uniprocessor kernel does not respect cpus in first_cpu. So
+	 * do not go there if we have nothing to do. */
+	if (cpus_empty(cpus))
+		return;
+
 	/*
 	 * We really want smp_call_function_mask() here.  But that's not
 	 * available, so ipi all cpus in parallel and wait for them

-- 
