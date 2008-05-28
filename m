Return-Path: <linux-kernel-owner+w=401wt.eu-S1751966AbYE1OJi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751966AbYE1OJi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 10:09:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751145AbYE1OJd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 10:09:33 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:40901 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751150AbYE1OJd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 10:09:33 -0400
Date: Wed, 28 May 2008 16:10:12 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       xen-devel <xen-devel@lists.xensource.com>,
       Thomas Gleixner <tglx@linutronix.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       x86@kernel.org
Subject: Re: [bisected] Re: [PATCH 05 of 12] xen: add p2m mfn_list_list
Message-ID: <20080528141012.GA4669@uranus.ravnborg.org>
References: <patchbomb.1211550067@localhost> <a405e5f9ddf6f5f142ea.1211550072@localhost> <20080528122813.GA5502@elte.hu> <483D65E6.3020604@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <483D65E6.3020604@goop.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 28, 2008 at 03:02:14PM +0100, Jeremy Fitzhardinge wrote:
> 
> The use of __section(.data.page_aligned) (or worse 
> __attribute__((section(".data.page_aligned"))) is fairly verbose and 
> brittle. I've got a (totally untested) proposed patch below, to 
> introduce __page_aligned_data|bss which sets the section and the 
> alignment. This will work, but it requires that all page-aligned 
> variables also have an alignment associated with them, so that mis-sized 
> ones don't push the others around.
> 
> There aren't very many users of .data|bss.page_aligned, so it should be 
> easy enough to fix them all up.
> 
> A link-time warning would be good too, of course.

I cooked up this:
diff --git a/arch/x86/kernel/vmlinux_32.lds.S b/arch/x86/kernel/vmlinux_32.lds.S
index ce5ed08..963b2ae 100644
--- a/arch/x86/kernel/vmlinux_32.lds.S
+++ b/arch/x86/kernel/vmlinux_32.lds.S
@@ -40,6 +40,7 @@ SECTIONS
   .text : AT(ADDR(.text) - LOAD_OFFSET) {
        . = ALIGN(PAGE_SIZE); /* not really needed, already page aligned */
        *(.text.page_aligned)
+       end_text_page_aligned = .;
        TEXT_TEXT
        SCHED_TEXT
        LOCK_TEXT
@@ -49,6 +50,9 @@ SECTIONS
        _etext = .;                     /* End of text section */
   } :text = 0x9090

+       ASSERT((end_text_page_aligned == ALIGN((end_text_page_aligned), PAGE_SIZE)),
+              "Text in .text.page_aligned are not modulo PAGE_SIZE")
+
   . = ALIGN(16);               /* Exception table */
   __ex_table : AT(ADDR(__ex_table) - LOAD_OFFSET) {
        __start___ex_table = .;
@@ -89,6 +93,8 @@ SECTIONS
        *(.data.page_aligned)
        *(.data.idt)
   }
+       ASSERT((. == ALIGN(PAGE_SIZE)),
+              "Data in .data.page_aligned are not modulo PAGE_SIZE")

   . = ALIGN(32);
   .data.cacheline_aligned : AT(ADDR(.data.cacheline_aligned) - LOAD_OFFSET) {


But we should try to do it so all archs can benefit.
And it failed in the second ASSERT - I dunno why.

Soccer duties - so I have to run.

	Sam
