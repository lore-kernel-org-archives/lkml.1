Return-Path: <linux-kernel-owner+w=401wt.eu-S1756576AbYKLAmy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756576AbYKLAmy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 19:42:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753924AbYKLA1D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 19:27:03 -0500
Received: from kroah.org ([198.145.64.141]:42622 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753903AbYKLA1A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 19:27:00 -0500
Date: Tue, 11 Nov 2008 16:24:27 -0800
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
       alan@lxorguk.ukuu.org.uk, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Pavel Machek <pavel@suse.cz>
Subject: [patch 44/49] Fix __pfn_to_page(pfn) for CONFIG_DISCONTIGMEM=y
Message-ID: <20081112002427.GS10989@kroah.com>
References: <20081112001401.926965113@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="fix-__pfn_to_page-for-config_discontigmem-y.patch"
In-Reply-To: <20081112002215.GA10989@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Rafael J. Wysocki <rjw@sisk.pl>

commit c5d712433ff57a66d8fb79a57a4fc7a7c3467b97 upstream

Fix the __pfn_to_page(pfn) macro so that it doesn't evaluate its
argument twice in the CONFIG_DISCONTIGMEM=y case, because 'pfn' may
be a result of a funtion call having side effects.

For example, the hibernation code applies pfn_to_page(pfn) to the
result of a function returning the pfn corresponding to the next set
bit in a bitmap and the current bit position is modified on each
call.  This leads to "interesting" failures for CONFIG_DISCONTIGMEM=y
due to the current behavior of __pfn_to_page(pfn).

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Pavel Machek <pavel@suse.cz>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/asm-generic/memory_model.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/asm-generic/memory_model.h
+++ b/include/asm-generic/memory_model.h
@@ -34,7 +34,7 @@
 
 #define __pfn_to_page(pfn)			\
 ({	unsigned long __pfn = (pfn);		\
-	unsigned long __nid = arch_pfn_to_nid(pfn);  \
+	unsigned long __nid = arch_pfn_to_nid(__pfn);  \
 	NODE_DATA(__nid)->node_mem_map + arch_local_page_offset(__pfn, __nid);\
 })
 

-- 
