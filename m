Return-Path: <linux-kernel-owner+w=401wt.eu-S1761745AbYBEWDc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761745AbYBEWDc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 17:03:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759086AbYBEWDZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 17:03:25 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:38898 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758520AbYBEWDY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 17:03:24 -0500
Date: Tue, 5 Feb 2008 23:03:42 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Ingo Molnar <mingo@elte.hu>
Cc: Arjan van de Ven <arjan@infradead.org>, Hugh Dickins <hugh@veritas.com>,
       Jiri Kosina <jkosina@suse.cz>,
       kernel list <linux-kernel@vger.kernel.org>,
       Abel Bernabeu <abel.bernabeu@gmail.com>
Subject: Re: brk randomization breaks columns
Message-ID: <20080205220342.GB1630@elf.ucw.cz>
References: <20080204122837.GA1647@elf.ucw.cz> <Pine.LNX.4.64.0802050242440.30873@twin.jikos.cz> <Pine.LNX.4.64.0802051243240.542@blonde.site> <20080205070001.7bc8058f@laptopd505.fenrus.org> <20080205154648.GA24331@elf.ucw.cz> <20080205154953.GA26829@elte.hu> <20080205155959.GC24331@elf.ucw.cz> <20080205160620.GA28812@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080205160620.GA28812@elte.hu>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > . Yes, setarch i386 -R /usr/local/bin/uemacs (etc) fixes them, too.
> > 	
> > What about this?
> > 
> > Heap randomization breaks /lib/libc.so.5.4.33, make it possible to 
> > randomize normal stuff but leave the heap alone.
> 
> certainly looks fine to me, but please also add a .config to make it 
> default to 2. The reason is that a good portions of the overflows happen 
> on the heap and 99.9% of the Linux users do not run 1996-era glibc 
> anymore.
> 
> something like CONFIG_COMPAT_BRK=y, which would cause randomize_va_space 
> to default to 1, and if a user or distro disables it, it will default to 
> 2.

I named it slightly differently, but idea is same. Heap randomization
breaks ancient binaries, so disable it by default.

Signed-off-by: Pavel Machek <pavel@suse.cz>

diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index 18ed6dd..4b099ea 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -1077,7 +1077,7 @@ #endif /* ARCH_HAS_SETUP_ADDITIONAL_PAGE
 	current->mm->start_stack = bprm->p;
 
 #ifdef arch_randomize_brk
-	if (current->flags & PF_RANDOMIZE)
+	if ((current->flags & PF_RANDOMIZE) && (randomize_va_space > 1))
 		current->mm->brk = current->mm->start_brk =
 			arch_randomize_brk(current->mm);
 #endif
diff --git a/init/Kconfig b/init/Kconfig
index dcc96a8..37c7852 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -541,6 +541,16 @@ config ELF_CORE
 	help
 	  Enable support for generating core dumps. Disabling saves about 4k.
 
+config RANDOMIZE_HEAP
+	bool "Randomize heap placement"
+	help
+	  Randomizing heap placement makes heap exploits harder, but it also
+	  breaks old programs (including anything libc5 based). This only
+	  changes default, and can be overriden in runtime by tweaking
+	  /proc/sys/kernel/randomize_va_space.
+
+	  N is safe choice here.	  
+
 config BASE_FULL
 	default y
 	bool "Enable full-sized data structures for core" if EMBEDDED
diff --git a/mm/memory.c b/mm/memory.c
index 4706af1..5134014 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -82,7 +82,12 @@ void * high_memory;
 EXPORT_SYMBOL(num_physpages);
 EXPORT_SYMBOL(high_memory);
 
-int randomize_va_space __read_mostly = 1;
+int randomize_va_space __read_mostly = 
+#ifdef CONFIG_RANDOMIZE_HEAP
+					2;
+#else
+					1;
+#endif
 
 static int __init disable_randmaps(char *s)
 {


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
