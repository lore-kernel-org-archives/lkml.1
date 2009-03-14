Return-Path: <linux-kernel-owner+w=401wt.eu-S1761277AbZCNAjv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761277AbZCNAjv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 20:39:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753847AbZCNATf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 20:19:35 -0400
Received: from kroah.org ([198.145.64.141]:34819 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753501AbZCNATV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 20:19:21 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Mar 13 17:07:48 2009
Message-Id: <20090314000748.256126466@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 13 Mar 2009 17:06:09 -0700
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
Subject: [patch 61/96] selinux: Fix the NetLabel glue code for setsockopt()
References: <20090314000508.803142980@mini.kroah.org>
Content-Disposition: inline; filename=selinux-fix-the-netlabel-glue-code-for-setsockopt.patch
In-Reply-To: <20090314001449.GA4485@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Paul Moore <paul.moore@hp.com>

commit 09c50b4a52c01a1f450b8eec819089e228655bfb upstream.

At some point we (okay, I) managed to break the ability for users to use the
setsockopt() syscall to set IPv4 options when NetLabel was not active on the
socket in question.  The problem was noticed by someone trying to use the
"-R" (record route) option of ping:

 # ping -R 10.0.0.1
 ping: record route: No message of desired type

The solution is relatively simple, we catch the unlabeled socket case and
clear the error code, allowing the operation to succeed.  Please note that we
still deny users the ability to override IPv4 options on socket's which have
NetLabel labeling active; this is done to ensure the labeling remains intact.

Signed-off-by: Paul Moore <paul.moore@hp.com>
Signed-off-by: James Morris <jmorris@namei.org>
Cc: Chuck Ebbert <cebbert@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 security/selinux/netlabel.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/security/selinux/netlabel.c
+++ b/security/selinux/netlabel.c
@@ -340,8 +340,10 @@ int selinux_netlbl_socket_setsockopt(str
 		lock_sock(sk);
 		rc = netlbl_sock_getattr(sk, &secattr);
 		release_sock(sk);
-		if (rc == 0 && secattr.flags != NETLBL_SECATTR_NONE)
+		if (rc == 0)
 			rc = -EACCES;
+		else if (rc == -ENOMSG)
+			rc = 0;
 		netlbl_secattr_destroy(&secattr);
 	}
 


