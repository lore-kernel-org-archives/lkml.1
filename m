Return-Path: <linux-kernel-owner+w=401wt.eu-S1763571AbZCNBoS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763571AbZCNBoS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 21:44:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754932AbZCNBVK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 21:21:10 -0400
Received: from kroah.org ([198.145.64.141]:35446 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754149AbZCNBUs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 21:20:48 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Mar 13 18:10:41 2009
Message-Id: <20090314011041.178682760@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 13 Mar 2009 18:10:43 -0700
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
       alan@lxorguk.ukuu.org.uk, Paul Moore <paul.moore@hp.com>,
       James Morris <jmorris@namei.org>
Subject: [patch 066/114] selinux: Fix a panic in selinux_netlbl_inode_permission()
References: <20090314010937.416083662@mini.kroah.org>
Content-Disposition: inline; filename=selinux-fix-a-panic-in-selinux_netlbl_inode_permission.patch
In-Reply-To: <20090314011649.GA26170@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Paul Moore <paul.moore@hp.com>

commit d7f59dc4642ce2fc7b79fcd4ec02ffce7f21eb02 upstream.

Rick McNeal from LSI identified a panic in selinux_netlbl_inode_permission()
caused by a certain sequence of SUNRPC operations.  The problem appears to be
due to the lack of NULL pointer checking in the function; this patch adds the
pointer checks so the function will exit safely in the cases where the socket
is not completely initialized.

Signed-off-by: Paul Moore <paul.moore@hp.com>
Signed-off-by: James Morris <jmorris@namei.org>
Cc: Chuck Ebbert <cebbert@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 security/selinux/netlabel.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/security/selinux/netlabel.c
+++ b/security/selinux/netlabel.c
@@ -386,11 +386,12 @@ int selinux_netlbl_inode_permission(stru
 	if (!S_ISSOCK(inode->i_mode) ||
 	    ((mask & (MAY_WRITE | MAY_APPEND)) == 0))
 		return 0;
-
 	sock = SOCKET_I(inode);
 	sk = sock->sk;
+	if (sk == NULL)
+		return 0;
 	sksec = sk->sk_security;
-	if (sksec->nlbl_state != NLBL_REQUIRE)
+	if (sksec == NULL || sksec->nlbl_state != NLBL_REQUIRE)
 		return 0;
 
 	local_bh_disable();


