Return-Path: <linux-kernel-owner+w=401wt.eu-S1762559AbYGaDic@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762559AbYGaDic (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 23:38:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758123AbYGaDhz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 23:37:55 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60994 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757778AbYGaDhy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 23:37:54 -0400
Date: Wed, 30 Jul 2008 20:37:41 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Mike Frysinger" <vapier.adi@gmail.com>
Cc: "Yoshinori Sato" <ysato@users.sourceforge.jp>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] blackfin / h8300 build error fix
Message-Id: <20080730203741.4d7df2ad.akpm@linux-foundation.org>
In-Reply-To: <8bd0f97a0807302026x41d143b6p5c9eb63ef3185f06@mail.gmail.com>
References: <87provuzwk.wl%ysato@users.sourceforge.jp>
	<8bd0f97a0807300911n4ae81b70v97276abf612f6b3e@mail.gmail.com>
	<87hca7npmp.wl%ysato@users.sourceforge.jp>
	<20080730130117.3495cba9.akpm@linux-foundation.org>
	<8bd0f97a0807302026x41d143b6p5c9eb63ef3185f06@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Jul 2008 23:26:47 -0400 "Mike Frysinger" <vapier.adi@gmail.com> wrote:

> you cant just use straight symbol names in common header files as they
> dont take into consideration weird arch-specific ABI conventions.  in
> the case of Blackfin/h8300, the ABI dictates that any C-visible
> symbols have an underscore prefixed to them.  thus all symbols in
> vmlinux.lds.h need to be wrapped in VMLINUX_SYMBOL() so that each arch
> can put hide this magic in their own files.

ooh, a changelog.

This seems to be a pretty common failing.  I just had to fix the same
problem in a linux-next patch:

diff -puN include/asm-generic/vmlinux.lds.h~zero-based-percpu-use-vmlinux_symbol-in-include-asm-generic-vmlinuxldsh include/asm-generic/vmlinux.lds.h
--- a/include/asm-generic/vmlinux.lds.h~zero-based-percpu-use-vmlinux_symbol-in-include-asm-generic-vmlinuxldsh
+++ a/include/asm-generic/vmlinux.lds.h
@@ -385,15 +385,15 @@
 #define PERCPU(align)							\
 	. = ALIGN(align);						\
 	percpu : { } :percpu						\
-	__per_cpu_load = .;						\
-	.data.percpu 0 : AT(__per_cpu_load - LOAD_OFFSET) {		\
+	VMLINUX_SYMBOL(__per_cpu_load) = .;				\
+	.data.percpu 0 : AT(VMLINUX_SYMBOL(__per_cpu_load) - LOAD_OFFSET) { \
 		*(.data.percpu.first)					\
 		*(.data.percpu.shared_aligned)				\
 		*(.data.percpu)						\
 		*(.data.percpu.page_aligned)				\
-		____per_cpu_size = .;					\
+		VMLINUX_SYMBOL(____per_cpu_size) = .;			\
 	}								\
-	. = __per_cpu_load + ____per_cpu_size;				\
+	. = VMLINUX_SYMBOL(__per_cpu_load) + VMLINUX_SYMBOL(____per_cpu_size); \
 	data : { } :data
 #else
 #define PERCPU(align)							\
_

(haven't tested it yet).

It's going to keep happening too, unless we find some way of making x86
break when people forget to use VMLINUX_SYMBOL().
