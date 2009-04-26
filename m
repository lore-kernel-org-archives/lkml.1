Return-Path: <linux-kernel-owner+w=401wt.eu-S1755199AbZDZCSY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755199AbZDZCSY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Apr 2009 22:18:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754107AbZDZCR6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Apr 2009 22:17:58 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:54203 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753971AbZDZCR5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Apr 2009 22:17:57 -0400
Date: Sat, 25 Apr 2009 22:10:38 -0400 (EDT)
From: Tim Abbott <tabbott@MIT.EDU>
To: Sam Ravnborg <sam@ravnborg.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Anders Kaseorg <andersk@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <andi@firstfloor.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, Jeff Arnold <jbarnold@MIT.EDU>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jon Masters <jonathan@jonmasters.org>,
       Masami Hiramatsu <mhiramat@redhat.com>, "Theodore Ts'o" <tytso@MIT.EDU>,
       Nikanth Karthikesan <knikanth@suse.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Paul Mundt <lethal@linux-sh.org>,
       =?ISO-8859-15?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>
Subject: Re: [PATCH v3 1/3] Make section names compatible with -ffunction-sections
 -fdata-sections
In-Reply-To: <20090424172358.GA21946@uranus.ravnborg.org>
Message-ID: <alpine.DEB.1.10.0904251304120.7631@vinegar-pot.mit.edu>
References: <alpine.DEB.1.10.0904221826180.24694@vinegar-pot.mit.edu> <1240519774-20307-1-git-send-email-tabbott@mit.edu> <20090424172358.GA21946@uranus.ravnborg.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Apr 2009, Sam Ravnborg wrote:

> This patch touches far too many files.
> We should try to work out a method so we are in better control
> of the section names, so renaming in the end is a simple patch
> touching only a few files.

OK, I'm now planning to implement this approach.

> > -.section .text.head, "ax"
> > +.section .text..head, "ax"
> 
> Use __HEAD (from include/linux/init.h)
> Same goes for all other uses of .text.head.

I notice that __HEAD uses .head.text, while some architectures use 
.text.head.  It looks like this is just an inconsistency across 
architectures that will be removed as a consequence of this cleanup work 
(no architecture uses both .head.text and .text.head).

One challenge with this approach is that many linker scripts use these 
section names in more complex ways than just squashing HEAD_TEXT at the 
start of the text section.  For example, the the linker scripts for x86 
and ia64 have code like:

  .text.head : AT(ADDR(.text.head) - LOAD_OFFSET) {
        _text = .;                      /* Text and read-only data */
        *(.text.head)
  } :text = 0x9090

which can't user either the __HEAD macro (which is the full .section line) 
or the HEAD_TEXT macro (which is the *(.head.text)).  I think the right 
way to solve this is to create a HEAD_TEXT_SECTION macro in a new header 
(include/linux/section-names.h) and define everything else in terms of 
that; these linker script blocks would then use HEAD_TEXT_SECTION when 
necessary.  The new header would grow to contain several other section
names used in both code and linker scripts as this work proceeds.

I'm sending with this a prototype patch series that replaces all 
".head.text" and ".text.head" usage with these macros.  Please review the 
design, as I intend to implement this design for many other section names 
in the near future.

	-Tim Abbott

Tim Abbott (15):
  Add new HEAD_TEXT_SECTION macro.
  xtensa: convert to use __HEAD and HEAD_TEXT macros.
  alpha: convert to use __HEAD and HEAD_TEXT macros.
  frv: convert frv to use __HEAD and HEAD_TEXT macros.
  arm: convert to use __HEAD and HEAD_TEXT macros.
  ia64: convert to use __HEAD and HEAD_TEXT macros.
  m32r: convert to use __HEAD and HEAD_TEXT macros.
  m68k: convert to use __HEAD and HEAD_TEXT macros.
  mn10300: convert to use __HEAD and HEAD_TEXT macros.
  powerpc: convert to use __HEAD and HEAD_TEXT macros.
  s390: convert to use __HEAD and HEAD_TEXT macros.
  sh: convert to use __HEAD and HEAD_TEXT macros.
  sparc: convert to use __HEAD and HEAD_TEXT macros.
  x86: convert to use __HEAD and HEAD_TEXT macros.
  modpost: convert modpost to use HEAD_TEXT_SECTION macro.

 arch/alpha/kernel/head.S                           |    3 ++-
 arch/alpha/kernel/vmlinux.lds.S                    |    2 +-
 arch/arm/kernel/head-nommu.S                       |    2 +-
 arch/arm/kernel/head.S                             |    2 +-
 arch/arm/kernel/vmlinux.lds.S                      |    4 ++--
 arch/frv/kernel/head.S                             |    3 ++-
 arch/frv/kernel/vmlinux.lds.S                      |    2 +-
 arch/ia64/kernel/head.S                            |    2 +-
 arch/ia64/kernel/vmlinux.lds.S                     |    4 ++--
 arch/m32r/kernel/head.S                            |    2 +-
 arch/m32r/kernel/vmlinux.lds.S                     |    2 +-
 arch/m68k/kernel/head.S                            |    2 +-
 arch/m68k/kernel/sun3-head.S                       |    2 +-
 arch/m68k/kernel/vmlinux-std.lds                   |    2 +-
 arch/m68k/kernel/vmlinux-sun3.lds                  |    2 +-
 arch/mn10300/kernel/head.S                         |    3 ++-
 arch/mn10300/kernel/vmlinux.lds.S                  |    5 +----
 arch/powerpc/kernel/head_32.S                      |    3 ++-
 arch/powerpc/kernel/head_40x.S                     |    3 ++-
 arch/powerpc/kernel/head_44x.S                     |    3 ++-
 arch/powerpc/kernel/head_8xx.S                     |    3 ++-
 arch/powerpc/kernel/head_fsl_booke.S               |    3 ++-
 arch/powerpc/kernel/vmlinux.lds.S                  |    2 +-
 arch/s390/kernel/head.S                            |    3 ++-
 arch/s390/kernel/vmlinux.lds.S                     |    4 ++--
 arch/sh/kernel/head_32.S                           |    3 ++-
 arch/sh/kernel/head_64.S                           |    5 ++++-
 arch/sh/kernel/vmlinux_32.lds.S                    |    2 +-
 arch/sh/kernel/vmlinux_64.lds.S                    |    2 +-
 arch/sparc/kernel/head_32.S                        |    2 +-
 arch/sparc/kernel/vmlinux.lds.S                    |    2 +-
 arch/x86/boot/compressed/Makefile                  |    2 ++
 arch/x86/boot/compressed/head_32.S                 |    3 ++-
 arch/x86/boot/compressed/head_64.S                 |    3 ++-
 .../{vmlinux_32.lds => vmlinux_32.lds.S}           |    6 ++++--
 .../{vmlinux_64.lds => vmlinux_64.lds.S}           |    6 ++++--
 arch/x86/kernel/head_32.S                          |    2 +-
 arch/x86/kernel/head_64.S                          |    2 +-
 arch/x86/kernel/vmlinux_32.lds.S                   |    4 ++--
 arch/x86/kernel/vmlinux_64.lds.S                   |    2 +-
 arch/xtensa/kernel/head.S                          |    3 ++-
 arch/xtensa/kernel/vmlinux.lds.S                   |    4 ++--
 include/asm-generic/vmlinux.lds.h                  |    4 +++-
 include/linux/init.h                               |    4 +++-
 include/linux/section-names.h                      |    6 ++++++
 scripts/mod/modpost.c                              |    8 +++++---
 46 files changed, 87 insertions(+), 56 deletions(-)
 rename arch/x86/boot/compressed/{vmlinux_32.lds => vmlinux_32.lds.S} (89%)
 rename arch/x86/boot/compressed/{vmlinux_64.lds => vmlinux_64.lds.S} (90%)
 create mode 100644 include/linux/section-names.h

