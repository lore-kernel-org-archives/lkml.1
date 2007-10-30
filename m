Return-Path: <linux-kernel-owner+w=401wt.eu-S1758405AbXJ3QV0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758405AbXJ3QV0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 12:21:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753179AbXJ3QOS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 12:14:18 -0400
Received: from mx1.redhat.com ([66.187.233.31]:47056 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755838AbXJ3QOI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 12:14:08 -0400
Message-Id: <20071030160913.946725000@chello.nl>
References: <20071030160401.296770000@chello.nl>
User-Agent: quilt/0.45-1
Date: Tue, 30 Oct 2007 17:04:18 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, netdev@vger.kernel.org, trond.myklebust@fys.uio.no
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 17/33] sysctl: propagate conv errors
Content-Disposition: inline; filename=sysctl_parse_error.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Currently conv routines will only generate -EINVAL, allow for other
errors to be propagetd.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sysctl.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

Index: linux-2.6/kernel/sysctl.c
===================================================================
--- linux-2.6.orig/kernel/sysctl.c
+++ linux-2.6/kernel/sysctl.c
@@ -1732,6 +1732,7 @@ static int __do_proc_dointvec(void *tbl_
 	int *i, vleft, first=1, neg, val;
 	unsigned long lval;
 	size_t left, len;
+	int ret = 0;
 	
 	char buf[TMPBUFLEN], *p;
 	char __user *s = buffer;
@@ -1787,14 +1788,16 @@ static int __do_proc_dointvec(void *tbl_
 			s += len;
 			left -= len;
 
-			if (conv(&neg, &lval, i, 1, data))
+			ret = conv(&neg, &lval, i, 1, data);
+			if (ret)
 				break;
 		} else {
 			p = buf;
 			if (!first)
 				*p++ = '\t';
 	
-			if (conv(&neg, &lval, i, 0, data))
+			ret = conv(&neg, &lval, i, 0, data);
+			if (ret)
 				break;
 
 			sprintf(p, "%s%lu", neg ? "-" : "", lval);
@@ -1823,11 +1826,9 @@ static int __do_proc_dointvec(void *tbl_
 			left--;
 		}
 	}
-	if (write && first)
-		return -EINVAL;
 	*lenp -= left;
 	*ppos += *lenp;
-	return 0;
+	return ret;
 #undef TMPBUFLEN
 }
 

--

