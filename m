Return-Path: <linux-kernel-owner+w=401wt.eu-S937495AbYBWAsy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937495AbYBWAsy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 19:48:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933171AbYBWAgH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 19:36:07 -0500
Received: from mail.suse.de ([195.135.220.2]:45004 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759178AbYBWAgE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 19:36:04 -0500
Date: Fri, 22 Feb 2008 16:31:23 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 31/38] S390: Fix futex_atomic_cmpxchg_std inline assembly.
Message-ID: <20080223003123.GF7268@suse.de>
References: <20080223001946.979768610@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="s390-fix-futex_atomic_cmpxchg_std-inline-assembly.patch"
In-Reply-To: <20080223002907.GA7268@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.24-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Heiko Carstens <heiko.carstens@de.ibm.com>

commit: d5b02b3ff1d9a2e1074f559c84ed378cfa6fc3c0 upstream

Add missing exception table entry so that the kernel can handle
proctection exceptions as well on the cs instruction. Currently only
specification exceptions are handled correctly.
The missing entry allows user space to crash the kernel.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/s390/lib/uaccess_std.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/arch/s390/lib/uaccess_std.c
+++ b/arch/s390/lib/uaccess_std.c
@@ -293,10 +293,10 @@ int futex_atomic_cmpxchg_std(int __user 
 
 	asm volatile(
 		"   sacf 256\n"
-		"   cs   %1,%4,0(%5)\n"
-		"0: lr   %0,%1\n"
-		"1: sacf 0\n"
-		EX_TABLE(0b,1b)
+		"0: cs   %1,%4,0(%5)\n"
+		"1: lr   %0,%1\n"
+		"2: sacf 0\n"
+		EX_TABLE(0b,2b) EX_TABLE(1b,2b)
 		: "=d" (ret), "+d" (oldval), "=m" (*uaddr)
 		: "0" (-EFAULT), "d" (newval), "a" (uaddr), "m" (*uaddr)
 		: "cc", "memory" );

-- 
