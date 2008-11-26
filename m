Return-Path: <linux-kernel-owner+w=401wt.eu-S1753004AbYKZIki@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753004AbYKZIki (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 03:40:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751113AbYKZIk3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 03:40:29 -0500
Received: from mta23.gyao.ne.jp ([125.63.38.249]:61122 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750864AbYKZIk2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 03:40:28 -0500
Date: Wed, 26 Nov 2008 17:39:05 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Subject: Detecting endianness in scripts/recordmcount.pl?
Message-ID: <20081126083905.GA20472@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Presently there doesn't seem to be any way to determine whether the
target is big or little endian, and it is assumed that the compiler will
do the right thing by default. Unfortunately this can not be assumed,
and mismatches ensue, resulting in the linker bailing out.

The only obvious solution I saw was to pass in KBUILD_CFLAGS and ld_flags
along with $(CC) and $(LD) to the script, and killing off the hardcoded
flags. This at least gets things building, but that still leaves objcopy
and objdump as the odd ones out. On the other hand, the format can be figured
out by objdumping the object and reading in the file format line, but people
obviously do not have consistent naming for these, and a double-pass would
be needed -- once for establishing little or big, followed by figuring out
which set of regexes to use.

The CONFIG_64BIT test could likewise be adopted for testing endianness, but
not all architectures have config options for endian selections. Likewise, a
simple test program to check if __LITTLE_ENDIAN is set or not won't work
without having knowledge of KBUILD_CFLAGS, in which case it seems saner just
to pass it off as a starting point.

Any better ideas?

---

diff --git a/scripts/Makefile.build b/scripts/Makefile.build
index 7a17677..de2cc42 100644
--- a/scripts/Makefile.build
+++ b/scripts/Makefile.build
@@ -201,7 +201,8 @@ endif
 ifdef CONFIG_FTRACE_MCOUNT_RECORD
 cmd_record_mcount = perl $(srctree)/scripts/recordmcount.pl "$(ARCH)" \
 	"$(if $(CONFIG_64BIT),64,32)" \
-	"$(OBJDUMP)" "$(OBJCOPY)" "$(CC)" "$(LD)" "$(NM)" "$(RM)" "$(MV)" "$(@)";
+	"$(OBJDUMP)" "$(OBJCOPY)" "$(CC) $(KBUILD_CFLAGS)" \
+	"$(LD) $(ld_flags)" "$(NM)" "$(RM)" "$(MV)" "$(@)";
 endif
 
 define rule_cc_o_c
