Return-Path: <linux-kernel-owner+w=401wt.eu-S1754186AbYJOLYR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754186AbYJOLYR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 07:24:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751706AbYJOLYF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 07:24:05 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:47007 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751265AbYJOLYE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 07:24:04 -0400
Date: Wed, 15 Oct 2008 13:23:24 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeff Chua <jeff.chua.linux@gmail.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: linux 2.6.27 kernel panic on x86 - please revert commit
	3a85e770aa77e4f1a4096275c97b64c10cd7323e
Message-ID: <20081015112324.GB31476@elte.hu>
References: <Pine.LNX.4.64.0810151902510.19590@boston.corp.fedex.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0810151902510.19590@boston.corp.fedex.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE,URI_HEX autolearn=no SpamAssassin version=3.2.3
	0.4 URI_HEX                URI: URI hostname has long hexadecimal sequence
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeff Chua <jeff.chua.linux@gmail.com> wrote:

> Commit 3a85e770aa77e4f1a4096275c97b64c10cd7323e broke linux boot on 
> x86 resulting in kernel panic. Here's the console output ...
>
> Net: Registered protocol family 17
> Using IPI No-Shortcut mode
> RAMDISK: Compressed image found at block 0
> VFS: Mounted root (ext2 filesystem (readonly).
> Freeing unsued kernel memory: 312k freed
> init[1]: segfault at ffffe01c up b7f0dc28 sp bfc26628 error 5 in ld-2.7.90.so[b7f0b000+1c000]
> Kernel panic - not syncing: Attempted to kill init!

hm, ffffe01c is weird - VDSO on some ancient distro perhaps? Do you have 
CONFIG_COMPAT_VDSO=y enabled?

if you have CONFIG_COMPAT_VDSO=y enabled but the read access still 
faults, then the question is, why is ffffe000 not mapped properly? The 
logic in arch/x86/vdso/vdso32-setup.c and map_compat_vdso() / 
arch_setup_additional_pages() seems correct and should result in the 
VDSO being mapped as user-readable.

The revert probably just works around some other bug - it is dangerous 
to keep a generic-sounding page table constant like PTE/PDE_IDENT_ATTR 
with user bits set - if that ever leaks through to user-space, surviving 
pagetable init, we've got a root hole.

	Ingo
