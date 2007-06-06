Return-Path: <linux-kernel-owner+w=401wt.eu-S933976AbXFFPUt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933976AbXFFPUt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 11:20:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761120AbXFFPUm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 11:20:42 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:56539 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755584AbXFFPUl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 11:20:41 -0400
Date: Wed, 6 Jun 2007 11:11:34 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: Re: [PATCH 2/2] UML - Fix kernel stack size on x86_64
Message-ID: <20070606151134.GA5972@c2.user-mode-linux.org>
References: <20070605205055.GA9770@c2.user-mode-linux.org> <20070605170001.c8b2110e.akpm@linux-foundation.org> <20070606003752.GA11511@c2.user-mode-linux.org> <20070605182024.003502d4.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070605182024.003502d4.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 05, 2007 at 06:20:24PM -0700, Andrew Morton wrote:
> If you do
> 
> -	int "Kernel stack size order"
> +	int
> 
> then this rule will no longer be offered to the user and `make oldconfig'
> (actually anythingconfig) will override whatever happens to be in .config
> for KERNEL_STACK_ORDER.

You're saying that making an option user-visible changes whether
*config overrides .config?  That's non-intuitive.

> I'm not sure if that's actually what you want, but if the current situation
> is that a random CONFIG_KERNEL_STACK_ORDER=0 left over in .config will
> break the kernel at runtime then I think something sterner than editing
> defconfig is needed?

That's a good point, but I think I do want it user-visible.  If
someone sees someething I suspect to be a stack overflow, I'd like to
be able to tell them to bump KERNEL_STACK_ORDER and see if the problem
goes away.

As for something sterner, it turns out that Kbuild provides some
support for this.  So, drop the previous patch in favor of this one:

Force KERNEL_STACK_ORDER to be at least 1 on UML/x86_64.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
--
 arch/um/Kconfig |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6.21-mm/arch/um/Kconfig
===================================================================
--- linux-2.6.21-mm.orig/arch/um/Kconfig	2007-06-06 09:28:13.000000000 -0400
+++ linux-2.6.21-mm/arch/um/Kconfig	2007-06-06 11:08:49.000000000 -0400
@@ -278,6 +278,7 @@ config HIGHMEM
 config KERNEL_STACK_ORDER
 	int "Kernel stack size order"
 	default 1 if 64BIT
+	range 1 10 if 64BIT
 	default 0 if !64BIT
 	help
 	This option determines the size of UML kernel stacks.  They will
