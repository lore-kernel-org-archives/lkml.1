Return-Path: <linux-kernel-owner+w=401wt.eu-S1758190AbYJGAvM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758190AbYJGAvM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 20:51:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757119AbYJGAoG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 20:44:06 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60581 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754330AbYJGAoE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 20:44:04 -0400
Date: Mon, 6 Oct 2008 17:38:40 -0700
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
       Krzysztof Helt <krzysztof.h1@wp.pl>
Subject: [patch 29/71] x86: fdiv bug detection fix
Message-ID: <20081007003840.GD3055@suse.de>
References: <20081007002606.723632097@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="x86-fdiv-bug-detection-fix.patch"
In-Reply-To: <20081007003634.GA3055@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.26-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Krzysztof Helt <krzysztof.h1@wp.pl>

commit e0d22d03c06c4e2c194d7010bc1e4a972199f156 upstream

The fdiv detection code writes s32 integer into
the boot_cpu_data.fdiv_bug.
However, the boot_cpu_data.fdiv_bug is only char (s8)
field so the detection overwrites already set fields for
other bugs, e.g. the f00f bug field.

Use local s32 variable to receive result.

This is a partial fix to Bugzilla #9928  - fixes wrong
information about the f00f bug (tested) and probably
for coma bug (I have no cpu to test this).

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: Chuck Ebbert <cebbert@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/cpu/bugs.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -50,6 +50,8 @@ static double __initdata y = 3145727.0;
  */
 static void __init check_fpu(void)
 {
+	s32 fdiv_bug;
+
 	if (!boot_cpu_data.hard_math) {
 #ifndef CONFIG_MATH_EMULATION
 		printk(KERN_EMERG "No coprocessor found and no math emulation present.\n");
@@ -70,8 +72,10 @@ static void __init check_fpu(void)
 		"fistpl %0\n\t"
 		"fwait\n\t"
 		"fninit"
-		: "=m" (*&boot_cpu_data.fdiv_bug)
+		: "=m" (*&fdiv_bug)
 		: "m" (*&x), "m" (*&y));
+
+	boot_cpu_data.fdiv_bug = fdiv_bug;
 	if (boot_cpu_data.fdiv_bug)
 		printk("Hmm, FPU with FDIV bug.\n");
 }

-- 
