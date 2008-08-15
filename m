Return-Path: <linux-kernel-owner+w=401wt.eu-S1755215AbYHOKG5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755215AbYHOKG5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 06:06:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752662AbYHOKGs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 06:06:48 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:35502 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752331AbYHOKGr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 06:06:47 -0400
Date: Fri, 15 Aug 2008 12:06:00 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       Clark Williams <williams@redhat.com>, srostedt@redhat.com,
       Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH 0/3] ftrace: handle kernel code remove
Message-ID: <20080815100600.GA29180@elte.hu>
References: <20080815024716.480118113@goodmis.org> <20080815092844.GD22209@elte.hu> <20080815093851.GB9312@elte.hu> <20080815094827.GA21766@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080815094827.GA21766@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> >   http://redhat.com/~mingo/misc/config-Fri_Aug_15_11_34_53_CEST_2008.bad
> 
> the problem is that i'm building a 32-bit kernel on a 64-bit host, and 
> the scripts/recordmcount.pl script does not create the temporary 
> object files in the proper (32-bit) output ELF format.

the crude hack below got me going for now - but this needs a proper 
solution.

	Ingo

--------------------->
>From 52a4a65bcb5b796b7ad83ad069968c476142706f Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Mon, 9 Jun 2008 20:54:22 +0200
Subject: [PATCH] ftrace: scripts/recordmcount.pl cross-build hack

hack around:

 ld: Relocatable linking with relocations from format elf32-i386 (init/.tmp_gl_calibrate.o) to format elf64-x86-64 (init/.tmp_mx_calibrate.o) i  CC      arch/x86/mm/extable.o
 objcopy: 'init/.tmp_mx_calibrate.o': No such file
 rm: cannot remove `init/.tmp_mx_calibrate.o': No such file or directory
 ld: Relocatable linking with relocations from format elf32-i386 (arch/x86/mm/extable.o) to format elf64-x86-64 (arch/x86/mm/.tmp_mx_extable.o) is not supported
 mv: cannot stat `arch/x86/mm/.tmp_mx_extable.o': No such file or directory
 ld: Relocatable linking with relocations from format elf32-i386 (arch/x86/mm/fault.o) to format elf64-x86-64 (arch/x86/mm/.tmp_mx_fault.o) is not supported

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 scripts/recordmcount.pl |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/scripts/recordmcount.pl b/scripts/recordmcount.pl
index 44b4b23..41b55e0 100755
--- a/scripts/recordmcount.pl
+++ b/scripts/recordmcount.pl
@@ -108,6 +108,20 @@ if ($#ARGV < 6) {
 
 my ($arch, $objdump, $objcopy, $cc, $ld, $nm, $rm, $mv, $inputfile) = @ARGV;
 
+if ($arch eq "i386") {
+  $ld = "ld -m elf_i386";
+  $objdump = "objdump -M i386";
+  $objcopy = "objcopy -O elf32-i386";
+  $cc = "gcc -m32";
+}
+
+if ($arch eq "x86_64") {
+  $ld = "ld -m elf_x86_64";
+  $objdump = "objdump -M x86-64";
+  $objcopy = "objcopy -O elf64-i386";
+  $cc = "gcc -m64";
+}
+
 $objdump = "objdump" if ((length $objdump) == 0);
 $objcopy = "objcopy" if ((length $objcopy) == 0);
 $cc = "gcc" if ((length $cc) == 0);
