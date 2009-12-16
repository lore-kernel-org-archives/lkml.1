Return-Path: <linux-kernel-owner+w=401wt.eu-S1762312AbZLPWNX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762312AbZLPWNX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 17:13:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758084AbZLPWNV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 17:13:21 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:59862 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758069AbZLPWNT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 17:13:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=SacKKlN/6jp5tHKsERIK2Xo4xrWv7zf4YcyoUwpm8sW9jKygxhwRzvJNPKoXtBpfQR
         RELyP6Ces+j0D6dbQvH+o6iqSPBSNAE/8PB8XVMVVL7dzZMf/4mh3me90MJyFeTRhAAe
         nWTmGpwJlNuno5rrwhb5yluHdq0C1i3k64ELo=
Date: Wed, 16 Dec 2009 23:13:12 +0100
From: Borislav Petkov <petkovbb@googlemail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Masami Hiramatsu <mhiramat@redhat.com>,
       Borislav Petkov <borislav.petkov@amd.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: perf and libdwarf on debian
Message-ID: <20091216221312.GC27228@liondog.tnic>
Mail-Followup-To: Borislav Petkov <petkovbb@googlemail.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Masami Hiramatsu <mhiramat@redhat.com>,
	Borislav Petkov <borislav.petkov@amd.com>,
	Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
References: <20091216135448.GD11618@aftab>
 <1260988340.21028.198.camel@laptop>
 <4B292F69.3000608@redhat.com>
 <1260991155.21028.261.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1260991155.21028.261.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 16, 2009 at 08:19:15PM +0100, Peter Zijlstra wrote:
> Well, I'm not 100% sure -I/foo will actually work if foo doesn't exist,
> but I'd sure try it first since its less typing :-)

Yes, it does :) Here's a much simpler fix:

--
From: Borislav Petkov <petkovbb@gmail.com>
Date: Wed, 16 Dec 2009 23:07:10 +0100
Subject: [PATCH] perf: fix libdwarf include paths

even after installing libdwarf-dev on debian make in tools/perf/ still
complains that it cannot find libdwarf:

Makefile:491: No libdwarf.h found or old libdwarf.h found, disables dwarf support. Please install libdwarf-dev/libdwarf-devel >= 20081231

The problem is that the libdwarf headers on debian are not placed in
/usr/include/libdwarf/ but simply in /usr/include.

Fix by adding the non-standard path to BASIC_CFLAGS and truncating the
include directives.

Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 tools/perf/Makefile            |    4 ++--
 tools/perf/util/probe-finder.h |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 7814dbb..23ce10d 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -260,7 +260,7 @@ endif
 # Those must not be GNU-specific; they are shared with perl/ which may
 # be built by a different compiler. (Note that this is an artifact now
 # but it still might be nice to keep that distinction.)
-BASIC_CFLAGS = -Iutil/include
+BASIC_CFLAGS = -Iutil/include -I/usr/include/libdwarf
 BASIC_LDFLAGS =
 
 # Guard against environment variables
@@ -487,7 +487,7 @@ else
 	msg := $(error No libelf.h/libelf found, please install libelf-dev/elfutils-libelf-devel and glibc-dev[el]);
 endif
 
-ifneq ($(shell sh -c "(echo '\#include <libdwarf/dwarf.h>'; echo '\#include <libdwarf/libdwarf.h>'; echo 'int main(void) { Dwarf_Debug dbg; Dwarf_Error err; Dwarf_Ranges *rng; dwarf_init(0, DW_DLC_READ, 0, 0, &dbg, &err); dwarf_get_ranges(dbg, 0, &rng, 0, 0, &err); return (long)dbg; }') | $(CC) -x c - $(ALL_CFLAGS) -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -ldwarf -lelf -o /dev/null $(ALL_LDFLAGS) $(EXTLIBS) "$(QUIET_STDERR)" && echo y"), y)
+ifneq ($(shell sh -c "(echo '\#include <dwarf.h>'; echo '\#include <libdwarf.h>'; echo 'int main(void) { Dwarf_Debug dbg; Dwarf_Error err; Dwarf_Ranges *rng; dwarf_init(0, DW_DLC_READ, 0, 0, &dbg, &err); dwarf_get_ranges(dbg, 0, &rng, 0, 0, &err); return (long)dbg; }') | $(CC) -x c - $(ALL_CFLAGS) -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -ldwarf -lelf -o /dev/null $(ALL_LDFLAGS) $(EXTLIBS) "$(QUIET_STDERR)" && echo y"), y)
 	msg := $(warning No libdwarf.h found or old libdwarf.h found, disables dwarf support. Please install libdwarf-dev/libdwarf-devel >= 20081231);
 	BASIC_CFLAGS += -DNO_LIBDWARF
 else
diff --git a/tools/perf/util/probe-finder.h b/tools/perf/util/probe-finder.h
index 5e4050c..adf7949 100644
--- a/tools/perf/util/probe-finder.h
+++ b/tools/perf/util/probe-finder.h
@@ -35,8 +35,8 @@ struct probe_point {
 #ifndef NO_LIBDWARF
 extern int find_probepoint(int fd, struct probe_point *pp);
 
-#include <libdwarf/dwarf.h>
-#include <libdwarf/libdwarf.h>
+#include <dwarf.h>
+#include <libdwarf.h>
 
 struct probe_finder {
 	struct probe_point	*pp;	/* Target probe point */
-- 
1.6.5


-- 
Regards/Gruss,
    Boris.
