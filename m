Return-Path: <linux-kernel-owner+w=401wt.eu-S1761521AbYEHJQj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761521AbYEHJQj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 05:16:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755096AbYEHJQb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 05:16:31 -0400
Received: from sacred.ru ([62.205.161.221]:43103 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754734AbYEHJQa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 05:16:30 -0400
Message-ID: <4822C268.7060501@openvz.org>
Date: Thu, 08 May 2008 13:05:44 +0400
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Balbir Singh <balbir@linux.vnet.ibm.com>, Paul Menage <menage@google.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] Mark res_counter_charge(_locked) with __must_check
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Thu, 08 May 2008 13:08:21 +0400 (MSD)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ignoring theirs return value may result in counter underflow
in the future - when the value charged will be uncharged (or in
"leaks" - when the value is not uncharged).

This also prevents from using charging routines to decrement the
counter value (i.e. uncharge it) ;)

(Current code works OK with res_counter, however :) )

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>

---

diff --git a/include/linux/res_counter.h b/include/linux/res_counter.h
index 6d9e1fc..125660e 100644
--- a/include/linux/res_counter.h
+++ b/include/linux/res_counter.h
@@ -95,8 +95,10 @@ void res_counter_init(struct res_counter *counter);
  * counter->limit _locked call expects the counter->lock to be taken
  */
 
-int res_counter_charge_locked(struct res_counter *counter, unsigned long val);
-int res_counter_charge(struct res_counter *counter, unsigned long val);
+int __must_check res_counter_charge_locked(struct res_counter *counter,
+		unsigned long val);
+int __must_check res_counter_charge(struct res_counter *counter,
+		unsigned long val);
 
 /*
  * uncharge - tell that some portion of the resource is released
