Return-Path: <linux-kernel-owner+w=401wt.eu-S932428AbZLDSHq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932428AbZLDSHq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 13:07:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932324AbZLDSHo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 13:07:44 -0500
Received: from g4t0016.houston.hp.com ([15.201.24.19]:9360 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932318AbZLDSHn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 13:07:43 -0500
Date: Fri, 4 Dec 2009 11:07:49 -0700
From: Alex Chiang <achiang@hp.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: sam@ravnborg.org, mmarek@suse.cz
Subject: kbuild - hostprogs not seeing CONFIG_FOO?
Message-ID: <20091204180749.GA28311@ldl.fc.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm hoping someone can help me understand this because I don't
have the Makefile-fu to figure out what's going on.

I'm trying to patch a helper program: Documentation/vm/page-types.c

The interesting part of the patch is this:

+enum pageflags {
+	PG_locked,              /* Page is locked. Don't touch. */
+	PG_error,
+	PG_referenced,
+	PG_uptodate,
+	PG_dirty,
+	PG_lru,
+	PG_active,
+	PG_slab,
+	PG_owner_priv_1,        /* Owner use. If pagecache, fs may use*/
+	PG_arch_1,
+	PG_reserved,
+	PG_private,             /* If pagecache, has fs-private data */
+	PG_private_2,           /* If pagecache, has fs aux data */
+	PG_writeback,           /* Page is under writeback */
+#ifdef CONFIG_PAGEFLAGS_EXTENDED
+	PG_head,                /* A head page */
+	PG_tail,                /* A tail page */
+#else
+	PG_compound,            /* A compound page */
+#endif
+	PG_swapcache,           /* Swap page: swp_entry_t in private */
+	PG_mappedtodisk,        /* Has blocks allocated on-disk */
+	PG_reclaim,             /* To be reclaimed asap */
+	PG_buddy,               /* Page is free, on buddy lists */
+	PG_swapbacked,          /* Page is backed by RAM/swap */
+	PG_unevictable,         /* Page is "unevictable"  */
+#ifdef CONFIG_MMU
+	PG_mlocked,             /* Page is vma mlocked */
+#endif
+#ifdef CONFIG_ARCH_USES_PG_UNCACHED
+	PG_uncached,            /* Page has been mapped as uncached */
+#endif
+#ifdef CONFIG_MEMORY_FAILURE
+	PG_hwpoison,            /* hardware poisoned page. Don't touch */
+#endif
+	__NR_PAGEFLAGS,
+};

The #ifdefs are what I care about. I want to build this helper
program with the same config that I build the kernel so it can
accurately describe page flags.

	src/ia64 # grep CONFIG_PAGEFLAGS_EXTENDED .config
	CONFIG_PAGEFLAGS_EXTENDED=y

	src/ia64 # grep CONFIG_PAGEFLAGS_EXTENDED include/generated/autoconf.h 
	#define CONFIG_PAGEFLAGS_EXTENDED 1

	src/ia64 # grep CONFIG_PAGEFLAGS_EXTENDED include/config/auto.conf
	CONFIG_PAGEFLAGS_EXTENDED=y

But when I build, it doesn't seem to be getting those config
values. I determined this with a test case using the binary.

As far as I can tell, hostprogs *should* be getting all the same
stuff as the rest of the tree when building, but in my case, it's
clearly not.

Operator error? Something else?

Thanks,
/ac


coffee0:/usr/local/src/ia64 # make V=1 Documentation/vm/
make -f scripts/Makefile.build obj=arch/ia64/kernel include/generated/nr-irqs.h
make[1]: `include/generated/nr-irqs.h' is up to date.
rm -f include/config/kernel.release
echo 2.6.32-rc7-mm1 > include/config/kernel.release
set -e; : '  CHK     include/linux/version.h'; mkdir -p include/linux/; 	(echo \#define LINUX_VERSION_CODE 132640; echo '#define KERNEL_VERSION(a,b,c) (((a) << 16) + ((b) << 8) + (c))';) < /usr/local/src/ia64/Makefile > include/linux/version.h.tmp; if [ -r include/linux/version.h ] && cmp -s include/linux/version.h include/linux/version.h.tmp; then rm -f include/linux/version.h.tmp; else : '  UPD     include/linux/version.h'; mv -f include/linux/version.h.tmp include/linux/version.h; fi
set -e; : '  CHK     include/generated/utsrelease.h'; mkdir -p include/generated/; 	if [ `echo -n "2.6.32-rc7-mm1" | wc -c ` -gt 64 ]; then echo '"2.6.32-rc7-mm1" exceeds 64 characters' >&2; exit 1; fi; (echo \#define UTS_RELEASE \"2.6.32-rc7-mm1\";) < include/config/kernel.release > include/generated/utsrelease.h.tmp; if [ -r include/generated/utsrelease.h ] && cmp -s include/generated/utsrelease.h include/generated/utsrelease.h.tmp; then rm -f include/generated/utsrelease.h.tmp; else : '  UPD     include/generated/utsrelease.h'; mv -f include/generated/utsrelease.h.tmp include/generated/utsrelease.h; fi
mkdir -p .tmp_versions 
make -f scripts/Makefile.build obj=scripts/basic
make -f scripts/Makefile.build obj=.
mkdir -p kernel/
mkdir -p arch/ia64/kernel/
make -f scripts/Makefile.build obj=. missing-syscalls
  /bin/sh scripts/checksyscalls.sh gcc -Wp,-MD,./.missing-syscalls.d  -nostdinc -isystem /usr/lib/gcc/ia64-suse-linux/4.3/include -I/usr/local/src/ia64/arch/ia64/include -Iinclude  -include include/generated/autoconf.h -D__KERNEL__ -DHAVE_WORKING_TEXT_ALIGN -DHAVE_MODEL_SMALL_ATTRIBUTE -DHAVE_SERIALIZE_DIRECTIVE -Wall -Wundef -Wstrict-prototypes -Wno-trigraphs -fno-strict-aliasing -fno-common -Werror-implicit-function-declaration -Wno-format-security -fno-delete-null-pointer-checks -Os -pipe -ffixed-r13 -mfixed-range=f12-f15,f32-f127 -falign-functions=32 -frename-registers -fno-optimize-sibling-calls -fno-stack-protector -fomit-frame-pointer -g -Wdeclaration-after-statement -Wno-pointer-sign -fno-strict-overflow  -mconstant-gp -D"KBUILD_STR(s)=#s" -D"KBUILD_BASENAME=KBUILD_STR(missing_syscalls)"  -D"KBUILD_MODNAME=KBUILD_STR(missing_syscalls)" -D"DEBUG_HASH=8" -D"DEBUG_HASH2=54"
<stdin>:1519:2: warning: #warning syscall perf_event_open not implemented
<stdin>:1523:2: warning: #warning syscall recvmmsg not implemented
<stdin>:1527:2: warning: #warning syscall fanotify_init not implemented
<stdin>:1531:2: warning: #warning syscall fanotify_mark not implemented
make -f scripts/Makefile.build obj=scripts
make -f scripts/Makefile.build obj=scripts/genksyms
make -f scripts/Makefile.build obj=scripts/mod
mkdir -p .tmp_versions 
make KBUILD_MODULES=1 \
	-f scripts/Makefile.build obj=Documentation/vm
(cat /dev/null; ) > Documentation/vm/modules.order
  gcc -Wp,-MD,Documentation/vm/.page-types.d -Wall -Wmissing-prototypes -Wstrict-prototypes -O2 -fomit-frame-pointer     -o Documentation/vm/page-types Documentation/vm/page-types.c  

