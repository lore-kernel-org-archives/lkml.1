Return-Path: <linux-kernel-owner+w=401wt.eu-S1765967AbZD3RmN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765967AbZD3RmN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 13:42:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764720AbZD3RIk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 13:08:40 -0400
Received: from kroah.org ([198.145.64.141]:56895 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764580AbZD3RIV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 13:08:21 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Apr 30 09:57:49 2009
Message-Id: <20090430165749.430745380@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 30 Apr 2009 09:57:04 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
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
       alan@lxorguk.ukuu.org.uk, mtosatti@redhat.com, avi@redhat.com
Subject: [patch 75/88] KVM: VMX: Flush volatile msrs before emulating rdmsr
References: <20090430165549.117010404@mini.kroah.org>
Content-Disposition: inline; filename=kvm-vmx-flush-volatile-msrs-before-emulating-rdmsr.patch
In-Reply-To: <20090430170122.GA16015@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Avi Kivity <avi@redhat.com>

(cherry picked from 516a1a7e9dc80358030fe01aabb3bedf882db9e2)

Some msrs (notable MSR_KERNEL_GS_BASE) are held in the processor registers
and need to be flushed to the vcpu struture before they can be read.

This fixes cygwin longjmp() failure on Windows x64.

Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/x86/kvm/vmx.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -897,6 +897,7 @@ static int vmx_get_msr(struct kvm_vcpu *
 		data = vmcs_readl(GUEST_SYSENTER_ESP);
 		break;
 	default:
+		vmx_load_host_state(to_vmx(vcpu));
 		msr = find_msr_entry(to_vmx(vcpu), msr_index);
 		if (msr) {
 			data = msr->data;


