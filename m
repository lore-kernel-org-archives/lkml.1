Return-Path: <linux-kernel-owner+w=401wt.eu-S1754864AbZGUF6u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754864AbZGUF6u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 01:58:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752804AbZGUF6t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 01:58:49 -0400
Received: from mga06.intel.com ([134.134.136.21]:47377 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752685AbZGUF6s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 01:58:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,239,1246863600"; 
   d="scan'208,223";a="431921031"
Message-ID: <4A655917.9080504@linux.intel.com>
Date: Mon, 20 Jul 2009 22:58:47 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 2.0.0.22 (Windows/20090605)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Ingo Molnar <mingo@elte.hu>
Subject: [PATCH] perf: avoid structure size confusion by using a fixed size
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 From f9edcb31f1d4935fa0a8fc0891c90d6e0174fcae Mon Sep 17 00:00:00 2001
From: Arjan van de Ven <arjan@linux.intel.com>
Date: Mon, 20 Jul 2009 22:54:26 -0700
Subject: [PATCH] perf: avoid structure size confusion by using a fixed size

for some reason, this structure gets compiled as 36 bytes in some files
(the ones that alloacte it) but 40 bytes in others (the ones that use it).
The cause is an off_t type that gets a different size in different
compilation units for some yet-to-be-explained reason.

But the effect is disasterous; the size/offset members of the struct
are at different offsets, and result in mostly complete garbage.
The parser in perf is so robust that this all gets hidden, and after
skipping an certain amount of samples, it recovers.... so this bug
is not normally noticed.

... except when you want every sample to be exact.

Fix this by just using an explicitly sized type.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
  tools/perf/util/header.h |    2 +-
  1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/header.h b/tools/perf/util/header.h
index b5ef53a..bf28044 100644
--- a/tools/perf/util/header.h
+++ b/tools/perf/util/header.h
@@ -16,7 +16,7 @@ struct perf_header {
  	int frozen;
  	int attrs, size;
  	struct perf_header_attr **attr;
-	off_t attr_offset;
+	s64 attr_offset;
  	u64 data_offset;
  	u64 data_size;
  };
-- 
1.6.0.6

