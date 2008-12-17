Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1759916AbYLQALT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759916AbYLQALT (ORCPT <rfc822;akpm@linux-foundation.org>);
	Tue, 16 Dec 2008 19:11:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759753AbYLQAGR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 19:06:17 -0500
Received: from kroah.org ([198.145.64.141]:41380 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759719AbYLQAGN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 19:06:13 -0500
Date: Tue, 16 Dec 2008 16:04:35 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
        Zwane Mwaikambo <zwane@arm.linux.org.uk>,
        "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
        Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
        Chris Wedgwood <reviews@ml.cw.f00f.org>,
        Michael Krufky <mkrufky@linuxtv.org>,
        Chuck Ebbert <cebbert@redhat.com>,
        Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
        Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
        Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [patch 18/22] SUNRPC: Fix a performance regression in the RPC
	authentication code
Message-ID: <20081217000435.GS4504@kroah.com>
References: <20081216235704.347182084@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="sunrpc-fix-a-performance-regression-in-the-rpc-authentication-code.patch"
In-Reply-To: <20081217000306.GA4504@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Trond Myklebust <Trond.Myklebust@netapp.com>

commit 23918b03060f6e572168fdde1798a905679d2e06 upstream.

Fix a regression reported by Max Kellermann whereby kernel profiling
showed that his clients were spending 45% of their time in
rpcauth_lookup_credcache.

It turns out that although his processes had identical uid/gid/groups,
generic_match() was failing to detect this, because the task->group_info
pointers were not shared. This again lead to the creation of a huge number
of identical credentials at the RPC layer.

The regression is fixed by comparing the contents of task->group_info
if the actual pointers are not identical.

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/sunrpc/auth_generic.c |   20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

--- a/net/sunrpc/auth_generic.c
+++ b/net/sunrpc/auth_generic.c
@@ -133,13 +133,29 @@ static int
 generic_match(struct auth_cred *acred, struct rpc_cred *cred, int flags)
 {
 	struct generic_cred *gcred = container_of(cred, struct generic_cred, gc_base);
+	int i;
 
 	if (gcred->acred.uid != acred->uid ||
 	    gcred->acred.gid != acred->gid ||
-	    gcred->acred.group_info != acred->group_info ||
 	    gcred->acred.machine_cred != acred->machine_cred)
-		return 0;
+		goto out_nomatch;
+
+	/* Optimisation in the case where pointers are identical... */
+	if (gcred->acred.group_info == acred->group_info)
+		goto out_match;
+
+	/* Slow path... */
+	if (gcred->acred.group_info->ngroups != acred->group_info->ngroups)
+		goto out_nomatch;
+	for (i = 0; i < gcred->acred.group_info->ngroups; i++) {
+		if (GROUP_AT(gcred->acred.group_info, i) !=
+				GROUP_AT(acred->group_info, i))
+			goto out_nomatch;
+	}
+out_match:
 	return 1;
+out_nomatch:
+	return 0;
 }
 
 void __init rpc_init_generic_auth(void)

