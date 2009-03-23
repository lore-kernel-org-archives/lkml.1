Return-Path: <linux-kernel-owner+w=401wt.eu-S1756698AbZCWNMw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756698AbZCWNMw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 09:12:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756409AbZCWNMG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 09:12:06 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:46849 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756384AbZCWNMB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 09:12:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=wCkQp7vC9Q/AK1H+FHrQOYbB2SDaXypFVETKw3KyKLbEDZzz26B3aMEUtx5KIZh2hB
         PXJFIgm8wTSsrdDCogVhObAOCY+IQ2WvXvCSn/WVS6raLvNYUMNd2rUc7u30+1zWOPMG
         ahpAdDFOtpUvHrK0yzbwwFLLGTf74VY6EsToI=
From: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
To: mingo@elte.hu
Cc: rostedt@goodmis.org, compudj@krystal.dyndns.org, fweisbec@gmail.com,
       penberg@cs.helsinki.fi, paulmck@linux.vnet.ibm.com,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 2/7] tracing: provide trace_seq_reserve()
Date: Mon, 23 Mar 2009 15:12:22 +0200
Message-Id: <6698c7b983cc20ec84becc757362f48a8948762d.1237813499.git.eduard.munteanu@linux360.ro>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <75eba730cfee8e771090b60c4b252bd8d3ffcb18.1237813499.git.eduard.munteanu@linux360.ro>
References: <cover.1237813499.git.eduard.munteanu@linux360.ro>
 <75eba730cfee8e771090b60c4b252bd8d3ffcb18.1237813499.git.eduard.munteanu@linux360.ro>
In-Reply-To: <cover.1237813499.git.eduard.munteanu@linux360.ro>
References: <cover.1237813499.git.eduard.munteanu@linux360.ro>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

trace_seq_reserve() allows a caller to reserve space in a trace_seq and
write directly into it. This makes it easier to export binary data to
userspace via the tracing interface, by simply filling in a struct.

Signed-off-by: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
---
 kernel/trace/trace_output.c |   13 +++++++++++++
 kernel/trace/trace_output.h |    1 +
 2 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/trace_output.c b/kernel/trace/trace_output.c
index 9fc8150..bdcc3fe 100644
--- a/kernel/trace/trace_output.c
+++ b/kernel/trace/trace_output.c
@@ -116,6 +116,19 @@ int trace_seq_putmem_hex(struct trace_seq *s, void *mem, size_t len)
 	return trace_seq_putmem(s, hex, j);
 }
 
+void *trace_seq_reserve(struct trace_seq *s, size_t len)
+{
+	void *ret;
+
+	if (len > ((PAGE_SIZE - 1) - s->len))
+		return NULL;
+
+	ret = s->buffer + s->len;
+	s->len += len;
+
+	return ret;
+}
+
 int trace_seq_path(struct trace_seq *s, struct path *path)
 {
 	unsigned char *p;
diff --git a/kernel/trace/trace_output.h b/kernel/trace/trace_output.h
index 551a25a..cbc0ec8 100644
--- a/kernel/trace/trace_output.h
+++ b/kernel/trace/trace_output.h
@@ -27,6 +27,7 @@ int trace_seq_puts(struct trace_seq *s, const char *str);
 int trace_seq_putc(struct trace_seq *s, unsigned char c);
 int trace_seq_putmem(struct trace_seq *s, void *mem, size_t len);
 int trace_seq_putmem_hex(struct trace_seq *s, void *mem, size_t len);
+void *trace_seq_reserve(struct trace_seq *s, size_t len);
 int trace_seq_path(struct trace_seq *s, struct path *path);
 int seq_print_userip_objs(const struct userstack_entry *entry,
 			  struct trace_seq *s, unsigned long sym_flags);
-- 
1.6.0.6

