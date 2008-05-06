Return-Path: <linux-kernel-owner+w=401wt.eu-S1756838AbYEFISm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756838AbYEFISm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 04:18:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754203AbYEFIS0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 04:18:26 -0400
Received: from aun.it.uu.se ([130.238.12.36]:60610 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753715AbYEFISY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 04:18:24 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18464.5177.649312.999486@harpo.it.uu.se>
Date: Tue, 6 May 2008 10:18:01 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
       venkatesh.pallipadi@intel.com
Cc: linux-kernel@vger.kernel.org
Subject: 2.6.26-rc1 lies about PAT not being available
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Booting 2.6.26-rc1 on an old Coppermine PIII, I'm greeted with:

>Linux version 2.6.26-rc1 (mikpe@dryhop) (gcc version 4.2.3) #1 Mon May 5 21:49:49 CEST 2008
>BIOS-provided physical RAM map:
> BIOS-e820: 0000000000000000 - 000000000009c000 (usable)
> BIOS-e820: 000000000009c000 - 00000000000a0000 (reserved)
> BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
> BIOS-e820: 0000000000100000 - 000000002ffec000 (usable)
> BIOS-e820: 000000002ffec000 - 000000002ffef000 (ACPI data)
> BIOS-e820: 000000002ffef000 - 000000002ffff000 (reserved)
> BIOS-e820: 000000002ffff000 - 0000000030000000 (ACPI NVS)
> BIOS-e820: 00000000ffff0000 - 0000000100000000 (reserved)
>CPU and/or kernel does not support PAT.

I know about Intel's PAT erratum (only 4 PAT entries work) and
understand that the kernel might not want to use a half-broken
PAT implementation, but the statement above is blatantly false:
the kernel IS built with PAT support and the CPU DOES have
(half-broken) PAT HW support as /proc/cpuinfo from earlier kernels
confirms.

arch/x86/kernel/cpu/common.c unconditionally disables PAT and
then reenables it for certain vendor/family/model combinations.(*)
Then mm/pat.c comes along, finds !cpu_has_pat, and prints the
bogus message above.

IMO, it would be a lot nicer if common.c printed a warning when
it disables PAT due to the erratum, then the printk() in pat.c
could be something like "PAT support absent or disabled".

(*) common.c enables PAT for all Intel family 15 CPUs. Is that
correct? I don't have the spec updates in front of me, but I
seem to recall the PAT erratum existed also in early P4s.

/Mikael
