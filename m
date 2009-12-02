Return-Path: <linux-kernel-owner+w=401wt.eu-S1751424AbZLBFmL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751424AbZLBFmL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 00:42:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751048AbZLBFmK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 00:42:10 -0500
Received: from mail.windriver.com ([147.11.1.11]:44285 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750882AbZLBFmJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 00:42:09 -0500
Message-ID: <4B15FED8.2080108@windriver.com>
Date: Wed, 02 Dec 2009 13:44:56 +0800
From: Wang Liming <liming.wang@windriver.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: mingo@redhat.com, peterz@infradead.org, fweisbec@gmail.com,
       mhiramat@redhat.com, linux-kernel@vger.kernel.org
CC: rostedt@goodmis.org, jbaron@redhat.com, fche@redhat.com,
       jkenisto@us.ibm.com, hch@infradead.org, ananth@in.ibm.com,
       srikar@linux.vnet.ibm.com, prasad@linux.vnet.ibm.com
Subject: Re: [tip:perf/core] perf probe: Add argv_split() from lib/argv_split.c
References: <20091201002005.10235.55602.stgit@harusame> <tip-e1c01d61a98703fcc80d15b8068ec36d5a215f7e@git.kernel.org>
In-Reply-To: <tip-e1c01d61a98703fcc80d15b8068ec36d5a215f7e@git.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 02 Dec 2009 05:41:38.0296 (UTC) FILETIME=[1DF93F80:01CA7312]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Masami,

tip-bot for Masami Hiramatsu wrote:
...
> diff --git a/tools/perf/util/string.c b/tools/perf/util/string.c
> index 2270435..0977cf4 100644
> --- a/tools/perf/util/string.c
> +++ b/tools/perf/util/string.c
> @@ -127,3 +127,104 @@ out_err:
>  out:
>  	return length;
>  }
> +
> +/*
> + * Helper function for splitting a string into an argv-like array.
> + * originaly copied from lib/argv_split.c
> + */
> +static const char *skip_sep(const char *cp)
> +{
> +	while (*cp && isspace(*cp))
> +		cp++;
> +
> +	return cp;
> +}
> +
> +static const char *skip_arg(const char *cp)
> +{
> +	while (*cp && !isspace(*cp))
> +		cp++;
> +
> +	return cp;
> +}
> +
> +static int count_argc(const char *str)
> +{
> +	int count = 0;
> +
> +	while (*str) {
> +		str = skip_sep(str);
> +		if (*str) {
> +			count++;
> +			str = skip_arg(str);
> +		}
> +	}
> +
> +	return count;
> +}
> +
> +/**
> + * argv_free - free an argv
> + * @argv - the argument vector to be freed
> + *
> + * Frees an argv and the strings it points to.
> + */
> +void argv_free(char **argv)
> +{
> +	char **p;
> +	for (p = argv; *p; p++)
> +		free(*p);
> +
> +	free(argv);
> +}
> +
> +/**
> + * argv_split - split a string at whitespace, returning an argv
> + * @str: the string to be split
> + * @argcp: returned argument count
> + *
> + * Returns an array of pointers to strings which are split out from
> + * @str.  This is performed by strictly splitting on white-space; no
> + * quote processing is performed.  Multiple whitespace characters are
> + * considered to be a single argument separator.  The returned array
> + * is always NULL-terminated.  Returns NULL on memory allocation
> + * failure.
> + */
> +char **argv_split(const char *str, int *argcp)
> +{
> +	int argc = count_argc(str);
> +	char **argv = zalloc(sizeof(*argv) * (argc+1));
> +	char **argvp;
> +
> +	if (argv == NULL)
> +		goto out;
> +
> +	if (argcp)
> +		*argcp = argc;
> +
> +	argvp = argv;
> +
> +	while (*str) {
> +		str = skip_sep(str);
> +
> +		if (*str) {
> +			const char *p = str;
> +			char *t;
> +
> +			str = skip_arg(str);
> +
> +			t = strndup(p, str-p);
When I compiled "perf", I encountered following error:

     CC util/string.o
cc1: warnings being treated as errors
util/string.c: In function 'argv_split':
util/string.c:216: warning: implicit declaration of function 'strndup'
util/string.c:216: warning: incompatible implicit declaration of built-in 
function 'strndup'
make: *** [util/string.o] Error 1

Do we need to define _GNU_SOURCE in the head? Or maybe I used rather old glibc 
version.

diff --git a/tools/perf/util/string.c b/tools/perf/util/string.c
index 0977cf4..ea3eb39 100644
--- a/tools/perf/util/string.c
+++ b/tools/perf/util/string.c
@@ -1,5 +1,8 @@
+#define _GNU_SOURCE
  #include <string.h>
  #include <stdlib.h>
+
+#undef _GNU_SOURCE
  #include "string.h"
  #include "util.h"


