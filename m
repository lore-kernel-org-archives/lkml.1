Return-Path: <linux-kernel-owner+w=401wt.eu-S1751539AbZLWAdZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751539AbZLWAdZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 19:33:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751310AbZLWAdX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 19:33:23 -0500
Received: from mga09.intel.com ([134.134.136.24]:37388 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751109AbZLWAdW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 19:33:22 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,439,1257148800"; 
   d="scan'208";a="581432455"
From: "Smith, GeoffX" <geoffx.smith@intel.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "andi@firstfloor.org" <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Michael Stone <michael@laptop.org>
Date: Tue, 22 Dec 2009 16:33:19 -0800
Subject: [PATCH] prctl: return MCE process flags through pointer
Thread-Topic: [PATCH] prctl: return MCE process flags through pointer
Thread-Index: AcqDZ4Z2LVxKePbQQXqQWRnwRTLGaA==
Message-ID: <354B2877CF17F44BB3FA44EB4DB0E5470C91CE1829@orsmsx510.amr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the semantics of prctl() option PR_MCE_KILL_GET 
to pass the return value through *arg2.

With this change, the option now follows the same conventions as the
other "get" options added since 2.6.0, and also brings it into
conformance with the advice in chapter 16 of Documentation/CodingStyle.

This prctl() option was only added within the last month, so there are
not any production applications to break.  This patch applies cleanly
to mainline and to 2.6.32.2 for backporting.

Signed-off-by:  Geoff Smith <geoffx.smith@intel.com>


diff --git a/kernel/sys.c b/kernel/sys.c
index 26a6b73..347021a 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -1570,13 +1570,16 @@ SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
 			error = 0;
 			break;
 		case PR_MCE_KILL_GET:
-			if (arg2 | arg3 | arg4 | arg5)
+			if (arg3 | arg4 | arg5)
 				return -EINVAL;
 			if (current->flags & PF_MCE_PROCESS)
-				error = (current->flags & PF_MCE_EARLY) ?
-					PR_MCE_KILL_EARLY : PR_MCE_KILL_LATE;
+				error = put_user(
+					(current->flags & PF_MCE_EARLY) ?
+					PR_MCE_KILL_EARLY : PR_MCE_KILL_LATE,
+					(unsigned long __user *)arg2);
 			else
-				error = PR_MCE_KILL_DEFAULT;
+				error = put_user(PR_MCE_KILL_DEFAULT,
+					(unsigned long __user *)arg2);
 			break;
 		default:
 			error = -EINVAL;
 				return -EINVAL;

