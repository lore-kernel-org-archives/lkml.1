Return-Path: <linux-kernel-owner+w=401wt.eu-S1753076AbZK3Wke@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753076AbZK3Wke (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 17:40:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751504AbZK3Wkd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 17:40:33 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:46562 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750876AbZK3Wkc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 17:40:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=S2ysKJnyyF7dvOmVxT1qn/4GFQiIz1J5q0wTQECAQRtB9/GOSf1Y2dtVuwNqa5vg27
         9F6fOPmPGwPabYH1SNne8t4BE5K016db9pOED18l0qrJdf9Do5VggBos2YVc+Ksb3STU
         IiWK/bMKO1YIakmiTPTYzJUdGA/HLvbPP7NBg=
Date: Tue, 1 Dec 2009 01:40:32 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org
Cc: jkj@kapsi.fi, linux-kernel@vger.kernel.org, mschmidt@redhat.com,
       dhowells@redhat.com, serue@us.ibm.com, jmorris@namei.org
Subject: [PATCH] bsdacct: fix uid/gid misreporting (#14676)
Message-ID: <20091130224032.GA5598@x200.malnet.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit d8e180dcd5bbbab9cd3ff2e779efcf70692ef541
"bsdacct: switch credentials for writing to the accounting file"
introduced credential switching during final acct data collecting.
However, uid/gid pair continued to be collected from current which
became credentials of who created acct file, not who exits.

Fix http://bugzilla.kernel.org/show_bug.cgi?id=14676

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 Juho, please, confirm.

 kernel/acct.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/kernel/acct.c
+++ b/kernel/acct.c
@@ -536,7 +536,8 @@ static void do_acct_process(struct bsd_acct_struct *acct,
 	do_div(elapsed, AHZ);
 	ac.ac_btime = get_seconds() - elapsed;
 	/* we really need to bite the bullet and change layout */
-	current_uid_gid(&ac.ac_uid, &ac.ac_gid);
+	ac.ac_uid = orig_cred->uid;
+	ac.ac_gid = orig_cred->gid;
 #if ACCT_VERSION==2
 	ac.ac_ahz = AHZ;
 #endif
