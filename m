Return-Path: <linux-kernel-owner+w=401wt.eu-S964804AbZLPW32@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964804AbZLPW32 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 17:29:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935429AbZLPW3V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 17:29:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46754 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935401AbZLPW3S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 17:29:18 -0500
Message-ID: <4B295F2E.3060208@redhat.com>
Date: Wed, 16 Dec 2009 17:29:02 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Borislav Petkov <petkovbb@googlemail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Borislav Petkov <borislav.petkov@amd.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: perf and libdwarf on debian
References: <20091216135448.GD11618@aftab> <1260988340.21028.198.camel@laptop> <4B292F69.3000608@redhat.com> <1260991155.21028.261.camel@laptop> <20091216221312.GC27228@liondog.tnic>
In-Reply-To: <20091216221312.GC27228@liondog.tnic>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Borislav Petkov wrote:
> On Wed, Dec 16, 2009 at 08:19:15PM +0100, Peter Zijlstra wrote:
>> Well, I'm not 100% sure -I/foo will actually work if foo doesn't exist,
>> but I'd sure try it first since its less typing :-)
> 
> Yes, it does :) Here's a much simpler fix:

Oops, I also posted another version X(

Actually, from unknown reason, #include <libdwarf.h>
causes "_MIPS_SZLONG is not defined" error on my
Fedora11 (curiously, even #include <libdwarf/libdwarf.h>
didn't cause the bug!).
So I added a workaround for the bug on my patch.

Anyway, Thank you very much for reporting the bug and making a fix!!

> 
> --
> From: Borislav Petkov <petkovbb@gmail.com>
> Date: Wed, 16 Dec 2009 23:07:10 +0100
> Subject: [PATCH] perf: fix libdwarf include paths
> 
> even after installing libdwarf-dev on debian make in tools/perf/ still
> complains that it cannot find libdwarf:
> 
> Makefile:491: No libdwarf.h found or old libdwarf.h found, disables dwarf support. Please install libdwarf-dev/libdwarf-devel >= 20081231
> 
> The problem is that the libdwarf headers on debian are not placed in
> /usr/include/libdwarf/ but simply in /usr/include.
> 
> Fix by adding the non-standard path to BASIC_CFLAGS and truncating the
> include directives.
> 
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Masami Hiramatsu <mhiramat@redhat.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
> ---
>  tools/perf/Makefile            |    4 ++--
>  tools/perf/util/probe-finder.h |    4 ++--
>  2 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/tools/perf/Makefile b/tools/perf/Makefile
> index 7814dbb..23ce10d 100644
> --- a/tools/perf/Makefile
> +++ b/tools/perf/Makefile
> @@ -260,7 +260,7 @@ endif
>  # Those must not be GNU-specific; they are shared with perl/ which may
>  # be built by a different compiler. (Note that this is an artifact now
>  # but it still might be nice to keep that distinction.)
> -BASIC_CFLAGS = -Iutil/include
> +BASIC_CFLAGS = -Iutil/include -I/usr/include/libdwarf
>  BASIC_LDFLAGS =
>  
>  # Guard against environment variables
> @@ -487,7 +487,7 @@ else
>  	msg := $(error No libelf.h/libelf found, please install libelf-dev/elfutils-libelf-devel and glibc-dev[el]);
>  endif
>  
> -ifneq ($(shell sh -c "(echo '\#include <libdwarf/dwarf.h>'; echo '\#include <libdwarf/libdwarf.h>'; echo 'int main(void) { Dwarf_Debug dbg; Dwarf_Error err; Dwarf_Ranges *rng; dwarf_init(0, DW_DLC_READ, 0, 0, &dbg, &err); dwarf_get_ranges(dbg, 0, &rng, 0, 0, &err); return (long)dbg; }') | $(CC) -x c - $(ALL_CFLAGS) -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -ldwarf -lelf -o /dev/null $(ALL_LDFLAGS) $(EXTLIBS) "$(QUIET_STDERR)" && echo y"), y)
> +ifneq ($(shell sh -c "(echo '\#include <dwarf.h>'; echo '\#include <libdwarf.h>'; echo 'int main(void) { Dwarf_Debug dbg; Dwarf_Error err; Dwarf_Ranges *rng; dwarf_init(0, DW_DLC_READ, 0, 0, &dbg, &err); dwarf_get_ranges(dbg, 0, &rng, 0, 0, &err); return (long)dbg; }') | $(CC) -x c - $(ALL_CFLAGS) -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -ldwarf -lelf -o /dev/null $(ALL_LDFLAGS) $(EXTLIBS) "$(QUIET_STDERR)" && echo y"), y)
>  	msg := $(warning No libdwarf.h found or old libdwarf.h found, disables dwarf support. Please install libdwarf-dev/libdwarf-devel >= 20081231);
>  	BASIC_CFLAGS += -DNO_LIBDWARF
>  else
> diff --git a/tools/perf/util/probe-finder.h b/tools/perf/util/probe-finder.h
> index 5e4050c..adf7949 100644
> --- a/tools/perf/util/probe-finder.h
> +++ b/tools/perf/util/probe-finder.h
> @@ -35,8 +35,8 @@ struct probe_point {
>  #ifndef NO_LIBDWARF
>  extern int find_probepoint(int fd, struct probe_point *pp);
>  
> -#include <libdwarf/dwarf.h>
> -#include <libdwarf/libdwarf.h>
> +#include <dwarf.h>
> +#include <libdwarf.h>
>  
>  struct probe_finder {
>  	struct probe_point	*pp;	/* Target probe point */

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

