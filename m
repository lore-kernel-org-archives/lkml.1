Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752185Ab0BRGTf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 01:19:35 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:44415 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751155Ab0BRGTd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 01:19:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=p9/IPFqIx2sHcWmlB6kc21RUASqnRCA1uxxRNXwFxcCBjrKxNLUIUQb8qxMhBpv5aQ
         ZD65uGsHh+r+jGgPZw7UTNuzJudGKRFsPxKaVNb+vf1pA05WlYhgkD855RCKBwaYFpS/
         0eJtfY6220ad+JmEZPAFwxfMG7+xr3ovoU398=
Date: Thu, 18 Feb 2010 07:19:23 +0100
From: Borislav Petkov <petkovbb@googlemail.com>
To: Michal Marek <mmarek@suse.cz>
Cc: Borislav Petkov <bp@amd64.org>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kbuild <linux-kbuild@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>,
       LKML <linux-kernel@vger.kernel.org>, Jamie Lokier <jamie@shareable.org>,
       Roland Dreier <rdreier@cisco.com>, Al Viro <viro@ZenIV.linux.org.uk>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Brian Gerst <brgerst@gmail.com>
Subject: Re: [PATCH 2/5] bitops: compile time optimization for
 hweight_long(CONSTANT)
Message-ID: <20100218061923.GA1594@liondog.tnic>
Mail-Followup-To: Borislav Petkov <petkovbb@googlemail.com>,
	Michal Marek <mmarek@suse.cz>, Borislav Petkov <bp@amd64.org>,
	"H. Peter Anvin" <hpa@zytor.com>,
	linux-kbuild <linux-kbuild@vger.kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Wu Fengguang <fengguang.wu@intel.com>,
	LKML <linux-kernel@vger.kernel.org>,
	Jamie Lokier <jamie@shareable.org>,
	Roland Dreier <rdreier@cisco.com>,
	Al Viro <viro@ZenIV.linux.org.uk>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	Ingo Molnar <mingo@elte.hu>, Brian Gerst <brgerst@gmail.com>
References: <20100211172424.GB19779@aftab>
 <4B743F7D.3090605@zytor.com>
 <20100212170649.GC3114@aftab>
 <4B758FC0.1020600@zytor.com>
 <20100212174751.GD3114@aftab>
 <4B75A66A.70005@zytor.com>
 <4B7BF5D6.3030701@suse.cz>
 <20100217172040.GC13429@aftab>
 <4B7C27D8.9050408@suse.cz>
 <4B7C29C1.10906@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4B7C29C1.10906@suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 17, 2010 at 06:39:13PM +0100, Michal Marek wrote:
> It wouldn't work actually, because such variable would then apply to all
> hweight.o targets in the tree. But another way would be:
> 
> arch/x86/Kconfig
> config ARCH_HWEIGHT_CFLAGS
>         string
>         default "..." if X86_32
>         default "..." if X86_64
> 
> lib/Makefile
> CFLAGS_hweight.o = $(CONFIG_ARCH_HWEIGHT_CFLAGS)

Yep, this works, albeit with a small adjustment since
CONFIG_ARCH_HWEIGHT_CFLAGS is quoted in the Kconfig and the quotes
appear in the $(CC) call like this:

gcc -Wp,-MD,lib/.hweight.o.d  ... "-fcall-saved-ecx..."

which I fixed like this (idea reused from the make manual):

---
 source "init/Kconfig"
diff --git a/lib/Makefile b/lib/Makefile
index 3b0b4a6..e2ad17c 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -39,7 +39,10 @@ lib-$(CONFIG_RWSEM_XCHGADD_ALGORITHM) += rwsem.o
 lib-$(CONFIG_GENERIC_FIND_FIRST_BIT) += find_next_bit.o
 lib-$(CONFIG_GENERIC_FIND_NEXT_BIT) += find_next_bit.o
 obj-$(CONFIG_GENERIC_FIND_LAST_BIT) += find_last_bit.o
+
+CFLAGS_hweight.o = $(subst $(quote),,$(CONFIG_ARCH_HWEIGHT_CFLAGS))
 obj-$(CONFIG_GENERIC_HWEIGHT) += hweight.o
+
 obj-$(CONFIG_LOCK_KERNEL) += kernel_lock.o
 obj-$(CONFIG_DEBUG_PREEMPT) += smp_processor_id.o
 obj-$(CONFIG_DEBUG_LIST) += list_debug.o
diff --git a/scripts/Makefile.lib b/scripts/Makefile.lib
index f9bdf26..cbcd654 100644
--- a/scripts/Makefile.lib
+++ b/scripts/Makefile.lib
@@ -245,3 +245,7 @@ quiet_cmd_lzo = LZO    $@
 cmd_lzo = (cat $(filter-out FORCE,$^) | \
 	lzop -9 && $(call size_append, $(filter-out FORCE,$^))) > $@ || \
 	(rm -f $@ ; false)
+
+# misc stuff
+# ---------------------------------------------------------------------------
+quote:="



I'm open for better suggestions though.

-- 
Regards/Gruss,
    Boris.
