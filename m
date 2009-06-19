Return-Path: <linux-kernel-owner+w=401wt.eu-S1755717AbZFSPOs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755717AbZFSPOs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 11:14:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751078AbZFSPOl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 11:14:41 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:58567 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751865AbZFSPOk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 11:14:40 -0400
Date: Fri, 19 Jun 2009 16:13:21 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Stephen Rothwell <sfr@canb.auug.org.au>, Sam Ravnborg <sam@ravnborg.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Mike Frysinger <vapier.adi@gmail.com>
Subject: Re: linux-next: arm build failures
Message-ID: <20090619151321.GA6223@flint.arm.linux.org.uk>
References: <20090617162612.703adfd9.sfr@canb.auug.org.au> <tnx3a9ztg14.fsf@pc1117.cambridge.arm.com> <20090617230804.5e353ec9.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090617230804.5e353ec9.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 17, 2009 at 11:08:04PM +1000, Stephen Rothwell wrote:
> Hi Catalin,
> 
> On Wed, 17 Jun 2009 09:34:31 +0100 Catalin Marinas <catalin.marinas@arm.com> wrote:
> >
> > Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> > > Over the past few days, I have started getting some arm configs (at least
> > > iop13xx_defconfig and integrator_defconfig, but some others) failing to
> > > build getting this error:
> > >
> > >   SYSMAP  System.map
> > >   SYSMAP  .tmp_System.map
> > > Inconsistent kallsyms data
> > > Try setting CONFIG_KALLSYMS_EXTRA_PASS
> > >
> > > Is this something you have seen?  Could it be my toolchain (I am
> > > currently using gcc 4.4.0 and have not changed it recently)?
> > 
> > I reported an error with kallsysms on ARM this Monday leading to
> > inconsistent data:
> > 
> > http://lkml.org/lkml/2009/6/15/233
> > 
> > Could it be related?
> 
> Could be.  I have added the proposed fix patch to my fixes tree until
> Linus or Sam gets around to including it.

No, I don't think it's got anything to do with it.  It's the kallsyms
generator that's getting confused.

What's happening is that we're ending up with differences between the
symbolic information generated for .tmp_vmlinux2 and vmlinux:

 c024c638 t svc_pool_stats_seq_ops
 c024c648 t rpc_proc_fops
 c024c6b0 T kallsyms_addresses
-c024ea10 T kallsyms_num_syms
-c024ea20 T kallsyms_names
-c0253990 T kallsyms_markers
-c02539c0 T kallsyms_token_table
-c0253d70 T kallsyms_token_index
+c024ea00 T kallsyms_num_syms
+c024ea10 T kallsyms_names
+c0253970 T kallsyms_markers
+c02539a0 T kallsyms_token_table
+c0253d50 T kallsyms_token_index
 c027b000 r __pci_fixup_PCI_VENDOR_ID_VIA0x324equirk_via_cx700_pci_parking_caching
 c027b000 R __start_pci_fixups_early
 c027b000 R __start_rodata

>From what I can tell, what happens is the following:

- link kernel into .tmp_vmlinux1 - thereby containing only weak references
  to the kallsyms data

- generate .tmp_kallsyms1.S and assemble it
- link kernel plus .tmp_kallsyms1.o into .tmp_vmlinux2.  This now contains
  kallsyms data, but based upon the kernel without any such data.  The
  symbolic addresses are therefore all wrong.

- generate .tmp_kallsyms2.S and assemble it
- link kernel plus .tmp_kallsyms2.o into vmlinux.  This contains the kallsyms
  data, but in theory the only difference is that the addresses should now
  be correct.

Now, what seems to be happening in this case is that for .tmp_vmlinux1,
_etext != _data - in other words, the ". = ALIGN(THREAD_SIZE);" statement
is having to do something:

c02880c4 R __stop___param
c0289000 R __end_rodata
c0289000 A _etext
c028a000 A __data_loc
c028a000 D _data
c028a000 D _sdata
c028a000 D init_thread_union

However, for .tmp_vmlinux2, _etext == _data:

c028f0c4 R __stop___param
c0290000 A __data_loc
c0290000 R __end_rodata
c0290000 D _data
c0290000 A _etext
c0290000 D _sdata
c0290000 D init_thread_union

I think the significance of this is the sorting algorithm in kallsyms.c,
and therefore the way the symbolic information gets compressed.  This
causes the tables produced in .tmp_kallsyms1.S and .tmp_kallsyms2.S to
be rather different - particularly size-wise - we can see that
kallsyms_addresses has shrunk by 16 bytes.  (Note that kallsyms_num_syms
is aligned to 8 bytes, so it could be 12 bytes... see the next data point
below.)

It also appears that 3 symbols disappeared between .tmp_kallsyms1.S and
.tmp_kallsyms2.S - get the diff of 'arm-linux-nm -n' output between
.tmp_vmlinux1 and .tmp_vmlinux2 shows no fewer symbols.  If that
translates to 3 fewer addresses in the kallsyms_addresses table,
that'd explain why its shrunk.

The question is... what are these three magically disappearing symbols
and why have they disappeared?  Are they related to the reshuffling
of _etext and __end_rodata vs _data?

I've tried seeing if there's a change to our vmlinux.lds.S file that's
caused this, but my only solution which so far has worked is to add a
". += 4;" after "_etext = .;" to force separation of _data from _etext.
I'm not sure wasting 8K in this way is going to please many people
though, so I wouldn't call it a solution.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
