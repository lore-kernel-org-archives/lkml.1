Return-Path: <linux-kernel-owner+w=401wt.eu-S1760884AbYLKTrH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760884AbYLKTrH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 14:47:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757841AbYLKTTg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 14:19:36 -0500
Received: from kroah.org ([198.145.64.141]:56846 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756842AbYLKTTf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 14:19:35 -0500
Date: Thu, 11 Dec 2008 11:16:49 -0800
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
       alan@lxorguk.ukuu.org.uk, Grant Likely <grant.likely@secretlab.ca>,
       Josh Boyer <jwboyer@linux.vnet.ibm.com>
Subject: [patch 80/83] powerpc/virtex5: Fix Virtex5 machine check handling
Message-ID: <20081211191649.GB5894@kroah.com>
References: <20081211190201.612240183@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="powerpc-virtex5-fix-virtex5-machine-check-handling.patch"
In-Reply-To: <20081211191014.GA5759@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Grant Likely <grant.likely@secretlab.ca>

commit 640d17d60e83401e10e66a0ab6e9e2d6350df656 upstream.

The 440x5 core in the Virtex5 uses the 440A type machine check
(ie, they have MCSRR0/MCSRR1). They thus need to call the
appropriate fixup function to hook the right variant of the
exception.

Without this, all machine checks become fatal due to loss
of context when entering the exception handler.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
Signed-off-by: Josh Boyer <jwboyer@linux.vnet.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/powerpc/kernel/cpu_setup_44x.S |    1 +
 arch/powerpc/kernel/cputable.c      |    3 +++
 2 files changed, 4 insertions(+)

--- a/arch/powerpc/kernel/cpu_setup_44x.S
+++ b/arch/powerpc/kernel/cpu_setup_44x.S
@@ -35,6 +35,7 @@ _GLOBAL(__setup_cpu_440grx)
 _GLOBAL(__setup_cpu_460ex)
 _GLOBAL(__setup_cpu_460gt)
 	b	__init_fpu_44x
+_GLOBAL(__setup_cpu_440x5)
 _GLOBAL(__setup_cpu_440gx)
 _GLOBAL(__setup_cpu_440spe)
 	b	__fixup_440A_mcheck
--- a/arch/powerpc/kernel/cputable.c
+++ b/arch/powerpc/kernel/cputable.c
@@ -39,6 +39,7 @@ extern void __setup_cpu_440epx(unsigned 
 extern void __setup_cpu_440gx(unsigned long offset, struct cpu_spec* spec);
 extern void __setup_cpu_440grx(unsigned long offset, struct cpu_spec* spec);
 extern void __setup_cpu_440spe(unsigned long offset, struct cpu_spec* spec);
+extern void __setup_cpu_440x5(unsigned long offset, struct cpu_spec* spec);
 extern void __setup_cpu_460ex(unsigned long offset, struct cpu_spec* spec);
 extern void __setup_cpu_460gt(unsigned long offset, struct cpu_spec* spec);
 extern void __setup_cpu_603(unsigned long offset, struct cpu_spec* spec);
@@ -1463,6 +1464,8 @@ static struct cpu_spec __initdata cpu_sp
 		.cpu_user_features	= COMMON_USER_BOOKE,
 		.icache_bsize		= 32,
 		.dcache_bsize		= 32,
+		.cpu_setup		= __setup_cpu_440x5,
+		.machine_check		= machine_check_440A,
 		.platform		= "ppc440",
 	},
 	{ /* 460EX */

