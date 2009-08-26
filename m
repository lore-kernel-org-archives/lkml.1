Return-Path: <linux-kernel-owner+w=401wt.eu-S1757456AbZHZOK1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757456AbZHZOK1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 10:10:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757439AbZHZOK0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 10:10:26 -0400
Received: from ey-out-2122.google.com ([74.125.78.26]:18176 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757391AbZHZOKZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 10:10:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=nEwDv46RD8oy8vhizL5J56gyip32xnA+b850AMUOJDtA60OUaDBhhsnS9EHGCixTlU
         +/Fu4huKgTPsxCfcJDZ6Mb1LCsgURpfkNxvYFwTb4jOTehC4szhk42tqU049bzzpZT3M
         VMRfbu6M5Lk9056FKqp70s7xdHzM44KFr4RV0=
Message-ID: <4A95437C.2060707@gmail.com>
Date: Wed, 26 Aug 2009 16:15:24 +0200
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 05/47] KVM: VMX: Optimize vmx_get_cpl()
References: <1251282609-12835-1-git-send-email-avi@redhat.com> <1251282609-12835-6-git-send-email-avi@redhat.com>
In-Reply-To: <1251282609-12835-6-git-send-email-avi@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Op 26-08-09 12:29, Avi Kivity schreef:
> Instead of calling vmx_get_segment() (which reads a whole bunch of
> vmcs fields), read only the cs selector which contains the cpl.
> 
> Signed-off-by: Avi Kivity <avi@redhat.com>

Can't we also optimise cs_ss_rpl_check()? (Please review, untested.)

------------- >8 ---------------------- 8< --------------------
Instead of calling vmx_get_segment() (which reads a whole bunch of
vmcs fields), read only the cs/ss selectors which contains the rpls.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 29f9129..5d8512a 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -1932,13 +1932,8 @@ static bool ldtr_valid(struct kvm_vcpu *vcpu)
 
 static bool cs_ss_rpl_check(struct kvm_vcpu *vcpu)
 {
-	struct kvm_segment cs, ss;
-
-	vmx_get_segment(vcpu, &cs, VCPU_SREG_CS);
-	vmx_get_segment(vcpu, &ss, VCPU_SREG_SS);
-
-	return ((cs.selector & SELECTOR_RPL_MASK) ==
-		 (ss.selector & SELECTOR_RPL_MASK));
+	return ((vmcs_read16(GUEST_CS_SELECTOR) & SELECTOR_RPL_MASK) ==
+		 (vmcs_read16(GUEST_SS_SELECTOR) & SELECTOR_RPL_MASK));
 }
 
 /*
