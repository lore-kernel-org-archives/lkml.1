Return-Path: <linux-kernel-owner+w=401wt.eu-S936784AbXGZWlV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936784AbXGZWlV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 18:41:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932567AbXGZWks
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 18:40:48 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:32914 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761989AbXGZWkq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 18:40:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=okw08PqkaCEfALit3d92WjViwq4ZfT9KAkDZffRbMsH2wYahHRi9LDbntWZI+IX0lJTtC0oTQF+18JIAYttVq698QOqnKnZawEMnOINUvb6gvopcSteVKdF92mMqGBSfRCwXhKICMDCZmM+2v5LF/pZlWDc/YWx0NvgDWE7dEqM=
From: Jesper Juhl <jesper.juhl@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH][dccp] Fix memory leak and clean up style - dccp_feat_empty_confirm()
Date: Fri, 27 Jul 2007 00:39:37 +0200
User-Agent: KMail/1.9.7
Cc: Andrea Bittau <a.bittau@cs.ucl.ac.uk>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       dccp@vger.kernel.org, Jesper Juhl <jesper.juhl@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707270039.37860.jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Greetings,

There's a memory leak in net/dccp/feat.c::dccp_feat_empty_confirm().
If we hit the 'default:' case of the 'switch' statement, then we 
return without freeing 'opt', thus leaking 'struct dccp_opt_pend' 
bytes.
The leak is fixed easily enough by adding a kfree(opt); before the 
return statement.
The patch also changes the layout of the 'switch' to be more in line 
with CodingStyle.

Patch has been compile tested.

Please consider merging.


Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---

 net/dccp/feat.c |   14 ++++++++++----
 1 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/net/dccp/feat.c b/net/dccp/feat.c
index cd845df..5ebdd86 100644
--- a/net/dccp/feat.c
+++ b/net/dccp/feat.c
@@ -327,10 +327,16 @@ static void dccp_feat_empty_confirm(struct dccp_minisock *dmsk,
 	}
 
 	switch (type) {
-	case DCCPO_CHANGE_L: opt->dccpop_type = DCCPO_CONFIRM_R; break;
-	case DCCPO_CHANGE_R: opt->dccpop_type = DCCPO_CONFIRM_L; break;
-	default:	     DCCP_WARN("invalid type %d\n", type); return;
-
+	case DCCPO_CHANGE_L:
+		opt->dccpop_type = DCCPO_CONFIRM_R;
+		break;
+	case DCCPO_CHANGE_R:
+		opt->dccpop_type = DCCPO_CONFIRM_L;
+		break;
+	default:
+		DCCP_WARN("invalid type %d\n", type);
+		kfree(opt);
+		return;
 	}
 	opt->dccpop_feat = feature;
 	opt->dccpop_val	 = NULL;





PS. Please keep me on Cc when replying.


