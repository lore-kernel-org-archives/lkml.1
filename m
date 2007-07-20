Return-Path: <linux-kernel-owner+w=401wt.eu-S1760420AbXGTWNt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760420AbXGTWNt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 18:13:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755055AbXGTWNm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 18:13:42 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:4826 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755978AbXGTWNl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 18:13:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=ftIPTRkkKFkZIs25YiCcyb9qmgAhoHjzDUi4u7xK37kTJzzzbEBFmnNQ5Km+owE97auT5xCXROnwOu8b3wXWUqUwi/An05iUFf3wCvbPqTJzt1GRzEjZwP+SlMptF5CljEnhG+qdvfVMpg+X8jdwFK0fXgI+I8mi/JayhA+MUpQ=
From: Jesper Juhl <jesper.juhl@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH][SELinux] Let us not leak memory in SELinux : security_netlbl_cache_add()
Date: Sat, 21 Jul 2007 00:12:44 +0200
User-Agent: KMail/1.9.7
Cc: Stephen Smalley <sds@epoch.ncsc.mil>, James Morris <jmorris@redhat.com>,
       dgoeddel@trustedcs.com, Frank Mayer <mayerf@tresys.com>,
       Karl MacMillan <kmacmillan@tresys.com>, paul.moore@hp.com,
       Chad Sellers <csellers@tresys.com>, Stephen Smalley <sds@tycho.nsa.gov>,
       James Morris <jmorris@namei.org>, Eric Paris <eparis@parisplace.org>,
       Jesper Juhl <jesper.juhl@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707210012.45185.jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Leaking memory is a bad idea, so let's not do it, in 
security/selinux/ss/services.c::security_netlbl_cache_add().

Note: The Coverity checker gets credit for spotting this one.
Note: Patch has only been compile tested.


Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---

 security/selinux/ss/services.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/security/selinux/ss/services.c b/security/selinux/ss/services.c
index b5f017f..0ae032f 100644
--- a/security/selinux/ss/services.c
+++ b/security/selinux/ss/services.c
@@ -2417,8 +2417,10 @@ static void security_netlbl_cache_add(struct netlbl_lsm_secattr *secattr,
 
 	cache->type = NETLBL_CACHE_T_MLS;
 	if (ebitmap_cpy(&cache->data.mls_label.level[0].cat,
-			&ctx->range.level[0].cat) != 0)
+			&ctx->range.level[0].cat) != 0) {
+		kfree(cache);
 		return;
+	}
 	cache->data.mls_label.level[1].cat.highbit =
 		cache->data.mls_label.level[0].cat.highbit;
 	cache->data.mls_label.level[1].cat.node =


