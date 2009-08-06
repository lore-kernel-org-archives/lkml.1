Return-Path: <linux-kernel-owner+w=401wt.eu-S932124AbZHFTfN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932124AbZHFTfN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 15:35:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756556AbZHFTfM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 15:35:12 -0400
Received: from mx2.redhat.com ([66.187.237.31]:35124 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756549AbZHFTfM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 15:35:12 -0400
Date: Thu, 6 Aug 2009 15:33:49 -0400
From: Jason Baron <jbaron@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Chris Mason <chris.mason@oracle.com>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -v2] perf: Don't list tracepoints without an id
Message-ID: <20090806193349.GA2666@redhat.com>
References: <1249497664.5890.4.camel@laptop> <1249500229.5890.10.camel@laptop> <20090805200721.GA3127@redhat.com> <1249570134.32113.483.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1249570134.32113.483.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 06, 2009 at 04:48:54PM +0200, Peter Zijlstra wrote:
> Stop perf list from displaying tracepoints without an id file.
> 
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
>  tools/perf/util/parse-events.c |   18 +++++++++++++++++-
>  1 file changed, 17 insertions(+), 1 deletion(-)
> 
> Index: linux-2.6/tools/perf/util/parse-events.c
> ===================================================================
> --- linux-2.6.orig/tools/perf/util/parse-events.c
> +++ linux-2.6/tools/perf/util/parse-events.c
> @@ -121,13 +121,29 @@ static unsigned long hw_cache_stat[C(MAX
>  	   (strcmp(sys_dirent.d_name, ".")) &&				       \
>  	   (strcmp(sys_dirent.d_name, "..")))
>  
> +static int tp_event_has_id(struct dirent *sys_dir, struct dirent *evt_dir)
> +{
> +	char evt_path[MAXPATHLEN];
> +	int fd;
> +
> +	snprintf(evt_path, MAXPATHLEN, "%s/%s/%s/id", debugfs_path,
> +			sys_dir->d_name, evt_dir->d_name);
> +	fd = open(evt_path, O_RDONLY);
> +	if (fd < 0)
> +		return -EINVAL;
> +	close(fd);
> +
> +	return 0;
> +}
> +
>  #define for_each_event(sys_dirent, evt_dir, evt_dirent, evt_next, file, st)    \
>  	while (!readdir_r(evt_dir, &evt_dirent, &evt_next) && evt_next)        \
>  	if (snprintf(file, MAXPATHLEN, "%s/%s/%s", debugfs_path,	       \
>  		     sys_dirent.d_name, evt_dirent.d_name) &&		       \
>  	   (!stat(file, &st)) && (S_ISDIR(st.st_mode)) &&		       \
>  	   (strcmp(evt_dirent.d_name, ".")) &&				       \
> -	   (strcmp(evt_dirent.d_name, "..")))
> +	   (strcmp(evt_dirent.d_name, "..")) &&				       \
> +	   (!tp_event_has_id(&sys_dirent, &evt_dirent)))
>  
>  #define MAX_EVENT_LENGTH 30
>  

looks good to me.

Acked-by: Jason Baron <jbaron@redhat.com>

thanks,

-Jason
