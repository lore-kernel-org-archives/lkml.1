Return-Path: <linux-kernel-owner+w=401wt.eu-S936153AbZLQBtg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936153AbZLQBtg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 20:49:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932767AbZLQBtL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 20:49:11 -0500
Received: from kroah.org ([198.145.64.141]:47771 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763572AbZLQBTu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 20:19:50 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Dec 16 17:15:58 2009
Message-Id: <20091217011558.884142808@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Dec 2009 17:14:19 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Alexey Dobriyan <adobriyan@gmail.com>, Serge Hallyn <serue@us.ibm.com>,
       David Howells <dhowells@redhat.com>, James Morris <jmorris@namei.org>
Subject: [08/90] bsdacct: fix uid/gid misreporting
In-Reply-To: <20091217011835.GA20434@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alexey Dobriyan <adobriyan@gmail.com>

commit 4b731d50ff3df6b9141a6c12b088e8eb0109e83c upstream.

commit d8e180dcd5bbbab9cd3ff2e779efcf70692ef541 "bsdacct: switch
credentials for writing to the accounting file" introduced credential
switching during final acct data collecting.  However, uid/gid pair
continued to be collected from current which became credentials of who
created acct file, not who exits.

Addresses http://bugzilla.kernel.org/show_bug.cgi?id=14676

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Reported-by: Juho K. Juopperi <jkj@kapsi.fi>
Acked-by: Serge Hallyn <serue@us.ibm.com>
Acked-by: David Howells <dhowells@redhat.com>
Reviewed-by: Michal Schmidt <mschmidt@redhat.com>
Cc: James Morris <jmorris@namei.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/acct.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/kernel/acct.c
+++ b/kernel/acct.c
@@ -536,7 +536,8 @@ static void do_acct_process(struct bsd_a
 	do_div(elapsed, AHZ);
 	ac.ac_btime = get_seconds() - elapsed;
 	/* we really need to bite the bullet and change layout */
-	current_uid_gid(&ac.ac_uid, &ac.ac_gid);
+	ac.ac_uid = orig_cred->uid;
+	ac.ac_gid = orig_cred->gid;
 #if ACCT_VERSION==2
 	ac.ac_ahz = AHZ;
 #endif


