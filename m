Return-Path: <linux-kernel-owner+w=401wt.eu-S1752637AbZHIWoH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752637AbZHIWoH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Aug 2009 18:44:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751857AbZHIWoG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Aug 2009 18:44:06 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:19714 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751183AbZHIWoF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Aug 2009 18:44:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=sPmvv1tmy+/aKZqVocGXgJfq1Q7Y35J64wsgjMXuOUDRKW06qBjR19GJIt1k6jWIZA
         pyOWJiZgk12CP9JqufJ1xfQbetc+5BzFeNu1RoquALAI5DmI+JyZ0aVluDfLXGtSdeW8
         JSQmelQRngi8KAeVHqfdl8IPmy8WhBznsLH3U=
Date: Mon, 10 Aug 2009 00:44:02 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: perf: store and retrieve trace event names in the perf.data
	file
Message-ID: <20090809224400.GA6089@nowhere>
References: <4A7F4463.3050508@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A7F4463.3050508@linux.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 09, 2009 at 02:49:23PM -0700, Arjan van de Ven wrote:
> In order to be able to use trace events, a key aspect is the "type" field;
> this is the id of the event that you recorded, as stored in the /sys/kernel/debug/events/*/*/id file.
> What is currently missing is a way to map the id number (which is not abi stable)
> to the event that was recorded.



We already have that.
See tools/perf/util/parse-events.c: char *tracepoint_id_to_name(u64 id)

Frederic.



> This patch adds the facility that stores the trace event name and id in the perf.data file,
> and then allows users of it to map the ID back to the original string.
>
> Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
>
> diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
> index b92a457..73eeefb 100644
> --- a/tools/perf/util/header.c
> +++ b/tools/perf/util/header.c
> @@ -48,7 +48,7 @@ void perf_header_attr__add_id(struct perf_header_attr *self, u64 id)
>
>  struct perf_header *perf_header__new(void)
>  {
> -	struct perf_header *self = malloc(sizeof(*self));
> +	struct perf_header *self = malloc(sizeof(struct perf_header));
>
>  	if (!self)
>  		die("nomem");
> @@ -86,6 +86,45 @@ void perf_header__add_attr(struct perf_header *self,
>  	self->attr[pos] = attr;
>  }
>
> +struct perf_trace_event_type
> +{
> +	u64	event_id;
> +	char	name[64];
> +};
> +
> +static int event_count;
> +static struct perf_trace_event_type *events;
> +
> +void perf_header__push_event(u64 id, const char *name)
> +{
> +	if (strlen(name) > 64) {
> +		printf("Event %s will be truncated\n", name);
> +	}
> +	if (!events) {
> +		events = malloc(sizeof(struct perf_trace_event_type));
> +		if (!events)
> +			die("nomem");
> +	} else {
> +		events = realloc(events, (event_count + 1) * sizeof(struct perf_trace_event_type));
> +		if (!events)
> +			die("nomem");
> +	}
> +	memset(&events[event_count], 0, sizeof(struct perf_trace_event_type));
> +	events[event_count].event_id = id;
> +	strncpy(events[event_count].name, name, 63);
> +	event_count++;
> +}
> +
> +char * perf_header__find_event(u64 id)
> +{
> +	int i;
> +	for (i = 0 ; i < event_count; i++) {
> +		if (events[i].event_id == id)
> +			return events[i].name;
> +	}
> +	return NULL;
> +}
> +
>  static const char *__perf_magic = "PERFFILE";
>
>  #define PERF_MAGIC	(*(u64 *)__perf_magic)
> @@ -106,6 +145,7 @@ struct perf_file_header {
>  	u64				attr_size;
>  	struct perf_file_section	attrs;
>  	struct perf_file_section	data;
> +	struct perf_file_section	event_types;
>  };
>
>  static void do_write(int fd, void *buf, size_t size)
> @@ -154,6 +194,11 @@ void perf_header__write(struct perf_header *self, int fd)
>  		do_write(fd, &f_attr, sizeof(f_attr));
>  	}
>
> +	self->event_offset = lseek(fd, 0, SEEK_CUR);
> +	self->event_size = event_count * sizeof(struct perf_trace_event_type);
> +	if (events)
> +		do_write(fd, events, self->event_size);
> +
>
>  	self->data_offset = lseek(fd, 0, SEEK_CUR);
>
> @@ -169,6 +214,10 @@ void perf_header__write(struct perf_header *self, int fd)
>  			.offset = self->data_offset,
>  			.size	= self->data_size,
>  		},
> +		.event_types = {
> +			.offset = self->event_offset,
> +			.size	= self->event_size,
> +		},
>  	};
>
>  	lseek(fd, 0, SEEK_SET);
> @@ -237,6 +286,20 @@ struct perf_header *perf_header__read(int fd)
>  	self->data_offset = f_header.data.offset;
>  	self->data_size   = f_header.data.size;
>
> +		printf("event_types.size = %i \n", (int)f_header.event_types.size);
> +
> +	if (f_header.event_types.size) {
> +
> +		lseek(fd, f_header.event_types.offset, SEEK_SET);
> +		events = malloc(f_header.event_types.size);
> +		if (!events)
> +			die("nomem");
> +		do_read(fd, events, f_header.event_types.size);
> +		event_count =  f_header.event_types.size / sizeof(struct perf_trace_event_type);
> +	}
> +	self->event_offset = f_header.event_types.offset;
> +	self->event_size   = f_header.event_types.size;
> +
>  	lseek(fd, self->data_offset + self->data_size, SEEK_SET);
>
>  	self->frozen = 1;
> diff --git a/tools/perf/util/header.h b/tools/perf/util/header.h
> index bf28044..606a8fb 100644
> --- a/tools/perf/util/header.h
> +++ b/tools/perf/util/header.h
> @@ -19,6 +19,8 @@ struct perf_header {
>  	s64 attr_offset;
>  	u64 data_offset;
>  	u64 data_size;
> +	u64 event_offset;
> +	u64 event_size;
>  };
>
>  struct perf_header *perf_header__read(int fd);
> @@ -27,6 +29,10 @@ void perf_header__write(struct perf_header *self, int fd);
>  void perf_header__add_attr(struct perf_header *self,
>  			   struct perf_header_attr *attr);
>
> +void perf_header__push_event(u64 id, const char *name);
> +char * perf_header__find_event(u64 id);
> +
> +
>  struct perf_header_attr *
>  perf_header_attr__new(struct perf_counter_attr *attr);
>  void perf_header_attr__add_id(struct perf_header_attr *self, u64 id);
> diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
> index 4858d83..e8c5255 100644
> --- a/tools/perf/util/parse-events.c
> +++ b/tools/perf/util/parse-events.c
> @@ -6,6 +6,7 @@
>  #include "exec_cmd.h"
>  #include "string.h"
>  #include "cache.h"
> +#include "header.h"
>
>  extern char *strcasestr(const char *haystack, const char *needle);
>
> @@ -543,10 +544,32 @@ static int parse_event_symbols(const char **str, struct perf_counter_attr *attr)
>  	return 1;
>  }
>
> +static void store_event_type(const char *orgname)
> +{
> +	char filename[PATH_MAX], *c;
> +	FILE *file;
> +	int id;
> +
> +	sprintf(filename, "/sys/kernel/debug/tracing/events/%s/id", orgname);
> +	c = strchr(filename, ':');
> +	if (c) *c = '/';
> +
> +	file = fopen(filename, "r");
> +	if (!file)
> +		return;
> +	fscanf(file, "%i", &id);
> +	fclose(file);
> +	perf_header__push_event(id, orgname);
> +}
> +
> +
>  int parse_events(const struct option *opt __used, const char *str, int unset __used)
>  {
>  	struct perf_counter_attr attr;
>
> +	if (strchr(str, ':'))
> +		store_event_type(str);
> +
>  	for (;;) {
>  		if (nr_counters == MAX_COUNTERS)
>  			return -1;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

