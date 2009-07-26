Return-Path: <linux-kernel-owner+w=401wt.eu-S1753088AbZGZCpS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753088AbZGZCpS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jul 2009 22:45:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753056AbZGZCpS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Jul 2009 22:45:18 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:35232 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753044AbZGZCpR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jul 2009 22:45:17 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19051.49973.882153.443825@cargo.ozlabs.ibm.com>
Date: Sun, 26 Jul 2009 12:45:09 +1000
From: Paul Mackerras <paulus@samba.org>
To: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>
CC: linux-kernel@vger.kernel.org
Subject: Starting 2nd cpu on recent intel macbook
X-Mailer: VM 8.0.12 under 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I recently got my daughter a new Macbook because her current ppc-based
iBook is starting to die.  On macbooks you can boot Linux either as a
"legacy" OS, where firmware provides a BIOS, or using a native EFI
boot, where everything is done through EFI and there is no BIOS.  The
CPU is a Core 2 Duo (2.13GHz).

When I boot any recent kernel with a legacy boot, the kernel fails to
bring up the second core and then hangs some time later.  If I boot
with "nosmp" it boots up OK.  Interestingly, when booting via EFI the
second core comes up just fine, though this machine requires some
changes to the EFI code in the kernel, and you have to use efifb for
the console.

The downside of the EFI boot is that we then don't know how to control
the screen brightness, and in fact when switching from X to a text
console the backlight gets turned off and we don't know how to turn it
on.  So a legacy boot is better from the point of view of video
support, but we don't get to use the second core.

I have tried to find any difference between how we poke the APIC in
the two cases, but that looks to be identical.  In both cases we send
INIT IPIs to turn INIT on and then off, and then send two STARTUP
IPIs.  The trampoline code is the same, and one of the first things it
does is to write 0xa5a5a5a5 to the first dword of the trampoline area.
I see that happening on the EFI boot but not the legacy boot.

So I'm wondering how much firmware gets involved in this process.  It
sounds like the STARTUP IPI acts pretty directly in hardware, but only
does anything if the core is in the halted state.  Does the INIT IPI
put the cpu into the halted start as well as resetting it?  Or does
the INIT make the cpu start executing somewhere (where?) and then it
goes through some initialization code before executing a hlt
instruction somewhere in firmware?

Paul.
