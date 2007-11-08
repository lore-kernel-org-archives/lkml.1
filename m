Return-Path: <linux-kernel-owner+w=401wt.eu-S1760865AbXKHKxl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760865AbXKHKxl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 05:53:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759383AbXKHKxd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 05:53:33 -0500
Received: from [222.73.24.84] ([222.73.24.84]:53277 "EHLO song.cn.fujitsu.com"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1759238AbXKHKxc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 05:53:32 -0500
Message-ID: <4732EAB4.5070605@cn.fujitsu.com>
Date: Thu, 08 Nov 2007 18:53:40 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: tglx@linutronix.de
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] time: fix sysfs_show_{available,current}_clocksources() buffer
 overflow problem
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,every one.
   I found that there is a buffer overflow problem in the following code.

Version:	2.6.24-rc2,
File:		kernel/time/clocksource.c:417-432
--------------------------------------------------------------------
static ssize_t
sysfs_show_available_clocksources(struct sys_device *dev, char *buf)
{
	struct clocksource *src;
	char *curr = buf;

	spin_lock_irq(&clocksource_lock);
	list_for_each_entry(src, &clocksource_list, list) {
		curr += sprintf(curr, "%s ", src->name);
	}
	spin_unlock_irq(&clocksource_lock);

	curr += sprintf(curr, "\n");

	return curr - buf;
}
-----------------------------------------------------------------------

sysfs_show_current_clocksources() also has the same problem though in practice
the size of current clocksource's name won't exceed PAGE_SIZE.

I fix the bug by using snprintf according to the specification of the kernel
(Version:2.6.24-rc2,File:Documentation/filesystems/sysfs.txt)

Fix sysfs_show_available_clocksources() and sysfs_show_current_clocksources()
buffer overflow problem with snprintf().

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>

---
  kernel/time/clocksource.c |   19 ++++++++++---------
  1 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
index c8a9d13..5d5926f 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -342,15 +342,13 @@ void clocksource_change_rating(struct clocksource *cs, int rating)
  static ssize_t
  sysfs_show_current_clocksources(struct sys_device *dev, char *buf)
  {
-	char *curr = buf;
+	ssize_t count = 0;

  	spin_lock_irq(&clocksource_lock);
-	curr += sprintf(curr, "%s ", curr_clocksource->name);
+	count = snprintf(buf, PAGE_SIZE, "%s\n", curr_clocksource->name);
  	spin_unlock_irq(&clocksource_lock);

-	curr += sprintf(curr, "\n");
-
-	return curr - buf;
+	return count;
  }

  /**
@@ -418,17 +416,20 @@ static ssize_t
  sysfs_show_available_clocksources(struct sys_device *dev, char *buf)
  {
  	struct clocksource *src;
-	char *curr = buf;
+	ssize_t count = 0;

  	spin_lock_irq(&clocksource_lock);
  	list_for_each_entry(src, &clocksource_list, list) {
-		curr += sprintf(curr, "%s ", src->name);
+		count += snprintf(buf + count,
+				  max((ssize_t)PAGE_SIZE - count, (ssize_t)0),
+				  "%s ", src->name);
  	}
  	spin_unlock_irq(&clocksource_lock);

-	curr += sprintf(curr, "\n");
+	count += snprintf(buf + count,
+			  max((ssize_t)PAGE_SIZE - count, (ssize_t)0), "\n");

-	return curr - buf;
+	return count;
  }

  /*
-- 
1.5.3


