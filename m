Return-Path: <linux-kernel-owner+w=401wt.eu-S1753416AbZGVHm5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753416AbZGVHm5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 03:42:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752524AbZGVHm4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 03:42:56 -0400
Received: from mx2.redhat.com ([66.187.237.31]:57367 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752521AbZGVHmz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 03:42:55 -0400
Date: Wed, 22 Jul 2009 09:42:30 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>,
       Li Zefan <lizf@cn.fujitsu.com>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH] tracing: dont reset set_ftrace_filter/notrace when
	opened with r/w perm
Message-ID: <20090722074230.GA18925@jolsa.lab.eng.brq.redhat.com>
References: <20090716165135.GA4739@jolsa.lab.eng.brq.redhat.com> <alpine.DEB.2.00.0907202104130.17909@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0907202104130.17909@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 20, 2009 at 09:11:34PM -0400, Steven Rostedt wrote:
> 
> On Thu, 16 Jul 2009, Jiri Olsa wrote:
> 
> > If user setup set_ftrace_filter/set_ftrace_notrace files and then opens them
> > with read&write permissions, the previous setup will be removed.
> 
> This is exactly what it was suppose to do.
> 
> man fopen:
> 
>        w+     Open for reading and writing.  The file is created  if  it  does
>               not  exist, otherwise it is truncated.  The stream is positioned
>               at the beginning of the file.
> 
> Which means that if you open a file for "w+" it will truncate it. Hence, 
> you will remove all previous settings.
> 
> What you want is:
> 
>        a+     Open for reading and appending (writing at end  of  file).   The
>               file is created if it does not exist.  The initial file position
>               for reading is at the beginning  of  the  file,  but  output  is
>               always appended to the end of the file.
> 
> Change the belowe code from "w+" to "a+" and you get your expected result.

My point was that if you open set_ftrace_filter/set_ftrace_notrace with just O_RDWR
perm. and will use the file just for reading, the filter will reset.

You're right about the "w+", there's the O_CREAT|O_TRUNC, sry I missed that.. ;)
Anyway with "r+" you'll get O_RDWR perm. only, showing the issue:


sh-4.0# echo "sys_open sys_write" > ./set_ftrace_filter 
sh-4.0# cat ./set_ftrace_filter 
sys_open
sys_write
sh-4.0# /ft ./set_ftrace_filter r+
#### all functions enabled ####
sh-4.0# cat ./set_ftrace_filter 
#### all functions enabled ####
sh-4.0# 


wbr,
jirka

> 
> Thus, the current code is correct.
> 
> -- Steve
> 
> 
> 
> > 
> > Tested with following program:
> > 
> > [snip]
> > #include <stdio.h>
> > #include <string.h>
> > 
> > int main(int argc, char **argv)
> > {
> > 	FILE *f;
> > 	char *mode = "w+";
> > 	char *file = argv[1];
> > 
> > 	if (argc == 3)
> > 		mode = argv[2];
> > 
> > 	if (NULL == (f = fopen(file, mode))) {
> > 		perror("fopen failed");
> > 		return -1;
> > 	}
> > 
> > 	while(!feof(f)) {
> > #define BUFLEN 100
> > 		char buf[BUFLEN];
> > 		memset(buf, 0, BUFLEN);
> > 		fgets(buf, BUFLEN, f);
> > 		printf(buf);
> > 	}
> > 
> > 	fclose(f);
> > 	return 0;
> > }
> > [snip]
> > 
> > wbr,
> > jirka
> > 
> > 
> > Signed-off-by: Jiri Olsa <jolsa@redhat.com>
> > 
> > ---
> > diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
> > index 4521c77..11394bc 100644
> > --- a/kernel/trace/ftrace.c
> > +++ b/kernel/trace/ftrace.c
> > @@ -1661,10 +1661,6 @@ ftrace_regex_open(struct inode *inode, struct file *file, int enable)
> >  		return -ENOMEM;
> >  
> >  	mutex_lock(&ftrace_regex_lock);
> > -	if ((file->f_mode & FMODE_WRITE) &&
> > -	    !(file->f_flags & O_APPEND))
> > -		ftrace_filter_reset(enable);
> > -
> >  	if (file->f_mode & FMODE_READ) {
> >  		iter->pg = ftrace_pages_start;
> >  		iter->flags = enable ? FTRACE_ITER_FILTER :
> > @@ -2260,6 +2256,9 @@ ftrace_regex_write(struct file *file, const char __user *ubuf,
> >  		return 0;
> >  
> >  	mutex_lock(&ftrace_regex_lock);
> > +	if ((file->f_mode & FMODE_WRITE) &&
> > +	    !(file->f_flags & O_APPEND))
> > +		ftrace_filter_reset(enable);
> >  
> >  	if (file->f_mode & FMODE_READ) {
> >  		struct seq_file *m = file->private_data;
> > 
