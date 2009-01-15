Return-Path: <linux-kernel-owner+w=401wt.eu-S936026AbZAOWo3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936026AbZAOWo3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 17:44:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933789AbZAOWD6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 17:03:58 -0500
Received: from kroah.org ([198.145.64.141]:39075 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S934011AbZAOWDv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 17:03:51 -0500
Date: Thu, 15 Jan 2009 14:01:51 -0800
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
       alan@lxorguk.ukuu.org.uk, Brian King <brking@linux.vnet.ibm.com>,
       Paul Mackerras <paulus@samba.org>
Subject: [patch 75/85] powerpc: Disable Collaborative Memory Manager for
	kdump
Message-ID: <20090115220151.GX17227@kroah.com>
References: <20090115215237.906089480@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="powerpc-disable-collaborative-memory-manager-for-kdump.patch"
In-Reply-To: <20090115215812.GA17227@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Brian King <brking@linux.vnet.ibm.com>

commit 2218108e182fd8a6d9106077833ed7ad05fc8e75 upstream.

When running Active Memory Sharing, the Collaborative Memory Manager
(CMM) may mark some pages as "loaned" with the hypervisor.
Periodically, the CMM will query the hypervisor for a loan request,
which is a single signed value.  When kexec'ing into a kdump kernel,
the CMM driver in the kdump kernel is not aware of the pages the
previous kernel had marked as "loaned", so the hypervisor and the CMM
driver are out of sync.  This results in the CMM driver getting a
negative loan request, which can then get treated as a large unsigned
value and can cause kdump to hang due to the CMM driver inflating too
large.  Since there really is no clean way for the CMM driver in the
kdump kernel to clean this up, simply disable CMM in the kdump kernel.
This fixes hangs we were seeing doing kdump with AMS.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
Signed-off-by: Paul Mackerras <paulus@samba.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/powerpc/platforms/pseries/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/powerpc/platforms/pseries/Kconfig
+++ b/arch/powerpc/platforms/pseries/Kconfig
@@ -54,7 +54,7 @@ config PPC_SMLPAR
 
 config CMM
 	tristate "Collaborative memory management"
-	depends on PPC_SMLPAR
+	depends on PPC_SMLPAR && !CRASH_DUMP
 	default y
 	help
 	  Select this option, if you want to enable the kernel interface

