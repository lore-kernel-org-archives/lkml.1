Return-Path: <linux-kernel-owner+w=401wt.eu-S1754029AbZESSXc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754029AbZESSXc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 14:23:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753484AbZESSXY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 14:23:24 -0400
Received: from mail.windriver.com ([147.11.1.11]:60388 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751266AbZESSXY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 14:23:24 -0400
Message-ID: <4A12F8FF.2050108@windriver.com>
Date: Tue, 19 May 2009 13:22:55 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH 01/13] RFC ONLY - kdb: core for kgdb back end
References: <1241817800-9320-1-git-send-email-jason.wessel@windriver.com> <1241817800-9320-2-git-send-email-jason.wessel@windriver.com> <20090509040942.GB8007@elte.hu>
In-Reply-To: <20090509040942.GB8007@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 19 May 2009 18:22:50.0206 (UTC) FILETIME=[D12CE7E0:01C9D8AE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> Just a first quick 30-seconds impression from skimming through the
> patch:
>
>  - The cleanups are an absolute must before doing any in-depth
>    review. We only want to waste valuable review bandwidth on code
>    that at least _looks_ nice and tidy.
>

I think in depth review is still a bit off.  The intent of the RFC was
to gauge interest in the project of unifying the kernel debug tools.

>  - Many functions are way too large, with many indentation levels -
>    they need a split-up.

Sure.  I cleaned up one or two places just to kdb look a little more
friendly, but there is a lot more slicing/dicing/refactoring that
needs to occur.  This initial work was nothing more than a rapid
"throw away prototype".  In terms of iterations, we should decide what
the directory structure an naming conversion should look like (more
below).

>
> bits like:
> +        // HACK HACK HACK
> +        printk(KERN_CRIT "DOH NEED TO IMPLEMENT THIS!");
>
> need fixed.
>

The next version has all those type comments cleaned up correctly and
in most cases the function is now implemented.

> Locking needs reviewed and fixed:

Agreed, and that will happen in a future iteration.  The APIs,
directory structure, and glue need some work first.

>
> Plus, if _any_ debugger front-end is considered for merging, it
> _must_ work with Kernel Mode Setting properly, out of X. No ifs
> and when.

This is in the "road map".  I view kernel mode setting for opening a
debugger on the console to be extremely important, but it should not
gate an initial merge of a debugger front end.  The serial and text
console alone are quite useful as interactive debug consoles.

I talked to Jesse Barnes about the state of the kernel mode setting
code as well as doing some investigation of how the mode switching API
worked.  In the first pass, the emergency escape back to the console
via kernel mode switching was completely broken. Jesse gave me patch
to fix this problem in order to complete the investigation.  While the
emergency escape to the console now works, it is not a solution that
would work for a generic kernel debugger.

The key problem today for kernel mode setting is that there is no API
to allow you to atomically change and restore the console during the
time you are in the exception context but before you return.  The
current console switching uses a separate kernel thread and all sorts
of locks to manage display device.  This is not an unsolvable problem,
but it will require some special API to be created for use in the
exception context.

On the bright side, the hook points exist in the debug framework to
make use of the kernel mode setting once the console layer implents
some kind of atomic kernel mode setting API.

>
> Also, high-level file organization: i'd suggest to move it all under
> the kernel/debug/ hierarchy, and move kernel/kgdb.c to
> kernel/debug/backend/core.c or so [possibly split up a bit, it's
> getting quite large] and the KDB bits under kernel/debug/frontend/.
> We dont want multiple back-ends nor multiple front-ends. We want one
> good back-end and one good (built-in) front-end.
>

Do we really want that many directories?  There is also the question
about changing some of the function names used by kgdb today.  I
believe we should come to an agreement on this first, and stage all
future work on top of that.  This also needs to include the naming
structure for the headers.

Here is an initial proposal, which I prototyped just to see what it
might look like.  I used the kernel/debug directory as the home to the
generic kernel debug code.

The present kernel/kgdb.c breaks down into:

kernel/debug/debug_core.c - ~829 lines
   * Contains the generic cpu exception handling
   * Breakpoint handling
   * Memory access
   * If the break point code grows to much we split it later

kernel/debug/gdbstub.c - ~902 lines
   * This is all the logic to implement the state machine that
     speaks gdb serial

kernel/debug/Makefile

kernel/debug/debug_core.h - ~35 lines
   * This is a private include file for use between the
     gdbstub and any future frontend because no other
     files outside this directory should use these API calls/
   * There is a cut and past of this below.


Some of what we call "kgdb" needs to get a new name because some of
the API is required for the gdbstub or for anything else that might
use it.  Presently there is gdb serial oriented "stuff" in some of the
arch specific kgdb code.  In the new scheme we need a clean way to
eliminate it.  In theory, when done you could go so far as to compile
the debugger frontend or the gdbstub.

Right now kgdb also has a number of I/O modules. They all start with
kgdbXXXX, but it is the case that none of these have any knowledge of
the interworking of the debugger.  The I/O modules merely provide low
level get and put character interfaces.  So the question is if these
should be renamed (ie kgdboc, kgdboe, kgdbts) to something like:

   dbgoc - Debugger over console
   dbgoe - Debugger over ethernet
   gdbts - gdb stub test suite

The include/linux/kgdb.h would move to include/linux/debugger.h.  The
debugger.h would then contain the pieces that any other part of the
kernel need in order to hook in, just like kgdb.h does today.  APIs
that are currently prefixed with kgdb_ would get moved to dbg_ or
gdbstub_ depending on the true purpose of the API.

Does this sound reasonable?

If so I will post a patch series that contains the split and post a
new kdb patch series at a later point.

The kdb code would go in:
kernel/debug/kdbmain.c
kernel/debug/kdbsupport.c
kernel/debug/kdb_io.c
... etc ...


Jason.




--- debug_core.h ---
/* kernel debug core data structures */
struct kgdb_state {
    int            ex_vector;
    int            signo;
    int            err_code;
    int            cpu;
    int            pass_exception;
    unsigned long        thr_query;
    unsigned long        threadid;
    long            kgdb_usethreadid;
    struct pt_regs        *linux_regs;
};

struct debuggerinfo_struct {
    void            *debuggerinfo;
    struct task_struct    *task;
};

extern struct debuggerinfo_struct kgdb_info[];
extern struct kgdb_io *dbg_io_ops;

/* kernel debug core break point routines */
extern int dbg_remove_all_break(void);
extern int dbg_set_sw_break(unsigned long addr);
extern int dbg_remove_sw_break(unsigned long addr);
extern int dbg_activate_sw_breakpoints(void);

/* gdbstub interface functions */
extern int gdb_serial_stub(struct kgdb_state *ks);
extern void gdbstub_msg_write(const char *s, int len);

