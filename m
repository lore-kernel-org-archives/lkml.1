Return-Path: <linux-kernel-owner+w=401wt.eu-S1753819AbYL3Dnj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753819AbYL3Dnj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 22:43:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752537AbYL3Dna
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 22:43:30 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:36955 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752458AbYL3Dna (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 22:43:30 -0500
From: Darren Hart <dvhltc@us.ibm.com>
Subject: [PATCH] futex: add WARN_ON to catch certain assymetric
	(get|put)_futex_key calls
To: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Cc: Darren Hart <dvhltc@us.ibm.com>, "Peter Zijlstra" <peterz@infradead.org>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Rusty Russell" <rusty@au1.ibm.com>
Date: Mon, 29 Dec 2008 19:43:21 -0800
Message-ID: <20081230034320.24404.56248.stgit@Aeon>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Following up on my previous key reference accounting patches, this patch
will catch puts on keys that haven't been "got".  This won't catch nested
get/put mismatches though.

Build and boot tested, with minimal desktop activity and a run of the
open_posix_testsuite in LTP for testing.  No warnings logged.

Signed-off-by: Darren Hart <dvhltc@us.ibm.com>
Cc: "Peter Zijlstra" <peterz@infradead.org>
Cc: "Thomas Gleixner" <tglx@linutronix.de>
Cc: "Rusty Russell" <rusty@au1.ibm.com>
---

 kernel/futex.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index 748778a..5288acf 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -170,8 +170,11 @@ static void get_futex_key_refs(union futex_key *key)
  */
 static void drop_futex_key_refs(union futex_key *key)
 {
-	if (!key->both.ptr)
+	if (!key->both.ptr) {
+		/* If we're here then we tried to put a key we failed to get */
+		WARN_ON(1);
 		return;
+	}
 
 	switch (key->both.offset & (FUT_OFF_INODE|FUT_OFF_MMSHARED)) {
 	case FUT_OFF_INODE:

