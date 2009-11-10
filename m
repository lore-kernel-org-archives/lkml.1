Return-Path: <linux-kernel-owner+w=401wt.eu-S1756976AbZKJQbR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756976AbZKJQbR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 11:31:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756749AbZKJQbQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 11:31:16 -0500
Received: from relay3.sgi.com ([192.48.152.1]:44797 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756137AbZKJQbP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 11:31:15 -0500
Date: Tue, 10 Nov 2009 10:31:18 -0600
From: Dimitri Sivanich <sivanich@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       yinghai@kernel.org, suresh.b.siddha@intel.com, tglx@linutronix.de
Subject: Re: [tip:x86/apic] x86/apic: Limit irq affinity
Message-ID: <20091110163118.GA13707@sgi.com>
References: <20091021011233.GB32196@sgi.com> <tip-683c91f85d7a3e1092d7fa3ec5687af8cd379f02@git.kernel.org> <20091108145355.GA8432@elte.hu> <20091109160215.GA14718@sgi.com> <20091110044025.GA7897@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091110044025.GA7897@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 10, 2009 at 05:40:25AM +0100, Ingo Molnar wrote:
> 
> * Dimitri Sivanich <sivanich@sgi.com> wrote:
> 
> > On Sun, Nov 08, 2009 at 03:53:55PM +0100, Ingo Molnar wrote:
> > > 
> > > * tip-bot for Dimitri Sivanich <sivanich@sgi.com> wrote:
> > > 
> > > > Commit-ID:  683c91f85d7a3e1092d7fa3ec5687af8cd379f02
> > > > Gitweb:     http://git.kernel.org/tip/683c91f85d7a3e1092d7fa3ec5687af8cd379f02
> > > > Author:     Dimitri Sivanich <sivanich@sgi.com>
> > > > AuthorDate: Tue, 3 Nov 2009 12:40:37 -0600
> > > > Committer:  Ingo Molnar <mingo@elte.hu>
> > > > CommitDate: Sun, 8 Nov 2009 13:30:40 +0100
> > > > 
> > > > x86/apic: Limit irq affinity
> > > > 
> > > > This patch allows for hard numa restrictions to irq affinity on
> > > > x86 systems.
> > > 
> > > -tip testing found a build failure:
> > > 
> > > arch/x86/kernel/apic/io_apic.c:1438: error: ???struct irq_desc??? has no member named ???node???
> > > arch/x86/kernel/apic/io_apic.c:3286: error: ???struct irq_desc??? has no member named ???node???
> > >
> > 
> > In the interest of doing some ifdef cleanup as well as fixing the 
> > build problem, can I suggest that we remove the 'ifdef CONFIG_SMP' 
> > from the irq_desc?
> 
> What's the (data and code) size effect on UP kernels?
> 

While I'm not fully certain what is best to report, here is output from
both 'size' and 'readelf'.

For the x86_32 case (the default configuration with SMP_CONFIG off):

Without the patch to remove '#ifdef CONFIG_SMP' from irq_desc:
$ size vmlinux
   text    data     bss     dec     hex filename
6853617  674868 1333604 8862089  873989 vmlinux

With the patch to remove '#ifdef CONFIG_SMP' from irq_desc:
$ size vmlinux
size vmlinux
   text    data     bss     dec     hex filename
6853621  674996 1333604 8862221  873a0d vmlinux

So it looks like we have 4 bytes more text and 128 bytes more data.

Looking at elf data, no MemSiz difference is apparent.

Without the patch:
$ readelf -l vmlinux
..
..
Program Headers:
  Type           Offset   VirtAddr   PhysAddr   FileSiz MemSiz  Flg Align
  LOAD           0x001000 0xc1000000 0x01000000 0x651000 0x651000 R E 0x1000
  LOAD           0x652000 0xc1651000 0x01651000 0xdea1e 0x225000 RWE 0x1000
  NOTE           0x43bd4c 0xc143ad4c 0x0143ad4c 0x00024 0x00024     0x4

With the patch:
Program Headers:
  Type           Offset   VirtAddr   PhysAddr   FileSiz MemSiz  Flg Align
  LOAD           0x001000 0xc1000000 0x01000000 0x651000 0x651000 R E 0x1000
  LOAD           0x652000 0xc1651000 0x01651000 0xdea1e 0x225000 RWE 0x1000
  NOTE           0x43bd44 0xc143ad44 0x0143ad44 0x00024 0x00024     0x4





For the x86_64 case:
Without patch on x86_64:
$ size vmlinux
   text    data     bss     dec     hex filename
6879227  731284  883216 8493727  819a9f vmlinux

With patch on x86_64:
$ size vmlinux
   text    data     bss     dec     hex filename
6879242  731524  883216 8493982  819b9e vmlinux

Looks like 15 bytes text and 240 bytes data.


Looking at elf data, there's a 256 byte difference in MemSiz data
(here I'm showing the output diff without/with the patch):

Program Headers:
  Type           Offset             VirtAddr           PhysAddr
                 FileSiz            MemSiz              Flags  Align
  LOAD           0x0000000000200000 0xffffffff81000000 0x0000000001000000
                 0x0000000000807000 0x0000000000807000  R E    200000
  LOAD           0x0000000000c00000 0xffffffff81a00000 0x0000000001a00000
-                0x0000000000088ff8 0x0000000000088ff8  RWE    200000
+                0x00000000000890f8 0x00000000000890f8  RWE    200000
