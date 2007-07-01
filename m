Return-Path: <linux-kernel-owner+w=401wt.eu-S1757194AbXGAWNo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757194AbXGAWNo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2007 18:13:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751820AbXGAWNh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jul 2007 18:13:37 -0400
Received: from gw.goop.org ([64.81.55.164]:34410 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751789AbXGAWNg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2007 18:13:36 -0400
Message-ID: <4688270E.7020508@goop.org>
Date: Sun, 01 Jul 2007 15:13:34 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Adrian Bunk <bunk@stusta.de>, Andrew Morton <akpm@linux-foundation.org>,
       Jeremy Fitzhardinge <jeremy@xensource.com>, Andi Kleen <ak@suse.de>,
       chrisw@sous-sol.org, xen-devel@lists.xensource.com,
       linux-kernel@vger.kernel.org, Vivek Goyal <vgoyal@in.ibm.com>
Subject: Re: 2.6.22-rc6-mm1: Xen: WARNING: Absolute relocations present
References: <20070628034321.38c9f12b.akpm@linux-foundation.org>	<20070628204001.GA6087@stusta.de> <46841EC4.7080805@goop.org>	<m1hcoorv79.fsf@ebiederm.dsl.xmission.com> <4687D744.6000103@goop.org> <m1bqevsw5r.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m1bqevsw5r.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> Jeremy Fitzhardinge <jeremy@goop.org> writes:
>
>
>   
>>>> Adrian Bunk wrote:
>>>>
>>>>         
>>>>> <--  snip  -->
>>>>>
>>>>> ...
>>>>>   RELOCS  arch/i386/boot/compressed/vmlinux.relocs
>>>>> WARNING: Absolute relocations present
>>>>> Offset     Info     Type     Sym.Value Sym.Name
>>>>> c0101f80 020c6501   R_386_32 00000000  xen_irq_disable_direct_reloc
>>>>> c0101f9a 0221ea01   R_386_32 00000000  xen_save_fl_direct_reloc
>>>>>           
> Actually I have to ask.  How in the world are these absolute symbols
> ok from a relocation perspective.
>
> If the kernel is not running at 0xc0100000 the offset value looks like
> it will be completely bogus.
>   

Notice they're absolute 0.

> Maybe those are ok, but if you could please explain why those are
> false positives I would appreciate it. (Especially in your patch
> description).
>
> If these are indeed false positives the patch looks ok.
>   

Subject: xen: suppress abs symbol warnings for unused reloc pointers

arch/i386/xen/xen-asm.S defines some small pieces of code which are
used to implement a few paravirt_ops.  They're designed so they can be
used either in-place, or be inline patched into their callsites if
there's enough space.

Some of those operations need to make calls out (specifically, if you
re-enable events [interrupts], and there's a pending event at that
time).  These calls need the call instruction to be relocated if the
code is patched inline.  In this case xen_foo_reloc is a section-relative
symbol which points to xen_foo's required relocation.

Other operations have no need of a relocation, and so their
corresponding xen_bar_reloc is absolute 0.  These are the cases which
are triggering the warning.

This patch adds those symbols to the list of safe abs symbols.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: Adrian Bunk <bunk@stusta.de>

---
 arch/i386/boot/compressed/relocs.c |    2 ++
 1 file changed, 2 insertions(+)

===================================================================
--- a/arch/i386/boot/compressed/relocs.c
+++ b/arch/i386/boot/compressed/relocs.c
@@ -31,6 +31,8 @@ static const char* safe_abs_relocs[] = {
 		"__kernel_rt_sigreturn",
 		"__kernel_sigreturn",
 		"SYSENTER_RETURN",
+		"xen_irq_disable_direct_reloc",
+		"xen_save_fl_direct_reloc",
 };
 
 static int is_safe_abs_reloc(const char* sym_name)


