Return-Path: <linux-kernel-owner+w=401wt.eu-S1763452AbYGaA0e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763452AbYGaA0e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 20:26:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762835AbYGaAYO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 20:24:14 -0400
Received: from mx2.suse.de ([195.135.220.15]:37752 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762625AbYGaAYN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 20:24:13 -0400
Date: Wed, 30 Jul 2008 16:59:50 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Jeff Dike <jdike@linux.intel.com>
Subject: [patch 53/62] UML - Fix boot crash
Message-ID: <20080730235950.GA12896@suse.de>
References: <20080730233050.332789722@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="uml-fix-boot-crash.patch"
In-Reply-To: <20080730234915.GA12426@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.26 -stable review patch.  If anyone has any objections, please let
us know.

------------------
From: Jeff Dike <jdike@addtoit.com>

commit 7c1fed03b9fa32d4323d5caa6a9c7dcdd7eba767 upstream

My copying of linux/init.h didn't go far enough.  The definition of
__used singled out gcc minor version 3, but didn't care what the major
version was.  This broke when unit-at-a-time was added and gcc started
throwing out initcalls.

This results in an early boot crash when ptrace tries to initialize a
process with an empty, uninitialized register set.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/um/include/init.h |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/arch/um/include/init.h
+++ b/arch/um/include/init.h
@@ -45,6 +45,8 @@ typedef void (*exitcall_t)(void);
 # define __section(S) __attribute__ ((__section__(#S)))
 #endif
 
+#if __GNUC__ == 3
+
 #if __GNUC_MINOR__ >= 3
 # define __used			__attribute__((__used__))
 #else
@@ -52,6 +54,12 @@ typedef void (*exitcall_t)(void);
 #endif
 
 #else
+#if __GNUC__ == 4
+# define __used			__attribute__((__used__))
+#endif
+#endif
+
+#else
 #include <linux/compiler.h>
 #endif
 /* These are for everybody (although not all archs will actually

-- 
