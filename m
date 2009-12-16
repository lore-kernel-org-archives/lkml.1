Return-Path: <linux-kernel-owner+w=401wt.eu-S933502AbZLPNy6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933502AbZLPNy6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 08:54:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932744AbZLPNy5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 08:54:57 -0500
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:39872
	"EHLO VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932700AbZLPNyz convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 08:54:55 -0500
X-SpamScore: 1
X-BigFish: VPS1(zzab9bhzz1202hzzz32i6bh62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KUQZYY-02-2MK-02
X-M-MSG: 
Date: Wed, 16 Dec 2009 14:54:48 +0100
From: Borislav Petkov <borislav.petkov@amd.com>
To: Ingo Molnar <mingo@elte.hu>, Masami Hiramatsu <mhiramat@redhat.com>
CC: linux-kernel@vger.kernel.org
Subject: perf and libdwarf on debian
Message-ID: <20091216135448.GD11618@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 16 Dec 2009 13:54:35.0954 (UTC) FILETIME=[4D6A3120:01CA7E57]
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

even after installing libdwarf-dev on my debian box here, make in tools/perf/
still complains that it cannot find libdwarf:

Makefile:491: No libdwarf.h found or old libdwarf.h found, disables dwarf support. Please install libdwarf-dev/libdwarf-devel >= 20081231

The problem is that the include path on debian is not
/usr/include/libdwarf/ but simply /usr/include because the debian
package libdwarf-dev puts the headers straight into /usr/include.

Now, fixing this in the build system could get ugly and too much (see
below), IMHO, so how about adding a README file in <tools/perf/>
which explains that on Debian-like systems, one should mkdir
/usr/include/libdwarf/ and symlink libdwarf.h and dwarf.h into it?

There could be a better solution though...?

---
diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 4069996..5b48ce2 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -161,6 +161,7 @@ uname_O := $(shell sh -c 'uname -o 2>/dev/null || echo not')
 uname_R := $(shell sh -c 'uname -r 2>/dev/null || echo not')
 uname_P := $(shell sh -c 'uname -p 2>/dev/null || echo not')
 uname_V := $(shell sh -c 'uname -v 2>/dev/null || echo not')
+uname_D := $(shell sh -c "lsb_release -a 2>/dev/null | awk '/ID/ { print \$$3 }'")
 
 # CFLAGS and LDFLAGS are for the users to override from the command line.
 
@@ -475,6 +476,14 @@ ifeq ($(uname_S),Darwin)
 	PTHREAD_LIBS =
 endif
 
+ifeq ($(uname_D),Debian)
+	LIBDWARF_PREFIX =
+	BASIC_CFLAGS += -DDEBIAN
+else
+	LIBDWARF_PREFIX = libdwarf/
+endif
+
+
 ifeq ($(shell sh -c "(echo '\#include <libelf.h>'; echo 'int main(void) { Elf * elf = elf_begin(0, ELF_C_READ, 0); return (long)elf; }') | $(CC) -x c - $(ALL_CFLAGS) -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -o /dev/null $(ALL_LDFLAGS) $(EXTLIBS) "$(QUIET_STDERR)" && echo y"), y)
 ifneq ($(shell sh -c "(echo '\#include <gnu/libc-version.h>'; echo 'int main(void) { const char * version = gnu_get_libc_version(); return (long)version; }') | $(CC) -x c - $(ALL_CFLAGS) -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -o /dev/null $(ALL_LDFLAGS) $(EXTLIBS) "$(QUIET_STDERR)" && echo y"), y)
 	msg := $(error No gnu/libc-version.h found, please install glibc-dev[el]/glibc-static);
@@ -487,7 +496,7 @@ else
 	msg := $(error No libelf.h/libelf found, please install libelf-dev/elfutils-libelf-devel and glibc-dev[el]);
 endif
 
-ifneq ($(shell sh -c "(echo '\#include <libdwarf/dwarf.h>'; echo '\#include <libdwarf/libdwarf.h>'; echo 'int main(void) { Dwarf_Debug dbg; Dwarf_Error err; Dwarf_Ranges *rng; dwarf_init(0, DW_DLC_READ, 0, 0, &dbg, &err); dwarf_get_ranges(dbg, 0, &rng, 0, 0, &err); return (long)dbg; }') | $(CC) -x c - $(ALL_CFLAGS) -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -ldwarf -lelf -o /dev/null $(ALL_LDFLAGS) $(EXTLIBS) "$(QUIET_STDERR)" && echo y"), y)
+ifneq ($(shell sh -c "(echo '\#include <$(LIBDWARF_PREFIX)dwarf.h>'; echo '\#include <$(LIBDWARF_PREFIX)libdwarf.h>'; echo 'int main(void) { Dwarf_Debug dbg; Dwarf_Error err; Dwarf_Ranges *rng; dwarf_init(0, DW_DLC_READ, 0, 0, &dbg, &err); dwarf_get_ranges(dbg, 0, &rng, 0, 0, &err); return (long)dbg; }') | $(CC) -x c - $(ALL_CFLAGS) -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -ldwarf -lelf -o /dev/null $(ALL_LDFLAGS) $(EXTLIBS) "$(QUIET_STDERR)" && echo y"), y)
 	msg := $(warning No libdwarf.h found or old libdwarf.h found, disables dwarf support. Please install libdwarf-dev/libdwarf-devel >= 20081231);
 	BASIC_CFLAGS += -DNO_LIBDWARF
 else
diff --git a/tools/perf/util/probe-finder.h b/tools/perf/util/probe-finder.h
index bdebca6..3be22f1 100644
--- a/tools/perf/util/probe-finder.h
+++ b/tools/perf/util/probe-finder.h
@@ -32,8 +32,13 @@ struct probe_point {
 #ifndef NO_LIBDWARF
 extern int find_probepoint(int fd, struct probe_point *pp);
 
+#ifndef DEBIAN
 #include <libdwarf/dwarf.h>
 #include <libdwarf/libdwarf.h>
+#else
+#include <dwarf.h>
+#include <libdwarf.h>
+#endif
 
 struct probe_finder {
 	struct probe_point	*pp;	/* Target probe point */


-- 
Regards/Gruss,
Boris.

Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Andrew Bowd, Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632

