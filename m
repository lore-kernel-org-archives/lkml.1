Return-Path: <linux-kernel-owner+w=401wt.eu-S1758523AbZC3Ldy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758523AbZC3Ldy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 07:33:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755848AbZC3Ldo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 07:33:44 -0400
Received: from ozlabs.org ([203.10.76.45]:42032 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755637AbZC3Ldl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 07:33:41 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PULL] module and parameter patches
Date: Mon, 30 Mar 2009 22:03:30 +1030
User-Agent: KMail/1.11.1 (Linux/2.6.27-11-generic; KDE/4.2.1; i686; ; )
Cc: linux-kernel@vger.kernel.org,
       =?utf-8?q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>,
       Anders Kaseorg <andersk@mit.edu>,
       Arjan van de Ven <arjan@linux.intel.com>, Tim Abbott <tabbott@mit.edu>,
       Russell King <rmk@arm.linux.org.uk>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200903302203.31097.rusty@rustcorp.com.au>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 0d34fb8e93ceba7b6dad0062dbb4a0813bacd75b:                      
  Linus Torvalds (1):                                                                             
        Merge branch 'bzip2-lzma-for-linus' of git://git.kernel.org/.../x86/linux-2.6-tip         

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/rusty/linux-2.6-module-and-param.git master

Américo Wang (1):
      kernel/module.c: fix an unused goto label

Anders Kaseorg (1):
      Ksplice: Add functions for walking kallsyms symbols

Arjan van de Ven (3):
      module: create a request_module_nowait()
      use the new request_module_nowait() in the hid driver
      use the new request_module_nowait() in drivers/media 

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

 arch/arm/boot/compressed/misc.c            |    5 +-
 drivers/hid/hid-core.c                     |   19 +--
 drivers/media/video/bt8xx/bttv-driver.c    |    8 +-
 drivers/media/video/bt8xx/bttvp.h          |    3 -
 drivers/media/video/cx88/cx88-mpeg.c       |   14 +-
 drivers/media/video/cx88/cx88.h            |    1 -
 drivers/media/video/em28xx/em28xx-cards.c  |   17 +--
 drivers/media/video/em28xx/em28xx.h        |    2 -
 drivers/media/video/saa7134/saa7134-core.c |   19 +--
 drivers/media/video/saa7134/saa7134.h      |    2 -
 drivers/mtd/nand/nand_base.c               |    4 +-
 include/linux/kallsyms.h                   |   15 ++
 include/linux/kmod.h                       |   11 +-
 include/linux/module.h                     |   63 ++++++-
 include/linux/moduleparam.h                |   10 +
 include/linux/string.h                     |    9 +
 kernel/extable.c                           |    6 +-
 kernel/kallsyms.c                          |   19 ++
 kernel/kmod.c                              |   10 +-
 kernel/module.c                            |  274 ++++++++++++++++------------
 kernel/params.c                            |   26 +++-
 scripts/mod/modpost.c                      |    4 +-
 22 files changed, 334 insertions(+), 207 deletions(-)

commit 2fe667fa1bced0148826421aca4eb44833f2f577
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Mon Mar 30 22:02:10 2009 -0600

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

commit b99d58d32fbaf50306e8f514393d2865b46d88bf
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

commit 4859d6f3a8f8e60edb9ed390a2e9044ca0a4f2d2
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

commit 6da318ebd26eef48738ede69ec0a65c86a3d278e
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Mon Mar 30 22:02:15 2009 -0600

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

commit a90b646caa84683c1526c75002303ab952e7dcb2
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Mon Mar 30 22:02:17 2009 -0600

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

commit 61e666feaa61bfdeb721ffa048b1a41e6a16c13b
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

commit e7b7f2253592a38d046691360d9fcb49c6ae4a38
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

commit 3fc34f3c1939d173a7c7e3bfd946e6852c9a016a
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Mon Mar 30 22:02:19 2009 -0600

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

commit 212d604c4f542e780613656c8acdc035b3431f5f
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Mon Mar 30 22:02:19 2009 -0600

    module: remove the SHF_ALLOC flag on the __versions section.
    
    Impact: reduce kernel memory usage
    
    This patch just takes off the SHF_ALLOC flag on __versions so we don't
    keep them around after module load.
    
    This saves about 7% of module memory if CONFIG_MODVERSIONS=y.
    
    Cc: Shawn Bohrer <shawn.bohrer@gmail.com>
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

 kernel/module.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

commit 7b87baad9307d2c7cbb56a61ae2471d927b06b5d
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Mon Mar 30 22:02:20 2009 -0600

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

commit 5ac4706bb09cdfc21ad94477462cd5fb74709062
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

commit 743b7e3627cbcd5b04b2d1878b1c6b39e357173e
Author: Arjan van de Ven <arjan@linux.intel.com>
Date:   Sun Feb 8 10:42:40 2009 -0800

    use the new request_module_nowait() in the hid driver
    
    Now that there is a request_module_nowait(), use it in the hid driver.
    This gets rid of a kernel thread, and also greatly simplifies the code...
    
    Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

 drivers/hid/hid-core.c |   19 +------------------
 1 files changed, 1 insertions(+), 18 deletions(-)

commit e777b1632850740b36d17ef86f4cc2882508fe94
Author: Arjan van de Ven <arjan@linux.intel.com>
Date:   Mon Mar 30 22:02:24 2009 -0600

    use the new request_module_nowait() in drivers/media
    
    Several drivers/media/video drivers use keventd to load modules
    to avoid the "load a module from the module init code" deadlock.
    
    Now that we have request_module_nowait() this can be simplified
    greatly.
    
    Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
    Acked-by: Mauro Carvalho Chehab <mchehab@redhat.com>

 drivers/media/video/bt8xx/bttv-driver.c    |    8 +-------
 drivers/media/video/bt8xx/bttvp.h          |    3 ---
 drivers/media/video/cx88/cx88-mpeg.c       |   14 +++-----------
 drivers/media/video/cx88/cx88.h            |    1 -
 drivers/media/video/em28xx/em28xx-cards.c  |   17 ++++-------------
 drivers/media/video/em28xx/em28xx.h        |    2 --
 drivers/media/video/saa7134/saa7134-core.c |   19 ++++++-------------
 drivers/media/video/saa7134/saa7134.h      |    2 --
 8 files changed, 14 insertions(+), 52 deletions(-)

commit 9e7ea4956260af4ca7f1b3c2f9ef9957f0bf7dca
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Mon Mar 30 22:02:29 2009 -0600

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

commit 8837424a91af312896ce8d436a81f3798f6ea0d8
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Mon Mar 30 22:02:31 2009 -0600

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

commit 7c315c7413b13c6b74f675b2d052021915534e4d
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Mon Mar 30 22:02:32 2009 -0600

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

commit fb9acaa4082e370256b997011d565d1259a71c0f
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Mon Mar 30 22:02:32 2009 -0600

    module: use strstarts()
    
    Impact: minor cleanup.
    
    I'm not going to neaten anyone else's code, but I'm happy to clean up
    my own.
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

 kernel/module.c |   11 ++++-------
 1 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/arch/arm/boot/compressed/misc.c b/arch/arm/boot/compressed/misc.c
index 393c816..9e6e512 100644
--- a/arch/arm/boot/compressed/misc.c
+++ b/arch/arm/boot/compressed/misc.c
@@ -18,7 +18,10 @@
 
 unsigned int __machine_arch_type;
 
-#include <linux/string.h>
+#include <linux/compiler.h>	/* for inline */
+#include <linux/types.h>	/* for size_t */
+#include <linux/stddef.h>	/* for NULL */
+#include <asm/string.h>
 
 #ifdef STANDALONE_DEBUG
 #define putstr printf
diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 1cc9674..483fa0d 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1813,15 +1813,6 @@ void hid_unregister_driver(struct hid_driver *hdrv)
 }
 EXPORT_SYMBOL_GPL(hid_unregister_driver);
 
-#ifdef CONFIG_HID_COMPAT
-static void hid_compat_load(struct work_struct *ws)
-{
-	request_module("hid-dummy");
-}
-static DECLARE_WORK(hid_compat_work, hid_compat_load);
-static struct workqueue_struct *hid_compat_wq;
-#endif
-
 static int __init hid_init(void)
 {
 	int ret;
@@ -1837,12 +1828,7 @@ static int __init hid_init(void)
 		goto err_bus;
 
 #ifdef CONFIG_HID_COMPAT
-	hid_compat_wq = create_singlethread_workqueue("hid_compat");
-	if (!hid_compat_wq) {
-		hidraw_exit();
-		goto err;
-	}
-	queue_work(hid_compat_wq, &hid_compat_work);
+	request_module_nowait("hid-dummy");
 #endif
 
 	return 0;
@@ -1854,9 +1840,6 @@ err:
 
 static void __exit hid_exit(void)
 {
-#ifdef CONFIG_HID_COMPAT
-	destroy_workqueue(hid_compat_wq);
-#endif
 	hidraw_exit();
 	bus_unregister(&hid_bus_type);
 }
diff --git a/drivers/media/video/bt8xx/bttv-driver.c b/drivers/media/video/bt8xx/bttv-driver.c
index c71f394..7b23d87 100644
--- a/drivers/media/video/bt8xx/bttv-driver.c
+++ b/drivers/media/video/bt8xx/bttv-driver.c
@@ -175,15 +175,9 @@ static DEVICE_ATTR(card, S_IRUGO, show_card, NULL);
 /* ----------------------------------------------------------------------- */
 /* dvb auto-load setup                                                     */
 #if defined(CONFIG_MODULES) && defined(MODULE)
-static void request_module_async(struct work_struct *work)
-{
-	request_module("dvb-bt8xx");
-}
-
 static void request_modules(struct bttv *dev)
 {
-	INIT_WORK(&dev->request_module_wk, request_module_async);
-	schedule_work(&dev->request_module_wk);
+	request_module_nowait("dvb-bt8xx");
 }
 #else
 #define request_modules(dev)
diff --git a/drivers/media/video/bt8xx/bttvp.h b/drivers/media/video/bt8xx/bttvp.h
index 199a4d2..767d483 100644
--- a/drivers/media/video/bt8xx/bttvp.h
+++ b/drivers/media/video/bt8xx/bttvp.h
@@ -439,9 +439,6 @@ struct bttv {
 	unsigned int users;
 	struct bttv_fh init;
 
-	/* used to make dvb-bt8xx autoloadable */
-	struct work_struct request_module_wk;
-
 	/* Default (0) and current (1) video capturing and overlay
 	   cropping parameters in bttv_tvnorm.cropcap units. Protected
 	   by bttv.lock. */
diff --git a/drivers/media/video/cx88/cx88-mpeg.c b/drivers/media/video/cx88/cx88-mpeg.c
index b295b76..683d6cc 100644
--- a/drivers/media/video/cx88/cx88-mpeg.c
+++ b/drivers/media/video/cx88/cx88-mpeg.c
@@ -50,20 +50,12 @@ MODULE_PARM_DESC(debug,"enable debug messages [mpeg]");
 	printk(KERN_DEBUG "%s/2-mpeg: " fmt, core->name, ## arg)
 
 #if defined(CONFIG_MODULES) && defined(MODULE)
-static void request_module_async(struct work_struct *work)
+static void request_modules(struct cx8802_dev *dev)
 {
-	struct cx8802_dev *dev=container_of(work, struct cx8802_dev, request_module_wk);
-
 	if (dev->core->board.mpeg & CX88_MPEG_DVB)
-		request_module("cx88-dvb");
+		request_module_nowait("cx88-dvb");
 	if (dev->core->board.mpeg & CX88_MPEG_BLACKBIRD)
-		request_module("cx88-blackbird");
-}
-
-static void request_modules(struct cx8802_dev *dev)
-{
-	INIT_WORK(&dev->request_module_wk, request_module_async);
-	schedule_work(&dev->request_module_wk);
+		request_module_nowait("cx88-blackbird");
 }
 #else
 #define request_modules(dev)
diff --git a/drivers/media/video/cx88/cx88.h b/drivers/media/video/cx88/cx88.h
index 6025fdd..242cd62 100644
--- a/drivers/media/video/cx88/cx88.h
+++ b/drivers/media/video/cx88/cx88.h
@@ -510,7 +510,6 @@ struct cx8802_dev {
 
 	/* List of attached drivers */
 	struct list_head	   drvlist;
-	struct work_struct	   request_module_wk;
 };
 
 /* ----------------------------------------------------------- */
diff --git a/drivers/media/video/em28xx/em28xx-cards.c b/drivers/media/video/em28xx/em28xx-cards.c
index 3b3ca3f..dc00102 100644
--- a/drivers/media/video/em28xx/em28xx-cards.c
+++ b/drivers/media/video/em28xx/em28xx-cards.c
@@ -1809,24 +1809,15 @@ void em28xx_card_setup(struct em28xx *dev)
 
 
 #if defined(CONFIG_MODULES) && defined(MODULE)
-static void request_module_async(struct work_struct *work)
+static void request_modules(struct em28xx *dev)
 {
-	struct em28xx *dev = container_of(work,
-			     struct em28xx, request_module_wk);
-
 	if (dev->has_audio_class)
-		request_module("snd-usb-audio");
+		request_module_nowait("snd-usb-audio");
 	else if (dev->has_alsa_audio)
-		request_module("em28xx-alsa");
+		request_module_nowait("em28xx-alsa");
 
 	if (dev->board.has_dvb)
-		request_module("em28xx-dvb");
-}
-
-static void request_modules(struct em28xx *dev)
-{
-	INIT_WORK(&dev->request_module_wk, request_module_async);
-	schedule_work(&dev->request_module_wk);
+		request_module_nowait("em28xx-dvb");
 }
 #else
 #define request_modules(dev)
diff --git a/drivers/media/video/em28xx/em28xx.h b/drivers/media/video/em28xx/em28xx.h
index dd2cd36..164a543 100644
--- a/drivers/media/video/em28xx/em28xx.h
+++ b/drivers/media/video/em28xx/em28xx.h
@@ -498,8 +498,6 @@ struct em28xx {
 	enum em28xx_dev_state state;
 	enum em28xx_io_method io;
 
-	struct work_struct         request_module_wk;
-
 	/* locks */
 	struct mutex lock;
 	struct mutex ctrl_urb_lock;	/* protects urb_buf */
diff --git a/drivers/media/video/saa7134/saa7134-core.c b/drivers/media/video/saa7134/saa7134-core.c
index 99221d7..a4bc939 100644
--- a/drivers/media/video/saa7134/saa7134-core.c
+++ b/drivers/media/video/saa7134/saa7134-core.c
@@ -149,23 +149,16 @@ void saa7134_set_gpio(struct saa7134_dev *dev, int bit_no, int value)
 /* delayed request_module                                      */
 
 #if defined(CONFIG_MODULES) && defined(MODULE)
-
-static void request_module_async(struct work_struct *work){
-	struct saa7134_dev* dev = container_of(work, struct saa7134_dev, request_module_wk);
+static void request_submodules(struct saa7134_dev *dev)
+{
 	if (card_is_empress(dev))
-		request_module("saa7134-empress");
+		request_module_nowait("saa7134-empress");
 	if (card_is_dvb(dev))
-		request_module("saa7134-dvb");
+		request_module_nowait("saa7134-dvb");
 	if (alsa)
-		request_module("saa7134-alsa");
+		request_module_nowait("saa7134-alsa");
 	if (oss)
-		request_module("saa7134-oss");
-}
-
-static void request_submodules(struct saa7134_dev *dev)
-{
-	INIT_WORK(&dev->request_module_wk, request_module_async);
-	schedule_work(&dev->request_module_wk);
+		request_module_nowait("saa7134-oss");
 }
 
 #else
diff --git a/drivers/media/video/saa7134/saa7134.h b/drivers/media/video/saa7134/saa7134.h
index 14ee265..d13d16f 100644
--- a/drivers/media/video/saa7134/saa7134.h
+++ b/drivers/media/video/saa7134/saa7134.h
@@ -482,8 +482,6 @@ struct saa7134_dev {
 	struct mutex               lock;
 	spinlock_t                 slock;
 	struct v4l2_prio_state     prio;
-	/* workstruct for loading modules */
-	struct work_struct request_module_wk;
 
 	/* insmod option/autodetected */
 	int                        autodetected;
diff --git a/drivers/mtd/nand/nand_base.c b/drivers/mtd/nand/nand_base.c
index 0c3afcc..5f71371 100644
--- a/drivers/mtd/nand/nand_base.c
+++ b/drivers/mtd/nand/nand_base.c
@@ -2720,14 +2720,14 @@ int nand_scan_tail(struct mtd_info *mtd)
 	return chip->scan_bbt(mtd);
 }
 
-/* module_text_address() isn't exported, and it's mostly a pointless
+/* is_module_text_address() isn't exported, and it's mostly a pointless
    test if this is a module _anyway_ -- they'd have to try _really_ hard
    to call us from in-kernel code if the core NAND support is modular. */
 #ifdef MODULE
 #define caller_is_module() (1)
 #else
 #define caller_is_module() \
-	module_text_address((unsigned long)__builtin_return_address(0))
+	is_module_text_address((unsigned long)__builtin_return_address(0))
 #endif
 
 /**
diff --git a/include/linux/kallsyms.h b/include/linux/kallsyms.h
index f3fe343..7922742 100644
--- a/include/linux/kallsyms.h
+++ b/include/linux/kallsyms.h
@@ -13,10 +13,17 @@
 #define KSYM_SYMBOL_LEN (sizeof("%s+%#lx/%#lx [%s]") + (KSYM_NAME_LEN - 1) + \
 			 2*(BITS_PER_LONG*3/10) + (MODULE_NAME_LEN - 1) + 1)
 
+struct module;
+
 #ifdef CONFIG_KALLSYMS
 /* Lookup the address for a symbol. Returns 0 if not found. */
 unsigned long kallsyms_lookup_name(const char *name);
 
+/* Call a function on each kallsyms symbol in the core kernel */
+int kallsyms_on_each_symbol(int (*fn)(void *, const char *, struct module *,
+				      unsigned long),
+			    void *data);
+
 extern int kallsyms_lookup_size_offset(unsigned long addr,
 				  unsigned long *symbolsize,
 				  unsigned long *offset);
@@ -43,6 +50,14 @@ static inline unsigned long kallsyms_lookup_name(const char *name)
 	return 0;
 }
 
+static inline int kallsyms_on_each_symbol(int (*fn)(void *, const char *,
+						    struct module *,
+						    unsigned long),
+					  void *data)
+{
+	return 0;
+}
+
 static inline int kallsyms_lookup_size_offset(unsigned long addr,
 					      unsigned long *symbolsize,
 					      unsigned long *offset)
diff --git a/include/linux/kmod.h b/include/linux/kmod.h
index 92213a9..d5fa565 100644
--- a/include/linux/kmod.h
+++ b/include/linux/kmod.h
@@ -29,10 +29,15 @@
 #ifdef CONFIG_MODULES
 /* modprobe exit status on success, -ve on error.  Return value
  * usually useless though. */
-extern int request_module(const char * name, ...) __attribute__ ((format (printf, 1, 2)));
-#define try_then_request_module(x, mod...) ((x) ?: (request_module(mod), (x)))
+extern int __request_module(bool wait, const char *name, ...) \
+	__attribute__((format(printf, 2, 3)));
+#define request_module(mod...) __request_module(true, mod)
+#define request_module_nowait(mod...) __request_module(false, mod)
+#define try_then_request_module(x, mod...) \
+	((x) ?: (__request_module(false, mod), (x)))
 #else
-static inline int request_module(const char * name, ...) { return -ENOSYS; }
+static inline int request_module(const char *name, ...) { return -ENOSYS; }
+static inline int request_module_nowait(const char *name, ...) { return -ENOSYS; }
 #define try_then_request_module(x, mod...) (x)
 #endif
 
diff --git a/include/linux/module.h b/include/linux/module.h
index 145a755..d246da0 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -248,6 +248,10 @@ struct module
 	const unsigned long *crcs;
 	unsigned int num_syms;
 
+	/* Kernel parameters. */
+	struct kernel_param *kp;
+	unsigned int num_kp;
+
 	/* GPL-only exported symbols. */
 	unsigned int num_gpl_syms;
 	const struct kernel_symbol *gpl_syms;
@@ -350,6 +354,8 @@ struct module
 #define MODULE_ARCH_INIT {}
 #endif
 
+extern struct mutex module_mutex;
+
 /* FIXME: It'd be nice to isolate modules during init, too, so they
    aren't used before they (may) fail.  But presently too much code
    (IDE & SCSI) require entry into the module during init.*/
@@ -358,10 +364,10 @@ static inline int module_is_live(struct module *mod)
 	return mod->state != MODULE_STATE_GOING;
 }
 
-/* Is this address in a module? (second is with no locks, for oops) */
-struct module *module_text_address(unsigned long addr);
 struct module *__module_text_address(unsigned long addr);
-int is_module_address(unsigned long addr);
+struct module *__module_address(unsigned long addr);
+bool is_module_address(unsigned long addr);
+bool is_module_text_address(unsigned long addr);
 
 static inline int within_module_core(unsigned long addr, struct module *mod)
 {
@@ -375,6 +381,31 @@ static inline int within_module_init(unsigned long addr, struct module *mod)
 	       addr < (unsigned long)mod->module_init + mod->init_size;
 }
 
+/* Search for module by name: must hold module_mutex. */
+struct module *find_module(const char *name);
+
+struct symsearch {
+	const struct kernel_symbol *start, *stop;
+	const unsigned long *crcs;
+	enum {
+		NOT_GPL_ONLY,
+		GPL_ONLY,
+		WILL_BE_GPL_ONLY,
+	} licence;
+	bool unused;
+};
+
+/* Search for an exported symbol by name. */
+const struct kernel_symbol *find_symbol(const char *name,
+					struct module **owner,
+					const unsigned long **crc,
+					bool gplok,
+					bool warn);
+
+/* Walk the exported symbol table */
+bool each_symbol(bool (*fn)(const struct symsearch *arr, struct module *owner,
+			    unsigned int symnum, void *data), void *data);
+
 /* Returns 0 and fills in value, defined and namebuf, or -ERANGE if
    symnum out of range. */
 int module_get_kallsym(unsigned int symnum, unsigned long *value, char *type,
@@ -383,6 +414,10 @@ int module_get_kallsym(unsigned int symnum, unsigned long *value, char *type,
 /* Look for this name: can be of form module:name. */
 unsigned long module_kallsyms_lookup_name(const char *name);
 
+int module_kallsyms_on_each_symbol(int (*fn)(void *, const char *,
+					     struct module *, unsigned long),
+				   void *data);
+
 extern void __module_put_and_exit(struct module *mod, long code)
 	__attribute__((noreturn));
 #define module_put_and_exit(code) __module_put_and_exit(THIS_MODULE, code);
@@ -444,6 +479,7 @@ static inline void __module_get(struct module *module)
 #define symbol_put_addr(p) do { } while(0)
 
 #endif /* CONFIG_MODULE_UNLOAD */
+int use_module(struct module *a, struct module *b);
 
 /* This is a #define so the string doesn't get put in every .o file */
 #define module_name(mod)			\
@@ -490,21 +526,24 @@ search_module_extables(unsigned long addr)
 	return NULL;
 }
 
-/* Is this address in a module? */
-static inline struct module *module_text_address(unsigned long addr)
+static inline struct module *__module_address(unsigned long addr)
 {
 	return NULL;
 }
 
-/* Is this address in a module? (don't take a lock, we're oopsing) */
 static inline struct module *__module_text_address(unsigned long addr)
 {
 	return NULL;
 }
 
-static inline int is_module_address(unsigned long addr)
+static inline bool is_module_address(unsigned long addr)
 {
-	return 0;
+	return false;
+}
+
+static inline bool is_module_text_address(unsigned long addr)
+{
+	return false;
 }
 
 /* Get/put a kernel symbol (calls should be symmetric) */
@@ -559,6 +598,14 @@ static inline unsigned long module_kallsyms_lookup_name(const char *name)
 	return 0;
 }
 
+static inline int module_kallsyms_on_each_symbol(int (*fn)(void *, const char *,
+							   struct module *,
+							   unsigned long),
+						 void *data)
+{
+	return 0;
+}
+
 static inline int register_module_notifier(struct notifier_block * nb)
 {
 	/* no events will happen anyway, so this can always succeed */
diff --git a/include/linux/moduleparam.h b/include/linux/moduleparam.h
index e4af339..a4f0b93 100644
--- a/include/linux/moduleparam.h
+++ b/include/linux/moduleparam.h
@@ -138,6 +138,16 @@ extern int parse_args(const char *name,
 		      unsigned num,
 		      int (*unknown)(char *param, char *val));
 
+/* Called by module remove. */
+#ifdef CONFIG_SYSFS
+extern void destroy_params(const struct kernel_param *params, unsigned num);
+#else
+static inline void destroy_params(const struct kernel_param *params,
+				  unsigned num)
+{
+}
+#endif /* !CONFIG_SYSFS */
+
 /* All the helper functions */
 /* The macros to do compile-time type checking stolen from Jakub
    Jelinek, who IIRC came up with this idea for the 2.4 module init code. */
diff --git a/include/linux/string.h b/include/linux/string.h
index d18fc19..76ec218 100644
--- a/include/linux/string.h
+++ b/include/linux/string.h
@@ -114,5 +114,14 @@ extern bool sysfs_streq(const char *s1, const char *s2);
 extern ssize_t memory_read_from_buffer(void *to, size_t count, loff_t *ppos,
 			const void *from, size_t available);
 
+/**
+ * strstarts - does @str start with @prefix?
+ * @str: string to examine
+ * @prefix: prefix to look for.
+ */
+static inline bool strstarts(const char *str, const char *prefix)
+{
+	return strncmp(str, prefix, strlen(prefix)) == 0;
+}
 #endif
 #endif /* _LINUX_STRING_H_ */
diff --git a/kernel/extable.c b/kernel/extable.c
index e136ed8..384f0da 100644
--- a/kernel/extable.c
+++ b/kernel/extable.c
@@ -58,14 +58,14 @@ __notrace_funcgraph int __kernel_text_address(unsigned long addr)
 {
 	if (core_kernel_text(addr))
 		return 1;
-	return __module_text_address(addr) != NULL;
+	return is_module_text_address(addr);
 }
 
 int kernel_text_address(unsigned long addr)
 {
 	if (core_kernel_text(addr))
 		return 1;
-	return module_text_address(addr) != NULL;
+	return is_module_text_address(addr);
 }
 
 /*
@@ -81,5 +81,5 @@ int func_ptr_is_kernel_text(void *ptr)
 	addr = (unsigned long) dereference_function_descriptor(ptr);
 	if (core_kernel_text(addr))
 		return 1;
-	return module_text_address(addr) != NULL;
+	return is_module_text_address(addr);
 }
diff --git a/kernel/kallsyms.c b/kernel/kallsyms.c
index 7b8b0f2..374faf9 100644
--- a/kernel/kallsyms.c
+++ b/kernel/kallsyms.c
@@ -161,6 +161,25 @@ unsigned long kallsyms_lookup_name(const char *name)
 	return module_kallsyms_lookup_name(name);
 }
 
+int kallsyms_on_each_symbol(int (*fn)(void *, const char *, struct module *,
+				      unsigned long),
+			    void *data)
+{
+	char namebuf[KSYM_NAME_LEN];
+	unsigned long i;
+	unsigned int off;
+	int ret;
+
+	for (i = 0, off = 0; i < kallsyms_num_syms; i++) {
+		off = kallsyms_expand_symbol(off, namebuf);
+		ret = fn(data, namebuf, NULL, kallsyms_addresses[i]);
+		if (ret != 0)
+			return ret;
+	}
+	return module_kallsyms_on_each_symbol(fn, data);
+}
+EXPORT_SYMBOL_GPL(kallsyms_on_each_symbol);
+
 static unsigned long get_symbol_pos(unsigned long addr,
 				    unsigned long *symbolsize,
 				    unsigned long *offset)
diff --git a/kernel/kmod.c b/kernel/kmod.c
index a27a5f6..dc13dd4 100644
--- a/kernel/kmod.c
+++ b/kernel/kmod.c
@@ -50,7 +50,8 @@ static struct workqueue_struct *khelper_wq;
 char modprobe_path[KMOD_PATH_LEN] = "/sbin/modprobe";
 
 /**
- * request_module - try to load a kernel module
+ * __request_module - try to load a kernel module
+ * @wait: wait (or not) for the operation to complete
  * @fmt: printf style format string for the name of the module
  * @...: arguments as specified in the format string
  *
@@ -63,7 +64,7 @@ char modprobe_path[KMOD_PATH_LEN] = "/sbin/modprobe";
  * If module auto-loading support is disabled then this function
  * becomes a no-operation.
  */
-int request_module(const char *fmt, ...)
+int __request_module(bool wait, const char *fmt, ...)
 {
 	va_list args;
 	char module_name[MODULE_NAME_LEN];
@@ -108,11 +109,12 @@ int request_module(const char *fmt, ...)
 		return -ENOMEM;
 	}
 
-	ret = call_usermodehelper(modprobe_path, argv, envp, 1);
+	ret = call_usermodehelper(modprobe_path, argv, envp,
+			wait ? UMH_WAIT_PROC : UMH_WAIT_EXEC);
 	atomic_dec(&kmod_concurrent);
 	return ret;
 }
-EXPORT_SYMBOL(request_module);
+EXPORT_SYMBOL(__request_module);
 #endif /* CONFIG_MODULES */
 
 struct subprocess_info {
diff --git a/kernel/module.c b/kernel/module.c
index f77ac32..f6e08b7 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -68,7 +68,8 @@
 
 /* List of modules, protected by module_mutex or preempt_disable
  * (delete uses stop_machine/add uses RCU list operations). */
-static DEFINE_MUTEX(module_mutex);
+DEFINE_MUTEX(module_mutex);
+EXPORT_SYMBOL_GPL(module_mutex);
 static LIST_HEAD(modules);
 
 /* Waiting for a module to finish initializing? */
@@ -76,7 +77,7 @@ static DECLARE_WAIT_QUEUE_HEAD(module_wq);
 
 static BLOCKING_NOTIFIER_HEAD(module_notify_list);
 
-/* Bounds of module allocation, for speeding __module_text_address */
+/* Bounds of module allocation, for speeding __module_address */
 static unsigned long module_addr_min = -1UL, module_addr_max = 0;
 
 int register_module_notifier(struct notifier_block * nb)
@@ -186,17 +187,6 @@ extern const unsigned long __start___kcrctab_unused_gpl[];
 #define symversion(base, idx) ((base != NULL) ? ((base) + (idx)) : NULL)
 #endif
 
-struct symsearch {
-	const struct kernel_symbol *start, *stop;
-	const unsigned long *crcs;
-	enum {
-		NOT_GPL_ONLY,
-		GPL_ONLY,
-		WILL_BE_GPL_ONLY,
-	} licence;
-	bool unused;
-};
-
 static bool each_symbol_in_section(const struct symsearch *arr,
 				   unsigned int arrsize,
 				   struct module *owner,
@@ -217,10 +207,8 @@ static bool each_symbol_in_section(const struct symsearch *arr,
 }
 
 /* Returns true as soon as fn returns true, otherwise false. */
-static bool each_symbol(bool (*fn)(const struct symsearch *arr,
-				   struct module *owner,
-				   unsigned int symnum, void *data),
-			void *data)
+bool each_symbol(bool (*fn)(const struct symsearch *arr, struct module *owner,
+			    unsigned int symnum, void *data), void *data)
 {
 	struct module *mod;
 	const struct symsearch arr[] = {
@@ -273,6 +261,7 @@ static bool each_symbol(bool (*fn)(const struct symsearch *arr,
 	}
 	return false;
 }
+EXPORT_SYMBOL_GPL(each_symbol);
 
 struct find_symbol_arg {
 	/* Input */
@@ -283,7 +272,7 @@ struct find_symbol_arg {
 	/* Output */
 	struct module *owner;
 	const unsigned long *crc;
-	unsigned long value;
+	const struct kernel_symbol *sym;
 };
 
 static bool find_symbol_in_section(const struct symsearch *syms,
@@ -324,17 +313,17 @@ static bool find_symbol_in_section(const struct symsearch *syms,
 
 	fsa->owner = owner;
 	fsa->crc = symversion(syms->crcs, symnum);
-	fsa->value = syms->start[symnum].value;
+	fsa->sym = &syms->start[symnum];
 	return true;
 }
 
-/* Find a symbol, return value, (optional) crc and (optional) module
- * which owns it */
-static unsigned long find_symbol(const char *name,
-				 struct module **owner,
-				 const unsigned long **crc,
-				 bool gplok,
-				 bool warn)
+/* Find a symbol and return it, along with, (optional) crc and
+ * (optional) module which owns it */
+const struct kernel_symbol *find_symbol(const char *name,
+					struct module **owner,
+					const unsigned long **crc,
+					bool gplok,
+					bool warn)
 {
 	struct find_symbol_arg fsa;
 
@@ -347,15 +336,16 @@ static unsigned long find_symbol(const char *name,
 			*owner = fsa.owner;
 		if (crc)
 			*crc = fsa.crc;
-		return fsa.value;
+		return fsa.sym;
 	}
 
 	DEBUGP("Failed to find symbol %s\n", name);
-	return -ENOENT;
+	return NULL;
 }
+EXPORT_SYMBOL_GPL(find_symbol);
 
 /* Search for module by name: must hold module_mutex. */
-static struct module *find_module(const char *name)
+struct module *find_module(const char *name)
 {
 	struct module *mod;
 
@@ -365,6 +355,7 @@ static struct module *find_module(const char *name)
 	}
 	return NULL;
 }
+EXPORT_SYMBOL_GPL(find_module);
 
 #ifdef CONFIG_SMP
 
@@ -641,7 +632,7 @@ static int already_uses(struct module *a, struct module *b)
 }
 
 /* Module a uses b */
-static int use_module(struct module *a, struct module *b)
+int use_module(struct module *a, struct module *b)
 {
 	struct module_use *use;
 	int no_warn, err;
@@ -674,6 +665,7 @@ static int use_module(struct module *a, struct module *b)
 	no_warn = sysfs_create_link(b->holders_dir, &a->mkobj.kobj, a->name);
 	return 1;
 }
+EXPORT_SYMBOL_GPL(use_module);
 
 /* Clear the unload stuff of the module. */
 static void module_unload_free(struct module *mod)
@@ -894,7 +886,7 @@ void __symbol_put(const char *symbol)
 	struct module *owner;
 
 	preempt_disable();
-	if (IS_ERR_VALUE(find_symbol(symbol, &owner, NULL, true, false)))
+	if (!find_symbol(symbol, &owner, NULL, true, false))
 		BUG();
 	module_put(owner);
 	preempt_enable();
@@ -908,8 +900,10 @@ void symbol_put_addr(void *addr)
 	if (core_kernel_text((unsigned long)addr))
 		return;
 
-	if (!(modaddr = module_text_address((unsigned long)addr)))
-		BUG();
+	/* module_text_address is safe here: we're supposed to have reference
+	 * to module from symbol_get, so it can't go away. */
+	modaddr = __module_text_address((unsigned long)addr);
+	BUG_ON(!modaddr);
 	module_put(modaddr);
 }
 EXPORT_SYMBOL_GPL(symbol_put_addr);
@@ -949,10 +943,11 @@ static inline void module_unload_free(struct module *mod)
 {
 }
 
-static inline int use_module(struct module *a, struct module *b)
+int use_module(struct module *a, struct module *b)
 {
 	return strong_try_module_get(b) == 0;
 }
+EXPORT_SYMBOL_GPL(use_module);
 
 static inline void module_unload_init(struct module *mod)
 {
@@ -995,12 +990,12 @@ static struct module_attribute *modinfo_attrs[] = {
 
 static const char vermagic[] = VERMAGIC_STRING;
 
-static int try_to_force_load(struct module *mod, const char *symname)
+static int try_to_force_load(struct module *mod, const char *reason)
 {
 #ifdef CONFIG_MODULE_FORCE_LOAD
 	if (!test_taint(TAINT_FORCED_MODULE))
-		printk("%s: no version for \"%s\" found: kernel tainted.\n",
-		       mod->name, symname);
+		printk(KERN_WARNING "%s: %s: kernel tainted.\n",
+		       mod->name, reason);
 	add_taint_module(mod, TAINT_FORCED_MODULE);
 	return 0;
 #else
@@ -1057,9 +1052,9 @@ static inline int check_modstruct_version(Elf_Shdr *sechdrs,
 {
 	const unsigned long *crc;
 
-	if (IS_ERR_VALUE(find_symbol("struct_module", NULL, &crc, true, false)))
+	if (!find_symbol("module_layout", NULL, &crc, true, false))
 		BUG();
-	return check_version(sechdrs, versindex, "struct_module", mod, crc);
+	return check_version(sechdrs, versindex, "module_layout", mod, crc);
 }
 
 /* First part is kernel version, which we ignore if module has crcs. */
@@ -1098,25 +1093,25 @@ static inline int same_magic(const char *amagic, const char *bmagic,
 
 /* Resolve a symbol for this module.  I.e. if we find one, record usage.
    Must be holding module_mutex. */
-static unsigned long resolve_symbol(Elf_Shdr *sechdrs,
-				    unsigned int versindex,
-				    const char *name,
-				    struct module *mod)
+static const struct kernel_symbol *resolve_symbol(Elf_Shdr *sechdrs,
+						  unsigned int versindex,
+						  const char *name,
+						  struct module *mod)
 {
 	struct module *owner;
-	unsigned long ret;
+	const struct kernel_symbol *sym;
 	const unsigned long *crc;
 
-	ret = find_symbol(name, &owner, &crc,
+	sym = find_symbol(name, &owner, &crc,
 			  !(mod->taints & (1 << TAINT_PROPRIETARY_MODULE)), true);
-	if (!IS_ERR_VALUE(ret)) {
-		/* use_module can fail due to OOM,
-		   or module initialization or unloading */
+	/* use_module can fail due to OOM,
+	   or module initialization or unloading */
+	if (sym) {
 		if (!check_version(sechdrs, versindex, name, mod, crc) ||
 		    !use_module(mod, owner))
-			ret = -EINVAL;
+			sym = NULL;
 	}
-	return ret;
+	return sym;
 }
 
 /*
@@ -1491,6 +1486,9 @@ static void free_module(struct module *mod)
 	/* Module unload stuff */
 	module_unload_free(mod);
 
+	/* Free any allocated parameters. */
+	destroy_params(mod->kp, mod->num_kp);
+
 	/* release any pointers to mcount in this module */
 	ftrace_release(mod->module_core, mod->core_size);
 
@@ -1513,17 +1511,15 @@ static void free_module(struct module *mod)
 void *__symbol_get(const char *symbol)
 {
 	struct module *owner;
-	unsigned long value;
+	const struct kernel_symbol *sym;
 
 	preempt_disable();
-	value = find_symbol(symbol, &owner, NULL, true, true);
-	if (IS_ERR_VALUE(value))
-		value = 0;
-	else if (strong_try_module_get(owner))
-		value = 0;
+	sym = find_symbol(symbol, &owner, NULL, true, true);
+	if (sym && strong_try_module_get(owner))
+		sym = NULL;
 	preempt_enable();
 
-	return (void *)value;
+	return sym ? (void *)sym->value : NULL;
 }
 EXPORT_SYMBOL_GPL(__symbol_get);
 
@@ -1551,8 +1547,7 @@ static int verify_export_symbols(struct module *mod)
 
 	for (i = 0; i < ARRAY_SIZE(arr); i++) {
 		for (s = arr[i].sym; s < arr[i].sym + arr[i].num; s++) {
-			if (!IS_ERR_VALUE(find_symbol(s->name, &owner,
-						      NULL, true, false))) {
+			if (find_symbol(s->name, &owner, NULL, true, false)) {
 				printk(KERN_ERR
 				       "%s: exports duplicate symbol %s"
 				       " (owned by %s)\n",
@@ -1576,6 +1571,7 @@ static int simplify_symbols(Elf_Shdr *sechdrs,
 	unsigned long secbase;
 	unsigned int i, n = sechdrs[symindex].sh_size / sizeof(Elf_Sym);
 	int ret = 0;
+	const struct kernel_symbol *ksym;
 
 	for (i = 1; i < n; i++) {
 		switch (sym[i].st_shndx) {
@@ -1595,13 +1591,14 @@ static int simplify_symbols(Elf_Shdr *sechdrs,
 			break;
 
 		case SHN_UNDEF:
-			sym[i].st_value
-			  = resolve_symbol(sechdrs, versindex,
-					   strtab + sym[i].st_name, mod);
-
+			ksym = resolve_symbol(sechdrs, versindex,
+					      strtab + sym[i].st_name, mod);
 			/* Ok if resolved.  */
-			if (!IS_ERR_VALUE(sym[i].st_value))
+			if (ksym) {
+				sym[i].st_value = ksym->value;
 				break;
+			}
+
 			/* Ok if weak.  */
 			if (ELF_ST_BIND(sym[i].st_info) == STB_WEAK)
 				break;
@@ -1676,8 +1673,7 @@ static void layout_sections(struct module *mod,
 			if ((s->sh_flags & masks[m][0]) != masks[m][0]
 			    || (s->sh_flags & masks[m][1])
 			    || s->sh_entsize != ~0UL
-			    || strncmp(secstrings + s->sh_name,
-				       ".init", 5) == 0)
+			    || strstarts(secstrings + s->sh_name, ".init"))
 				continue;
 			s->sh_entsize = get_offset(mod, &mod->core_size, s, i);
 			DEBUGP("\t%s\n", secstrings + s->sh_name);
@@ -1694,8 +1690,7 @@ static void layout_sections(struct module *mod,
 			if ((s->sh_flags & masks[m][0]) != masks[m][0]
 			    || (s->sh_flags & masks[m][1])
 			    || s->sh_entsize != ~0UL
-			    || strncmp(secstrings + s->sh_name,
-				       ".init", 5) != 0)
+			    || !strstarts(secstrings + s->sh_name, ".init"))
 				continue;
 			s->sh_entsize = (get_offset(mod, &mod->init_size, s, i)
 					 | INIT_OFFSET_MASK);
@@ -1828,8 +1823,7 @@ static char elf_type(const Elf_Sym *sym,
 		else
 			return 'b';
 	}
-	if (strncmp(secstrings + sechdrs[sym->st_shndx].sh_name,
-		    ".debug", strlen(".debug")) == 0)
+	if (strstarts(secstrings + sechdrs[sym->st_shndx].sh_name, ".debug"))
 		return 'n';
 	return '?';
 }
@@ -1898,8 +1892,7 @@ static noinline struct module *load_module(void __user *umod,
 	unsigned int symindex = 0;
 	unsigned int strindex = 0;
 	unsigned int modindex, versindex, infoindex, pcpuindex;
-	unsigned int num_kp, num_mcount;
-	struct kernel_param *kp;
+	unsigned int num_mcount;
 	struct module *mod;
 	long err = 0;
 	void *percpu = NULL, *ptr = NULL; /* Stops spurious gcc warning */
@@ -1916,12 +1909,6 @@ static noinline struct module *load_module(void __user *umod,
 	if (len > 64 * 1024 * 1024 || (hdr = vmalloc(len)) == NULL)
 		return ERR_PTR(-ENOMEM);
 
-	/* Create stop_machine threads since the error path relies on
-	 * a non-failing stop_machine call. */
-	err = stop_machine_create();
-	if (err)
-		goto free_hdr;
-
 	if (copy_from_user(hdr, umod, len) != 0) {
 		err = -EFAULT;
 		goto free_hdr;
@@ -1962,9 +1949,12 @@ static noinline struct module *load_module(void __user *umod,
 		}
 #ifndef CONFIG_MODULE_UNLOAD
 		/* Don't load .exit sections */
-		if (strncmp(secstrings+sechdrs[i].sh_name, ".exit", 5) == 0)
+		if (strstarts(secstrings+sechdrs[i].sh_name, ".exit"))
 			sechdrs[i].sh_flags &= ~(unsigned long)SHF_ALLOC;
 #endif
+		/* Don't keep __versions around; it's just for loading. */
+		if (strcmp(secstrings + sechdrs[i].sh_name, "__versions") == 0)
+			sechdrs[i].sh_flags &= ~(unsigned long)SHF_ALLOC;
 	}
 
 	modindex = find_sec(hdr, sechdrs, secstrings,
@@ -2006,7 +1996,7 @@ static noinline struct module *load_module(void __user *umod,
 	modmagic = get_modinfo(sechdrs, infoindex, "vermagic");
 	/* This is allowed: modprobe --force will invalidate it. */
 	if (!modmagic) {
-		err = try_to_force_load(mod, "magic");
+		err = try_to_force_load(mod, "bad vermagic");
 		if (err)
 			goto free_hdr;
 	} else if (!same_magic(modmagic, vermagic, versindex)) {
@@ -2144,8 +2134,8 @@ static noinline struct module *load_module(void __user *umod,
 
 	/* Now we've got everything in the final locations, we can
 	 * find optional sections. */
-	kp = section_objs(hdr, sechdrs, secstrings, "__param", sizeof(*kp),
-			  &num_kp);
+	mod->kp = section_objs(hdr, sechdrs, secstrings, "__param",
+			       sizeof(*mod->kp), &mod->num_kp);
 	mod->syms = section_objs(hdr, sechdrs, secstrings, "__ksymtab",
 				 sizeof(*mod->syms), &mod->num_syms);
 	mod->crcs = section_addr(hdr, sechdrs, secstrings, "__kcrctab");
@@ -2195,8 +2185,8 @@ static noinline struct module *load_module(void __user *umod,
 	    || (mod->num_unused_gpl_syms && !mod->unused_gpl_crcs)
 #endif
 		) {
-		printk(KERN_WARNING "%s: No versions for exported symbols.\n", mod->name);
-		err = try_to_force_load(mod, "nocrc");
+		err = try_to_force_load(mod,
+					"no versions for exported symbols");
 		if (err)
 			goto cleanup;
 	}
@@ -2291,11 +2281,11 @@ static noinline struct module *load_module(void __user *umod,
 	 */
 	list_add_rcu(&mod->list, &modules);
 
-	err = parse_args(mod->name, mod->args, kp, num_kp, NULL);
+	err = parse_args(mod->name, mod->args, mod->kp, mod->num_kp, NULL);
 	if (err < 0)
 		goto unlink;
 
-	err = mod_sysfs_setup(mod, kp, num_kp);
+	err = mod_sysfs_setup(mod, mod->kp, mod->num_kp);
 	if (err < 0)
 		goto unlink;
 	add_sect_attrs(mod, hdr->e_shnum, secstrings, sechdrs);
@@ -2304,12 +2294,13 @@ static noinline struct module *load_module(void __user *umod,
 	/* Get rid of temporary copy */
 	vfree(hdr);
 
-	stop_machine_destroy();
 	/* Done! */
 	return mod;
 
  unlink:
-	stop_machine(__unlink_module, mod, NULL);
+	/* Unlink carefully: kallsyms could be walking list. */
+	list_del_rcu(&mod->list);
+	synchronize_sched();
 	module_arch_cleanup(mod);
  cleanup:
 	kobject_del(&mod->mkobj.kobj);
@@ -2317,8 +2308,8 @@ static noinline struct module *load_module(void __user *umod,
 	ftrace_release(mod->module_core, mod->core_size);
  free_unload:
 	module_unload_free(mod);
- free_init:
 #if defined(CONFIG_MODULE_UNLOAD) && defined(CONFIG_SMP)
+ free_init:
 	percpu_modfree(mod->refptr);
 #endif
 	module_free(mod, mod->module_init);
@@ -2332,7 +2323,6 @@ static noinline struct module *load_module(void __user *umod,
 	kfree(args);
  free_hdr:
 	vfree(hdr);
-	stop_machine_destroy();
 	return ERR_PTR(err);
 
  truncated:
@@ -2609,6 +2599,25 @@ unsigned long module_kallsyms_lookup_name(const char *name)
 	preempt_enable();
 	return ret;
 }
+
+int module_kallsyms_on_each_symbol(int (*fn)(void *, const char *,
+					     struct module *, unsigned long),
+				   void *data)
+{
+	struct module *mod;
+	unsigned int i;
+	int ret;
+
+	list_for_each_entry(mod, &modules, list) {
+		for (i = 0; i < mod->num_symtab; i++) {
+			ret = fn(data, mod->strtab + mod->symtab[i].st_name,
+				 mod, mod->symtab[i].st_value);
+			if (ret != 0)
+				return ret;
+		}
+	}
+	return 0;
+}
 #endif /* CONFIG_KALLSYMS */
 
 static char *module_flags(struct module *mod, char *buf)
@@ -2744,29 +2753,31 @@ const struct exception_table_entry *search_module_extables(unsigned long addr)
 }
 
 /*
- * Is this a valid module address?
+ * is_module_address - is this address inside a module?
+ * @addr: the address to check.
+ *
+ * See is_module_text_address() if you simply want to see if the address
+ * is code (not data).
  */
-int is_module_address(unsigned long addr)
+bool is_module_address(unsigned long addr)
 {
-	struct module *mod;
+	bool ret;
 
 	preempt_disable();
-
-	list_for_each_entry_rcu(mod, &modules, list) {
-		if (within_module_core(addr, mod)) {
-			preempt_enable();
-			return 1;
-		}
-	}
-
+	ret = __module_address(addr) != NULL;
 	preempt_enable();
 
-	return 0;
+	return ret;
 }
 
-
-/* Is this a valid kernel address? */
-__notrace_funcgraph struct module *__module_text_address(unsigned long addr)
+/*
+ * __module_address - get the module which contains an address.
+ * @addr: the address.
+ *
+ * Must be called with preempt disabled or module mutex held so that
+ * module doesn't get freed during this.
+ */
+__notrace_funcgraph struct module *__module_address(unsigned long addr)
 {
 	struct module *mod;
 
@@ -2774,22 +2785,51 @@ __notrace_funcgraph struct module *__module_text_address(unsigned long addr)
 		return NULL;
 
 	list_for_each_entry_rcu(mod, &modules, list)
-		if (within(addr, mod->module_init, mod->init_text_size)
-		    || within(addr, mod->module_core, mod->core_text_size))
+		if (within_module_core(addr, mod)
+		    || within_module_init(addr, mod))
 			return mod;
 	return NULL;
 }
+EXPORT_SYMBOL_GPL(__module_address);
 
-struct module *module_text_address(unsigned long addr)
+/*
+ * is_module_text_address - is this address inside module code?
+ * @addr: the address to check.
+ *
+ * See is_module_address() if you simply want to see if the address is
+ * anywhere in a module.  See kernel_text_address() for testing if an
+ * address corresponds to kernel or module code.
+ */
+bool is_module_text_address(unsigned long addr)
 {
-	struct module *mod;
+	bool ret;
 
 	preempt_disable();
-	mod = __module_text_address(addr);
+	ret = __module_text_address(addr) != NULL;
 	preempt_enable();
 
+	return ret;
+}
+
+/*
+ * __module_text_address - get the module whose code contains an address.
+ * @addr: the address.
+ *
+ * Must be called with preempt disabled or module mutex held so that
+ * module doesn't get freed during this.
+ */
+struct module *__module_text_address(unsigned long addr)
+{
+	struct module *mod = __module_address(addr);
+	if (mod) {
+		/* Make sure it's within the text section. */
+		if (!within(addr, mod->module_init, mod->init_text_size)
+		    && !within(addr, mod->module_core, mod->core_text_size))
+			mod = NULL;
+	}
 	return mod;
 }
+EXPORT_SYMBOL_GPL(__module_text_address);
 
 /* Don't grab lock, we're oopsing. */
 void print_modules(void)
@@ -2809,9 +2849,17 @@ void print_modules(void)
 }
 
 #ifdef CONFIG_MODVERSIONS
-/* Generate the signature for struct module here, too, for modversions. */
-void struct_module(struct module *mod) { return; }
-EXPORT_SYMBOL(struct_module);
+/* Generate the signature for all relevant module structures here.
+ * If these change, we don't want to try to parse the module. */
+void module_layout(struct module *mod,
+		   struct modversion_info *ver,
+		   struct kernel_param *kp,
+		   struct kernel_symbol *ks,
+		   struct marker *marker,
+		   struct tracepoint *tp)
+{
+}
+EXPORT_SYMBOL(module_layout);
 #endif
 
 #ifdef CONFIG_MARKERS
diff --git a/kernel/params.c b/kernel/params.c
index a1e3025..de273ec 100644
--- a/kernel/params.c
+++ b/kernel/params.c
@@ -24,6 +24,9 @@
 #include <linux/err.h>
 #include <linux/slab.h>
 
+/* We abuse the high bits of "perm" to record whether we kmalloc'ed. */
+#define KPARAM_KMALLOCED	0x80000000
+
 #if 0
 #define DEBUGP printk
 #else
@@ -217,7 +220,19 @@ int param_set_charp(const char *val, struct kernel_param *kp)
 		return -ENOSPC;
 	}
 
-	*(char **)kp->arg = (char *)val;
+	if (kp->perm & KPARAM_KMALLOCED)
+		kfree(*(char **)kp->arg);
+
+	/* This is a hack.  We can't need to strdup in early boot, and we
+	 * don't need to; this mangled commandline is preserved. */
+	if (slab_is_available()) {
+		kp->perm |= KPARAM_KMALLOCED;
+		*(char **)kp->arg = kstrdup(val, GFP_KERNEL);
+		if (!kp->arg)
+			return -ENOMEM;
+	} else
+		*(const char **)kp->arg = val;
+
 	return 0;
 }
 
@@ -571,6 +586,15 @@ void module_param_sysfs_remove(struct module *mod)
 }
 #endif
 
+void destroy_params(const struct kernel_param *params, unsigned num)
+{
+	unsigned int i;
+
+	for (i = 0; i < num; i++)
+		if (params[i].perm & KPARAM_KMALLOCED)
+			kfree(*(char **)params[i].arg);
+}
+
 static void __init kernel_add_sysfs_param(const char *name,
 					  struct kernel_param *kparam,
 					  unsigned int name_skip)
diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index 7e62303..8cc7061 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -1607,12 +1607,12 @@ static void read_symbols(char *modname)
 
 	parse_elf_finish(&info);
 
-	/* Our trick to get versioning for struct_module - it's
+	/* Our trick to get versioning for module struct etc. - it's
 	 * never passed as an argument to an exported function, so
 	 * the automatic versioning doesn't pick it up, but it's really
 	 * important anyhow */
 	if (modversions)
-		mod->unres = alloc_symbol("struct_module", 0, mod->unres);
+		mod->unres = alloc_symbol("module_layout", 0, mod->unres);
 }
 
 #define SZ 500
