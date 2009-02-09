Return-Path: <linux-kernel-owner+w=401wt.eu-S1754857AbZBIVlE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754857AbZBIVlE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 16:41:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752805AbZBIVky
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 16:40:54 -0500
Received: from ns2.suse.de ([195.135.220.15]:56073 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752106AbZBIVkw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 16:40:52 -0500
Message-ID: <4990A27C.2090407@suse.com>
Date: Mon, 09 Feb 2009 16:39:08 -0500
From: Jeff Mahoney <jeffm@suse.com>
Organization: SUSE Labs, Novell, Inc
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Kyle McMartin <kyle@infradead.org>
Cc: Chuck Ebbert <cebbert@redhat.com>, linux-kernel@vger.kernel.org,
       Chris Mason <chris.mason@oracle.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: Build failure with latest -git: btrfs on ppc64
References: <20090207155039.3b6a7429@dhcp-100-2-144.bos.redhat.com> <20090207232458.GB23407@bombadil.infradead.org>
In-Reply-To: <20090207232458.GB23407@bombadil.infradead.org>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Kyle McMartin wrote:
> On Sat, Feb 07, 2009 at 03:50:39PM -0500, Chuck Ebbert wrote:
>> fs/btrfs/locking.c: In function 'btrfs_path_lock_waiting':
>> fs/btrfs/locking.c:254: error: implicit declaration of function '__raw_spin_is_contended'
>>
>> Looks like spin_is_contended() is only available on mips and x86??
>>
> 
> Looks to be if there are other folks in line for the ticket lock.
> 
> Arguably this should probably be something silly in spinlock.h like,
> 
> #ifndef __raw_spin_is_contended
> # define spin_is_contended (0)
> #else
> # define spin_is_contended(x) __raw_spin_is_contended((x))
> #endif
> 
> or something since in theory anybody has a chance of acquiring it next
> (well, lies because caches bias, but there's no waiters at least.)
> 
> Either that, or we just define it to be spin_is_locked if the assumption
> is that the lock will continue to be locked...

I fixed it in my tree using the following patch.

From: Jeff Mahoney <jeffm@suse.com>
Subject: [PATCH] spin_is_contended Kconfig fixes

 include/linux/spinlock.h contains the following chunk:
 #ifdef CONFIG_GENERIC_LOCKBREAK
 #define spin_is_contended(lock) ((lock)->break_lock)
 #else
 #define spin_is_contended(lock) __raw_spin_is_contended(&(lock)->raw_lock)
 #endif

 __raw_spin_is_contended() is only implemented on mips and x86.

 Prior to a recent commit against btrfs, spin_needbreak was the only
 user of spin_is_contended, and it returns 0 when !CONFIG_PREEMPT. The
 architecture Kconfigs reflect that, depending on PREEMPT to enable
 GENERIC_LOCKBREAK. With the btrfs changes, this is causing build
 failures on anything !x86 (and mips, but I don't build on mips).

 Now that there is another user of spin_is_contended, the PREEMPT
 dependency is obsolete. This removes the dependency.

 This patch also adds GENERIC_LOCKBREAK entries to architectures that
 didn't have it and offer SMP support.

 The removal of the SPARC64 dependency isn't an oversight - SMP is
 supported for 32-bit sparc, so it would run into the same problem.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
- ---
 arch/alpha/Kconfig    |    5 +++++
 arch/arm/Kconfig      |    2 +-
 arch/blackfin/Kconfig |    5 +++++
 arch/ia64/Kconfig     |    2 +-
 arch/m32r/Kconfig     |    2 +-
 arch/parisc/Kconfig   |    2 +-
 arch/powerpc/Kconfig  |    2 +-
 arch/s390/Kconfig     |    2 +-
 arch/sh/Kconfig       |    7 ++++++-
 arch/sparc/Kconfig    |    2 +-
 10 files changed, 23 insertions(+), 8 deletions(-)

- --- a/arch/alpha/Kconfig
+++ b/arch/alpha/Kconfig
@@ -25,6 +25,11 @@ config MMU
 config RWSEM_GENERIC_SPINLOCK
 	bool
 
+config GENERIC_LOCKBREAK
+        bool
+        default y
+        depends on SMP
+
 config RWSEM_XCHGADD_ALGORITHM
 	bool
 	default y
- --- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -115,7 +115,7 @@ config GENERIC_IRQ_PROBE
 config GENERIC_LOCKBREAK
 	bool
 	default y
- -	depends on SMP && PREEMPT
+	depends on SMP
 
 config RWSEM_GENERIC_SPINLOCK
 	bool
- --- a/arch/blackfin/Kconfig
+++ b/arch/blackfin/Kconfig
@@ -21,6 +21,11 @@ config RWSEM_XCHGADD_ALGORITHM
 	bool
 	default n
 
+config GENERIC_LOCKBREAK
+        bool
+        default y
+        depends on SMP
+
 config BLACKFIN
 	bool
 	default y
- --- a/arch/ia64/Kconfig
+++ b/arch/ia64/Kconfig
@@ -58,7 +58,7 @@ config IOMMU_HELPER
 config GENERIC_LOCKBREAK
 	bool
 	default y
- -	depends on SMP && PREEMPT
+	depends on SMP
 
 config RWSEM_XCHGADD_ALGORITHM
 	bool
- --- a/arch/m32r/Kconfig
+++ b/arch/m32r/Kconfig
@@ -243,7 +243,7 @@ config IRAM_SIZE
 config GENERIC_LOCKBREAK
 	bool
 	default y
- -	depends on SMP && PREEMPT
+	depends on SMP
 
 config RWSEM_GENERIC_SPINLOCK
 	bool
- --- a/arch/parisc/Kconfig
+++ b/arch/parisc/Kconfig
@@ -27,7 +27,7 @@ config STACK_GROWSUP
 config GENERIC_LOCKBREAK
 	bool
 	default y
- -	depends on SMP && PREEMPT
+	depends on SMP
 
 config RWSEM_GENERIC_SPINLOCK
 	def_bool y
- --- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -75,7 +75,7 @@ config RWSEM_XCHGADD_ALGORITHM
 config GENERIC_LOCKBREAK
 	bool
 	default y
- -	depends on SMP && PREEMPT
+	depends on SMP
 
 config ARCH_HAS_ILOG2_U32
 	bool
- --- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -63,7 +63,7 @@ config NO_DMA
 config GENERIC_LOCKBREAK
 	bool
 	default y
- -	depends on SMP && PREEMPT
+	depends on SMP
 
 config PGSTE
 	bool
- --- a/arch/sh/Kconfig
+++ b/arch/sh/Kconfig
@@ -43,6 +43,11 @@ config RWSEM_GENERIC_SPINLOCK
 config RWSEM_XCHGADD_ALGORITHM
 	bool
 
+config GENERIC_LOCKBREAK
+        bool
+        default y
+        depends on SMP
+
 config GENERIC_BUG
 	def_bool y
 	depends on BUG && SUPERH32
@@ -82,7 +87,7 @@ config GENERIC_CLOCKEVENTS_BROADCAST
 
 config GENERIC_LOCKBREAK
 	def_bool y
- -	depends on SMP && PREEMPT
+	depends on SMP
 
 config SYS_SUPPORTS_PM
 	bool
- --- a/arch/sparc/Kconfig
+++ b/arch/sparc/Kconfig
@@ -298,7 +298,7 @@ config US3_MC
 config GENERIC_LOCKBREAK
 	bool
 	default y
- -	depends on SPARC64 && SMP && PREEMPT
+	depends on SMP
 
 choice
 	prompt "SPARC64 Huge TLB Page Size"


- -- 
Jeff Mahoney
SUSE Labs
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iEYEARECAAYFAkmQonwACgkQLPWxlyuTD7JPyQCghVJ0vgGlCxAbKZQMPaJxrIYZ
ePYAoIbujOBBnc0wqgn2bG+5KB11g8HL
=7r7Q
-----END PGP SIGNATURE-----
