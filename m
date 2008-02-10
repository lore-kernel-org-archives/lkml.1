Return-Path: <linux-kernel-owner+w=401wt.eu-S1758746AbYBJIAH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758746AbYBJIAH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 03:00:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758418AbYBJH7o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 02:59:44 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:38146 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758407AbYBJH7m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 02:59:42 -0500
Date: Sun, 10 Feb 2008 08:59:23 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@zip.com.au>, Thomas Gleixner <tglx@linutronix.de>,
       Jason Wessel <jason.wessel@windriver.com>
Subject: Re: [3/6] kgdb: core
Message-ID: <20080210075923.GB7188@elte.hu>
References: <20080210071331.GC3851@elte.hu> <20080210073153.GA9805@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080210073153.GA9805@uranus.ravnborg.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Sam Ravnborg <sam@ravnborg.org> wrote:

> I see that only a very few of my comments posted yesterday got 
> addressed. On purpose or did you miss them?

no, they went into another thread :-)

i've now read your mail and addressed the majority of them - see the 
details below.

i've trickled all these fixes back to keep a clean split, test-built and 
test-booted the result, and updated the kgdb.git tree, which can be 
pulled from:

   git://git.kernel.org/pub/scm/linux/kernel/git/mingo/linux-2.6-kgdb.git

updated shortlog further below. I've re-tested kgdb on x86 and it still 
works (as expected).

> > +struct debuggerinfo_struct {
> > +	void			*debuggerinfo;
> > +	struct task_struct	*task;
> > +} kgdb_info[NR_CPUS];
> static?

fixed.

> > +
> > +/* Is a host GDB connected to us? */
> > +int				kgdb_connected;
> > +EXPORT_SYMBOL_GPL(kgdb_connected);
> Drop additional spaces.
> Add kernel-doc comments explaining the usage.

if you look at the resulting kernel/kgdb.c not the patch itself then 
you'll see that this is consistent style that aligns this variable with 
other fields. I agree that it looks ugly in isolation in the quote 
above.

> > +/* All the KGDB handlers are installed */
> > +int				kgdb_io_module_registered;
> static? drop spaces.

static: fixed. Spaces: see above.

> > +/* Guard for recursive entry */
> > +static int			exception_level;
> drop spaces. In more places below - but they are obvious.

really, please look at the resulting kernel/kgdb.c file. It's visually 
consistent.

> > +struct kgdb_bkpt		kgdb_break[KGDB_MAX_BREAKPOINTS] = {
> > +	[0 ... KGDB_MAX_BREAKPOINTS-1] = { .state = BP_UNDEFINED }
> > +};
> static?

fixed.

> > +
> > +extern int pid_max;
> 
> extern must be moved to a .h file.

i did that in my series.

> > +atomic_t			kgdb_setting_breakpoint;
> static?

fixed.

> Many more variables are static candidates. I will not repeat it.

i think i fixed all of them.

> > +#ifdef __BIG_ENDIAN
> > +		*buf++ = hexchars[(tmp_s >> 12) & 0xf];
> > +		*buf++ = hexchars[(tmp_s >> 8) & 0xf];
> > +		*buf++ = hexchars[(tmp_s >> 4) & 0xf];
> > +		*buf++ = hexchars[tmp_s & 0xf];
> > +#else
> > +		*buf++ = hexchars[(tmp_s >> 4) & 0xf];
> > +		*buf++ = hexchars[tmp_s & 0xf];
> > +		*buf++ = hexchars[(tmp_s >> 12) & 0xf];
> > +		*buf++ = hexchars[(tmp_s >> 8) & 0xf];
> > +#endif
> small helper function?

this is already part of a small helper function. (kgdb_mem2hex())

> > +int kgdb_isremovedbreak(unsigned long addr)
> > +{
> > +	int i;
> > +
> > +	for (i = 0; i < KGDB_MAX_BREAKPOINTS; i++) {
> > +		if ((kgdb_break[i].state == BP_REMOVED) &&
> > +					(kgdb_break[i].bpt_addr == addr))
> > +			return 1;
> > +	}
> > +	return 0;
> > +}
> static?

no, needed by architectures.

> > +int remove_all_break(void)

> static?

no.

> > +int kgdb_io_ready(int print_wait)

> static?

yes, fixed.

> > +	bool "KGDB: kernel debugging with remote gdb"
> > +	select KGDB_ARCH_HAS_SHADOW_INFO if X86_64
> > +	select DEBUG_INFO
> > +	select FRAME_POINTER
> > +	depends on DEBUG_KERNEL && ADD_A_KGDB_ARCH
> 
> Replace ADD_A_...
> with
> HAVE_KGDB

fixed.

	Ingo

------------------>
Ingo Molnar (3):
      pids: add pid_max prototype
      uaccess: add probe_kernel_write()
      x86: kgdb support

Jan Kiszka (1):
      consoles: polling support, kgdboc

Jason Wessel (2):
      kgdb: core
      kgdb: document parameters

 Documentation/kernel-parameters.txt |    5 +
 arch/x86/Kconfig                    |    4 +
 arch/x86/kernel/Makefile            |    1 +
 arch/x86/kernel/kgdb.c              |  550 ++++++++++
 drivers/char/tty_io.c               |   47 +
 drivers/serial/8250.c               |   62 ++
 drivers/serial/Kconfig              |    3 +
 drivers/serial/Makefile             |    1 +
 drivers/serial/kgdboc.c             |  164 +++
 drivers/serial/serial_core.c        |   67 ++-
 include/asm-generic/kgdb.h          |   93 ++
 include/asm-x86/kgdb.h              |   87 ++
 include/linux/kgdb.h                |  264 +++++
 include/linux/pid.h                 |    2 +
 include/linux/serial_core.h         |    4 +
 include/linux/tty_driver.h          |   12 +
 include/linux/uaccess.h             |   22 +
 kernel/Makefile                     |    1 +
 kernel/kgdb.c                       | 2020 +++++++++++++++++++++++++++++++++++
 kernel/sysctl.c                     |    2 +-
 lib/Kconfig.debug                   |    2 +
 lib/Kconfig.kgdb                    |   37 +
 22 files changed, 3448 insertions(+), 2 deletions(-)
 create mode 100644 arch/x86/kernel/kgdb.c
 create mode 100644 drivers/serial/kgdboc.c
 create mode 100644 include/asm-generic/kgdb.h
 create mode 100644 include/asm-x86/kgdb.h
 create mode 100644 include/linux/kgdb.h
 create mode 100644 kernel/kgdb.c
 create mode 100644 lib/Kconfig.kgdb

