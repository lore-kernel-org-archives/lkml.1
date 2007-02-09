Return-Path: <linux-kernel-owner+w=401wt.eu-S1423318AbXBIWm7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423318AbXBIWm7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 17:42:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423345AbXBIWm7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 17:42:59 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:37145 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423318AbXBIWm6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 17:42:58 -0500
Subject: Re: -mm merge plans for 2.6.21
From: David Woodhouse <dwmw2@infradead.org>
To: Russell King <rmk+lkml@arm.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Alexey Dobriyan <adobriyan@openvz.org>, linux-kernel@vger.kernel.org,
       drepper@redhat.com
In-Reply-To: <1171059147.29713.146.camel@pmac.infradead.org>
References: <20070208150710.1324f6b4.akpm@linux-foundation.org>
	 <1171042535.29713.96.camel@pmac.infradead.org>
	 <20070209134516.2367a7aa.akpm@linux-foundation.org>
	 <20070209214944.GA16158@flint.arm.linux.org.uk>
	 <1171057999.29713.129.camel@pmac.infradead.org>
	 <20070209220327.GB16158@flint.arm.linux.org.uk>
	 <1171059147.29713.146.camel@pmac.infradead.org>
Content-Type: text/plain
Date: Fri, 09 Feb 2007 22:42:48 +0000
Message-Id: <1171060968.29713.152.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-02-09 at 22:12 +0000, David Woodhouse wrote:
> 
> We could _also_ do with a way to warn about unimplemented syscalls on
> any given architecture. I'm thinking about something along the lines
> of
> a kernel/syscalls.c containing nothing but...
> 
>         #include <asm/unistd.h>
> 
>         #ifndef __NR_sys_foo
>         #warning The sys_foo system call is not implemented on this
> architecture
>         #endif
> 
> Ideally, that wants to be auto-generated from the union of all
> <asm-*/unistd.h> files, but in practice I suspect we could do it just
> from <asm-i386/unistd.h>. Even I usually manage to add new syscalls on
> i386 after I've done PowerPC. 

Realistically speaking, I'm not going to have time to do anything useful
with this before I disappear for a week starting tomorrow. But in case
it helps, I'll throw this in to see if it inspires anyone...

 ( echo -e "#include <asm/unistd.h>\n#include
<asm-generic/optional-syscalls.h>" ; sed -n '/^#define/s/[^_]*__NR_
\([^[:space:]]*\).*/#if !defined (__NR_\1) \&\& !defined (__IGNORE_
\1)\n#warning System call \1 is not implemented\n#endif/p'
include/asm-i386/unistd.h ) > kernel/syscalls.c

Coupled with an include/optional-syscalls.h which defines __IGNORE_vm86,
__IGNORE_vm86old and then on 64-bit machines a bunch more
__IGNORE_stat64 et al., that should mostly do the trick...

-- 
dwmw2

