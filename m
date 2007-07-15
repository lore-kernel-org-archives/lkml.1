Return-Path: <linux-kernel-owner+w=401wt.eu-S1755847AbXGOCto@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755847AbXGOCto (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2007 22:49:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752110AbXGOCtf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jul 2007 22:49:35 -0400
Received: from tomts20.bellnexxia.net ([209.226.175.74]:60874 "EHLO
	tomts20-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752198AbXGOCte (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2007 22:49:34 -0400
Date: Sat, 14 Jul 2007 22:49:31 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 1/2] F00F bug fixup for i386 - use immediate values
Message-ID: <20070715024931.GA25152@Krystal>
References: <20070714012642.499375439@polymtl.ca> <20070714012743.511046887@polymtl.ca> <20070714072239.GA5822@martell.zuzino.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20070714072239.GA5822@martell.zuzino.mipt.ru>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 22:29:56 up 7 days, 16:35,  2 users,  load average: 0.04, 0.20, 0.25
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Alexey Dobriyan (adobriyan@gmail.com) wrote:
> On Fri, Jul 13, 2007 at 09:26:43PM -0400, Mathieu Desnoyers wrote:
> > Use the faster immediate values for F00F bug handling in do_page_fault.
> 
> > --- linux-2.6-lttng.orig/arch/i386/mm/fault.c
> > +++ linux-2.6-lttng/arch/i386/mm/fault.c
> > @@ -492,7 +493,7 @@
> >  	/*
> >  	 * Pentium F0 0F C7 C8 bug workaround.
> >  	 */
> > -	if (boot_cpu_data.f00f_bug) {
> > +	immediate_if (&f00f_bug_fix) {
> 
> This code is not called during normal pagefaults and even during invalid
> userspace accesses.
> 
> Out of curiosity, I inserted printk() at this place to see where I was
> wrong. I got only two hits:
> 
> 	Checking if this processor honours the WP bit even in supervisor mode... do_page_fault:
> 	Freeing unused kernel memory: 116k freed
> 	do_page_fault:
> 
> Resume: nobody gives a fuck about performance of this particular if,
> 	so conversion it totally pointless.
> 

Interesting investigation, let's push it further:

instrumenting the f00f test site with a printk, I get:

[    0.000000] Checking if this processor honours the WP bit even in
supervisor mode... TEST: would test f00f bug at vadd ffecc000, eip c011928e
[    0.000000] Ok.
... and (whenever xdm restarts) :
[   64.768165] TEST: would test f00f bug at vadd 00000000, eip c0237596
[   64.787136] TEST: would test f00f bug at vadd 0000004c, eip c02375a2

Those EIPs are:

0xc011928e <do_test_wp_bit+20>: mov    %cl,0xffecd000(%edx)
-> Will trigger fixup_exception.

0xc0237596 <__copy_from_user_ll+53>:    rep movsl %ds:(%esi),%es:(%edi)
0xc02375a2 <__copy_from_user_ll+65>:    mov    0x20(%esi),%eax
-> Those look like user-space programs that gave NULL pointers to kernel
system calls.

I agree with you that this is not a "hot path". It was mostly a
straightforward test conversion.

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
