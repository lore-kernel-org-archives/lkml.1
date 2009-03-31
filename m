Return-Path: <linux-kernel-owner+w=401wt.eu-S1760393AbZCaCrV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760393AbZCaCrV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 22:47:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755037AbZCaCrJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 22:47:09 -0400
Received: from ozlabs.org ([203.10.76.45]:41538 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754706AbZCaCrH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 22:47:07 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Jiri Kosina <jkosina@suse.cz>
Subject: [PULL] module and parameter patches (minus a couple of conflicting changes)
Date: Tue, 31 Mar 2009 13:16:56 +1030
User-Agent: KMail/1.11.1 (Linux/2.6.27-11-generic; KDE/4.2.1; i686; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org,
       =?iso-8859-1?q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>,
       Anders Kaseorg <andersk@mit.edu>,
       Arjan van de Ven <arjan@linux.intel.com>, Tim Abbott <tabbott@mit.edu>,
       Russell King <rmk@arm.linux.org.uk>
References: <200903302203.31097.rusty@rustcorp.com.au> <alpine.LRH.2.00.0903302204100.8561@twin.jikos.cz>
In-Reply-To: <alpine.LRH.2.00.0903302204100.8561@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200903311316.56562.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 15f7176eb1cccec0a332541285ee752b935c1c85:             
  Linus Torvalds (1):                                                                    
        Merge git://git.kernel.org/.../davem/net-2.6                                     

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/rusty/linux-2.6-module-and-param.git master

Américo Wang (1):
      kernel/module.c: fix an unused goto label

Anders Kaseorg (1):
      Ksplice: Add functions for walking kallsyms symbols

Arjan van de Ven (1):
      module: create a request_module_nowait()

Rusty Russell (10):
      param: fix charp parameters set via sysfs
      module: __module_address                 
      module: remove module_text_address()     
      module: clarify the force-loading taint message.
      module: remove the SHF_ALLOC flag on the __versions section.
      module: include other structures in module version check
      module: don't use stop_machine on module load
      arm: allow usage of string functions in linux/string.h
      strstarts: helper function for !strncmp(str, prefix, strlen(prefix))
      module: use strstarts()

Tim Abbott (2):
      module: Make find_symbol return a struct kernel_symbol
      module: Export symbols needed for Ksplice

 arch/arm/boot/compressed/misc.c |    5 +-
 drivers/mtd/nand/nand_base.c    |    4 +-
 include/linux/kallsyms.h        |   15 ++
 include/linux/kmod.h            |   11 +-
 include/linux/module.h          |   63 ++++++++-
 include/linux/moduleparam.h     |   10 ++
 include/linux/string.h          |    9 ++
 kernel/extable.c                |    6 +-
 kernel/kallsyms.c               |   19 +++
 kernel/kmod.c                   |   10 +-
 kernel/module.c                 |  274 +++++++++++++++++++++++----------------
 kernel/params.c                 |   26 ++++-
 scripts/mod/modpost.c           |    4 +-
 13 files changed, 319 insertions(+), 137 deletions(-)

commit e180a6b7759a99a28cbcce3547c4c80822cb6c2a
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Tue Mar 31 13:05:29 2009 -0600

    param: fix charp parameters set via sysfs
    
    Impact: fix crash on reading from /sys/module/.../ieee80211_default_rc_algo
    
    The module_param type "charp" simply sets a char * pointer in the
    module to the parameter in the commandline string: this is why we keep
    the (mangled) module command line around.  But when set via sysfs (as
    about 11 charp parameters can be) this memory is freed on the way
    out of the write().  Future reads hit random mem.
    
    So we kstrdup instead: we have to check we're not in early commandline
    parsing, and we have to note when we've used it so we can reliably
    kfree the parameter when it's next overwritten, and also on module
    unload.
    
    (Thanks to Randy Dunlap for CONFIG_SYSFS=n fixes)
    
    Reported-by: Sitsofe Wheeler <sitsofe@yahoo.com>
    Diagnosed-by: Frederic Weisbecker <fweisbec@gmail.com>
    Tested-by: Frederic Weisbecker <fweisbec@gmail.com>
    Tested-by: Christof Schmitt <christof.schmitt@de.ibm.com>
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

 include/linux/module.h      |    4 ++++
 include/linux/moduleparam.h |   10 ++++++++++
 kernel/module.c             |   14 ++++++++------
 kernel/params.c             |   26 +++++++++++++++++++++++++-
 4 files changed, 47 insertions(+), 7 deletions(-)

commit b10153fe31dde3805f8320b61ef147cebe379aee
Author: Américo Wang <xiyou.wangcong@gmail.com>
Date:   Wed Mar 25 00:07:19 2009 +0800

    kernel/module.c: fix an unused goto label
    
    Impact: cleanup
    
    Label 'free_init' is only used when defined(CONFIG_MODULE_UNLOAD) &&
    defined(CONFIG_SMP), so move it inside to shut up gcc.
    
    Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
    Cc: Rusty Russell <rusty@rustcorp.com.au>
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

 kernel/module.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

commit 414fd31b2553aaf160ca9b9afe45aa0372b01b92
Author: Tim Abbott <tabbott@mit.edu>
Date:   Fri Dec 5 19:03:56 2008 -0500

    module: Make find_symbol return a struct kernel_symbol
    
    Impact: Cleanup, internal API change
    
    Ksplice needs access to the kernel_symbol structure in order to support
    modifications to the exported symbol table.
    
    Cc: Anders Kaseorg <andersk@mit.edu>
    Cc: Jeff Arnold <jbarnold@mit.edu>
    Signed-off-by: Tim Abbott <tabbott@mit.edu>
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au> (bugfix and style)

 kernel/module.c |   75 +++++++++++++++++++++++++++----------------------------
 1 files changed, 37 insertions(+), 38 deletions(-)

commit e610499e2656e61975affd0af56b26eb73964c84
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Tue Mar 31 13:05:31 2009 -0600

    module: __module_address
    
    Impact: New API, cleanup
    
    ksplice wants to know the bounds of a module, not just the module text.
    
    It makes sense to have __module_address.  We then implement
    is_module_address and __module_text_address in terms of this (and
    change is_module_text_address() to bool while we're at it).
    
    Also, add proper kerneldoc for them all.
    
    Cc: Anders Kaseorg <andersk@mit.edu>
    Cc: Jeff Arnold <jbarnold@mit.edu>
    Cc: Tim Abbott <tabbott@mit.edu>
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

 include/linux/module.h |   20 +++++++++---
 kernel/module.c        |   76 ++++++++++++++++++++++++++++++++++++-----------
 2 files changed, 73 insertions(+), 23 deletions(-)

commit a6e6abd575fcbe6572ebc7a70ad616406d206fa8
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Tue Mar 31 13:05:31 2009 -0600

    module: remove module_text_address()
    
    Impact: Replace and remove risky (non-EXPORTed) API
    
    module_text_address() returns a pointer to the module, which given locking
    improvements in module.c, is useless except to test for NULL:
    
    1) If the module can't go away, use __module_text_address.
    2) Otherwise, just use is_module_text_address().
    
    Cc: linux-mtd@lists.infradead.org
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

 drivers/mtd/nand/nand_base.c |    4 ++--
 include/linux/module.h       |    7 -------
 kernel/extable.c             |    6 +++---
 kernel/module.c              |   17 ++++-------------
 4 files changed, 9 insertions(+), 25 deletions(-)

commit 75a66614db21007bcc8c37f9c5d5b922981387b9
Author: Anders Kaseorg <andersk@mit.edu>
Date:   Fri Dec 5 19:03:58 2008 -0500

    Ksplice: Add functions for walking kallsyms symbols
    
    Impact: New API
    
    kallsyms_lookup_name only returns the first match that it finds.  Ksplice
    needs information about all symbols with a given name in order to correctly
    resolve local symbols.
    
    kallsyms_on_each_symbol provides a generic mechanism for iterating over the
    kallsyms table.
    
    Cc: Jeff Arnold <jbarnold@mit.edu>
    Cc: Tim Abbott <tabbott@mit.edu>
    Signed-off-by: Anders Kaseorg <andersk@mit.edu>
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

 include/linux/kallsyms.h |   15 +++++++++++++++
 include/linux/module.h   |   12 ++++++++++++
 kernel/kallsyms.c        |   19 +++++++++++++++++++
 kernel/module.c          |   19 +++++++++++++++++++
 4 files changed, 65 insertions(+), 0 deletions(-)

commit c6b37801911d7f4663c99cad8aa230bc934cea82
Author: Tim Abbott <tabbott@mit.edu>
Date:   Fri Dec 5 19:03:59 2008 -0500

    module: Export symbols needed for Ksplice
    
    Impact: Expose some module.c symbols
    
    Ksplice uses several functions from module.c in order to resolve
    symbols and implement dependency handling.  Calling these functions
    requires holding module_mutex, so it is exported.
    
    (This is just the module part of a bigger add-exports patch from Tim).
    
    Cc: Anders Kaseorg <andersk@mit.edu>
    Cc: Jeff Arnold <jbarnold@mit.edu>
    Signed-off-by: Tim Abbott <tabbott@mit.edu>
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

 include/linux/module.h |   28 ++++++++++++++++++++++++++++
 kernel/module.c        |   43 +++++++++++++++++++------------------------
 2 files changed, 47 insertions(+), 24 deletions(-)

commit c6e665c8f0c18ab3686117905765b5139efd6ebd
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Tue Mar 31 13:05:33 2009 -0600

    module: clarify the force-loading taint message.
    
    Impact: Message cleanup
    
    Two of three callers of try_to_force_load() are not because of a
    missing version, so change the messages:
    
    Old:
    	<modname>: no version for "magic" found: kernel tainted.
    New:
    	<modname>: bad vermagic: kernel tainted.
    
    Old:
    	<modname>: no version for "nocrc" found: kernel tainted.
    New:
    	<modname>: no versions for exported symbols: kernel tainted.
    
    Old:
    	<modname>: no version for "<symname>" found: kernel tainted.
    New:
    	<modname>: <symname>: kernel tainted.
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

 kernel/module.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

commit 9cb610d8e35fe3ec95a2fe2030b02f85aeea83c1
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Tue Mar 31 13:05:33 2009 -0600

    module: remove the SHF_ALLOC flag on the __versions section.
    
    Impact: reduce kernel memory usage
    
    This patch just takes off the SHF_ALLOC flag on __versions so we don't
    keep them around after module load.
    
    This saves about 7% of module memory if CONFIG_MODVERSIONS=y.
    
    Cc: Shawn Bohrer <shawn.bohrer@gmail.com>
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

 kernel/module.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

commit 8c8ef42aee8fcfb4128bb94c50d55c9f80ade525
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Tue Mar 31 13:05:34 2009 -0600

    module: include other structures in module version check
    
    With CONFIG_MODVERSIONS, we version 'struct module' using a dummy
    export, but other things matter too:
    
    1) 'struct modversion_info' determines the layout of the __versions section,
    2) 'struct kernel_param' determines the layout of the __params section,
    3) 'struct kernel_symbol' determines __ksymtab*.
    4) 'struct marker' determines __markers.
    5) 'struct tracepoint' determines __tracepoints.
    
    So we rename 'struct_module' to 'module_layout' and include these in
    the signature.  Now it's general we can add others later on without
    confusion.
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

 kernel/module.c       |   18 +++++++++++++-----
 scripts/mod/modpost.c |    4 ++--
 2 files changed, 15 insertions(+), 7 deletions(-)

commit acae05156551fd7528fbb616271e672789388e3c
Author: Arjan van de Ven <arjan@linux.intel.com>
Date:   Sun Feb 8 10:42:01 2009 -0800

    module: create a request_module_nowait()
    
    There seems to be a common pattern in the kernel where drivers want to
    call request_module() from inside a module_init() function. Currently
    this would deadlock.
    
    As a result, several drivers go through hoops like scheduling things via
    kevent, or creating custom work queues (because kevent can deadlock on them).
    
    This patch changes this to use a request_module_nowait() function macro instead,
    which just fires the modprobe off but doesn't wait for it, and thus avoids the
    original deadlock entirely.
    
    On my laptop this already results in one less kernel thread running..
    
    (Includes Jiri's patch to use enum umh_wait)
    
    Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au> (bool-ified)
    Cc: Jiri Slaby <jirislaby@gmail.com>

 include/linux/kmod.h |   11 ++++++++---
 kernel/kmod.c        |   10 ++++++----
 2 files changed, 14 insertions(+), 7 deletions(-)

commit e91defa26c527ceeaff6266c55cdc7e17c9081a2
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Tue Mar 31 13:05:35 2009 -0600

    module: don't use stop_machine on module load
    
    Kay Sievers <kay.sievers@vrfy.org> discovered that boot times are slowed
    by about half a second because all the stop_machine_create() calls,
    and he only probes about 40 modules (I have 125 loaded on this laptop).
    
    We only do stop_machine_create() so we can unlink the module if
    something goes wrong, but it's overkill (and buggy anyway: if
    stop_machine_create() fails we still call stop_machine_destroy()).
    
    Since we are only protecting against kallsyms (esp. oops) walking the
    list, synchronize_sched() is sufficient (synchronize_rcu() is probably
    sufficient, but we're not in a hurry).
    
    Kay says of this patch:
    	... no module takes more than 40 millisecs to link now, most of
    	them are between 3 and 8 millisecs.
    
    	That looks very different to the numbers without this patch
    	and the otherwise same setup, where we get heavy noise in the
    	traces and many delays of up to 200 millisecs until linking,
    	most of them taking 30+ millisecs.
    
    Tested-by: Kay Sievers <kay.sievers@vrfy.org>
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

 kernel/module.c |   12 +++---------
 1 files changed, 3 insertions(+), 9 deletions(-)

commit aa0d3bb77e780054babcd289484cf4c15180111b
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Tue Mar 31 13:05:35 2009 -0600

    arm: allow usage of string functions in linux/string.h
    
    In introducing a trivial "strstarts()" function in linux/string.h, we
    hit:
    
    	arch/arm/boot/compressed/misc.o: In function `strstarts':
    	misc.c:(.text+0x368): undefined reference to `strlen'
    	misc.c:(.text+0x378): undefined reference to `strncmp'
    
    This is because of "CFLAGS_misc.o := -Dstatic=" in the Makefile.
    "static inline strstarts(...)" becomes non-inline, and refers to the
    other string ops.
    
    The simplest workaround is to include asm/string.h.  This makes sense
    anyway, since lib/string.c won't be linked against this so we can't
    use those functions anyway.
    
    Compile tested here.
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
    Acked-by: Russell King <rmk+kernel@arm.linux.org.uk>

 arch/arm/boot/compressed/misc.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

commit 66f92cf9d415e96a5bdd6c64de8dd8418595d2fc
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Tue Mar 31 13:05:36 2009 -0600

    strstarts: helper function for !strncmp(str, prefix, strlen(prefix))
    
    Impact: minor new API
    
    ksplice added a "starts_with" function, which seems like a common need.
    When people open-code it they seem to use fixed numbers rather than strlen,
    so it's quite a readability win (also, strncmp() almost always wants != 0
    on it).
    
    So here's strstarts().
    
    Cc: Anders Kaseorg <andersk@mit.edu>
    Cc: Jeff Arnold <jbarnold@mit.edu>
    Cc: Tim Abbott <tabbott@mit.edu>
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

 include/linux/string.h |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

commit 49502677e11079c2e3e01867c922a894ce06a8be
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Tue Mar 31 13:05:36 2009 -0600

    module: use strstarts()
    
    Impact: minor cleanup.
    
    I'm not going to neaten anyone else's code, but I'm happy to clean up
    my own.
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

 kernel/module.c |   11 ++++-------
 1 files changed, 4 insertions(+), 7 deletions(-)
