Return-Path: <linux-kernel-owner+w=401wt.eu-S1762542AbXGWQE1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762542AbXGWQE1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 12:04:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758198AbXGWQES
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 12:04:18 -0400
Received: from mail4.iitk.ac.in ([203.197.196.4]:53093 "EHLO mail4.iitk.ac.in"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757968AbXGWQER (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 12:04:17 -0400
X-Virus-Scanner: This message was checked by NOD32 Antivirus system
	for Linux Server. For more information on NOD32 Antivirus System,
	please, visit our website: http://www.nod32.com/.
From: Satyam Sharma <ssatyam@cse.iitk.ac.in>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: David Howells <dhowells@redhat.com>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 23 Jul 2007 21:35:28 +0530
Message-Id: <20070723160528.22137.84144.sendpatchset@cselinux1.cse.iitk.ac.in>
Subject: [PATCH 0/8] i386: bitops: Cleanup, sanitize, optimize
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

There was a lot of bogus stuff that include/asm-i386/bitops.h was doing,
that was unnecessary and not required for the correctness of those APIs.
All that superfluous stuff was also unnecessarily disallowing compiler
optimization possibilities, and making gcc generate code that wasn't as
beautiful as it could otherwise have been. Hence the following series
of cleanups (some trivial, some surprising, in no particular order):

* Bogus extended asm constraints (such as specifying immediate-value
  constraint-modifiers to operands constrained to local registers)
* Obsolete / inapplicable-to-x86 / incorrect comments
* Marking "memory" as clobbered for no good reason
* Volatile-casting of memory addresses
  (wholly unnecessary, makes gcc generate bad code)
* Unwarranted use of __asm__ __volatile__ even when those semantics
  are not required
* Unnecessarily harsh definitions of smp_mb__{before, after}_clear_bit()
  (again, this was like *asking* gcc to generate bad code)


These patches fix no bugs, as there were none (or else we'd have known
long before, obviously). This is just an attempt to clean up / bring down
the bogosity level of that file by several microlenats :-)

Almost all the above are also applicable to include/asm-x86_64/bitops.h
so I will send a patch for that also, later. I have zero knowledge of
other arch's so cannot audit them, sorry.


My testbox boots/works fine with all these patches (uptime half an hour)
and the compressed bzImage is smaller by about ~2 KB for my .config --
don't know about savings in modules. But considering these primitives get
inlined from several places in the tree, I'd expect good savings for
allyesconfig or allmodconfig kind of setups. We've also probably lost
a few cycles from kernel codepaths that use these functions, but I haven't
verified that experimentally.


Satyam
