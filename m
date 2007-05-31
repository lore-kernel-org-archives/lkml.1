Return-Path: <linux-kernel-owner+w=401wt.eu-S1759831AbXEaEvR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759831AbXEaEvR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 00:51:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753366AbXEaEvH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 00:51:07 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:36261 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752490AbXEaEvG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 00:51:06 -0400
Date: Thu, 31 May 2007 06:50:33 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: section mismatches
Message-ID: <20070531045033.GB20795@uranus.ravnborg.org>
References: <20070530180217.bebfa4b0.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070530180217.bebfa4b0.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 30, 2007 at 06:02:17PM -0700, Andrew Morton wrote:
> 
> Mostly from Andi's tree:
> 
> WARNING: arch/i386/kernel/head.o(.note.Xen+0x68): Section mismatch: reference to .init.text:startup_xen
> WARNING: vmlinux(.text+0xc0101183): Section mismatch: reference to .init.text:start_kernel (between 'is386' and 'check_x87')
> WARNING: vmlinux(.text+0xc02fc63b): Section mismatch: reference to .init.text:kernel_init (between 'rest_init' and 'alloc_node_mem_map')
> WARNING: vmlinux(.text+0xc0302e16): Section mismatch: reference to .init.text: (between 'iret_exc' and '_etext')
> WARNING: vmlinux(.text+0xc0302e22): Section mismatch: reference to .init.text: (between 'iret_exc' and '_etext')
> WARNING: vmlinux(.text+0xc0302e2e): Section mismatch: reference to .init.text: (between 'iret_exc' and '_etext')
> WARNING: vmlinux(.text+0xc0302e3a): Section mismatch: reference to .init.text: (between 'iret_exc' and '_etext')
> WARNING: vmlinux(.text+0xc02fc6c7): Section mismatch: reference to .init.text:__alloc_bootmem_node (between 'alloc_node_mem_map' and 'zone_wait_table_init')
> WARNING: vmlinux(.text+0xc02fc797): Section mismatch: reference to .init.text:__alloc_bootmem_node (between 'zone_wait_table_init' and 'schedule')
> WARNING: vmlinux(.text+0xc0222408): Section mismatch: reference to .init.text:__alloc_bootmem (between 'vgacon_startup' and 'vgacon_scrolldelta')
> WARNING: vmlinux(.text+0xc03034c1): Section mismatch: reference to .init.text: (between 'iret_exc' and '_etext')
> WARNING: vmlinux(.text+0xc030360d): Section mismatch: reference to .init.text: (between 'iret_exc' and '_etext')
> WARNING: vmlinux(.notes+0x3d28): Section mismatch: reference to .init.text:startup_xen

Some of the above happens during the MODPOST where we check modules.
The recently added trick to use __init_refok should have 'killed' at least
the one referring to rest_init. But running the check on the final vmlinux have thrown
the .text.init.refok into .text.
Will try to work out a fix for it.

> WARNING: vmlinux(.text+0xc0101183): Section mismatch: reference to .init.text:start_kernel (between 'is386' and 'check_x87')
I too a quick look at this one yesterday.
Code in head.S (for i386) are usually .init.text but in CONFIG_HOTPLUG_CPU it us .text.
But start_kernel() is __init.
Is it correct assumed that start_kernel() is never called in the HOTPLUG case since we
are dealign with CPU #2 and more?
If this is true I will introduce the .text.init.refok section.

	Sam
