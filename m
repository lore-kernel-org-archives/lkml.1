Return-Path: <linux-kernel-owner+w=401wt.eu-S932960AbZLRU7U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932960AbZLRU7U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 15:59:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932699AbZLRU7M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 15:59:12 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:57664 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932914AbZLRU7H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 15:59:07 -0500
Date: Fri, 18 Dec 2009 18:58:53 -0200
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH 1/1] perf record: We should fork only if a program was
	specified to run
Message-ID: <20091218205853.GD19708@ghostprotocols.net>
References: <1261168944-6615-1-git-send-email-acme@infradead.org> <1261169561.20899.630.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1261169561.20899.630.camel@laptop>
X-Url: http://oops.ghostprotocols.net:81/blog
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Dec 18, 2009 at 09:52:41PM +0100, Peter Zijlstra escreveu:
> On Fri, 2009-12-18 at 18:42 -0200, Arnaldo Carvalho de Melo wrote:
> > From: Arnaldo Carvalho de Melo <acme@redhat.com>
> > @@ -422,7 +422,8 @@ static int __cmd_record(int argc __used, const char **argv)
> >  	signal(SIGCHLD, sig_handler);
> >  	signal(SIGINT, sig_handler);
> >  
> > -	if (pipe(child_ready_pipe) < 0 || pipe(go_pipe) < 0) {
> > +	if (target_pid == -1 && argc > 0 &&
> > +	    (pipe(child_ready_pipe) < 0 || pipe(go_pipe) < 0)) {
> >  		perror("failed to create pipes");
> >  		exit(-1);
> >  	}
> 
> Why bother?

Because we don't need it?

> > @@ -483,7 +484,7 @@ static int __cmd_record(int argc __used, const char **argv)
> >  
> >  	atexit(atexit_header);
> >  
> > -	if (target_pid == -1) {
> > +	if (target_pid == -1 && argc > 0) {
> >  		pid = fork();
> >  		if (pid < 0) {
> >  			perror("failed to fork");
> 
> I'd write:
> 
> target_pid == -1 && !system_wide

Because we want this to work:

[root@doppio linux-2.6-tip]# perf record -a -f sleep 2
[ perf record: Woken up 1 times to write data ]
[ perf record: Captured and wrote 0.243 MB perf.data (~10599 samples) ]
[root@doppio linux-2.6-tip]#

See, no hands mother! I.e. it is system wide, but just for 2 seconds,
its clever, but I like it, and it always worked :-)
 
> > @@ -667,7 +668,7 @@ int cmd_record(int argc, const char **argv, const char *prefix __used)
> >  
> >  	argc = parse_options(argc, argv, options, record_usage,
> >  			    PARSE_OPT_STOP_AT_NON_OPTION);
> > -	if (!argc && target_pid == -1 && (!system_wide || profile_cpu == -1))
> > +	if (!argc && target_pid == -1 && !system_wide)
> >  		usage_with_options(record_usage, options);
> >  
> >  	symbol__init();
> 
> Right, so I was thinking -C would be enough to also start profiling..
> clearly messed up the logic though :/

Yeah, it should, meaning "profile everything on CPU N"

- Arnaldo
