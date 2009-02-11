Return-Path: <linux-kernel-owner+w=401wt.eu-S1758090AbZBKRYu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758090AbZBKRYu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 12:24:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755081AbZBKRYl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 12:24:41 -0500
Received: from mx2.redhat.com ([66.187.237.31]:50670 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754884AbZBKRYl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 12:24:41 -0500
Subject: Re: [Cluster-devel] [RFC] blktrace: add glock tracing to blktrace
From: Steven Whitehouse <swhiteho@redhat.com>
To: axboe@kernel.dk
Cc: cluster-devel@redhat.com, linux-kernel@vger.kernel.org
In-Reply-To: <1234372827.3566.13.camel@localhost.localdomain>
References: <1234372827.3566.13.camel@localhost.localdomain>
Content-Type: text/plain
Organization: Red Hat UK Ltd
Date: Wed, 11 Feb 2009 17:25:31 +0000
Message-Id: <1234373131.3566.15.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here are the userland changes,

Steve.

diff --git a/blkparse.c b/blkparse.c
index ef55697..c808404 100644
--- a/blkparse.c
+++ b/blkparse.c
@@ -570,6 +570,25 @@ static struct process_pid_map *add_ppm_hash(pid_t pid, const char *name)
 	return ppm;
 }
 
+/* Matches the enum in linux/blktrace_api.h */
+const char *glock_states[] = {
+	"??",
+	"IV",
+	"NL",
+	"CR",
+	"CW",
+	"PR",
+	"PW",
+	"EX"
+};
+
+static const char *glstate2str(u8 state)
+{
+	if (state > (sizeof(glock_states)/sizeof(const char *)))
+		return glock_states[0];
+	return glock_states[state];
+}
+
 static void handle_notify(struct blk_io_trace *bit)
 {
 	void	*payload = (caddr_t) bit + sizeof(*bit);
@@ -614,6 +633,29 @@ static void handle_notify(struct blk_io_trace *bit)
 		}
 		break;
 
+	case BLK_TN_GLOCK:
+		if (bit->pdu_len == sizeof(struct blk_io_trace_glock)) {
+			struct blk_io_trace_glock *g = (struct blk_io_trace_glock *)payload;
+			fprintf(ofp,
+				"%3d,%-3d %2d %8lu %5d.%09lu %5u %2s %3s %u:%llu cur:%s",
+				MAJOR(bit->device), MINOR(bit->device),
+				bit->cpu, (unsigned long)bit->sequence,
+				(int) SECONDS(bit->time),
+				(unsigned long) NANO_SECONDS(bit->time),
+				bit->pid, "m", "G", be32_to_cpu(g->type),
+				(unsigned long long)bit->sector,
+				glstate2str(g->cur_state));
+			if (g->new_state)
+				fprintf(ofp, ",new:%s", glstate2str(g->new_state));
+			if (g->tgt_state)
+				fprintf(ofp, ",tgt:%s", glstate2str(g->tgt_state));
+			if (g->dmt_state)
+				fprintf(ofp, ",dmt:%s [%s]",
+					glstate2str(g->dmt_state),
+					find_process_name(bit->pid));
+			fprintf(ofp, "\n");
+
+		}
 	default:
 		/* Ignore unknown notify events */
 		;
@@ -1605,7 +1647,7 @@ static void dump_trace(struct blk_io_trace *t, struct per_cpu_info *pci,
 		       struct per_dev_info *pdi)
 {
 	if (text_output) {
-		if (t->action == BLK_TN_MESSAGE)
+		if (t->action == BLK_TN_MESSAGE || t->action == BLK_TN_GLOCK)
 			handle_notify(t);
 		else if (t->action & BLK_TC_ACT(BLK_TC_PC))
 			dump_trace_pc(t, pdi, pci);
@@ -2209,7 +2251,9 @@ static int read_events(int fd, int always_block, int *fdblock)
 		/*
 		 * not a real trace, so grab and handle it here
 		 */
-		if (bit->action & BLK_TC_ACT(BLK_TC_NOTIFY) && bit->action != BLK_TN_MESSAGE) {
+		if (bit->action & BLK_TC_ACT(BLK_TC_NOTIFY) &&
+		    bit->action != BLK_TN_MESSAGE &&
+		    bit->action != BLK_TN_GLOCK) {
 			handle_notify(bit);
 			output_binary(bit, sizeof(*bit) + bit->pdu_len);
 			continue;
@@ -2352,7 +2396,9 @@ static int ms_prime(struct ms_stream *msp)
 		if (verify_trace(bit))
 			goto err;
 
-		if (bit->action & BLK_TC_ACT(BLK_TC_NOTIFY) && bit->action != BLK_TN_MESSAGE) {
+		if (bit->action & BLK_TC_ACT(BLK_TC_NOTIFY) &&
+		    bit->action != BLK_TN_MESSAGE &&
+		    bit->action != BLK_TN_GLOCK) {
 			handle_notify(bit);
 			output_binary(bit, sizeof(*bit) + bit->pdu_len);
 			bit_free(bit);
diff --git a/blktrace_api.h b/blktrace_api.h
index 7218845..82dbe1b 100644
--- a/blktrace_api.h
+++ b/blktrace_api.h
@@ -59,6 +59,7 @@ enum blktrace_notify {
 	__BLK_TN_PROCESS = 0,		/* establish pid/name mapping */
 	__BLK_TN_TIMESTAMP,		/* include system clock */
 	__BLK_TN_MESSAGE,               /* Character string message */
+	__BLK_TN_GLOCK,                 /* Glock data */
 };
 
 /*
@@ -85,6 +86,7 @@ enum blktrace_notify {
 #define BLK_TN_PROCESS		(__BLK_TN_PROCESS | BLK_TC_ACT(BLK_TC_NOTIFY))
 #define BLK_TN_TIMESTAMP	(__BLK_TN_TIMESTAMP | BLK_TC_ACT(BLK_TC_NOTIFY))
 #define BLK_TN_MESSAGE		(__BLK_TN_MESSAGE | BLK_TC_ACT(BLK_TC_NOTIFY))
+#define BLK_TN_GLOCK            (__BLK_TN_GLOCK | BLK_TC_ACT(BLK_TC_NOTIFY))
 
 #define BLK_IO_TRACE_MAGIC	0x65617400
 #define BLK_IO_TRACE_VERSION	0x07
@@ -115,6 +117,29 @@ struct blk_io_trace_remap {
 	__u64 sector;
 };
 
+/* Glock lock states, so we don't need to add any header deps */
+enum {
+	BLK_GLS_NONE = 1,       /* i.e. invalid */
+	BLK_GLS_NULL,           /* Null lock (preserves LVB content) */
+	BLK_GLS_CREAD,          /* Concurrent read */
+	BLK_GLS_CWRITE,         /* Concurrent write */
+	BLK_GLS_PREAD,          /* Protected read */
+	BLK_GLS_PWRITE,         /* Protected write */
+	BLK_GLS_EXCLUSIVE,      /* Exclusive */
+};
+
+/*
+ * Glock info
+ */
+struct blk_io_trace_glock {
+	__u32 type;		/* Glock type, as per gl_name.ln_type */
+	__u32 flags;		/* Unused at the moment */
+	__u8 cur_state;		/* Current state */
+	__u8 new_state;		/* New state */
+	__u8 dmt_state;		/* Requested demote state */
+	__u8 tgt_state;		/* Target state */
+};
+
 /*
  * User setup structure passed with BLKSTARTTRACE
  */


