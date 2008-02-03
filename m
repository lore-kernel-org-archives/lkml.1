Return-Path: <linux-kernel-owner+w=401wt.eu-S934836AbYBCALa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934836AbYBCALa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 19:11:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759209AbYBCALW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 19:11:22 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36668 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755937AbYBCALV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 19:11:21 -0500
Date: Sat, 2 Feb 2008 16:10:57 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Russell Leidich" <rml@google.com>
Cc: "Andi Kleen" <andi@firstfloor.org>,
       "Torsten Kaiser" <just.for.lkml@googlemail.com>,
       linux-kernel@vger.kernel.org, "Thomas Gleixner" <tglx@linutronix.de>,
       "Ingo Molnar" <mingo@elte.hu>, valdis.kletnieks@vt.edu,
       "Tim Hockin" <thockin@google.com>
Subject: Re: [PATCH] AMD Thermal Interrupt Support
Message-Id: <20080202161057.b240f443.akpm@linux-foundation.org>
In-Reply-To: <3f1a065b0801171706o57ae5d6w8a986db508ddcee4@mail.gmail.com>
References: <3f1a065b0801021350x7fd065fbj9680ce1a4f3c6538@mail.gmail.com>
	<20080104222637.GA19248@one.firstfloor.org>
	<3f1a065b0801041653y77c27a8cvce703cb7d13e10a0@mail.gmail.com>
	<20080105132402.GA705@one.firstfloor.org>
	<3f1a065b0801051208y7e832e8ctda61f28e6328dec3@mail.gmail.com>
	<3f1a065b0801081542p6cca6249g35e83f7e1f450fbd@mail.gmail.com>
	<20080108235212.GE2117@one.firstfloor.org>
	<3f1a065b0801081828y4b084a52g1db9bcb8821cb3da@mail.gmail.com>
	<20080109023714.GK2117@one.firstfloor.org>
	<3f1a065b0801101821k71ea7523l5024f12abb50357f@mail.gmail.com>
	<3f1a065b0801171706o57ae5d6w8a986db508ddcee4@mail.gmail.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Jan 2008 17:06:33 -0800 "Russell Leidich" <rml@google.com> wrote:

> > Here's the hopefully-final version of the patch, which I have just
> > tested on Intel and AMD.

Curious.  This just broke.

i386 allmodconfig:

arch/x86/kernel/cpu/mcheck/p4.o: In function `smp_thermal_interrupt':
arch/x86/kernel/cpu/mcheck/p4.c:61: multiple definition of `smp_thermal_interrupt'
arch/x86/kernel/cpu/mcheck/mce_thermal.o:arch/x86/kernel/cpu/mcheck/mce_thermal.c:17: first defined here
/opt/crosstool/gcc-4.1.0-glibc-2.3.6/i686-unknown-linux-gnu/bin/i686-unknown-linux-gnu-ld: Warning: size of symbol `smp_thermal_interrupt' changed from 4 in arch/x86/kernel/cpu/mcheck/mce_thermal.o to 43 in arch/x86/kernel/cpu/mcheck/p4.o
/opt/crosstool/gcc-4.1.0-glibc-2.3.6/i686-unknown-linux-gnu/bin/i686-unknown-linux-gnu-ld: Warning: type of symbol `smp_thermal_interrupt' changed from 1 to 2 in arch/x86/kernel/cpu/mcheck/p4.o

In mainline we just did this:

--- linux-2.6.24/arch/x86/kernel/cpu/mcheck/p4.c        2008-02-01 14:29:18.000000000 -0800
+++ devel/arch/x86/kernel/cpu/mcheck/p4.c       2008-02-02 15:38:06.000000000 -0800
@@ -57,7 +57,7 @@ static void intel_thermal_interrupt(stru
 /* Thermal interrupt handler for this CPU setup */
 static void (*vendor_thermal_interrupt)(struct pt_regs *regs) = unexpected_thermal_interrupt;
 
-fastcall void smp_thermal_interrupt(struct pt_regs *regs)
+void smp_thermal_interrupt(struct pt_regs *regs)

which I think was always wrong and has just now tripped up the linker.  I
_assume_ that function should be __attribute__((weak)).  Then again, maybe
I'm full of it.  But hey, it compiles now.

