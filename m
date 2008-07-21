Return-Path: <linux-kernel-owner+w=401wt.eu-S1758073AbYGUJKV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758073AbYGUJKV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 05:10:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754923AbYGUJKG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 05:10:06 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:39008 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754703AbYGUJKF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 05:10:05 -0400
Date: Mon, 21 Jul 2008 11:09:46 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Avi Kivity <avi@qumranet.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Sam Ravnborg <sam@ravnborg.org>
Subject: [patch] KVM: fix exception entry / build bug, on 64-bit
Message-ID: <20080721090946.GA3795@elte.hu>
References: <1216554241-9966-1-git-send-email-avi@qumranet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1216554241-9966-1-git-send-email-avi@qumranet.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


hi Avi,

* Avi Kivity <avi@qumranet.com> wrote:

>       KVM: Handle virtualization instruction #UD faults during reboot

-tip testing found a build failure on 64-bit x86, caused by this commit. 
Find the fix below.

Thanks,

	Ingo

-------------------->
commit 33a37eb411d193851c334060780ab834ba534292
Author: Ingo Molnar <mingo@elte.hu>
Date:   Mon Jul 21 10:57:15 2008 +0200

    KVM: fix exception entry / build bug, on 64-bit
    
    -tip testing found this build bug:
    
     arch/x86/kvm/built-in.o:(.text.fixup+0x1): relocation truncated to fit: R_X86_64_32 against `.text'
     arch/x86/kvm/built-in.o:(.text.fixup+0xb): relocation truncated to fit: R_X86_64_32 against `.text'
     arch/x86/kvm/built-in.o:(.text.fixup+0x15): relocation truncated to fit: R_X86_64_32 against `.text'
     arch/x86/kvm/built-in.o:(.text.fixup+0x1f): relocation truncated to fit: R_X86_64_32 against `.text'
     arch/x86/kvm/built-in.o:(.text.fixup+0x29): relocation truncated to fit: R_X86_64_32 against `.text'
    
    Introduced by commit 4ecac3fd. The problem is that 'push' will default
    to 32-bit, which is not wide enough as a fixup address. (and which would
    crash on any real fixup event even if it was wide enough)
    
    Introduce KVM_EX_PUSH to get the proper address push width on 64-bit too.
    
    Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/asm-x86/kvm_host.h |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/include/asm-x86/kvm_host.h b/include/asm-x86/kvm_host.h
index f995783..fdde0be 100644
--- a/include/asm-x86/kvm_host.h
+++ b/include/asm-x86/kvm_host.h
@@ -703,9 +703,11 @@ enum {
 						vcpu, 0, 0, 0, 0, 0, 0)
 
 #ifdef CONFIG_64BIT
-#define KVM_EX_ENTRY ".quad"
+# define KVM_EX_ENTRY ".quad"
+# define KVM_EX_PUSH "pushq"
 #else
-#define KVM_EX_ENTRY ".long"
+# define KVM_EX_ENTRY ".long"
+# define KVM_EX_PUSH "pushl"
 #endif
 
 /*
@@ -719,7 +721,7 @@ asmlinkage void kvm_handle_fault_on_reboot(void);
 	"666: " insn "\n\t" \
 	".pushsection .text.fixup, \"ax\" \n" \
 	"667: \n\t" \
-	"push $666b \n\t" \
+	KVM_EX_PUSH " $666b \n\t" \
 	"jmp kvm_handle_fault_on_reboot \n\t" \
 	".popsection \n\t" \
 	".pushsection __ex_table, \"a\" \n\t" \
