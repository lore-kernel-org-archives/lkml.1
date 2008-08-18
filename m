Return-Path: <linux-kernel-owner+w=401wt.eu-S933123AbYHRTNd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933123AbYHRTNd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 15:13:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759071AbYHRTIY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 15:08:24 -0400
Received: from ns2.suse.de ([195.135.220.15]:37660 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757781AbYHRTIW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 15:08:22 -0400
Date: Mon, 18 Aug 2008 11:45:42 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       Jeff Layton <jlayton@redhat.com>
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
       alan@lxorguk.ukuu.org.uk, Steve French <sfrench@us.ibm.com>
Subject: [patch 58/60] CIFS: properly account for new user= field in SPNEGO
	upcall string allocation
Message-ID: <20080818184542.GG29394@suse.de>
References: <20080818183230.966310219@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="cifs-properly-account-for-new-user-field-in-spnego-upcall-string-allocation.patch"
In-Reply-To: <20080818184035.GA29394@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.26-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Jeff Layton <jlayton@redhat.com>

commit 66b8bd3c405389213de1d6ba6c2565990f62004f upstream

[CIFS] properly account for new user= field in SPNEGO upcall string allocation

...it doesn't look like it's being accounted for at the moment. Also
try to reorganize the calculation to make it a little more evident
what each piece means.

This should probably go to the stable series as well...

Signed-off-by: Jeff Layton <jlayton@redhat.com>
Signed-off-by: Steve French <sfrench@us.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/cifs/cifs_spnego.c |   18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

--- a/fs/cifs/cifs_spnego.c
+++ b/fs/cifs/cifs_spnego.c
@@ -66,8 +66,8 @@ struct key_type cifs_spnego_key_type = {
 	.describe	= user_describe,
 };
 
-#define MAX_VER_STR_LEN   9 /* length of longest version string e.g.
-				strlen(";ver=0xFF") */
+#define MAX_VER_STR_LEN   8 /* length of longest version string e.g.
+				strlen("ver=0xFF") */
 #define MAX_MECH_STR_LEN 13 /* length of longest security mechanism name, eg
 			       in future could have strlen(";sec=ntlmsspi") */
 #define MAX_IPV6_ADDR_LEN 42 /* eg FEDC:BA98:7654:3210:FEDC:BA98:7654:3210/60 */
@@ -81,11 +81,15 @@ cifs_get_spnego_key(struct cifsSesInfo *
 	struct key *spnego_key;
 	const char *hostname = server->hostname;
 
-	/* BB: come up with better scheme for determining length */
-	/* length of fields (with semicolons): ver=0xyz ipv4= ipaddress host=
-	   hostname sec=mechanism uid=0x uid */
-	desc_len = MAX_VER_STR_LEN + 5 + MAX_IPV6_ADDR_LEN + 1 + 6 +
-		  strlen(hostname) + MAX_MECH_STR_LEN + 8 + (sizeof(uid_t) * 2);
+	/* length of fields (with semicolons): ver=0xyz ip4=ipaddress
+	   host=hostname sec=mechanism uid=0xFF user=username */
+	desc_len = MAX_VER_STR_LEN +
+		   6 /* len of "host=" */ + strlen(hostname) +
+		   5 /* len of ";ipv4=" */ + MAX_IPV6_ADDR_LEN +
+		   MAX_MECH_STR_LEN +
+		   7 /* len of ";uid=0x" */ + (sizeof(uid_t) * 2) +
+		   6 /* len of ";user=" */ + strlen(sesInfo->userName) + 1;
+
 	spnego_key = ERR_PTR(-ENOMEM);
 	description = kzalloc(desc_len, GFP_KERNEL);
 	if (description == NULL)

-- 
