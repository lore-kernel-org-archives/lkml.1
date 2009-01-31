Return-Path: <linux-kernel-owner+w=401wt.eu-S1760330AbZAaDFc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760330AbZAaDFc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 22:05:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757015AbZAaCrf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 21:47:35 -0500
Received: from kroah.org ([198.145.64.141]:55356 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756807AbZAaCrZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 21:47:25 -0500
Date: Fri, 30 Jan 2009 18:42:50 -0800
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
       alan@lxorguk.ukuu.org.uk, Arjan van de Ven <arjan@linux.intel.com>,
       Ingo Molnar <mingo@elte.hu>, Kyle McMartin <kyle@redhat.com>
Subject: [patch 18/43] resources: skip sanity check of busy resources
Message-ID: <20090131024250.GS12368@kroah.com>
References: <20090131022548.656772939@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="resources-skip-sanity-check-of-busy-resources.patch"
In-Reply-To: <20090131024158.GA12368@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Arjan van de Ven <arjan@linux.intel.com>

commit 3ac52669c7a24b93663acfcab606d1065ed1accd upstream.

Impact: reduce false positives in iomem_map_sanity_check()

Some drivers (vesafb) only map/reserve a portion of a resource.
If then some other driver comes in and maps the whole resource,
the current code WARN_ON's. This is not the intent of the checks
in iomem_map_sanity_check(); rather these checks want to
warn when crossing *hardware* resources only.

This patch skips BUSY resources as suggested by Linus.

Note: having two drivers talk to the same hardware at the same
time is obviously not optimal behavior, but that's a separate story.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Kyle McMartin <kyle@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/resource.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/kernel/resource.c
+++ b/kernel/resource.c
@@ -853,6 +853,15 @@ int iomem_map_sanity_check(resource_size
 		if (PFN_DOWN(p->start) <= PFN_DOWN(addr) &&
 		    PFN_DOWN(p->end) >= PFN_DOWN(addr + size - 1))
 			continue;
+		/*
+		 * if a resource is "BUSY", it's not a hardware resource
+		 * but a driver mapping of such a resource; we don't want
+		 * to warn for those; some drivers legitimately map only
+		 * partial hardware resources. (example: vesafb)
+		 */
+		if (p->flags & IORESOURCE_BUSY)
+			continue;
+
 		printk(KERN_WARNING "resource map sanity check conflict: "
 		       "0x%llx 0x%llx 0x%llx 0x%llx %s\n",
 		       (unsigned long long)addr,

