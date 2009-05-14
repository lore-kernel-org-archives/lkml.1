Return-Path: <linux-kernel-owner+w=401wt.eu-S1761260AbZENNGU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761260AbZENNGU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 09:06:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761134AbZENNGD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 09:06:03 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37534 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760413AbZENNGB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 09:06:01 -0400
X-Sieve: CMU Sieve 2.2
From: Petr Tesarik <ptesarik@suse.cz>
To: linux-kernel@vger.kernel.org, linux-x86_64@vger.kernel.org, mingo@elte.hu,
       andi@firstfloor.org
Cc: zwane@arm.linux.org.uk, roland@redhat.com, Petr Tesarik <ptesarik@suse.cz>
Message-Id: <cover.1242299014.git.ptesarik@suse.cz>
Subject: [PATCH 0/4] x86-64: fix vclock_gettime()
Organization: SUSE LINUX
Date: Thu, 14 May 2009 15:06:01 +0200
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I noticed that x86_64 vDSOs are broken. More specifically, the
vclock_gettime() function may call vread_tsc(), which in turn
reads the TSC counter using vget_cycles().

Now, commit cb9e35dce94a1b9c59d46224e8a94377d673e204 removed
rdtsc_barrier() from that function, and moved it to
do_vgettimeofday(). AFAICS the same is also needed for
vgetns(). So far so good, a one-liner should do, shouldn't it?
No, it won't do.

Why? Because rdtsc_barrier() is defined as follows:

        alternative(ASM_NOP3, "mfence", X86_FEATURE_MFENCE_RDTSC);
        alternative(ASM_NOP3, "lfence", X86_FEATURE_LFENCE_RDTSC);

In other words, this expands to two NOP instructions, which are
patched by the kernel on startup. The location of the instruction
(and other information) is stored in the .altinstruction section.
And that's where the fun begins.

When building the vDSO, this section is saved into the vDSO. That
object will later be included as a blob, so the whole sections
ends outside the region delimited by __alt_instructions and
__alt_instructions_end, and alternative_instructions() will never
patch the NOPs in the vDSO.

To rectify the situation, I saw the following options:

 1. Adjust pointers in the vDSO .altinstruction section during
    vDSO setup, and then pass it to apply_alternatives()
 2. List the relocations with objdump and add them again to vdso.S
    using the .reloc GAS directive
 3. Link the vDSO into the kernel with relocations, i.e. not just
    as a blob

Each one has its drawbacks:

 1. a. All pointers in struct alt_instr are wrong, because they
       refer to the pre-linked location of the vDSO. If the layout
       of the structure is changed (or extended) in the future,
       further adjustments might be necessary.
    b. The .altinstruction is mapped into user-space, although
       user-space has no use for it. The .altinstr_replacement
       section must also be mapped, because .altinstruction
       contains relocations for that section.
       Consequently, in some cases the vDSO will need a few more
       bytes than fits into 1 page.
 2. Works pretty well, but needs binutils 2.18 or later.
 3. Requires linking the vDSO twice. First to produce the vDSO
    with all the ELF headers and linker-generated sections, and
    second to make the in-kernel structure with relocations.

I choose the third option, because it has some advantages, too:

 1. No run-time bloat. All that can be done at link time is done
    at link time.
 2. No user-space bloat. Only those sections which are needed by
    user-space are mapped into the process space.
 3. Possibility to re-use the technique for more general linking,
    e.g. get rid of VMAGIC and run-time vDSO "resolving" of vDSO
    variables in init_vdso_vars().

The following patchset implements the third option.

Beat me hard. ;)

Petr Tesarik (4):
  x86: Use vdso*-syms.h instead of vdso*-syms.lds
  x86: Cleanup vdso-layout.lds.S
  x86-64: link vDSO into the kernel with relocations
  x86: add rdtsc_barrier() to vgetns()

 arch/x86/include/asm/vdso.h     |   14 +-------
 arch/x86/vdso/.gitignore        |   11 +++---
 arch/x86/vdso/Makefile          |   39 +++++++++++++++--------
 arch/x86/vdso/vclock_gettime.c  |   11 ++++--
 arch/x86/vdso/vdso-layout.lds.S |   41 ++++++++++++++++++++----
 arch/x86/vdso/vdso-parts.S      |    7 ++++
 arch/x86/vdso/vdso-reloc.lds.S  |   66 +++++++++++++++++++++++++++++++++++++++
 arch/x86/vdso/vdso.S            |   10 ------
 arch/x86/vdso/vdso.lds.S        |    1 +
 arch/x86/vdso/vdso32-setup.c    |    2 +
 arch/x86/vdso/vma.c             |    1 +
 11 files changed, 151 insertions(+), 52 deletions(-)
 create mode 100644 arch/x86/vdso/vdso-parts.S
 create mode 100644 arch/x86/vdso/vdso-reloc.lds.S
 delete mode 100644 arch/x86/vdso/vdso.S

