Return-Path: <linux-kernel-owner+w=401wt.eu-S1754158AbYBJI6M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754158AbYBJI6M (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 03:58:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750754AbYBJI57
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 03:57:59 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:58827 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750740AbYBJI56 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 03:57:58 -0500
Date: Sun, 10 Feb 2008 09:57:35 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@zip.com.au>, Thomas Gleixner <tglx@linutronix.de>,
       Jason Wessel <jason.wessel@windriver.com>
Subject: Re: [3/6] kgdb: core
Message-ID: <20080210085735.GA13466@elte.hu>
References: <20080210071331.GC3851@elte.hu> <20080210073542.GB26666@infradead.org> <20080210074352.GA7188@elte.hu> <20080210075732.GA9349@infradead.org> <20080210080225.GC7188@elte.hu> <20080210082408.GA10479@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080210082408.GA10479@infradead.org>
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


* Christoph Hellwig <hch@infradead.org> wrote:

> [...]  And while you're at it please remove all the filenames in the 
> top-of-file comments, not just in include/asm-generic/kgdb.h.

fixed: there was just one such file remaining: include/linux/kgdb.h.

> While we're at it is there a good reason to have that file at all, 
> it's just function prototypes, and I'd say for now they should just go 
> into linux/kgdb.h.  If there's a a good reason why architectures 
> should implement them as inlines we can move them back, but looking at 
> the x86 implementation I doubt that's the case.

agreed, done.

> On Sun, Feb 10, 2008 at 09:02:25AM +0100, Ingo Molnar wrote:
> > thanks - i found Sam's mail meanwhile and addressed most of the 
> > observations and updated the kgdb.git tree. I'll now check the threads 
> > above whether i missed anything. (feel free to point it out if you 
> > notice anything outright) As the changes have been janitorial only i 
> > refrain from reposting the series once again. The latest shortlog is 
> > below.
> 
> It would be nice if you could move the kerneldoc comments to the 
> proper place at least. [...]

i'd agree in general but this is really a special case, please look at 
the context. This would duplicate all the kerneldoc headers for all 
architectures. We'd have to move the same kerneldoc header to all 
architecture arch/*/kernel/kgdb.c files. It's much nicer in 
asm-generic/kgdb.h.

> Also it seems at least some of Jan's patches are missing aswell.

i dont think so. Which ones do you mean? I just reviewed them and they 
are either already done, or moot (for kgdb complications that i objected 
to and removed from this kgdb-x86 tree).

anyway, i've implemented all these (trivial) tweaks you just mentioned 
and re-tested on 32-bit and 64-bit x86, backmerged the fixes to their 
proper places, and pushed the clean series out again to:

   git://git.kernel.org/pub/scm/linux/kernel/git/mingo/linux-2.6-kgdb.git

tip e6ba396b65e2f08afb5d8924140b126427085203. Shortlog below.

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
 include/asm-x86/kgdb.h              |   85 ++
 include/linux/kgdb.h                |  333 ++++++
 include/linux/pid.h                 |    2 +
 include/linux/serial_core.h         |    4 +
 include/linux/tty_driver.h          |   12 +
 include/linux/uaccess.h             |   22 +
 kernel/Makefile                     |    1 +
 kernel/kgdb.c                       | 2019 +++++++++++++++++++++++++++++++++++
 kernel/sysctl.c                     |    2 +-
 lib/Kconfig.debug                   |    2 +
 lib/Kconfig.kgdb                    |   37 +
 22 files changed, 3512 insertions(+), 2 deletions(-)
 create mode 100644 arch/x86/kernel/kgdb.c
 create mode 100644 drivers/serial/kgdboc.c
 create mode 100644 include/asm-generic/kgdb.h
 create mode 100644 include/asm-x86/kgdb.h
 create mode 100644 include/linux/kgdb.h
 create mode 100644 kernel/kgdb.c
 create mode 100644 lib/Kconfig.kgdb
