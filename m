Return-Path: <linux-kernel-owner+w=401wt.eu-S1752550AbZI2QhW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752550AbZI2QhW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 12:37:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752068AbZI2QhV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 12:37:21 -0400
Received: from smtp.nokia.com ([192.100.122.230]:46787 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751673AbZI2QhU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 12:37:20 -0400
From: Phil Carmody <ext-phil.2.carmody@nokia.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Phil Carmody <ext-phil.2.carmody@nokia.com>
Subject: [PATCH 1/1] err.h: Additional helper function to simplify pointer error checking.
Date: Tue, 29 Sep 2009 19:40:26 +0300
Message-Id: <d2b6fffe5164f15a9cd7e3b814c4ba21aaf281de.1254242153.git.ext-phil.2.carmody@nokia.com>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <>
References: <>
X-OriginalArrivalTime: 29 Sep 2009 16:36:59.0828 (UTC) FILETIME=[10FEDF40:01CA4123]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Phil Carmody <ext-phil.2.carmody@nokia.com>

There are quite a few instances in the kernel of checks of pointers
both against NULL and against the errno range, handling both cases
identically. This additional helper function would simplify such
code.

Signed-off-by: Phil Carmody <ext-phil.2.carmody@nokia.com>

---
Should apply cleanly to latest 2.6 tree.

The reason I noticed the lack of a helper like this was because I
was chasing down some issues where error returns were being handled
incorrectly. I concluded that a catch-all doesn't-point-to-an-object
test would be useful for pointers, so that such errors would be
harder to make.

There are possibly 50 instances in the code already of a verbatim
combined check, such as:
drivers/base/core.c:    if (class == NULL || IS_ERR(class))
most from a few architecture-specific trees. I would be prepared
to create a broader-reaching patchset which migrates more verbose
checks to this simpler one if that would be desirable.

Aside - the test used isn't computationally optimal. Comparing
unlikely((unsigned long)-x <= MAX_ERRNO) may be quicker on some
archs. I have favoured the more self-explanatory and portable
approach in this patch.
---
 include/linux/err.h |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/include/linux/err.h b/include/linux/err.h
index ec87f31..fcc836c 100644
--- a/include/linux/err.h
+++ b/include/linux/err.h
@@ -34,6 +34,11 @@ static inline long IS_ERR(const void *ptr)
 	return IS_ERR_VALUE((unsigned long)ptr);
 }
 
+static inline long IS_ERR_OR_NULL(const void *ptr)
+{
+	return (ptr == NULL) || IS_ERR_VALUE((unsigned long)ptr);
+}
+
 /**
  * ERR_CAST - Explicitly cast an error-valued pointer to another pointer type
  * @ptr: The pointer to cast.
-- 
1.5.4.3

