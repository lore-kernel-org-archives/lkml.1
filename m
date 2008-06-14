Return-Path: <linux-kernel-owner+w=401wt.eu-S1761064AbYFNA2J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761064AbYFNA2J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 20:28:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761200AbYFNAPl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 20:15:41 -0400
Received: from ns2.suse.de ([195.135.220.15]:52243 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762310AbYFNAPi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 20:15:38 -0400
Date: Fri, 13 Jun 2008 17:12:20 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Roman Zippel <zippel@linux-m68k.org>,
       Ingo Molnar <mingo@elte.hu>, Ravikiran Thirumalai <kiran@scalex86.org>
Subject: [patch 46/47] x86: fix recursive dependencies
Message-ID: <20080614001220.GT24698@suse.de>
References: <20080613234753.235721454@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="x86-fix-recursive-dependencies.patch"
In-Reply-To: <20080614000840.GA24659@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Roman Zippel <zippel@linux-m68k.org>

commit 823c248e7cc75b4f22da914b01f8e5433cff197e in mainline

The proper dependency check uncovered a few dependency problems,
the subarchitecture used a mixture of selects and depends on SMP
and PCI dependency was messed up.

Signed-off-by: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Ravikiran Thirumalai <kiran@scalex86.org>

---
 arch/x86/Kconfig |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -246,8 +246,7 @@ config X86_ELAN
 
 config X86_VOYAGER
 	bool "Voyager (NCR)"
-	depends on X86_32
-	select SMP if !BROKEN
+	depends on X86_32 && (SMP || BROKEN)
 	help
 	  Voyager is an MCA-based 32-way capable SMP architecture proprietary
 	  to NCR Corp.  Machine classes 345x/35xx/4100/51xx are Voyager-based.
@@ -259,9 +258,8 @@ config X86_VOYAGER
 
 config X86_NUMAQ
 	bool "NUMAQ (IBM/Sequent)"
-	select SMP
+	depends on SMP && X86_32
 	select NUMA
-	depends on X86_32
 	help
 	  This option is used for getting Linux to run on a (IBM/Sequent) NUMA
 	  multiquad box. This changes the way that processors are bootstrapped,
@@ -332,7 +330,7 @@ config X86_RDC321X
 
 config X86_VSMP
 	bool "Support for ScaleMP vSMP"
-	depends on X86_64 && PCI
+	depends on X86_64
 	 help
 	  Support for ScaleMP vSMP systems.  Say 'Y' here if this kernel is
 	  supposed to run on these EM64T-based machines.  Only choose this option
@@ -1384,7 +1382,7 @@ endmenu
 menu "Bus options (PCI etc.)"
 
 config PCI
-	bool "PCI support" if !X86_VISWS
+	bool "PCI support" if !X86_VISWS && !X86_VSMP
 	depends on !X86_VOYAGER
 	default y
 	select ARCH_SUPPORTS_MSI if (X86_LOCAL_APIC && X86_IO_APIC)

-- 
