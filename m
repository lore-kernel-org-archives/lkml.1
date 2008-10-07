Return-Path: <linux-kernel-owner+w=401wt.eu-S1756770AbYJGAy1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756770AbYJGAy1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 20:54:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757650AbYJGAol
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 20:44:41 -0400
Received: from ns2.suse.de ([195.135.220.15]:60732 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757619AbYJGAok (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 20:44:40 -0400
Date: Mon, 6 Oct 2008 17:39:02 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Ingo Molnar <mingo@elte.hu>,
       Prarit Bhargava <prarit@redhat.com>
Subject: [patch 38/71] x86: fix memmap=exactmap boot argument
Message-ID: <20081007003902.GM3055@suse.de>
References: <20081007002606.723632097@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="x86-fix-memmap-exactmap-boot-argument.patch"
In-Reply-To: <20081007003634.GA3055@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.26-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Prarit Bhargava <prarit@redhat.com>

Backport of d6be118a97ce51ca84035270f91c2bccecbfac5f by Chuck Ebbert

When using kdump modifying the e820 map is yielding strange results.

For example starting with

 BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000100 - 0000000000093400 (usable)
 BIOS-e820: 0000000000093400 - 00000000000a0000 (reserved)
 BIOS-e820: 0000000000100000 - 000000003fee0000 (usable)
 BIOS-e820: 000000003fee0000 - 000000003fef3000 (ACPI data)
 BIOS-e820: 000000003fef3000 - 000000003ff80000 (ACPI NVS)
 BIOS-e820: 000000003ff80000 - 0000000040000000 (reserved)
 BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
 BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000ff000000 - 0000000100000000 (reserved)

and booting with args

memmap=exactmap memmap=640K@0K memmap=5228K@16384K memmap=125188K@22252K memmap=76K#1047424K memmap=564K#1047500K

resulted in:

 user-defined physical RAM map:
 user: 0000000000000000 - 0000000000093400 (usable)
 user: 0000000000093400 - 00000000000a0000 (reserved)
 user: 0000000000100000 - 000000003fee0000 (usable)
 user: 000000003fee0000 - 000000003fef3000 (ACPI data)
 user: 000000003fef3000 - 000000003ff80000 (ACPI NVS)
 user: 000000003ff80000 - 0000000040000000 (reserved)
 user: 00000000e0000000 - 00000000f0000000 (reserved)
 user: 00000000fec00000 - 00000000fec10000 (reserved)
 user: 00000000fee00000 - 00000000fee01000 (reserved)
 user: 00000000ff000000 - 0000000100000000 (reserved)

But should have resulted in:

 user-defined physical RAM map:
 user: 0000000000000000 - 00000000000a0000 (usable)
 user: 0000000001000000 - 000000000151b000 (usable)
 user: 00000000015bb000 - 0000000008ffc000 (usable)
 user: 000000003fee0000 - 000000003ff80000 (ACPI data)

This is happening because of an improper usage of strcmp() in the
e820 parsing code.  The strcmp() always returns !0 and never resets the
value for e820.nr_map and returns an incorrect user-defined map.

This patch fixes the problem.

Signed-off-by: Prarit Bhargava <prarit@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: Chuck Ebbert <cebbert@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/e820_32.c |    2 +-
 arch/x86/kernel/e820_64.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/arch/x86/kernel/e820_32.c
+++ b/arch/x86/kernel/e820_32.c
@@ -697,7 +697,7 @@ static int __init parse_memmap(char *arg
 	if (!arg)
 		return -EINVAL;
 
-	if (strcmp(arg, "exactmap") == 0) {
+	if (strncmp(arg, "exactmap", 8) == 0) {
 #ifdef CONFIG_CRASH_DUMP
 		/* If we are doing a crash dump, we
 		 * still need to know the real mem
--- a/arch/x86/kernel/e820_64.c
+++ b/arch/x86/kernel/e820_64.c
@@ -776,7 +776,7 @@ static int __init parse_memmap_opt(char 
 	char *oldp;
 	unsigned long long start_at, mem_size;
 
-	if (!strcmp(p, "exactmap")) {
+	if (!strncmp(p, "exactmap", 8)) {
 #ifdef CONFIG_CRASH_DUMP
 		/*
 		 * If we are doing a crash dump, we still need to know

-- 
