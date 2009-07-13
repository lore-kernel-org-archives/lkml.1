Return-Path: <linux-kernel-owner+w=401wt.eu-S1754525AbZGMHPq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754525AbZGMHPq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 03:15:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752757AbZGMHPm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 03:15:42 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:48629 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750934AbZGMHPl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 03:15:41 -0400
Date: Mon, 13 Jul 2009 09:15:31 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jason Baron <jbaron@redhat.com>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, a.p.zijlstra@chello.nl,
       rostedt@goodmis.org, fweisbec@gmail.com
Subject: Re: [PATCH 2/2] perf_counter: add support to the 'perf' tool for
	tracepoints
Message-ID: <20090713071531.GA19230@elte.hu>
References: <cover.1246912068.git.jbaron@redhat.com> <0d7326e18b9860fbf8fb2739f90a23eb9262e24b.1246912068.git.jbaron@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0d7326e18b9860fbf8fb2739f90a23eb9262e24b.1246912068.git.jbaron@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jason Baron <jbaron@redhat.com> wrote:

> +static char *tracepoint_id_to_name(u64 config)
> +{
> +	static char tracepoint_name[2 * MAX_EVENT_LENGTH];
> +	DIR *sys_dir, *evt_dir;
> +	struct dirent *sys_next, *evt_next, sys_dirent, evt_dirent;
> +	struct stat st;
> +	char id_buf[4];
> +	int fd;
> +	long long id;

could this become u64?

> +	char evt_path[MAX_PATH_LENGTH];
> +
> +	if (valid_debugfs_mount())
> +		return "unkown";
> +
> +	sys_dir = opendir(default_debugfs_path);
> +	if (!sys_dir)
> +		goto cleanup;
> +	for_each_subsystem(sys_dir, sys_dirent, sys_next, evt_path, st) {
> +		evt_dir = opendir(evt_path);
> +		if (!evt_dir)
> +			goto cleanup;
> +		for_each_event(sys_dirent, evt_dir, evt_dirent, evt_next,
> +								evt_path, st) {
> +			sprintf(evt_path, "%s/%s/%s/id", default_debugfs_path,
> +				sys_dirent.d_name, evt_dirent.d_name);
> +			fd = open(evt_path, O_RDONLY);
> +			if (fd < 0)
> +				continue;
> +			if (read(fd, id_buf, sizeof(id_buf)) < 0) {
> +				close(fd);
> +				continue;
> +			}
> +			close(fd);
> +			id = atoll(id_buf);
> +			if ((u64)id == config) {

... and thus the cast here could be dropped?

> +				closedir(evt_dir);
> +				closedir(sys_dir);
> +				snprintf(tracepoint_name, 2 * MAX_EVENT_LENGTH,
> +					"%s:%s", sys_dirent.d_name,
> +					evt_dirent.d_name);
> +				return tracepoint_name;
> +			}
> +		}
> +		closedir(evt_dir);
> +	}
> +cleanup:
> +	closedir(sys_dir);
> +	return "unkown";
> +}
> +
>  static int is_cache_op_valid(u8 cache_type, u8 cache_op)
>  {
>  	if (hw_cache_stat[cache_type] & COP(cache_op))
> @@ -177,6 +259,9 @@ char *event_name(int counter)
>  			return sw_event_names[config];
>  		return "unknown-software";
>  
> +	case PERF_TYPE_TRACEPOINT:
> +		return tracepoint_id_to_name(config);
> +
>  	default:
>  		break;
>  	}
> @@ -265,6 +350,78 @@ parse_generic_hw_event(const char **str, struct perf_counter_attr *attr)
>  	return 1;
>  }
>  
> +static int parse_tracepoint_event(const char **strp,
> +				    struct perf_counter_attr *attr)
> +{
> +	const char *evt_name;
> +	char sys_name[MAX_EVENT_LENGTH];
> +	DIR *sys_dir, *evt_dir;
> +	struct dirent *sys_next, *evt_next, sys_dirent, evt_dirent;
> +	struct stat st;
> +	char id_buf[4];
> +	int fd;
> +	unsigned int sys_length, evt_length;
> +	u64 id;
> +	char evt_path[MAX_PATH_LENGTH];
> +
> +	if (valid_debugfs_mount())
> +		return 0;
> +
> +	evt_name = strchr(*strp, ':');
> +	if (evt_name) {
> +		sys_length = evt_name - *strp;
> +		if (sys_length >= MAX_EVENT_LENGTH)
> +			return 0;
> +		strncpy(sys_name, *strp, sys_length);
> +		sys_name[sys_length] = '\0';
> +		evt_name = evt_name + 1;
> +		evt_length = strlen(evt_name);
> +		if (evt_length >= MAX_EVENT_LENGTH)
> +			return 0;
> +	} else
> +		return 0;
> +
> +	sys_dir = opendir(default_debugfs_path);
> +	if (!sys_dir)
> +		goto cleanup;
> +	for_each_subsystem(sys_dir, sys_dirent, sys_next, evt_path, st) {

a minor request. Just like you added a newline after the return 0 
above, please add a newline after separate blocks of code as well - 
i.e after the 'goto cleanup' above. It makes the loop which begins 
stand out on its own, and makes the sys_dir initialization look 
self-sufficient as well. (which it is)

> +		if (strcmp(sys_dirent.d_name, sys_name) == 0) {
> +			evt_dir = opendir(evt_path);
> +			if (!evt_dir)
> +				goto cleanup;
> +			for_each_event(sys_dirent, evt_dir, evt_dirent,
> +						       evt_next, evt_path, st) {
> +				if (strcmp(evt_dirent.d_name, evt_name) == 0) {
> +					sprintf(evt_path, "%s/%s/%s/id",
> +						default_debugfs_path,
> +						sys_dirent.d_name,
> +						evt_dirent.d_name);
> +					fd = open(evt_path, O_RDONLY);
> +					if (fd < 0)
> +						continue;
> +					if (read(fd, id_buf,
> +						 sizeof(id_buf)) < 0) {
> +						close(fd);
> +						continue;
> +					}
> +					close(fd);
> +					id = atoll(id_buf);
> +					attr->config = id;
> +					attr->type = PERF_TYPE_TRACEPOINT;
> +					closedir(evt_dir);
> +					closedir(sys_dir);
> +					*strp = evt_name + evt_length;
> +					return 1;
> +				}
> +			}
> +			closedir(evt_dir);
> +		}
> +	}
> +cleanup:
> +	closedir(sys_dir);
> +	return 0;
> +}

Ok, this whole feature looks nice. A few minor details need fixing: 
the two functions above tracepoint_id_to_name() and 
parse_tracepoint_event() are a bit large and look very crowded.

one trick to win an indentation level would be to turn this:

> +		if (strcmp(sys_dirent.d_name, sys_name) == 0) {
> +			evt_dir = opendir(evt_path);

into:

		if (strcmp(sys_dirent.d_name, sys_name))
			continue;

		evt_dir = opendir(evt_path);

(Also, for logic operations please write '!x' instead of 'x == 0' - 
it's easy to see only the beginning of the line and miss the 
effective negation.)

The other thing to do would be to move the inner core of the loop 
out into a helper inline function.

plus, this:

> +	if (evt_name) {
> +		sys_length = evt_name - *strp;
> +		if (sys_length >= MAX_EVENT_LENGTH)
> +			return 0;
> +		strncpy(sys_name, *strp, sys_length);
> +		sys_name[sys_length] = '\0';
> +		evt_name = evt_name + 1;
> +		evt_length = strlen(evt_name);
> +		if (evt_length >= MAX_EVENT_LENGTH)
> +			return 0;
> +	} else
> +		return 0;

should be written as:

	if (!evt_name)
		return 0;

	sys_length = evt_name - *strp;
	...

i.e. we should try to compress the visual complexity of 
code as much as possible.

Also ... all code flows return 0, regardless of error or not error. 
Is this intentional?

	Ingo
