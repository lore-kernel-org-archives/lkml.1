Return-Path: <linux-kernel-owner+w=401wt.eu-S1753296AbZHKP3V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753296AbZHKP3V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 11:29:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752815AbZHKP3U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 11:29:20 -0400
Received: from mx2.redhat.com ([66.187.237.31]:48927 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752061AbZHKP3R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 11:29:17 -0400
Date: Tue, 11 Aug 2009 17:29:04 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] tracing: FTRACE_ITER_CONT handling fix
Message-ID: <20090811152904.GA26065@jolsa.lab.eng.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

if one filter item (for set_ftrace_filter and set_ftrace_notrace) is being 
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

wbr,
jirka


Signed-off-by: Jiri Olsa <jolsa@redhat.com>

---
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 0948634..da0757a 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -2233,7 +2233,11 @@ ftrace_regex_write(struct file *file, const char __user *ubuf,
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
@@ -2243,8 +2247,9 @@ ftrace_regex_write(struct file *file, const char __user *ubuf,
 			cnt--;
 		}
 
+		/* only spaces were written */
 		if (isspace(ch)) {
-			file->f_pos += read;
+			*ppos += read;
 			ret = read;
 			goto out;
 		}
@@ -2273,12 +2278,12 @@ ftrace_regex_write(struct file *file, const char __user *ubuf,
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
