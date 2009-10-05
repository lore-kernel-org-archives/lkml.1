Return-Path: <linux-kernel-owner+w=401wt.eu-S1758244AbZJEBf0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758244AbZJEBf0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Oct 2009 21:35:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758209AbZJEBfZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Oct 2009 21:35:25 -0400
Received: from wavehammer.waldi.eu.org ([82.139.201.20]:40738 "EHLO
	wavehammer.waldi.eu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758188AbZJEBfY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Oct 2009 21:35:24 -0400
Date: Mon, 5 Oct 2009 03:35:17 +0200
From: Bastian Blank <bastian@waldi.eu.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ingo Molnar <mingo@redhat.com>, the arch/x86 maintainers <x86@kernel.org>,
       Stable Kernel <stable@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>
Subject: Re: [PATCH] xen: Disable stack protector for irq helper
Message-ID: <20091005013517.GA6081@wavehammer.waldi.eu.org>
Mail-Followup-To: Bastian Blank <bastian@waldi.eu.org>,
	Jeremy Fitzhardinge <jeremy@goop.org>,
	Ingo Molnar <mingo@redhat.com>,
	the arch/x86 maintainers <x86@kernel.org>,
	Stable Kernel <stable@kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Xen-devel <xen-devel@lists.xensource.com>
References: <20091004183013.GA26101@wavehammer.waldi.eu.org> <4AC92A65.40806@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4AC92A65.40806@goop.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 04, 2009 at 04:06:13PM -0700, Jeremy Fitzhardinge wrote:
> On 10/04/09 11:30, Bastian Blank wrote:
> > The stack protector needs additional registers on x86_32, which are not
> > saved in calls to the small paravirt interrupt handlers. This leads to
> > early crashes as registers are overwritten and not saved by the caller
> > as instructed.
> Thanks for the patch, but I don't think its quite right.  
> PV_CALLEE_SAVE_REGS_THUNK() is responsible for generating a wrapper for
> the functions to save/restore all the appropriate registers.  If it is
> failing to do so, then the correct fix is to update
> PV_SAVE/RESTORE_ALL_CALLER_REGS.

Well, I did not understand this part of the code, but you seem right. So
lets try the following. I have not yet run tested it.

Save all caller-saved registers on x86_32 for the paravirt callee saved
registers.

Signed-off-by: Bastian Blank <waldi@debian.org>

diff --git a/arch/x86/include/asm/paravirt.h b/arch/x86/include/asm/paravirt.h
index e19ffe3..e4272f3 100644
--- a/arch/x86/include/asm/paravirt.h
+++ b/arch/x86/include/asm/paravirt.h
@@ -793,8 +793,8 @@ static __always_inline void __raw_spin_unlock(struct raw_spinlock *lock)
 #define PV_RESTORE_REGS "popl %edx; popl %ecx;"
 
 /* save and restore all caller-save registers, except return value */
-#define PV_SAVE_ALL_CALLER_REGS		"pushl %ecx;"
-#define PV_RESTORE_ALL_CALLER_REGS	"popl  %ecx;"
+#define PV_SAVE_ALL_CALLER_REGS PV_SAVE_REGS
+#define PV_RESTORE_ALL_CALLER_REGS PV_RESTORE_REGS
 
 #define PV_FLAGS_ARG "0"
 #define PV_EXTRA_CLOBBERS
-- 
In the strict scientific sense we all feed on death -- even vegetarians.
		-- Spock, "Wolf in the Fold", stardate 3615.4
