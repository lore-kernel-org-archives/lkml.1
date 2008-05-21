Return-Path: <linux-kernel-owner+w=401wt.eu-S936426AbYEUUGH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936426AbYEUUGH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 16:06:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937049AbYEUUFf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 16:05:35 -0400
Received: from [198.99.130.12] ([198.99.130.12]:52330 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S936909AbYEUUFc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 16:05:32 -0400
Date: Wed, 21 May 2008 16:05:15 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Gabriel C <nix.or.die@googlemail.com>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-next@vger.kernel.org, user-mode-linux-devel@lists.sourceforge.net
Subject: Re: linux-next: UML build error
Message-ID: <20080521200515.GB12373@c2.user-mode-linux.org>
References: <48345B31.50904@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48345B31.50904@googlemail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 21, 2008 at 07:26:09PM +0200, Gabriel C wrote:
>   CC      arch/um/sys-x86_64/ksyms.o
> arch/um/sys-x86_64/ksyms.c:5: error: '__memcpy' undeclared here (not in a function)
> arch/um/sys-x86_64/ksyms.c:5: warning: type defaults to 'int' in declaration of '__memcpy'

Does the patch below help?  There's gcc-version-dependent logic in
include/asm-x86/string_64.h which decides whether to declare memcpy or
__memcpy and it looks like you're hitting that.

	     	      Jeff

-- 
Work email - jdike at linux dot intel dot com

Index: linux-2.6.22/arch/um/sys-x86_64/ksyms.c
===================================================================
--- linux-2.6.22.orig/arch/um/sys-x86_64/ksyms.c	2008-04-23 13:07:23.000000000 -0400
+++ linux-2.6.22/arch/um/sys-x86_64/ksyms.c	2008-05-21 16:03:03.000000000 -0400
@@ -2,4 +2,8 @@
 #include "asm/string.h"
 
 /*XXX: we need them because they would be exported by x86_64 */
+#if (__GNUC__ == 4 && __GNUC_MINOR__ >= 3) || __GNUC__ > 4
+EXPORT_SYMBOL(memcpy);
+#else
 EXPORT_SYMBOL(__memcpy);
+#endif
