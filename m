Return-Path: <linux-kernel-owner+w=401wt.eu-S1753538AbYGUNHS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753538AbYGUNHS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 09:07:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752022AbYGUNHG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 09:07:06 -0400
Received: from ik-out-1112.google.com ([66.249.90.176]:10702 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751728AbYGUNHF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 09:07:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:in-reply-to:user-agent:from;
        b=W+RIHLKNqPX1kQAIII4AIMj2xL4HVNzoVRFImIEqM3clyS0xXRRxRXqJuOX1LNrp/W
         jWq9Jsya+OOY3Imx833wilpEgiMHsU2qsfyt7LaUTxEoRERGrwkA2tL4mrS5g5EbF5Kk
         0M20TAkiyoVlSlwxeBLca4+BC9kxlEMXkYtWA=
Date: Mon, 21 Jul 2008 15:06:35 +0200
To: Olaf Hering <olaf@aepfle.de>, Ingo Molnar <mingo@elte.hu>
Cc: Adrian Bunk <bunk@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: asm-x86/processor-flags.h, CONFIG_* leaks
Message-ID: <20080721130635.GA19123@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080721124656.GA28618@aepfle.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: Vegard Nossum <vegard.nossum@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 21, 2008 at 2:46 PM, Olaf Hering <olaf@aepfle.de> wrote:
>
> asm-x86/processor-flags.h is an exported header,
> via 'make headers_install_all'
>
> Please move X86_VM_MASK inside __KERNEL__

Oops, this seems to be my fault. Find the fix below.

As I stated in the original commit, this was tested with 'make
headers_check', so I can only guess that it's a merge fall-out.

Adrian Bunk pointed it out in my original submission, which is
why it was explicitly tested... But I just tested it again, and
why doesn't make headers_check catch it?

Sorry :-/


Vegard


>From d3795de8f7001aa1a485c52e2f0ce565dd1e23cf Mon Sep 17 00:00:00 2001
From: Vegard Nossum <vegard.nossum@gmail.com>
Date: Mon, 21 Jul 2008 14:54:23 +0200
Subject: [PATCH] x86: don't leak X86_VM_MASK in processor-flags.h

Apparently,

commit 6330a30a76c1e62d4b4ec238368957f8febf9113
Author: Vegard Nossum <vegard.nossum@gmail.com>
Date:   Wed May 28 09:46:19 2008 +0200

    x86: break mutual header inclusion

introduced some CONFIG names to processor-flags.h, which was exported in

commit 6093015db2bd9e70cf20cdd23be1a50733baafdd
Author: Ingo Molnar <mingo@elte.hu>
Date:   Sun Mar 30 11:45:23 2008 +0200

    x86: cleanup replace most vm86 flags with flags from processor-flags.h, fix

Fix it by wrapping the CONFIG parts in __KERNEL__.

Reported-by: Olaf Hering <olaf@aepfle.de>
Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
---
 include/asm-x86/processor-flags.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/asm-x86/processor-flags.h b/include/asm-x86/processor-flags.h
index 092b39b..eff2ecd 100644
--- a/include/asm-x86/processor-flags.h
+++ b/include/asm-x86/processor-flags.h
@@ -88,10 +88,12 @@
 #define CX86_ARR_BASE	0xc4
 #define CX86_RCR_BASE	0xdc
 
+#ifdef __KERNEL__
 #ifdef CONFIG_VM86
 #define X86_VM_MASK	X86_EFLAGS_VM
 #else
 #define X86_VM_MASK	0 /* No VM86 support */
 #endif
+#endif
 
 #endif	/* __ASM_I386_PROCESSOR_FLAGS_H */
-- 
1.5.5.1

