Return-Path: <linux-kernel-owner+w=401wt.eu-S932444AbXIQVLr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932444AbXIQVLr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 17:11:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760320AbXIQVHg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 17:07:36 -0400
Received: from smtp-out.google.com ([216.239.33.17]:9245 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760299AbXIQVHe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 17:07:34 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:references:user-agent:date:from:to:cc:
	subject:content-disposition;
	b=OPvh3j0pTcjb1OQl33jWDtF0ORmQ9HGAU34EpenzO7N4j0Xh7g91+Gj3/XHm6S6KT
	bFWNAWTw2QOtU5bPJSC7g==
Message-Id: <20070917210429.690425000@menage.corp.google.com>
References: <20070917210307.116234000@menage.corp.google.com>
User-Agent: quilt/0.45-1
Date: Mon, 17 Sep 2007 14:03:29 -0700
From: Paul Menage <menage@google.com>
To: akpm@linuxfoundation.org, balbir@linux.vnet.ibm.com,
       "Serge E. Hallyn" <serue@us.ibm.com>, Cedric Le Goater <clg@fr.ibm.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Pavel Emelianov <xemul@openvz.org>,
       David Rientjes <rientjes@google.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, pj@sgi.com,
       containers@lists.osdl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 22/33] memory controller resource counters v7 fix
Content-Disposition: inline; filename=memory-controller-resource-counters-v7-fix.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Rientjes <rientjes@google.com>
(container->cgroup renaming by Paul Menage <menage@google.com>)

There's a gotcha in res_counter_charge_locked() because of C99 6.3.1.8(1)
since both counter->limit and 'val' are of unsigned long type, the result
of the subtraction will be the same; no promotion is required.  So if
'val' is greater than counter->limit, it will always be larger than
counter->usage and the conditional will fail.  Simply casting this to
signed doesn't work since counter->usage is also unsigned and thus the
result of the subtraction will be promoted to unsigned since the ranks are
the same.

Even though the only (current) use of res_counter_charge() is with a 'val'
actual of 1, this still fails if you set counter->limit to 0.  No chance
of overflow unless you're running on a machine with 4KB pages and 16TB of
memory.

Signed-off-by: David Rientjes <rientjes@google.com>
Signed-off-by: Paul Menage <menage@google.com>
---

 kernel/res_counter.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/res_counter.c~memory-controller-resource-counters-v7-fix kernel/res_counter.c
--- a/kernel/res_counter.c~memory-controller-resource-counters-v7-fix
+++ a/kernel/res_counter.c
@@ -21,7 +21,7 @@ void res_counter_init(struct res_counter
 
 int res_counter_charge_locked(struct res_counter *counter, unsigned long val)
 {
-	if (counter->usage > (counter->limit - val)) {
+	if (counter->usage + val > counter->limit) {
 		counter->failcnt++;
 		return -ENOMEM;
 	}
_

--
