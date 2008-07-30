Return-Path: <linux-kernel-owner+w=401wt.eu-S1753861AbYGaA2O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753861AbYGaA2O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 20:28:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761778AbYGaAZu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 20:25:50 -0400
Received: from cantor.suse.de ([195.135.220.2]:39748 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760615AbYGaAZs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 20:25:48 -0400
Date: Wed, 30 Jul 2008 16:59:59 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
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
       alan@lxorguk.ukuu.org.uk,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [patch 57/62] markers: fix markers read barrier for multiple probes
Message-ID: <20080730235959.GE12896@suse.de>
References: <20080730233050.332789722@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="markers-fix-markers-read-barrier-for-multiple-probes.patch"
In-Reply-To: <20080730234915.GA12426@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.26 -stable review patch.  If anyone has any objections, please let
us know.

------------------
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

commit 5def9a3a22e09c99717f41ab7f07ec9e1a1f3ec8 upstream

Paul pointed out two incorrect read barriers in the marker handler code in
the path where multiple probes are connected.  Those are ordering reads of
"ptype" (single or multi probe marker), "multi" array pointer, and "multi"
array data access.

It should be ordered like this :

read ptype
smp_rmb()
read multi array pointer
smp_read_barrier_depends()
access data referenced by multi array pointer

The code with a single probe connected (optimized case, does not have to
allocate an array) has correct memory ordering.

It applies to kernel 2.6.26.x, 2.6.25.x and linux-next.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/marker.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- a/kernel/marker.c
+++ b/kernel/marker.c
@@ -127,6 +127,11 @@ void marker_probe_cb(const struct marker
 		struct marker_probe_closure *multi;
 		int i;
 		/*
+		 * Read mdata->ptype before mdata->multi.
+		 */
+		smp_rmb();
+		multi = mdata->multi;
+		/*
 		 * multi points to an array, therefore accessing the array
 		 * depends on reading multi. However, even in this case,
 		 * we must insure that the pointer is read _before_ the array
@@ -134,7 +139,6 @@ void marker_probe_cb(const struct marker
 		 * in the fast path, so put the explicit barrier here.
 		 */
 		smp_read_barrier_depends();
-		multi = mdata->multi;
 		for (i = 0; multi[i].func; i++) {
 			va_start(args, fmt);
 			multi[i].func(multi[i].probe_private, call_private, fmt,
@@ -177,6 +181,11 @@ void marker_probe_cb_noarg(const struct 
 		struct marker_probe_closure *multi;
 		int i;
 		/*
+		 * Read mdata->ptype before mdata->multi.
+		 */
+		smp_rmb();
+		multi = mdata->multi;
+		/*
 		 * multi points to an array, therefore accessing the array
 		 * depends on reading multi. However, even in this case,
 		 * we must insure that the pointer is read _before_ the array
@@ -184,7 +193,6 @@ void marker_probe_cb_noarg(const struct 
 		 * in the fast path, so put the explicit barrier here.
 		 */
 		smp_read_barrier_depends();
-		multi = mdata->multi;
 		for (i = 0; multi[i].func; i++)
 			multi[i].func(multi[i].probe_private, call_private, fmt,
 				&args);

-- 
