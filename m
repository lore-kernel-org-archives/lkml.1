Return-Path: <linux-kernel-owner+w=401wt.eu-S1756934AbZKUWKf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756934AbZKUWKf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Nov 2009 17:10:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756889AbZKUWKb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Nov 2009 17:10:31 -0500
Received: from mail01d.mail.t-online.hu ([84.2.42.6]:56325 "EHLO
	mail01d.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756873AbZKUWKQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Nov 2009 17:10:16 -0500
X-Authuid: nmarci
Message-ID: <4B086547.5040100@freemail.hu>
Date: Sat, 21 Nov 2009 23:10:15 +0100
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; hu-HU; rv:1.8.1.21) Gecko/20090402 SeaMonkey/1.1.16
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
       Ingo Molnar <mingo@elte.hu>
CC: cocci@diku.dk, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/4] perf_event: remove redundant zero fill
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-DCC-mail.t-online.hu-Metrics: mail01d.mail.t-online.hu 32711; Body=5 Fuz1=5
	Fuz2=5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Márton Németh <nm127@freemail.hu>

The buffer is first zeroed out by memset(). Then strncpy() is used to
fill the content. The strncpy() function also pads the string till the
end of the specified length, which is redundant. The strncpy() does not
ensures that the string will be properly closed with 0. Use strlcpy()
instead.

The semantic match that finds this kind of pattern is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
expression buffer;
expression size;
expression str;
@@
	memset(buffer, 0, size);
	...
-	strncpy(
+	strlcpy(
	buffer, str, sizeof(buffer)
	);
@@
expression buffer;
expression size;
expression str;
@@
	memset(&buffer, 0, size);
	...
-	strncpy(
+	strlcpy(
	&buffer, str, sizeof(buffer));
@@
expression buffer;
identifier field;
expression size;
expression str;
@@
	memset(buffer, 0, size);
	...
-	strncpy(
+	strlcpy(
	buffer->field, str, sizeof(buffer->field)
	);
@@
expression buffer;
identifier field;
expression size;
expression str;
@@
	memset(&buffer, 0, size);
	...
-	strncpy(
+	strlcpy(
	buffer.field, str, sizeof(buffer.field));
// </smpl>

On strncpy() vs strlcpy() see http://www.gratisoft.us/todd/papers/strlcpy.html .

Signed-off-by: Márton Németh <nm127@freemail.hu>
---
diff -u -p a/kernel/perf_event.c b/kernel/perf_event.c
--- a/kernel/perf_event.c 2009-11-14 07:06:52.000000000 +0100
+++ b/kernel/perf_event.c 2009-11-21 22:15:26.000000000 +0100
@@ -3367,7 +3367,7 @@ static void perf_event_comm_event(struct
 	char comm[TASK_COMM_LEN];

 	memset(comm, 0, sizeof(comm));
-	strncpy(comm, comm_event->task->comm, sizeof(comm));
+	strlcpy(comm, comm_event->task->comm, sizeof(comm));
 	size = ALIGN(strlen(comm)+1, sizeof(u64));

 	comm_event->comm = comm;
