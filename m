Return-Path: <linux-kernel-owner+w=401wt.eu-S1752492AbZHEUIc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752492AbZHEUIc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 16:08:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752440AbZHEUIb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 16:08:31 -0400
Received: from mx2.redhat.com ([66.187.237.31]:51514 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752329AbZHEUIb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 16:08:31 -0400
Date: Wed, 5 Aug 2009 16:07:21 -0400
From: Jason Baron <jbaron@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Chris Mason <chris.mason@oracle.com>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] perf: Don't list tracepoints without an id
Message-ID: <20090805200721.GA3127@redhat.com>
References: <1249497664.5890.4.camel@laptop> <1249500229.5890.10.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1249500229.5890.10.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 05, 2009 at 09:23:49PM +0200, Peter Zijlstra wrote:
> Stop perf list from displaying tracepoints without an id file.
> 
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
>  tools/perf/util/parse-events.c |   10 ++++++++++
>  1 files changed, 10 insertions(+), 0 deletions(-)
> 
> diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
> index 7bdad8d..d00636b 100644
> --- a/tools/perf/util/parse-events.c
> +++ b/tools/perf/util/parse-events.c
> @@ -568,6 +568,7 @@ static void print_tracepoint_events(void)
>  	struct dirent *sys_next, *evt_next, sys_dirent, evt_dirent;
>  	struct stat st;
>  	char evt_path[MAXPATHLEN];
> +	int fd;
>  
>  	if (valid_debugfs_mount(debugfs_path))
>  		return;
> @@ -582,6 +583,15 @@ static void print_tracepoint_events(void)
>  			goto cleanup;
>  		for_each_event(sys_dirent, evt_dir, evt_dirent, evt_next,
>  								evt_path, st) {
> +
> +			snprintf(evt_path, MAXPATHLEN, "%s/%s/%s/id",
> +					debugfs_path, 
> +					sys_dirent.d_name, evt_dirent.d_name);
> +			fd = open(evt_path, O_RDONLY);
> +			if (fd < 0)
> +				continue;
> +			close(fd);
> +
>  			snprintf(evt_path, MAXPATHLEN, "%s:%s",
>  				 sys_dirent.d_name, evt_dirent.d_name);
>  			fprintf(stderr, "  %-40s [%s]\n", evt_path,
> 
> 

hmmm, might be nicer to add this check to the 'for_each_event()' macro
instead...

thanks,

-Jason
