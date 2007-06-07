Return-Path: <linux-kernel-owner+w=401wt.eu-S966093AbXFGBJr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966093AbXFGBJr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 21:09:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758789AbXFGBJg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 21:09:36 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40800 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756938AbXFGBJf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 21:09:35 -0400
Date: Wed, 6 Jun 2007 18:09:24 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Paul Menage" <menage@google.com>
Cc: "William Lee Irwin III" <wli@holomorphy.com>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.22-rc4-mm1
Message-Id: <20070606180924.e455b13c.akpm@linux-foundation.org>
In-Reply-To: <6599ad830706061732i1ecb70f3gf0f4c288ba74563d@mail.gmail.com>
References: <20070606020737.4663d686.akpm@linux-foundation.org>
	<20070606163053.GM6909@holomorphy.com>
	<20070606111315.884cf712.akpm@linux-foundation.org>
	<20070606194329.GO6909@holomorphy.com>
	<6599ad830706061732i1ecb70f3gf0f4c288ba74563d@mail.gmail.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Jun 2007 17:32:33 -0700 "Paul Menage" <menage@google.com> wrote:

> On 6/6/07, William Lee Irwin III <wli@holomorphy.com> wrote:
> >
> > (1) build for i386 with my .config
> > (2) attempt to boot in qemu's i386 system simulator
> >
> > I'm not seeing the sort of nondeterminism Andy Whitcroft is. It breaks
> > every time when I try this.
> >
> 
> Looks to be lockdep related - it's reproducible for me when I turn on
> CONFIG_LOCKDEP and the early crash goes away when I move the
> container_init_early() call to after lockdep_init().
> 

ooh, yes, lockdep_init() really does want to be called before anything
else.

So do we take it that this code hasn't been tested with lockdep?  Please
don't forget that step - lockdep finds some pretty nasty bugs sometimes.

This?

--- a/init/main.c~containersv10-basic-container-framework-fix-2
+++ a/init/main.c
@@ -503,7 +503,6 @@ asmlinkage void __init start_kernel(void
 	char * command_line;
 	extern struct kernel_param __start___param[], __stop___param[];
 
-	container_init_early();
 	smp_setup_processor_id();
 
 	/*
@@ -512,6 +511,7 @@ asmlinkage void __init start_kernel(void
 	 */
 	unwind_init();
 	lockdep_init();
+	container_init_early();
 
 	local_irq_disable();
 	early_boot_irqs_off();
_

