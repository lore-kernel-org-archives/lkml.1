Return-Path: <linux-kernel-owner+w=401wt.eu-S1763992AbYD0TgO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763992AbYD0TgO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 15:36:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763296AbYD0Tf6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 15:35:58 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:49053 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763289AbYD0Tf6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 15:35:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer:mime-version:content-type:content-transfer-encoding:sender;
        b=oW927Yo4EqlEuzeolXWlVwCuF2UEpOAQejVSFCDSxaIu8WhZnQF1/DJeagX83yPvX8PEBpNaIYUzvHyTCRpYYZuPymCD6ENCKi2HLGaE8x7Y/b3DApZTLOEFpKCTrHRDv1Qb2N5lz9tL6XFRg7azh/x9LG2XFu9MQJYclqBJ6SM=
Date: Sun, 27 Apr 2008 22:35:52 +0300
From: Pekka Paalanen <pq@iki.fi>
To: Ingo Molnar <mingo@elte.hu>
Cc: Pekka Paalanen <pq@iki.fi>, Steven Rostedt <rostedt@goodmis.org>,
       linux-kernel@vger.kernel.org, akpm@osdl.org,
       Peter Zijlstra <peterz@infradead.org>,
       Soeren Sandmann Pedersen <sandmann@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>, Pavel Roskin <proski@gnu.org>
Subject: [PATCH 2/5] mmiotrace: print header using the read hook.
Message-ID: <20080427223552.785bbd51@daedalus.pq.iki.fi>
In-Reply-To: <20080427222925.02b2b27b@daedalus.pq.iki.fi>
References: <20080427222925.02b2b27b@daedalus.pq.iki.fi>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.8; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From edf8d48e6bea0202536f3221bc4098f88278645f Mon Sep 17 00:00:00 2001
From: Pekka Paalanen <pq@iki.fi>
Date: Sat, 26 Apr 2008 23:05:23 +0300
Subject: [PATCH] mmiotrace: print header using the read hook.

Now the header is printed only for `trace_pipe' file.

Signed-off-by: Pekka Paalanen <pq@iki.fi>
---
 kernel/trace/trace_mmiotrace.c |   60 +++++++++++++++++++++++++++++++++++----
 1 files changed, 53 insertions(+), 7 deletions(-)

diff --git a/kernel/trace/trace_mmiotrace.c b/kernel/trace/trace_mmiotrace.c
index 79be4a1..6d2edbd 100644
--- a/kernel/trace/trace_mmiotrace.c
+++ b/kernel/trace/trace_mmiotrace.c
@@ -12,6 +12,10 @@
 
 #include "trace.h"
 
+struct header_iter {
+	struct pci_dev *dev;
+};
+
 static struct trace_array *mmio_trace_array;
 
 static void mmio_reset_data(struct trace_array *tr)
@@ -89,17 +93,57 @@ static int mmio_print_pcidev(struct trace_seq *s, const struct pci_dev *dev)
 	return ret;
 }
 
-/* XXX: This is not called for trace_pipe file! */
-static void mmio_print_header(struct trace_iterator *iter)
+static void destroy_header_iter(struct header_iter *hiter)
+{
+	if (!hiter)
+		return;
+	pci_dev_put(hiter->dev);
+	kfree(hiter);
+}
+
+static void mmio_pipe_open(struct trace_iterator *iter)
 {
+	struct header_iter *hiter;
 	struct trace_seq *s = &iter->seq;
-	struct pci_dev *dev = NULL;
 
 	trace_seq_printf(s, "VERSION 20070824\n");
 
-	for_each_pci_dev(dev)
-		mmio_print_pcidev(s, dev);
-	/* XXX: return value? What if header is very long? */
+	hiter = kzalloc(sizeof(*hiter), GFP_KERNEL);
+	if (!hiter)
+		return;
+
+	hiter->dev = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, NULL);
+	iter->private = hiter;
+}
+
+/* XXX: This is not called when the pipe is closed! */
+static void mmio_close(struct trace_iterator *iter)
+{
+	struct header_iter *hiter = iter->private;
+	destroy_header_iter(hiter);
+	iter->private = NULL;
+}
+
+static ssize_t mmio_read(struct trace_iterator *iter, struct file *filp,
+				char __user *ubuf, size_t cnt, loff_t *ppos)
+{
+	ssize_t ret;
+	struct header_iter *hiter = iter->private;
+	struct trace_seq *s = &iter->seq;
+
+	if (!hiter)
+		return 0;
+
+	mmio_print_pcidev(s, hiter->dev);
+	hiter->dev = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, hiter->dev);
+
+	if (!hiter->dev) {
+		destroy_header_iter(hiter);
+		iter->private = NULL;
+	}
+
+	ret = trace_seq_to_user(s, ubuf, cnt);
+	return (ret == -EBUSY) ? 0 : ret;
 }
 
 static int mmio_print_rw(struct trace_iterator *iter)
@@ -190,7 +234,9 @@ static struct tracer mmio_tracer __read_mostly =
 	.name		= "mmiotrace",
 	.init		= mmio_trace_init,
 	.reset		= mmio_trace_reset,
-	.open		= mmio_print_header,
+	.pipe_open	= mmio_pipe_open,
+	.close		= mmio_close,
+	.read		= mmio_read,
 	.ctrl_update	= mmio_trace_ctrl_update,
 	.print_line	= mmio_print_line,
 };
-- 
1.5.3.7

