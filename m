Return-Path: <linux-kernel-owner+w=401wt.eu-S1751408AbZHSMhA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751408AbZHSMhA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 08:37:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751139AbZHSMg7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 08:36:59 -0400
Received: from hera.kernel.org ([140.211.167.34]:33211 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750858AbZHSMg6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 08:36:58 -0400
Date: Wed, 19 Aug 2009 12:36:38 GMT
From: tip-bot for Jiri Olsa <jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       rostedt@goodmis.org, tglx@linutronix.de, jolsa@redhat.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       rostedt@goodmis.org, tglx@linutronix.de, jolsa@redhat.com
In-Reply-To: <20090811152904.GA26065@jolsa.lab.eng.brq.redhat.com>
References: <20090811152904.GA26065@jolsa.lab.eng.brq.redhat.com>
Subject: [tip:tracing/urgent] tracing: handle broken names in ftrace filter
Message-ID: <tip-eda1e328556565e211b7450250e40d6de751563a@git.kernel.org>
Git-Commit-ID: eda1e328556565e211b7450250e40d6de751563a
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 19 Aug 2009 12:36:38 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  eda1e328556565e211b7450250e40d6de751563a
Gitweb:     http://git.kernel.org/tip/eda1e328556565e211b7450250e40d6de751563a
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Tue, 11 Aug 2009 17:29:04 +0200
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Tue, 18 Aug 2009 20:39:48 -0400

tracing: handle broken names in ftrace filter

If one filter item (for set_ftrace_filter and set_ftrace_notrace) is being
setup by more than 1 consecutive writes (FTRACE_ITER_CONT flag), it won't
be handled corretly.

I used following program to test/verify:

[snip]
#include <stdio.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <string.h>

int main(int argc, char **argv)
{
        int fd, i;
        char *file = argv[1];

        if (-1 == (fd = open(file, O_WRONLY))) {
                perror("open failed");
                return -1;
        }

        for(i = 0; i < (argc - 2); i++) {
                int len = strlen(argv[2+i]);
                int cnt, off = 0;

                while(len) {
                        cnt = write(fd, argv[2+i] + off, len);
                        len -= cnt;
                        off += cnt;
                }
        }

        close(fd);
        return 0;
}
[snip]

before change:
sh-4.0# echo > ./set_ftrace_filter
sh-4.0# /test ./set_ftrace_filter "sys" "_open "
sh-4.0# cat ./set_ftrace_filter
#### all functions enabled ####
sh-4.0#

after change:
sh-4.0# echo > ./set_ftrace_notrace
sh-4.0# test ./set_ftrace_notrace "sys" "_open "
sh-4.0# cat ./set_ftrace_notrace
sys_open
sh-4.0#

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
LKML-Reference: <20090811152904.GA26065@jolsa.lab.eng.brq.redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>


---
 kernel/trace/ftrace.c |   17 +++++++++++------
 1 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 1e1d23c..25edd5c 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -2278,7 +2278,11 @@ ftrace_regex_write(struct file *file, const char __user *ubuf,
 	read++;
 	cnt--;
 
-	if (!(iter->flags & ~FTRACE_ITER_CONT)) {
+	/*
+	 * If the parser haven't finished with the last write,
+	 * continue reading the user input without skipping spaces.
+	 */
+	if (!(iter->flags & FTRACE_ITER_CONT)) {
 		/* skip white space */
 		while (cnt && isspace(ch)) {
 			ret = get_user(ch, ubuf++);
@@ -2288,8 +2292,9 @@ ftrace_regex_write(struct file *file, const char __user *ubuf,
 			cnt--;
 		}
 
+		/* only spaces were written */
 		if (isspace(ch)) {
-			file->f_pos += read;
+			*ppos += read;
 			ret = read;
 			goto out;
 		}
@@ -2319,12 +2324,12 @@ ftrace_regex_write(struct file *file, const char __user *ubuf,
 		if (ret)
 			goto out;
 		iter->buffer_idx = 0;
-	} else
+	} else {
 		iter->flags |= FTRACE_ITER_CONT;
+		iter->buffer[iter->buffer_idx++] = ch;
+	}
 
-
-	file->f_pos += read;
-
+	*ppos += read;
 	ret = read;
  out:
 	mutex_unlock(&ftrace_regex_lock);
