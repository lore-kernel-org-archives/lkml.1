Return-Path: <linux-kernel-owner+w=401wt.eu-S1753119AbYLCUHw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753119AbYLCUHw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 15:07:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753657AbYLCTwz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 14:52:55 -0500
Received: from kroah.org ([198.145.64.141]:60057 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752674AbYLCTwv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 14:52:51 -0500
Date: Wed, 3 Dec 2008 11:51:23 -0800
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
       alan@lxorguk.ukuu.org.uk, Ian Campbell <ian.campbell@citrix.com>,
       Ingo Molnar <mingo@elte.hu>, Jeremy Fitzhardinge <jeremy@goop.org>
Subject: [patch 044/104] xen: do not reserve 2 pages of padding between
	hypervisor and fixmap.
Message-ID: <20081203195123.GS8950@kroah.com>
References: <20081203193901.715896543@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="xen-do-not-reserve-2-pages-of-padding-between-hypervisor-and-fixmap.patch"
In-Reply-To: <20081203194725.GA8950@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Ian Campbell <Ian.Campbell@citrix.com>

commit 5dc64a3442b98eaa0e3730c35fcf00cf962a93e7 upstream.

When reserving space for the hypervisor the Xen paravirt backend adds
an extra two pages (this was carried forward from the 2.6.18-xen tree
which had them "for safety"). Depending on various CONFIG options this
can cause the boot time fixmaps to span multiple PMDs which is not
supported and triggers a WARN in early_ioremap_init().

This was exposed by 2216d199b1430d1c0affb1498a9ebdbd9c0de439 which
moved the dmi table parsing earlier.
    x86: fix CONFIG_X86_RESERVE_LOW_64K=y

    The bad_bios_dmi_table() quirk never triggered because we do DMI setup
    too late. Move it a bit earlier.

There is no real reason to reserve these two extra pages and the
fixmap already incorporates FIX_HOLE which serves the same
purpose. None of the other callers of reserve_top_address do this.

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/xen/enlighten.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -1413,7 +1413,7 @@ static void __init xen_reserve_top(void)
 	if (HYPERVISOR_xen_version(XENVER_platform_parameters, &pp) == 0)
 		top = pp.virt_start;
 
-	reserve_top_address(-top + 2 * PAGE_SIZE);
+	reserve_top_address(-top);
 #endif	/* CONFIG_X86_32 */
 }
 

