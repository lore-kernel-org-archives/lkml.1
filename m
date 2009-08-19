Return-Path: <linux-kernel-owner+w=401wt.eu-S1751399AbZHSBXB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751399AbZHSBXB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 21:23:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751152AbZHSBW7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 21:22:59 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:41750 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751014AbZHSBW6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 21:22:58 -0400
Date: Tue, 18 Aug 2009 21:22:58 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: lkml <linux-kernel@vger.kernel.org>
cc: Jiri Olsa <jolsa@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL][2.6.31] tracing: handle broken names in ftrace filter
In-Reply-To: <20090811152904.GA26065@jolsa.lab.eng.brq.redhat.com>
Message-ID: <alpine.DEB.2.00.0908182121470.18648@gandalf.stny.rr.com>
References: <20090811152904.GA26065@jolsa.lab.eng.brq.redhat.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

Please pull the latest tip/tracing/urgent tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/tracing/urgent


Jiri Olsa (1):
      tracing: handle broken names in ftrace filter

----
 kernel/trace/ftrace.c |   17 +++++++++++------
 1 files changed, 11 insertions(+), 6 deletions(-)
---------------------------
commit eda1e328556565e211b7450250e40d6de751563a
Author: Jiri Olsa <jolsa@redhat.com>
Date:   Tue Aug 11 17:29:04 2009 +0200

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


