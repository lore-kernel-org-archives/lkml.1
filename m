Return-Path: <linux-kernel-owner+w=401wt.eu-S1758345AbZGIAra@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758345AbZGIAra (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 20:47:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755811AbZGIArX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 20:47:23 -0400
Received: from mail-ew0-f226.google.com ([209.85.219.226]:50836 "EHLO
	mail-ew0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755559AbZGIArW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 20:47:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=QU38tzAatYQMhqlh1XRi+m5qiRnAiOD7vI3ITKUgwy00w95aIcrVLJWSTxRNAdw8tu
         +UGualQyMjuJ2d7vy+u3NUseY+6gnrX3+uSA9YvLEjk/w1YxP3NgbBAc8YkwpJVKT0St
         4v1dJUoLIlYo/obBuqDG95m6JTeN835TIz+0k=
Date: Thu, 9 Jul 2009 02:47:17 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Jason Baron <jbaron@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, mingo@elte.hu,
       linux-kernel@vger.kernel.org, paulus@samba.org, rostedt@goodmis.org
Subject: Re: [PATCH 3/2] perf_counters: add debugfs dir option
Message-ID: <20090709004716.GA6275@nowhere>
References: <cover.1246912068.git.jbaron@redhat.com> <0d7326e18b9860fbf8fb2739f90a23eb9262e24b.1246912068.git.jbaron@redhat.com> <1246955360.8143.113.camel@twins> <20090708201743.GA3123@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090708201743.GA3123@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 08, 2009 at 04:17:43PM -0400, Jason Baron wrote:
> On Tue, Jul 07, 2009 at 10:29:20AM +0200, Peter Zijlstra wrote:
> > On Mon, 2009-07-06 at 17:12 -0400, Jason Baron wrote:
> > > Add support to 'perf list' and 'perf stat' for kernel tracepoints. The
> > > implementation creates a 'for_each_subsystem' and 'for_each_event' for
> > > easy iteration over the tracepoints. The debugfs filesystem must be mounted
> > > at '/sys/kernel/debug'. We can add an optional search path in the future.
> > 
> > I don't have a single machine that has that mount point.
> > 
> > 
> 
> ok, The patch below adds support for a 'PERF_DIR_DEBUGFS' environment
> variable. It also adds a command line for '--debugfs-dir' and
> '--debugfs-dir='. By default 'perf' continues to look in
> /sys/kernel/debug, which I believe is most common.
> 
> thanks,
> 
> -Jason
> 
> Signed-off-by: Jason Baron <jbaron@redhat.com>



Or why not parsing /etc/mtab ?

Thanks.



> 
> 
>  tools/perf/perf.c              |   16 ++++++++
>  tools/perf/util/cache.h        |    1 +
>  tools/perf/util/parse-events.c |   78
> ++++++++++++++++++++++++----------------
>  3 files changed, 62 insertions(+), 33 deletions(-)
> 
> 
> 
> diff --git a/tools/perf/perf.c b/tools/perf/perf.c
> index c565678..29876ee 100644
> --- a/tools/perf/perf.c
> +++ b/tools/perf/perf.c
> @@ -122,6 +122,20 @@ static int handle_options(const char*** argv, int* argc, int* envchanged)
>  			setenv(PERF_WORK_TREE_ENVIRONMENT, cmd + 12, 1);
>  			if (envchanged)
>  				*envchanged = 1;
> +		} else if (!strcmp(cmd, "--debugfs-dir")) {
> +			if (*argc < 2) {
> +				fprintf(stderr, "No directory given for --debugfs-dir.\n");
> +				usage(perf_usage_string);
> +			}
> +			setenv(PERF_DEBUGFS_ENVIRONMENT, (*argv)[1], 1);
> +			if (envchanged)
> +				*envchanged = 1;
> +			(*argv)++;
> +			(*argc)--;
> +		} else if (!prefixcmp(cmd, "--debugfs-dir=")) {
> +			setenv(PERF_DEBUGFS_ENVIRONMENT, cmd + 14, 1);
> +			if (envchanged)
> +				*envchanged = 1;
>  		} else {
>  			fprintf(stderr, "Unknown option: %s\n", cmd);
>  			usage(perf_usage_string);
> @@ -354,7 +368,7 @@ int main(int argc, const char **argv)
>  	cmd = perf_extract_argv0_path(argv[0]);
>  	if (!cmd)
>  		cmd = "perf-help";
> -
> +	setenv(PERF_DEBUGFS_ENVIRONMENT, "/sys/kernel/debug/", 0);
>  	/*
>  	 * "perf-xxxx" is the same as "perf xxxx", but we obviously:
>  	 *
> diff --git a/tools/perf/util/cache.h b/tools/perf/util/cache.h
> index 161d5f4..4ba4b3e 100644
> --- a/tools/perf/util/cache.h
> +++ b/tools/perf/util/cache.h
> @@ -18,6 +18,7 @@
>  #define PERFATTRIBUTES_FILE ".perfattributes"
>  #define INFOATTRIBUTES_FILE "info/attributes"
>  #define ATTRIBUTE_MACRO_PREFIX "[attr]"
> +#define PERF_DEBUGFS_ENVIRONMENT "PERF_DIR_DEBUGFS"
>  
>  typedef int (*config_fn_t)(const char *, const char *, void *);
>  extern int perf_default_config(const char *, const char *, void *);
> diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
> index d454eac..54b6c23 100644
> --- a/tools/perf/util/parse-events.c
> +++ b/tools/perf/util/parse-events.c
> @@ -5,6 +5,7 @@
>  #include "parse-events.h"
>  #include "exec_cmd.h"
>  #include "string.h"
> +#include "cache.h"
>  
>  extern char *strcasestr(const char *haystack, const char *needle);
>  
> @@ -12,8 +13,6 @@ int					nr_counters;
>  
>  struct perf_counter_attr		attrs[MAX_COUNTERS];
>  
> -static char default_debugfs_path[] = "/sys/kernel/debug/tracing/events";
> -
>  struct event_symbol {
>  	u8	type;
>  	u64	config;
> @@ -21,6 +20,8 @@ struct event_symbol {
>  	char	*alias;
>  };
>  
> +static char debugfs_path[MAXPATHLEN];
> +
>  #define CHW(x) .type = PERF_TYPE_HARDWARE, .config = PERF_COUNT_HW_##x
>  #define CSW(x) .type = PERF_TYPE_SOFTWARE, .config = PERF_COUNT_SW_##x
>  
> @@ -112,30 +113,38 @@ static unsigned long hw_cache_stat[C(MAX)] = {
>   [C(BPU)]	= (CACHE_READ),
>  };
>  
> -#define for_each_subsystem(sys_dir, sys_dirent, sys_next, file, st)	       \
> -	while (!readdir_r(sys_dir, &sys_dirent, &sys_next) && sys_next)	       \
> -	if (sprintf(file, "%s/%s", default_debugfs_path, sys_dirent.d_name) && \
> -	   (stat(file, &st) == 0) && (S_ISDIR(st.st_mode)) &&		       \
> -	   (strcmp(sys_dirent.d_name, ".") != 0) &&			       \
> +#define for_each_subsystem(sys_dir, sys_dirent, sys_next, file, st)	     \
> +	while (!readdir_r(sys_dir, &sys_dirent, &sys_next) && sys_next)	     \
> +	if (snprintf(file, MAXPATHLEN, "%s/%s/%s",			     \
> +		     getenv(PERF_DEBUGFS_ENVIRONMENT), "tracing/events",     \
> +		     sys_dirent.d_name) &&				     \
> +	   (stat(file, &st) == 0) && (S_ISDIR(st.st_mode)) &&		     \
> +	   (strcmp(sys_dirent.d_name, ".") != 0) &&			     \
>  	   (strcmp(sys_dirent.d_name, "..") != 0))
>  
> -#define for_each_event(sys_dirent, evt_dir, evt_dirent, evt_next, file, st)    \
> -	while (!readdir_r(evt_dir, &evt_dirent, &evt_next) && evt_next)        \
> -	if (sprintf(file, "%s/%s/%s", default_debugfs_path, sys_dirent.d_name, \
> -			evt_dirent.d_name) && 				       \
> -	   (stat(file, &st) == 0) && (S_ISDIR(st.st_mode)) &&		       \
> -	   (strcmp(evt_dirent.d_name, ".") != 0) && 			       \
> +#define for_each_event(sys_dirent, evt_dir, evt_dirent, evt_next, file, st)  \
> +	while (!readdir_r(evt_dir, &evt_dirent, &evt_next) && evt_next)	     \
> +	if (snprintf(file, MAXPATHLEN, "%s/%s/%s/%s",			     \
> +		     getenv(PERF_DEBUGFS_ENVIRONMENT), "tracing/events",     \
> +		     sys_dirent.d_name, evt_dirent.d_name) &&		     \
> +	   (stat(file, &st) == 0) && (S_ISDIR(st.st_mode)) &&		     \
> +	   (strcmp(evt_dirent.d_name, ".") != 0) &&			     \
>  	   (strcmp(evt_dirent.d_name, "..") != 0))
>  
> -#define MAX_PATH_LENGTH (strlen(default_debugfs_path) + 3 + \
> -			(3 * (strlen(sys_dirent.d_name))) + 1)
>  #define MAX_EVENT_LENGTH 30
>  
> -static int valid_debugfs_mount(void)
> +static void set_debugfs_path(void)
> +{
> +	snprintf(debugfs_path, MAXPATHLEN, "%s/%s",
> +		 getenv(PERF_DEBUGFS_ENVIRONMENT),
> +		 "tracing/events");
> +}
> +
> +static int valid_debugfs_mount(const char *mount)
>  {
>  	struct statfs st_fs;
>  
> -	if (statfs(default_debugfs_path, &st_fs) < 0)
> +	if (statfs(mount, &st_fs) < 0)
>  		return -ENOENT;
>  	else if (st_fs.f_type != (long) DEBUGFS_MAGIC)
>  		return -ENOENT;
> @@ -151,12 +160,13 @@ static char *tracepoint_id_to_name(u64 config)
>  	char id_buf[4];
>  	int fd;
>  	long long id;
> -	char evt_path[MAX_PATH_LENGTH];
> +	char evt_path[MAXPATHLEN];
>  
> -	if (valid_debugfs_mount())
> +	set_debugfs_path();
> +	if (valid_debugfs_mount(debugfs_path))
>  		return "unkown";
>  
> -	sys_dir = opendir(default_debugfs_path);
> +	sys_dir = opendir(debugfs_path);
>  	if (!sys_dir)
>  		goto cleanup;
>  	for_each_subsystem(sys_dir, sys_dirent, sys_next, evt_path, st) {
> @@ -165,8 +175,9 @@ static char *tracepoint_id_to_name(u64 config)
>  			goto cleanup;
>  		for_each_event(sys_dirent, evt_dir, evt_dirent, evt_next,
>  								evt_path, st) {
> -			sprintf(evt_path, "%s/%s/%s/id", default_debugfs_path,
> -				sys_dirent.d_name, evt_dirent.d_name);
> +			snprintf(evt_path, MAXPATHLEN, "%s/%s/%s/id",
> +				 debugfs_path, sys_dirent.d_name,
> +				 evt_dirent.d_name);
>  			fd = open(evt_path, O_RDONLY);
>  			if (fd < 0)
>  				continue;
> @@ -362,9 +373,10 @@ static int parse_tracepoint_event(const char **strp,
>  	int fd;
>  	unsigned int sys_length, evt_length;
>  	u64 id;
> -	char evt_path[MAX_PATH_LENGTH];
> +	char evt_path[MAXPATHLEN];
>  
> -	if (valid_debugfs_mount())
> +	set_debugfs_path();
> +	if (valid_debugfs_mount(debugfs_path))
>  		return 0;
>  
>  	evt_name = strchr(*strp, ':');
> @@ -381,7 +393,7 @@ static int parse_tracepoint_event(const char **strp,
>  	} else
>  		return 0;
>  
> -	sys_dir = opendir(default_debugfs_path);
> +	sys_dir = opendir(debugfs_path);
>  	if (!sys_dir)
>  		goto cleanup;
>  	for_each_subsystem(sys_dir, sys_dirent, sys_next, evt_path, st) {
> @@ -392,10 +404,11 @@ static int parse_tracepoint_event(const char **strp,
>  			for_each_event(sys_dirent, evt_dir, evt_dirent,
>  						       evt_next, evt_path, st) {
>  				if (strcmp(evt_dirent.d_name, evt_name) == 0) {
> -					sprintf(evt_path, "%s/%s/%s/id",
> -						default_debugfs_path,
> -						sys_dirent.d_name,
> -						evt_dirent.d_name);
> +					snprintf(evt_path, MAXPATHLEN,
> +						 "%s/%s/%s/id",
> +						 debugfs_path,
> +						 sys_dirent.d_name,
> +						 evt_dirent.d_name);
>  					fd = open(evt_path, O_RDONLY);
>  					if (fd < 0)
>  						continue;
> @@ -589,12 +602,13 @@ static void print_tracepoint_events(void)
>  	DIR *sys_dir, *evt_dir;
>  	struct dirent *sys_next, *evt_next, sys_dirent, evt_dirent;
>  	struct stat st;
> -	char evt_path[MAX_PATH_LENGTH];
> +	char evt_path[MAXPATHLEN];
>  
> -	if (valid_debugfs_mount())
> +	set_debugfs_path();
> +	if (valid_debugfs_mount(debugfs_path))
>  		return;
>  
> -	sys_dir = opendir(default_debugfs_path);
> +	sys_dir = opendir(debugfs_path);
>  	if (!sys_dir)
>  		goto cleanup;
>  	for_each_subsystem(sys_dir, sys_dirent, sys_next, evt_path, st) {
> 
> 

