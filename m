Return-Path: <linux-kernel-owner+w=401wt.eu-S1422900AbXCGR1U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422900AbXCGR1U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 12:27:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422897AbXCGRRw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 12:17:52 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43676 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422890AbXCGRRf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 12:17:35 -0500
Message-Id: <20070307171558.201204297@mini.kroah.org>
References: <20070307171035.150802805@mini.kroah.org>
User-Agent: quilt/0.45-1
Date: Wed, 07 Mar 2007 09:11:54 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, neilb@suse.de, kas@fi.muni.cz,
       Trond.Myklebust@netapp.com
Subject: [patch 079/101] RPM: fix double free in portmapper code
Content-Disposition: inline; filename=rpm-fix-double-free-in-portmapper-code.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Trond Myklebust <Trond.Myklebust@netapp.com>

rpc_run_task is guaranteed to always call ->rpc_release.

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: Neil Brown <neilb@suse.de>
Cc: Jan "Yenya" Kasprzak <kas@fi.muni.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>


---
 net/sunrpc/pmap_clnt.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- linux-2.6.20.1.orig/net/sunrpc/pmap_clnt.c
+++ linux-2.6.20.1/net/sunrpc/pmap_clnt.c
@@ -62,7 +62,10 @@ static inline void pmap_map_free(struct 
 
 static void pmap_map_release(void *data)
 {
-	pmap_map_free(data);
+	struct portmap_args *map = data;
+
+	xprt_put(map->pm_xprt);
+	pmap_map_free(map);
 }
 
 static const struct rpc_call_ops pmap_getport_ops = {
@@ -133,7 +136,7 @@ void rpc_getport(struct rpc_task *task)
 	status = -EIO;
 	child = rpc_run_task(pmap_clnt, RPC_TASK_ASYNC, &pmap_getport_ops, map);
 	if (IS_ERR(child))
-		goto bailout;
+		goto bailout_nofree;
 	rpc_put_task(child);
 
 	task->tk_xprt->stat.bind_count++;
@@ -222,7 +225,6 @@ static void pmap_getport_done(struct rpc
 			child->tk_pid, status, map->pm_port);
 
 	pmap_wake_portmap_waiters(xprt, status);
-	xprt_put(xprt);
 }
 
 /**

--
