Return-Path: <linux-kernel-owner+w=401wt.eu-S1422799AbXCGROl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422799AbXCGROl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 12:14:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422796AbXCGROk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 12:14:40 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42958 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422791AbXCGROh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 12:14:37 -0500
Message-Id: <20070307171259.680796765@mini.kroah.org>
References: <20070307171035.150802805@mini.kroah.org>
User-Agent: quilt/0.45-1
Date: Wed, 07 Mar 2007 09:11:06 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Neil Brown <neilb@suse.de>
Subject: [patch 031/101] Avoid using nfsd process pools on SMP machines.
Content-Disposition: inline; filename=avoid-using-nfsd-process-pools-on-smp-machines.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: NeilBrown <neilb@suse.de>


process-pools have real benefits for NUMA, but on SMP
machines they only work if network interface interrupts
go to all CPUs (via round-robin or multiple nics).  This is
not always the case, so disable the pools in this case until
a better solution is developped.

Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

diff .prev/net/sunrpc/svc.c ./net/sunrpc/svc.c
---
 net/sunrpc/svc.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- linux-2.6.20.1.orig/net/sunrpc/svc.c
+++ linux-2.6.20.1/net/sunrpc/svc.c
@@ -79,7 +79,11 @@ svc_pool_map_choose_mode(void)
 		 * x86_64 kernel on Xeons.  In this case we
 		 * want to divide the pools on cpu boundaries.
 		 */
-		return SVC_POOL_PERCPU;
+		/* actually, unless your IRQs round-robin nicely,
+		 * this turns out to be really bad, so just
+		 * go GLOBAL for now until a better fix can be developped
+		 */
+		return SVC_POOL_GLOBAL;
 	}
 
 	/* default: one global pool */

--
