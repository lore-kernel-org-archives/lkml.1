Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755199Ab0CCHFo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 02:05:44 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:58581 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755071Ab0CCHFj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 02:05:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=gWenWOXdFOgMxL2ehvEiXHRntjDvj81a+U53lH69/heIKx+XBF0YRPGArasoMuGQZV
         p1qAe7XGL1nEzSH9hFWYJqCCYnXTcRh3ZSXT1QnmGnUj6Sm+pnKXg79PRrHZxd+jf4vz
         PMh5jcRbxuIfHpvbF/9WzDvfLY6YMYECOZGYM=
From: Tom Zanussi <tzanussi@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, fweisbec@gmail.com, rostedt@goodmis.org,
       k-keiichi@bx.jp.nec.com
Subject: [RFC PATCH 3/7] perf: convert perf header attrs into attr events
Date: Wed,  3 Mar 2010 01:05:25 -0600
Message-Id: <1267599929-8310-4-git-send-email-tzanussi@gmail.com>
X-Mailer: git-send-email 1.6.4.GIT
In-Reply-To: <1267599929-8310-1-git-send-email-tzanussi@gmail.com>
References: <1267599929-8310-1-git-send-email-tzanussi@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bypasses the attr perf header code and replaces it with a synthesized
event and processing function that accomplishes the same thing, used
when reading/writing perf data to/from a pipe.

Making the attrs into events allows them to be streamed over a pipe
along with the rest of the header data (in later patches).  It also
paves the way to allowing events to be added and removed from perf
sessions dynamically.

Signed-off-by: Tom Zanussi <tzanussi@gmail.com>
---
 tools/perf/builtin-record.c |   10 +++++
 tools/perf/util/event.h     |   10 +++++-
 tools/perf/util/header.c    |   80 +++++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/header.h    |    8 ++++
 tools/perf/util/session.c   |   27 ++++++++++++++
 tools/perf/util/session.h   |    3 +-
 6 files changed, 136 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index b676689..3ba466f 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -566,6 +566,16 @@ static int __cmd_record(int argc, const char **argv)
 
 	post_processing_offset = lseek(output, 0, SEEK_CUR);
 
+	if (pipe_output) {
+		err = event__synthesize_attrs(&session->header,
+					      process_synthesized_event,
+					      session);
+		if (err < 0) {
+			pr_err("Couldn't synthesize attrs.\n");
+			return err;
+		}
+	}
+
 	err = event__synthesize_kernel_mmap(process_synthesized_event,
 					    session, "_text");
 	if (err < 0) {
diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index cec3067..83e5d08 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -84,7 +84,14 @@ struct build_id_event {
 };
 
 enum perf_header_event_type { /* above any possible kernel type */
-	PERF_RECORD_HEADER_MAX			= 64,
+	PERF_RECORD_HEADER_ATTR			= 64,
+	PERF_RECORD_HEADER_MAX
+};
+
+struct attr_event {
+	struct perf_event_header header;
+	struct perf_event_attr attr;
+	u64 id[];
 };
 
 typedef union event_union {
@@ -96,6 +103,7 @@ typedef union event_union {
 	struct lost_event		lost;
 	struct read_event		read;
 	struct sample_event		sample;
+	struct attr_event		attr;
 } event_t;
 
 struct events_stats {
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 75b8a4c..6397ad9 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -713,6 +713,7 @@ static int perf_header__read_pipe(struct perf_session *session, int fd)
 	}
 
 	perf_event_ops__fill_stop(&header_ops);
+	header_ops.attr = event__process_attr;
 	session->fd = fd;
 
 	return perf_session__process_events(session, &header_ops);
@@ -825,3 +826,82 @@ perf_header__find_attr(u64 id, struct perf_header *header)
 
 	return NULL;
 }
+
+int event__synthesize_attr(struct perf_event_attr *attr, u16 ids, u64 *id,
+			   event__handler_t process,
+			   struct perf_session *session)
+{
+	event_t *ev;
+	size_t size;
+	int err;
+
+	size = sizeof(struct perf_event_attr);
+	size = ALIGN(size, sizeof(u64));
+	size += sizeof(struct perf_event_header);
+	size += ids * sizeof(u64);
+
+	ev = malloc(size);
+
+	ev->attr.attr = *attr;
+	memcpy(ev->attr.id, id, ids * sizeof(u64));
+
+	ev->attr.header.type = PERF_RECORD_HEADER_ATTR;
+	ev->attr.header.size = size;
+
+	err = process(ev, session);
+
+	free(ev);
+
+	return err;
+}
+
+int event__synthesize_attrs(struct perf_header *self,
+			    event__handler_t process,
+			    struct perf_session *session)
+{
+	struct perf_header_attr	*attr;
+	int i, err = 0;
+
+	for (i = 0; i < self->attrs; i++) {
+		attr = self->attr[i];
+
+		err = event__synthesize_attr(&attr->attr, attr->ids, attr->id,
+					     process, session);
+		if (err) {
+			pr_debug("failed to create perf header attribute\n");
+			return err;
+		}
+	}
+
+	return err;
+}
+
+int event__process_attr(event_t *self, struct perf_session *session)
+{
+	struct perf_header_attr *attr;
+	unsigned int i, ids, n_ids;
+
+	attr = perf_header_attr__new(&self->attr.attr);
+	if (attr == NULL)
+		return -ENOMEM;
+
+	ids = self->header.size;
+	ids -= (void *)&self->attr.id - (void *)self;
+	n_ids = ids / sizeof(u64);
+
+	for (i = 0; i < n_ids; i++) {
+		if (perf_header_attr__add_id(attr, self->attr.id[i]) < 0) {
+			perf_header_attr__delete(attr);
+			return -ENOMEM;
+		}
+	}
+
+	if (perf_header__add_attr(&session->header, attr) < 0) {
+		perf_header_attr__delete(attr);
+		return -ENOMEM;
+	}
+
+	perf_session__update_sample_type(session);
+
+	return 0;
+}
diff --git a/tools/perf/util/header.h b/tools/perf/util/header.h
index 714b1d5..f5fd82c 100644
--- a/tools/perf/util/header.h
+++ b/tools/perf/util/header.h
@@ -95,4 +95,12 @@ int build_id_cache__add_s(const char *sbuild_id, const char *debugdir,
 			  const char *name, bool is_kallsyms);
 int build_id_cache__remove_s(const char *sbuild_id, const char *debugdir);
 
+int event__synthesize_attr(struct perf_event_attr *attr, u16 ids, u64 *id,
+			   event__handler_t process,
+			   struct perf_session *session);
+int event__synthesize_attrs(struct perf_header *self,
+			    event__handler_t process,
+			    struct perf_session *session);
+int event__process_attr(event_t *self, struct perf_session *session);
+
 #endif /* __PERF_HEADER_H */
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 3a3db33..ff51105 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -209,6 +209,8 @@ static void perf_event_ops__fill_defaults(struct perf_event_ops *handler)
 		handler->throttle = process_event_stub;
 	if (handler->unthrottle == NULL)
 		handler->unthrottle = process_event_stub;
+	if (handler->attr == NULL)
+		handler->attr = process_event_stub;
 }
 
 static int process_event_stop(event_t *event __used,
@@ -229,6 +231,7 @@ void perf_event_ops__fill_stop(struct perf_event_ops *handler)
 	handler->read = process_event_stop;
 	handler->throttle = process_event_stop;
 	handler->unthrottle = process_event_stop;
+	handler->attr = process_event_stop;
 }
 
 static const char *event__name[] = {
@@ -242,6 +245,7 @@ static const char *event__name[] = {
 	[PERF_RECORD_FORK]	 = "FORK",
 	[PERF_RECORD_READ]	 = "READ",
 	[PERF_RECORD_SAMPLE]	 = "SAMPLE",
+	[PERF_RECORD_HEADER_ATTR]	 = "ATTR",
 };
 
 unsigned long event__total[PERF_RECORD_HEADER_MAX];
@@ -308,6 +312,26 @@ static void event__read_swap(event_t *self)
 	self->read.id		= bswap_64(self->read.id);
 }
 
+static void event__attr_swap(event_t *self)
+{
+	size_t size;
+
+	self->attr.attr.type		= bswap_32(self->attr.attr.type);
+	self->attr.attr.size		= bswap_32(self->attr.attr.size);
+	self->attr.attr.config		= bswap_64(self->attr.attr.config);
+	self->attr.attr.sample_period	= bswap_64(self->attr.attr.sample_period);
+	self->attr.attr.sample_type	= bswap_64(self->attr.attr.sample_type);
+	self->attr.attr.read_format	= bswap_64(self->attr.attr.read_format);
+	self->attr.attr.wakeup_events	= bswap_32(self->attr.attr.wakeup_events);
+	self->attr.attr.bp_type		= bswap_32(self->attr.attr.bp_type);
+	self->attr.attr.bp_addr		= bswap_64(self->attr.attr.bp_addr);
+	self->attr.attr.bp_len		= bswap_64(self->attr.attr.bp_len);
+
+	size = self->header.size;
+	size -= (void *)&self->attr.id - (void *)self;
+	mem_bswap_64(self->attr.id, size);
+}
+
 typedef void (*event__swap_op)(event_t *self);
 
 static event__swap_op event__swap_ops[] = {
@@ -318,6 +342,7 @@ static event__swap_op event__swap_ops[] = {
 	[PERF_RECORD_LOST]   = event__all64_swap,
 	[PERF_RECORD_READ]   = event__read_swap,
 	[PERF_RECORD_SAMPLE] = event__all64_swap,
+	[PERF_RECORD_HEADER_ATTR]   = event__attr_swap,
 	[PERF_RECORD_HEADER_MAX]    = NULL,
 };
 
@@ -358,6 +383,8 @@ static int perf_session__process_event(struct perf_session *self,
 		return ops->throttle(event, self);
 	case PERF_RECORD_UNTHROTTLE:
 		return ops->unthrottle(event, self);
+	case PERF_RECORD_HEADER_ATTR:
+		return ops->attr(event, self);
 	default:
 		self->unknown_events++;
 		return -1;
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index ab1fcbf..7365a24 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -43,7 +43,8 @@ struct perf_event_ops {
 		 lost,
 		 read,
 		 throttle,
-		 unthrottle;
+		 unthrottle,
+		 attr;
 };
 
 /*
-- 
1.6.4.GIT

