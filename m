Return-Path: <linux-kernel-owner+w=401wt.eu-S1753565AbYAMAjm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753565AbYAMAjm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2008 19:39:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752479AbYAMAjc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jan 2008 19:39:32 -0500
Received: from ug-out-1314.google.com ([66.249.92.171]:33878 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752261AbYAMAjb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2008 19:39:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:user-agent:mime-version:content-type:from;
        b=NWkWZlQkBJiIHLbIiMGzD0QelY64BJOYbY1sGv5Qq3W/pGTUMC8qBgJCxCzl0mLhntC32izcu0rC72lUG2W9d5Xrj2hMLPcux2GgRdBIzaq+q+m1GDTAz0VZUZ+BuVbfPdodzDq5phOsMg1XT987jhifumEYPyrwKLJzqwMRUkM=
Date: Sun, 13 Jan 2008 01:34:13 +0100 (CET)
To: Samuel Ortiz <samuel@sortiz.org>
cc: Dag Brattli <dagb@cs.uit.no>, Jean Tourrilhes <jt@hpl.hp.com>,
       LKML <linux-kernel@vger.kernel.org>, Netdev <netdev@vger.kernel.org>,
       Jesper Juhl <jesper.juhl@gmail.com>
Subject: [PATCH 1/2] irda: return -ENOMEM upon failure to allocate new
 ias_obj
Message-ID: <alpine.LNX.1.00.0801130101510.2235@dragon.funnycrock.com>
User-Agent: Alpine 1.00 (LNX 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
From: Jesper Juhl <jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


irias_new_object() can fail its memory allocation and will return NULL in 
that case. I believe the proper thing to do is to catch this, free the 
ias_opt that was allocated earlier but won't be used and then return 
-ENOMEM.
There are assertions further on that check for a NULL ias_obj, but I think 
it's a lot nicer to simply return -ENOMEM to the caller here where we know 
a memory allocation failed, rather than hitting an assertion later.

note: I don't have any means of actually testing this, so it has been 
compile tested only.


Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---

 af_irda.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/irda/af_irda.c b/net/irda/af_irda.c
index d5e4dd7..e33f0a5 100644
--- a/net/irda/af_irda.c
+++ b/net/irda/af_irda.c
@@ -1881,6 +1881,10 @@ static int irda_setsockopt(struct socket *sock, int level, int optname,
 			/* Create a new object */
 			ias_obj = irias_new_object(ias_opt->irda_class_name,
 						   jiffies);
+			if (!ias_obj) {
+				kfree(ias_opt);
+				return -ENOMEM;
+			}
 		}
 
 		/* Do we have the attribute already ? */



