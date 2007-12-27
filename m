Return-Path: <linux-kernel-owner+w=401wt.eu-S1752372AbXL0Gr2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752372AbXL0Gr2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2007 01:47:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750998AbXL0GrU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Dec 2007 01:47:20 -0500
Received: from mga01.intel.com ([192.55.52.88]:34743 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750833AbXL0GrT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2007 01:47:19 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,210,1196668800"; 
   d="scan'208";a="464687360"
Subject: [PATCH linux-acpi] Fix /proc/acpi/alarm set error
From: Yi Yang <yi.y.yang@intel.com>
Reply-To: yi.y.yang@intel.com
To: linux-acpi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, lenb@kernel.org,
       acpi-bugzilla@lists.sourceforge.net
Content-Type: text/plain
Organization: Intel
Date: Thu, 27 Dec 2007 14:47:02 +0800
Message-Id: <1198738022.8950.3.camel@yangyi-dev.bj.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

/proc/acpi/alarm can't be set correctly, here is a sample:

[root@localhost /]# echo "2006 09" > /proc/acpi/alarm
[root@localhost /]# cat /proc/acpi/alarm
2007-12-09 09:09:09
[root@localhost /]# echo "2006 04" > /proc/acpi/alarm
[root@localhost /]# cat /proc/acpi/alarm
2007-12-04 04:04:04
[root@localhost /]#

Obviously, it is wrong, it should consider it as an invalid input.

This patch'll fix this issue, after applying this patch, the result is:

[root@localhost /]# echo "2008 09" > /proc/acpi/alarm
-bash: echo: write error: Invalid argument
[root@localhost /]#

Signed-off by Yi Yang <yi.y.yang@intel.com>
 
diff --git a/drivers/acpi/sleep/proc.c b/drivers/acpi/sleep/proc.c
index 1538355..fce78fb 100644
--- a/drivers/acpi/sleep/proc.c
+++ b/drivers/acpi/sleep/proc.c
@@ -178,6 +178,9 @@ static int get_date_field(char **p, u32 * value)
 	 * Try to find delimeter, only to insert null.  The end of the
 	 * string won't have one, but is still valid.
 	 */
+	if (*p == NULL)
+		return result;
+
 	next = strpbrk(*p, "- :");
 	if (next)
 		*next++ = '\0';
@@ -190,6 +193,8 @@ static int get_date_field(char **p, u32 * value)
 
 	if (next)
 		*p = next;
+	else
+		*p = NULL;
 
 	return result;
 }


