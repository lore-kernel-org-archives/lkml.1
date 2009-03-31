Return-Path: <linux-kernel-owner+w=401wt.eu-S1759425AbZCaXem@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759425AbZCaXem (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 19:34:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763988AbZCaXVh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 19:21:37 -0400
Received: from sous-sol.org ([216.99.217.87]:33277 "EHLO x200.localdomain"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1763978AbZCaXVg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 19:21:36 -0400
Message-Id: <20090331231738.727534186@sous-sol.org>
User-Agent: quilt/0.47-1
Date: Tue, 31 Mar 2009 16:11:23 -0700
From: Chris Wright <chrisw@sous-sol.org>
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
       alan@lxorguk.ukuu.org.uk, Yinghai Lu <yinghai@kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: [patch 38/45] x86: fix 64k corruption-check
References: <20090331231045.719396245@sous-sol.org>
Content-Disposition: inline; filename=x86-fix-64k-corruption-check.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Yinghai Lu <yinghai@kernel.org>

upstream commit: 6d7942dc2a70a7e74c352107b150265602671588

Impact: fix boot crash

Need to exit early if the addr is far above 64k.

The crash got exposed by:

  78a8b35: x86: make e820_update_range() handle small range update

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: <stable@kernel.org>
LKML-Reference: <49BC2279.2030101@kernel.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 arch/x86/kernel/check.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/arch/x86/kernel/check.c
+++ b/arch/x86/kernel/check.c
@@ -86,12 +86,12 @@ void __init setup_bios_corruption_check(
 		if (addr == 0)
 			break;
 
+		if (addr >= corruption_check_size)
+			break;
+
 		if ((addr + size) > corruption_check_size)
 			size = corruption_check_size - addr;
 
-		if (size == 0)
-			break;
-
 		e820_update_range(addr, size, E820_RAM, E820_RESERVED);
 		scan_areas[num_scan_areas].addr = addr;
 		scan_areas[num_scan_areas].size = size;

