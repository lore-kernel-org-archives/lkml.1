Return-Path: <linux-kernel-owner+w=401wt.eu-S1754072AbZGVMUP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754072AbZGVMUP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 08:20:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751542AbZGVMUO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 08:20:14 -0400
Received: from mx2.redhat.com ([66.187.237.31]:36583 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751018AbZGVMUN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 08:20:13 -0400
Date: Wed, 22 Jul 2009 14:19:47 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tracing: dont reset set_ftrace_filter/notrace when
	opened with r/w perm
Message-ID: <20090722121947.GA3143@jolsa.lab.eng.brq.redhat.com>
References: <20090716165135.GA4739@jolsa.lab.eng.brq.redhat.com> <4A604654.1090303@cn.fujitsu.com> <20090717111025.GC2891@jolsa.lab.eng.brq.redhat.com> <4A63C09A.80904@cn.fujitsu.com> <20090720013219.GB5172@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090720013219.GB5172@nowhere>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 19, 2009 at 09:32:25PM -0400, Frederic Weisbecker wrote:
> On Mon, Jul 20, 2009 at 08:55:54AM +0800, Li Zefan wrote:
> > Jiri Olsa wrote:
> > > On Fri, Jul 17, 2009 at 05:37:24PM +0800, Li Zefan wrote:
> > >> Jiri Olsa wrote:
> > >>> If user setup set_ftrace_filter/set_ftrace_notrace files and then opens them
> > >>> with read&write permissions, the previous setup will be removed.
> > >>>
> > >> Currently:
> > >>
> > >>  # echo 'sys_open sys_close' > set_ftrace_filter
> > >>  # cat set_ftrace_filter
> > >>  sys_open
> > >>  sys_close
> > >>
> > >> After your patch:
> > >>
> > >>  # echo 'sys_open sys_close' > set_ftrace_filter
> > >>  # cat set_ftrace_filter
> > >>  sys_close
> > >>
> > > 
> > > oops, sry I missed this..
> > > 
> > > Following patch adds new FTRACE_ITER_RESET flag, as the decision needs
> > > to be taken in "open" and applied in "write".  I'm not sure whats the
> > > policy for adding new flags, but it looks ok to me.
> > > 
> > 
> > I have no strong opinion whether to do the reset in "open" or in first
> > "write".
> > 
> > All said, I think this is cleaner, without introducing a new flag:
> > 
> > @@ -2260,6 +2256,9 @@ ftrace_regex_write(struct file *file, const char __user *ubuf,
> >  		return 0;
> >  
> >  	mutex_lock(&ftrace_regex_lock);
> > +	if (file->f_pos == 0 &&
> > +	    (file->f_mode & FMODE_WRITE) && !(file->f_flags & O_APPEND))
> > +		ftrace_filter_reset(enable);
> >  
> >  	if (file->f_mode & FMODE_READ) {
> >  		struct seq_file *m = file->private_data;
> 
> 
> Yeah, that avoids this need of creating a new flag.
> Looks like a good solution.
> 

yes, but this wont work unless the *ppos value is updated instead of the
file->f_pos, because of:


  SYSCALL_DEFINE3(write, unsigned int, fd, const char __user *, buf,
                size_t, count)
  {
	[snip]
                loff_t pos = file_pos_read(file);
                ret = vfs_write(file, buf, count, &pos);
                file_pos_write(file, pos);
	[snip]


Together with this fix I included fix for FTRACE_ITER_CONT flag, since
it does not seem to work correctly.
As far as I understand the reason for FTRACE_ITER_CONT flag is when
there's one regexp. in more write calls. I made a program to test it.

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

I got following behaviour on the current tip master:

sh-4.0# /tst ./set_ftrace_filter sys_o "pen "
sh-4.0# cat ./set_ftrace_filter 
#### all functions enabled ####


wbr,
jirka

---
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 24e3ff5..041a327 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1616,10 +1616,6 @@ ftrace_regex_open(struct inode *inode, struct file *file, int enable)
 		return -ENOMEM;
 
 	mutex_lock(&ftrace_regex_lock);
-	if ((file->f_mode & FMODE_WRITE) &&
-	    !(file->f_flags & O_APPEND))
-		ftrace_filter_reset(enable);
-
 	if (file->f_mode & FMODE_READ) {
 		iter->pg = ftrace_pages_start;
 		iter->flags = enable ? FTRACE_ITER_FILTER :
@@ -2225,6 +2221,10 @@ ftrace_regex_write(struct file *file, const char __user *ubuf,
 	if (!*ppos) {
 		iter->flags &= ~FTRACE_ITER_CONT;
 		iter->buffer_idx = 0;
+
+		if ((file->f_mode & FMODE_WRITE) &&
+		    !(file->f_flags & O_APPEND))
+			ftrace_filter_reset(enable);
 	}
 
 	ret = get_user(ch, ubuf++);
@@ -2233,7 +2233,11 @@ ftrace_regex_write(struct file *file, const char __user *ubuf,
 	read++;
 	cnt--;
 
-	if (!(iter->flags & ~FTRACE_ITER_CONT)) {
+	/*
+	 * If the parses havent finished with the last write,
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
