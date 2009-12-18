Return-Path: <linux-kernel-owner+w=401wt.eu-S932670AbZLRUx0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932670AbZLRUx0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 15:53:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932623AbZLRUxZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 15:53:25 -0500
Received: from casper.infradead.org ([85.118.1.10]:49958 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932622AbZLRUxY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 15:53:24 -0500
Subject: Re: [PATCH 1/1] perf record: We should fork only if a program was
 specified to run
From: Peter Zijlstra <peterz@infradead.org>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>
In-Reply-To: <1261168944-6615-1-git-send-email-acme@infradead.org>
References: <1261168944-6615-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 18 Dec 2009 21:52:41 +0100
Message-ID: <1261169561.20899.630.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-12-18 at 18:42 -0200, Arnaldo Carvalho de Melo wrote:
> From: Arnaldo Carvalho de Melo <acme@redhat.com>
> 
> IOW: Now 'perf record -a' works, this was a bug introduced in:
> 
> 856e96608a72412d319e498a3a7c557571f811bd
> "perf record: Properly synchronize child creation"
> 
> Reported-by: Pekka Enberg <penberg@cs.helsinki.fi>
> Cc: Frédéric Weisbecker <fweisbec@gmail.com>
> Cc: Mike Galbraith <efault@gmx.de>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Paul Mackerras <paulus@samba.org>
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> ---
>  tools/perf/builtin-record.c |    9 +++++----
>  1 files changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
> index 63136d0..90eedd9 100644
> --- a/tools/perf/builtin-record.c
> +++ b/tools/perf/builtin-record.c
> @@ -402,7 +402,7 @@ static void atexit_header(void)
>  	perf_header__write(&session->header, output, true);
>  }
>  
> -static int __cmd_record(int argc __used, const char **argv)
> +static int __cmd_record(int argc, const char **argv)
>  {
>  	int i, counter;
>  	struct stat st;
> @@ -422,7 +422,8 @@ static int __cmd_record(int argc __used, const char **argv)
>  	signal(SIGCHLD, sig_handler);
>  	signal(SIGINT, sig_handler);
>  
> -	if (pipe(child_ready_pipe) < 0 || pipe(go_pipe) < 0) {
> +	if (target_pid == -1 && argc > 0 &&
> +	    (pipe(child_ready_pipe) < 0 || pipe(go_pipe) < 0)) {
>  		perror("failed to create pipes");
>  		exit(-1);
>  	}

Why bother?

> @@ -483,7 +484,7 @@ static int __cmd_record(int argc __used, const char **argv)
>  
>  	atexit(atexit_header);
>  
> -	if (target_pid == -1) {
> +	if (target_pid == -1 && argc > 0) {
>  		pid = fork();
>  		if (pid < 0) {
>  			perror("failed to fork");

I'd write:

target_pid == -1 && !system_wide

> @@ -667,7 +668,7 @@ int cmd_record(int argc, const char **argv, const char *prefix __used)
>  
>  	argc = parse_options(argc, argv, options, record_usage,
>  			    PARSE_OPT_STOP_AT_NON_OPTION);
> -	if (!argc && target_pid == -1 && (!system_wide || profile_cpu == -1))
> +	if (!argc && target_pid == -1 && !system_wide)
>  		usage_with_options(record_usage, options);
>  
>  	symbol__init();

Right, so I was thinking -C would be enough to also start profiling..
clearly messed up the logic though :/

