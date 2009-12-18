Return-Path: <linux-kernel-owner+w=401wt.eu-S933033AbZLRVOR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933033AbZLRVOR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 16:14:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932658AbZLRVON
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 16:14:13 -0500
Received: from casper.infradead.org ([85.118.1.10]:35050 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932648AbZLRVOE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 16:14:04 -0500
Subject: Re: [PATCH 1/1] perf record: We should fork only if a program was
 specified to run
From: Peter Zijlstra <peterz@infradead.org>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>
In-Reply-To: <20091218205853.GD19708@ghostprotocols.net>
References: <1261168944-6615-1-git-send-email-acme@infradead.org>
	 <1261169561.20899.630.camel@laptop>
	 <20091218205853.GD19708@ghostprotocols.net>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 18 Dec 2009 22:13:38 +0100
Message-ID: <1261170818.20899.657.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-12-18 at 18:58 -0200, Arnaldo Carvalho de Melo wrote:
> Em Fri, Dec 18, 2009 at 09:52:41PM +0100, Peter Zijlstra escreveu:
> > On Fri, 2009-12-18 at 18:42 -0200, Arnaldo Carvalho de Melo wrote:
> > > From: Arnaldo Carvalho de Melo <acme@redhat.com>
> > > @@ -422,7 +422,8 @@ static int __cmd_record(int argc __used, const char **argv)
> > >  	signal(SIGCHLD, sig_handler);
> > >  	signal(SIGINT, sig_handler);
> > >  
> > > -	if (pipe(child_ready_pipe) < 0 || pipe(go_pipe) < 0) {
> > > +	if (target_pid == -1 && argc > 0 &&
> > > +	    (pipe(child_ready_pipe) < 0 || pipe(go_pipe) < 0)) {
> > >  		perror("failed to create pipes");
> > >  		exit(-1);
> > >  	}
> > 
> > Why bother?
> 
> Because we don't need it?

Well its a rare error, and the paranoid in me says bailing asap avoids
funny cases later.

> > > @@ -483,7 +484,7 @@ static int __cmd_record(int argc __used, const char **argv)
> > >  
> > >  	atexit(atexit_header);
> > >  
> > > -	if (target_pid == -1) {
> > > +	if (target_pid == -1 && argc > 0) {
> > >  		pid = fork();
> > >  		if (pid < 0) {
> > >  			perror("failed to fork");
> > 
> > I'd write:
> > 
> > target_pid == -1 && !system_wide
> 
> Because we want this to work:
> 
> [root@doppio linux-2.6-tip]# perf record -a -f sleep 2
> [ perf record: Woken up 1 times to write data ]
> [ perf record: Captured and wrote 0.243 MB perf.data (~10599 samples) ]
> [root@doppio linux-2.6-tip]#
> 
> See, no hands mother! I.e. it is system wide, but just for 2 seconds,
> its clever, but I like it, and it always worked :-)

Ah, right.. yes, totally forgot about that.

> > > @@ -667,7 +668,7 @@ int cmd_record(int argc, const char **argv, const char *prefix __used)
> > >  
> > >  	argc = parse_options(argc, argv, options, record_usage,
> > >  			    PARSE_OPT_STOP_AT_NON_OPTION);
> > > -	if (!argc && target_pid == -1 && (!system_wide || profile_cpu == -1))
> > > +	if (!argc && target_pid == -1 && !system_wide)
> > >  		usage_with_options(record_usage, options);
> > >  
> > >  	symbol__init();
> > 
> > Right, so I was thinking -C would be enough to also start profiling..
> > clearly messed up the logic though :/
> 
> Yeah, it should, meaning "profile everything on CPU N"

Right, so I tried folding that in and goofed up.

Anyway, patch looks ok, thanks!

