Return-Path: <linux-kernel-owner+w=401wt.eu-S1754415Ab0ARLyB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754415Ab0ARLyB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 06:54:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754017Ab0ARLyA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 06:54:00 -0500
Received: from casper.infradead.org ([85.118.1.10]:47157 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751614Ab0ARLx7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 06:53:59 -0500
Subject: [PATCH] perf: fix the is_software_event() definition
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Stephane Eranian <eranian@google.com>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, paulus@samba.org, davem@davemloft.net,
       perfmon2-devel@lists.sf.net
In-Reply-To: <1263813189.4283.245.camel@laptop>
References: <4b4c761b.0338560a.1eaa.ffff824d@mx.google.com>
	 <1263312616.4244.153.camel@laptop>
	 <bd4cb8901001130154p732672b6x56e758c1ab33a8e8@mail.gmail.com>
	 <1263400193.4244.238.camel@laptop>
	 <bd4cb8901001130852y1de007cbqe66d77605c1ec372@mail.gmail.com>
	 <bd4cb8901001130922s7ad85af6w6c631d90de177ef9@mail.gmail.com>
	 <20100117141233.GF5035@nowhere>  <1263813189.4283.245.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 18 Jan 2010 12:53:36 +0100
Message-ID: <1263815616.4283.332.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-01-18 at 12:13 +0100, Peter Zijlstra wrote:
> On Sun, 2010-01-17 at 15:12 +0100, Frederic Weisbecker wrote:
> 
> > You need to also call pmu->disable() if it is a software event,
> > because a breakpoint needs to be unregistered in hardware level
> > too.
> 
> breakpoint isn't a software pmu. But yeah, enable and disable need to
> match.

That is, it shouldn't be a software pmu, because we assume software
events can always be scheduled, whereas that's definitely not so for the
breakpoint one.

Which seems to suggest the following

---
Subject: perf: fix the is_software_event() definition

When adding the breakpoint pmu Frederic forgot to exclude it from being
a software event. While we're at it, make it an inclusive expression.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/perf_event.h |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index c66b34f..835ba26 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -814,9 +814,13 @@ extern int perf_event_overflow(struct perf_event *event, int nmi,
  */
 static inline int is_software_event(struct perf_event *event)
 {
-	return (event->attr.type != PERF_TYPE_RAW) &&
-		(event->attr.type != PERF_TYPE_HARDWARE) &&
-		(event->attr.type != PERF_TYPE_HW_CACHE);
+	switch (event->attr.type) {
+	case PERF_TYPE_SOFTWARE:
+	case PERF_TYPE_TRACEPOINT:
+	case PERF_TYPE_HW_CACHE:
+		return 1;
+	}
+	return 0;
 }
 
 extern atomic_t perf_swevent_enabled[PERF_COUNT_SW_MAX];


