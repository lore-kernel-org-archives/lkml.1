Return-Path: <linux-kernel-owner+w=401wt.eu-S1762125AbZEFV6w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762125AbZEFV6w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 17:58:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761166AbZEFVyb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 17:54:31 -0400
Received: from kroah.org ([198.145.64.141]:56979 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761369AbZEFVy1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 17:54:27 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Wed May  6 14:47:56 2009
Message-Id: <20090506214756.716862513@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 06 May 2009 14:45:39 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Joerg Roedel <joerg.roedel@amd.com>,
       Avi Kivity <avi@redhat.com>, Chris Wright <chrisw@sous-sol.org>
Subject: [patch 11/58] KVM: x86: release time_page on vcpu destruction
References: <20090506214528.660389067@mini.kroah.org>
Content-Disposition: inline; filename=kvm-x86-release-time_page-on-vcpu-destruction.patch
In-Reply-To: <20090506215017.GA21981@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.29-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Joerg Roedel <joerg.roedel@amd.com>

upstream commit: 7f1ea208968f021943d4103ba59e06bb6d8239cb

Not releasing the time_page causes a leak of that page or the compound
page it is situated in.

Cc: stable@kernel.org
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 arch/x86/kvm/x86.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3962,6 +3962,11 @@ EXPORT_SYMBOL_GPL(kvm_put_guest_fpu);
 
 void kvm_arch_vcpu_free(struct kvm_vcpu *vcpu)
 {
+	if (vcpu->arch.time_page) {
+		kvm_release_page_dirty(vcpu->arch.time_page);
+		vcpu->arch.time_page = NULL;
+	}
+
 	kvm_x86_ops->vcpu_free(vcpu);
 }
 


