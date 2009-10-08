Return-Path: <linux-kernel-owner+w=401wt.eu-S1757457AbZJHKEm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757457AbZJHKEm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 06:04:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757430AbZJHKEk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 06:04:40 -0400
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.15]:43550
	"EHLO VA3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757432AbZJHKEj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 06:04:39 -0400
X-SpamScore: -8
X-BigFish: VPS-8(zz15bfO4015Lzz1202hzzz32i6bh43j62h)
X-Spam-TCS-SCL: 1:0
X-FB-SS: 5,
X-WSS-ID: 0KR6X9U-04-3JX-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: Alexander Graf <agraf@suse.de>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 0/9 v2] KVM: Nested SVM fixes and tracepoint conversion
Date: Thu, 8 Oct 2009 12:03:10 +0200
Message-ID: <1254996199-17667-1-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.4.3
X-OriginalArrivalTime: 08 Oct 2009 10:03:23.0494 (UTC) FILETIME=[92480860:01CA47FE]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Avi, Marcelo,

this series of patches contains bugfixes for the Nested SVM code and the
conversion of Nested SVM debugging to tracepoints. The fixes are:

           1) A patch Alex already sent (1/9) but which was not yet
              applied. It fixes a lost event_inj problem when we emulate
              a vmrun and a vmexit without entering the guest in
	      the meantime.

	   2) The patch 2/9 fixes a schedule() while atomic bug in the
	      Nested SVM code. The KVM interrupt injection code runs
	      with preemtion and interrupts disabled. But the
	      enable_irq_window() function from SVM may emulate a
              #vmexit.  This emulation migth sleep which causes the
	      schedule() while atomic() bug.

These fixes (patches 1 and 2) should also be considered for -stable
backporting.

The patches 3 to 8 convert the old printk based debugging for Nested SVM
to tracepoints. Patch 9 removes the nsvm_printk code. Please review
and/or consider to apply these changes.

Thanks,

	Joerg

Changes to v1:

* Fixed typo on comment in patch
  "KVM: SVM: Notify nested hypervisor of lost event injections"
* Made the fix for the schedule()-while-atomic bug out of the generic
  code. It touches only SVM code now.

diffstat:


 arch/x86/kvm/svm.c   |  107 +++++++++++++++++++++-----------
 arch/x86/kvm/trace.h |  165 ++++++++++++++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/x86.c   |    6 ++
 3 files changed, 242 insertions(+), 36 deletions(-)

shortlog:

Alexander Graf (1):
      KVM: SVM: Notify nested hypervisor of lost event injections

Joerg Roedel (8):
      KVM: SVM: Move INTR vmexit out of atomic code
      KVM: SVM: Add tracepoint for nested vmrun
      KVM: SVM: Add tracepoint for nested #vmexit
      KVM: SVM: Add tracepoint for injected #vmexit
      KVM: SVM: Add tracepoint for #vmexit because intr pending
      KVM: SVM: Add tracepoint for invlpga instruction
      KVM: SVM: Add tracepoint for skinit instruction
      KVM: SVM: Remove nsvm_printk debugging code


