Return-Path: <linux-kernel-owner+w=401wt.eu-S1756940AbYBJIWO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756940AbYBJIWO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 03:22:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754337AbYBJIWD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 03:22:03 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:53812 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752510AbYBJIWA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 03:22:00 -0500
Date: Sun, 10 Feb 2008 09:21:32 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@zip.com.au>, Thomas Gleixner <tglx@linutronix.de>,
       Jason Wessel <jason.wessel@windriver.com>
Subject: Re: [3/6] kgdb: core
Message-ID: <20080210082132.GA9878@elte.hu>
References: <20080210071331.GC3851@elte.hu> <20080210073542.GB26666@infradead.org> <20080210074352.GA7188@elte.hu> <20080210075732.GA9349@infradead.org> <20080210080225.GC7188@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080210080225.GC7188@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> > It's all in the thread starting with '[PATCH 0/8] kgdb 2.6.25 
> > version', msgid 
> > 1202564114-18587-1-git-send-email-jason.wessel@windriver.com or at 
> > http://lkml.org/lkml/2008/2/9/104
> 
> thanks - i found Sam's mail meanwhile and addressed most of the 
> observations and updated the kgdb.git tree. I'll now check the threads 
> above whether i missed anything. (feel free to point it out if you 
> notice anything outright) As the changes have been janitorial only i 
> refrain from reposting the series once again. The latest shortlog is 
> below.

i've read all that thread now and i think all your observations are 
addressed in the latest tree i posted. In fact, most of the 
non-syntactic observations you made i already addressed in my series 
from yesterday. Find the latest tree at:

   git://git.kernel.org/pub/scm/linux/kernel/git/mingo/linux-2.6-kgdb.git

with tip commit 8fbf71f7636bd26843de01b4bdf819c9a9777427. Shortlog and 
diffstat below. I backmerged all the fixlets into their original 
commits, to keep the splitup clean.

Here are my replies to your feedback:

 Date: Sat, 9 Feb 2008 12:10:26 -0500
 From: Christoph Hellwig <hch@infradead.org>
 To: jason.wessel@windriver.com
 Subject: Re: [PATCH 2/8] pid, kgdb: add pid_max prototype

addressed.

 Date: Sat, 9 Feb 2008 12:15:03 -0500
 From: Christoph Hellwig <hch@infradead.org>
 Subject: Re: [PATCH 3/8] kgdb, modules: Always allow module sect info for

addressed: this was mooted by my original posting from yesterday 
already - i removed this complication.

 Date: Sat, 9 Feb 2008 12:16:05 -0500
 From: Christoph Hellwig <hch@infradead.org>
 Subject: Re: [PATCH 4/8] kgdb: COPTIMIZE flag

addressed: this was mooted by my original posting from yesterday 
already - i removed this complication.

> > + * include/asm-generic/kgdb.h
> 
> Please don't mention the file name in the top-of-file comments.  This 
> information is redundant and will easily get out of date when moving 
> files around or copying them.  Note that this applies to basically any 
> file in this patch.

fixed.

> > +#ifdef CONFIG_X86
> > +/**
> > + *	kgdb_skipexception - Bail of of KGDB when we've been triggered.
> 
> arch ifdefs don't belong into an asm-generic/ file.  Please have a
> proper asm-x86/kgdb.h that defines these things.

addressed: this was fixed in my submission yesterday.

> Kerneldoc comments don't belong above the prototype of a function but 
> the function body.

disagree - the best is to have it in both places - and in many places we 
do that. Anyway, this is up to maintainer discretion.

> > +#ifdef CONFIG_KGDB_ARCH_HAS_SHADOW_INFO
> > +/**
> > + *	kgdb_shadowinfo - Get shadowed information on @threadid.
> > + *	@regs: The &struct pt_regs of the current process.
> > + *	@buffer: A buffer of %BUFMAX size.
> > + *	@threadid: The thread id of the shadowed process to get information on.
> > + */
> > +extern void kgdb_shadowinfo(struct pt_regs *regs, char *buffer,
> > +			    unsigned threadid);
> 
> I don't really thing this belongs into an asm-generic header, again. 
> ARchitectures having shadow info should just provide this in their own 
> asm-foo/kgdb.h.  Or better yet just kill it for the first submission.

disagree. Many architectures will select shadow-info support so having 
this in asm-generic/kgdb.h is straightforward. I am actually an 
architecture who had to deal with this stuff in 32-bit (no shadow info 
support) and 64-bit (shadow info support) and this was handy and 
obvious. (But note that the patch submitted by Jason had a few 
uglinesses in this area that i fixed so please re-check the ones in my 
tree.)

> > +struct debuggerinfo_struct {
> > +	void			*debuggerinfo;
> > +	struct task_struct	*task;
> > +} kgdb_info[NR_CPUS];
> 
> shouldn't this use per-cpu data?  Or is that in some way to fragile 
> for a debugger?

yes, eventually we might want to use kgdb earlier than the per CPU areas 
are set up.

> > +/* reboot notifier block */
> > +static struct notifier_block kgdb_reboot_notifier = {
> > +	.notifier_call		= kgdb_notify_reboot,
> > +	.next			= NULL,
> > +	.priority		= INT_MAX,
> > +};
> 
> No need to initialize fields to 0 or NULL in static variables.

agreed, fixed.

> > +	if ((ch >= 'a') && (ch <= 'f'))
> > +		return ch - 'a' + 10;
> > +	if ((ch >= '0') && (ch <= '9'))
> > +		return ch - '0';
> > +	if ((ch >= 'A') && (ch <= 'F'))
> > +		return ch - 'A' + 10;
> 
> lots of superflous braces.  More of them later in this file in the 
> same style.

maintainer discretion item. I prefer having such clarity in operator 
ordering.

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
> 
> This is really ugly, but I don't really know a good way around it
> either.

yeah. Agreed about the ugliness and i volunteer to implement any 
sensible suggestions later on :-)

> > +	if (arch_kgdb_ops.shadowth &&
> > +			ks->kgdb_usethreadid >= pid_max + num_online_cpus()) {
> 
> 	if (arch_kgdb_ops.shadowth &&
> 	    ks->kgdb_usethreadid >= pid_max + num_online_cpus()) {
> 
> similar odd indentation in a few other spots.

check out the full context, not just the patch. It's often done for a 
reason to make the full visual appearance of that particular code nice.

> > +menuconfig KGDB
> > +	bool "KGDB: kernel debugging with remote gdb"
> > +	select KGDB_ARCH_HAS_SHADOW_INFO if X86_64
> 
> Why can't this be set in the X86_64 config?

addressed: it is in my series.

> > +	select DEBUG_INFO
> > +	select FRAME_POINTER
> 
> I think these two would be better as depends on

selecting FRAME_POINTER is totally sensible and other debugging code 
does it too. I agree about the DEBUG_INFO and it was addressed in 
yesterday's series already.

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
 include/asm-generic/kgdb.h          |   91 ++
 include/asm-x86/kgdb.h              |   87 ++
 include/linux/kgdb.h                |  264 +++++
 include/linux/pid.h                 |    2 +
 include/linux/serial_core.h         |    4 +
 include/linux/tty_driver.h          |   12 +
 include/linux/uaccess.h             |   22 +
 kernel/Makefile                     |    1 +
 kernel/kgdb.c                       | 2019 +++++++++++++++++++++++++++++++++++
 kernel/sysctl.c                     |    2 +-
 lib/Kconfig.debug                   |    2 +
 lib/Kconfig.kgdb                    |   37 +
 22 files changed, 3445 insertions(+), 2 deletions(-)
 create mode 100644 arch/x86/kernel/kgdb.c
 create mode 100644 drivers/serial/kgdboc.c
 create mode 100644 include/asm-generic/kgdb.h
 create mode 100644 include/asm-x86/kgdb.h
 create mode 100644 include/linux/kgdb.h
 create mode 100644 kernel/kgdb.c
 create mode 100644 lib/Kconfig.kgdb

