Return-Path: <linux-kernel-owner+w=401wt.eu-S1756650AbYBNSBq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756650AbYBNSBq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 13:01:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752386AbYBNSBi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 13:01:38 -0500
Received: from rv-out-0910.google.com ([209.85.198.189]:11638 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751971AbYBNSBh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 13:01:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=oXt+ftSSMRaCxmrVnVKO6SDTquwBjpFYpZoBT8whUvkGERfp99XhHNg11U1UUegQC8x2Ya8CZy7qHE0DEMvWK06NcTWYGaFE3etaaImJqpK2KuOyPCsS+rPcD8OKtyEPRiRPU5WkPEevNuDx3Pw6rBQ0WcaS7J7DJU4wgTz+NOM=
Subject: Re: [PATCH] kprobes: remove sparse warnings from x86
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Masami Hiramatsu <mhiramat@redhat.com>
In-Reply-To: <47B4595D.6030900@redhat.com>
References: <1202945433.18204.28.camel@brick>  <47B4595D.6030900@redhat.com>
Content-Type: text/plain
Date: Thu, 14 Feb 2008 10:01:34 -0800
Message-Id: <1203012094.2748.51.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-02-14 at 10:08 -0500, Masami Hiramatsu wrote:
> Harvey Harrison :
> > arch/x86/kernel/kprobes.c:584:16: warning: symbol 'kretprobe_trampoline_holder' was not declared. Should it be static?
> > arch/x86/kernel/kprobes.c:676:6: warning: symbol 'trampoline_handler' was not declared. Should it be static?
> > 
> > Make them static and add the __used attribute, approach taken from the
> > arm kprobes implementation.
> > 
> > kretprobe_trampoline_holder uses inline assemly to define the global
> > symbol kretprobe_trampoline, but nothing ever calls the holder explicitly.
> > 
> > trampoline handler is only called from inline assembly in the same file,
> > mark it used and static.
> > 
> > Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> 
> It looks good to me.
> 
> Acked-by: Masami Hiramatsu <mhiramat@redhat.com>
> 
> Thank you,
> 

Ingo, could you take this in x86.git?

Harvey


From: Harvey Harrison <harvey.harrison@gmail.com>
Subject: [PATCH] kprobes: remove sparse warnings from x86

arch/x86/kernel/kprobes.c:584:16: warning: symbol 'kretprobe_trampoline_holder' was not declared. Should it be static?
arch/x86/kernel/kprobes.c:676:6: warning: symbol 'trampoline_handler' was not declared. Should it be static?

Make them static and add the __used attribute, approach taken from the
arm kprobes implementation.

kretprobe_trampoline_holder uses inline assemly to define the global
symbol kretprobe_trampoline, but nothing ever calls the holder explicitly.

trampoline handler is only called from inline assembly in the same file,
mark it used and static.

Acked-by: Masami Hiramatsu <mhiramat@redhat.com>
Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 arch/x86/kernel/kprobes.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/kprobes.c b/arch/x86/kernel/kprobes.c
index a99e764..34a5912 100644
--- a/arch/x86/kernel/kprobes.c
+++ b/arch/x86/kernel/kprobes.c
@@ -581,7 +581,7 @@ static int __kprobes kprobe_handler(struct pt_regs *regs)
  * When a retprobed function returns, this code saves registers and
  * calls trampoline_handler() runs, which calls the kretprobe's handler.
  */
-void __kprobes kretprobe_trampoline_holder(void)
+static void __used __kprobes kretprobe_trampoline_holder(void)
 {
 	asm volatile (
 			".global kretprobe_trampoline\n"
@@ -673,7 +673,7 @@ void __kprobes kretprobe_trampoline_holder(void)
 /*
  * Called from kretprobe_trampoline
  */
-void * __kprobes trampoline_handler(struct pt_regs *regs)
+static __used __kprobes void *trampoline_handler(struct pt_regs *regs)
 {
 	struct kretprobe_instance *ri = NULL;
 	struct hlist_head *head, empty_rp;
-- 
1.5.4.1.1278.gc75be



