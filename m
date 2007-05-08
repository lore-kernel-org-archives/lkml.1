Return-Path: <linux-kernel-owner+w=401wt.eu-S967024AbXEHLZT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967024AbXEHLZT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 07:25:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934516AbXEHLZS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 07:25:18 -0400
Received: from terminus.zytor.com ([192.83.249.54]:53486 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934352AbXEHLZP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 07:25:15 -0400
Message-ID: <46405E0C.3020909@zytor.com>
Date: Tue, 08 May 2007 04:25:00 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Alexander van Heukelum <heukelum@mailshack.com>, Andi Kleen <ak@suse.de>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Make bootsector stub 16-bit-only (i386)
References: <20070505104452.GA30944@mailshack.com> <20070508032817.e4734798.akpm@linux-foundation.org>
In-Reply-To: <20070508032817.e4734798.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:

>>  
>>  	# Normalize the start address
>> -	jmpl	$BOOTSEG, $start2
>> +	jmpw	$BOOTSEG, $start2
> 
> Sigh, another blow struck in the ongoing struggle between my Vaio and the
> rest of the world.
> 
> Stone-cold black-screen lockup immediately upon boot.
> 
> Stock FC5 install, config at
> http://userweb.kernel.org/~akpm/config-sony.txt

Andrew, I'm seriously starting to think there is something fundamentally
wrong with that test setup.

The bootsect code in question is never executed.  AT ALL.  The only
raison d'être for it at all is to print an error message if someone
writes the kernel to a raw floppy disk.  Nor does it change the
alignment of the header or anything else to that effect -- the assembly
code downstream has an explicit ".org" directive.  For what it's worth,
just to make sure I'm not crazy, I just re-tested both booting the
kernel and booting the raw disk image, in simulation and on real
hardware, and it doesn't change anything.  I used your configuration
file (yes '' | make oldconfig) minus Bluetooth (which is broken in
current top of Linus) against top of tree Linus + the jmpw patch.  I
obviously don't have your Vaio, but I do have my own share of quirky
hardware.  FWIW, I netbooted the hardware using pxelinux 3.50-pre7 as
the bootloader.[*]

I'm not writing this to give you a hard time, far from it.  I'm
suggesting that there might be something wrong with that rig that's
giving you false testing failures.  I don't particularly care about the
patch itself -- all it does is save 3 bytes which are currently unused
anyway, (although it might help Vivek's work.)  However, I'm very
concerned that you might be getting false failures, for obvious reasons.

	-hpa


[*] On the other hand, as I discovered in the process,
arch/i386/kernel/cpu/transmeta.c apparently gets miscompiled on my
development system for top-of-Linus.  This is a Linux bug and not gcc's
fault.  The following code:

	rdmsr(0x80860004, cap_mask, uk);
	wrmsr(0x80860004, ~0, uk);
	c->x86_capability[0] = cpuid_edx(0x00000001);
	wrmsr(0x80860004, cap_mask, uk);

... gets turned into ...
c0430f2d:       b9 04 00 86 80          mov    $0x80860004,%ecx
c0430f32:       0f 32                   rdmsr
c0430f34:       89 c6                   mov    %eax,%esi
c0430f36:       83 c8 ff                or     $0xffffffff,%eax
c0430f39:       89 d7                   mov    %edx,%edi
c0430f3b:       89 c2                   mov    %eax,%edx	## WTF!!
c0430f3d:       0f 30                   wrmsr
c0430f3f:       31 c9                   xor    %ecx,%ecx
c0430f41:       b8 01 00 00 00          mov    $0x1,%eax
c0430f46:       0f a2                   cpuid
c0430f48:       8b 45 8c                mov    0xffffff8c(%ebp),%eax
c0430f4b:       b9 04 00 86 80          mov    $0x80860004,%ecx
c0430f50:       89 50 0c                mov    %edx,0xc(%eax)
c0430f53:       b8 00 00 00 00          mov    $0x0,%eax
c0430f58:       89 fa                   mov    %edi,%edx
c0430f5a:       09 f0                   or     %esi,%eax
c0430f5c:       0f 30                   wrmsr

... with an immediate crash as a result, since -1 is not legal to write
into the high part (%edx) of MSR 0x80860004.

This is due to native_write_msr() being incorrectly implemented as a
macro.  The preprocessed code expands to:
 do { unsigned long long __val = native_read_msr(0x80860004); cap_mask =
__val; uk = __val >> 32; } while(0);
 native_write_msr(0x80860004, ((unsigned long long)uk << 32) | ~0);
 c->x86_capability[0] = cpuid_edx(0x00000001);
 native_write_msr(0x80860004, ((unsigned long long)uk << 32) | cap_mask);

Spot the looney?  "((unsigned long long)uk << 32) | ~0)" is *exactly*
the same thing as "(unsigned long long)~0" which is exactly
0xffffffffffffffffULL.  Without casting the lower argument to u32 before
ORing, it is not guarded against sign extension as a result of promotion.

	-hpa




