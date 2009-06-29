Return-Path: <linux-kernel-owner+w=401wt.eu-S1758725AbZF2LOK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758725AbZF2LOK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 07:14:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751269AbZF2LN5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 07:13:57 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:50128 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752530AbZF2LN5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 07:13:57 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19016.41130.429944.316897@cargo.ozlabs.ibm.com>
Date: Mon, 29 Jun 2009 21:08:26 +1000
From: Paul Mackerras <paulus@samba.org>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] perf_counter: tools: Make :u and :k exclude hypervisor
X-Mailer: VM 8.0.12 under 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At present, appending ":u" to an event sets the exclude_kernel bit,
and ":k" sets the exclude_user bit.  There is no way to set the
exclude_hv bit, which means that on systems with a hypervisor (e.g.
IBM pSeries systems), we get counts from hypervisor mode for an event
such as 0:1:u.

This fixes the problem by setting all three exclude bits when we see
the second ':' and the clearing the exclude bits corresponding to the
modes we want to count.  This also adds a ":h" modifier to allow the
user to ask for counts in hypervisor mode.

Signed-off-by: Paul Mackerras <paulus@samba.org>
---
 tools/perf/util/parse-events.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 4d042f1..f2ffe2c 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -277,10 +277,15 @@ static int parse_event_symbols(const char *str, struct perf_counter_attr *attr)
 		sep = strchr(pstr, ':');
 		if (sep) {
 			pstr = sep + 1;
+			attr->exclude_user = 1;
+			attr->exclude_kernel = 1;
+			attr->exclude_hv = 1;
 			if (strchr(pstr, 'k'))
-				attr->exclude_user = 1;
+				attr->exclude_kernel = 0;
 			if (strchr(pstr, 'u'))
-				attr->exclude_kernel = 1;
+				attr->exclude_user = 0;
+			if (strchr(pstr, 'h'))
+				attr->exclude_hv = 0;
 		}
 		attr->type = type;
 		attr->config = id;
-- 
1.6.0.4

