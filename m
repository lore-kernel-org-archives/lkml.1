Return-Path: <linux-kernel-owner+w=401wt.eu-S934654AbZDJQXk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934654AbZDJQXk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 12:23:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758217AbZDJQXa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 12:23:30 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:50106 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197AbZDJQX3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 12:23:29 -0400
From: Darren Hart <dvhltc@us.ibm.com>
Subject: [tip PATCH] futex: fix futex_wait_setup key handling
To: linux-kernel@vger.kernel.org
Cc: Darren Hart <dvhltc@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>
Date: Fri, 10 Apr 2009 09:23:24 -0700
Message-ID: <20090410162324.12330.37348.stgit@Aeon>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the get_futex_key() call were to fail, the existing code would
try and put_futex_key() prior to returning.  This patch makes sure
we only put_futex_key() if get_futex_key() succeeded.

Please apply to -rt and to tip:/core/futexes.

Reported-by: Clark Williams <williams@redhat.com>
Signed-off-by: Darren Hart <dvhltc@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
---

 kernel/futex.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index 185c981..4357f06 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -1657,7 +1657,7 @@ retry_private:
 
 		ret = get_user(uval, uaddr);
 		if (ret)
-			goto out;
+			goto out_put_key;
 
 		if (!fshared)
 			goto retry_private;
@@ -1671,9 +1671,10 @@ retry_private:
 		ret = -EWOULDBLOCK;
 	}
 
-out:
+out_put_key:
 	if (ret)
 		put_futex_key(fshared, &q->key);
+out:
 	return ret;
 }
 

