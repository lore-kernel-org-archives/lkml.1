Return-Path: <linux-kernel-owner+w=401wt.eu-S1753291AbZCDFH0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753291AbZCDFH0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 00:07:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750739AbZCDFHM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 00:07:12 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:53169 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750717AbZCDFHK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 00:07:10 -0500
Date: Wed, 4 Mar 2009 00:07:07 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: LKML <linux-kernel@vger.kernel.org>
cc: Theodore Tso <tytso@mit.edu>, Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arjan van de Ven <arjan@infradead.org>, Pekka Paalanen <pq@iki.fi>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Martin Bligh <mbligh@google.com>, "Frank Ch. Eigler" <fche@redhat.com>,
       Tom Zanussi <tzanussi@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Jason Baron <jbaron@redhat.com>, Christoph Hellwig <hch@infradead.org>,
       Jiaying Zhang <jiayingz@google.com>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       mrubin@google.com, md@google.com, Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH] fs: make simple_read_from_buffer conventional
In-Reply-To: <20090304044614.GL32284@mit.edu>
Message-ID: <alpine.DEB.2.00.0903040002180.7995@gandalf.stny.rr.com>
References: <20090304024921.153061228@goodmis.org> <20090304025251.015368537@goodmis.org> <20090303193501.0055e329.akpm@linux-foundation.org> <alpine.DEB.2.00.0903032242180.6862@gandalf.stny.rr.com> <20090304044614.GL32284@mit.edu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: have simple_read_from_buffer conform to standards

It was brought to my attention by Andrew Morton, Theodore Tso,
and H. Peter Anvin that a read from userspace should only return
-EFAULT if nothing was actually read.

Looking at the simple_read_from_buffer I noticed that this function
does not conform to that rule. This patch fixes that function.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>

diff --git a/fs/libfs.c b/fs/libfs.c
index 49b4409..6a72298 100644
--- a/fs/libfs.c
+++ b/fs/libfs.c
@@ -525,14 +525,20 @@ ssize_t simple_read_from_buffer(void __user *to, size_t count, loff_t *ppos,
 				const void *from, size_t available)
 {
 	loff_t pos = *ppos;
+	size_t ret;
+
 	if (pos < 0)
 		return -EINVAL;
 	if (pos >= available)
 		return 0;
 	if (count > available - pos)
 		count = available - pos;
-	if (copy_to_user(to, from + pos, count))
-		return -EFAULT;
+	ret = copy_to_user(to, from + pos, count);
+	if (ret) {
+		if (ret == count)
+			return -EFAULT;
+		count -= ret;
+	}
 	*ppos = pos + count;
 	return count;
 }

