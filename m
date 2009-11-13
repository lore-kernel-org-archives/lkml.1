Return-Path: <linux-kernel-owner+w=401wt.eu-S1755631AbZKMJrG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755631AbZKMJrG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 04:47:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755305AbZKMJq6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 04:46:58 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:43476 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755012AbZKMJq5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 04:46:57 -0500
Date: Fri, 13 Nov 2009 10:46:50 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ling Ma <ling.ma@intel.com>
Subject: Re: [PATCH 1/4] perf bench: Add new subsystem and new suite,
 bench/mem-memcpy.c
Message-ID: <20091113094650.GA1364@elte.hu>
References: <1258086186-32317-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
 <1258086186-32317-2-git-send-email-mitake@dcl.info.waseda.ac.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=unknown-8bit
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1258086186-32317-2-git-send-email-mitake@dcl.info.waseda.ac.jp>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp> wrote:

> +#include <stdio.h>
> +#include <stdlib.h>
> +#include <string.h>
> +#include <sys/time.h>
> +#include <assert.h>
> +
> +#define K 1024
> +static char *length_str = (char *)"1MB";
> +static char *routine = (char *)"default";

no cast is needed for string literals.

> +static int use_clockcycle = 0;

also, please use the vertical alignment initialization style used in 
other builtin-*.c tools.

> +
> +typedef unsigned long int clockcycle_t;

We dont do new typedefs in .c's generally. It should be put into a 
header - but i think using u64 would be good too.

> +
> +#ifdef x86_64
> +
> +static inline clockcycle_t get_clock(void)
> +{
> +	long int ret;
> +
> +	asm("rdtsc; shlq $32, %%rdx;"
> +	    "orq %%rdx, %%rax;"
> +	    "movq %%rax, %0;"
> +	    : "=r" (ret));
> +
> +	return ret;
> +}
> +
> +#endif /* x86_64 */

There's full rdtscll implementations in arch/x86/include/asm/tsc.h. They 
should either be included - or copied in part.

> +static const struct option options[] = {
> +	OPT_STRING('l', "length", &length_str, "1MB",
> +		    "Specify length of memory to copy. "
> +		    "available unit: B, MB, GB (upper and lower)"),
> +	OPT_STRING('r', "routine", &routine, "default",
> +		    "Specify routine to copy"),
> +#ifdef x86_64
> +	/*
> +	 * TODO: This should be expanded to any architecuture
> +	 * perf supports
> +	 */
> +	OPT_BOOLEAN('c', "clockcycle", &use_clockcycle,
> +		    "Use CPU's clock cycle for measurement"),
> +#endif /* x86_64 */

That #ifdef x86_64 looks quite ugly.

Also, why not use the 'cycles' perf event to retrieve cycles?

> +	OPT_END()
> +};
> +
> +struct routine {
> +	const char *name;
> +	void * (*fn)(void *dst, const void *src, size_t len);
> +	const char *desc;

We try to align structure definitions vertically too.

> +};
> +
> +struct routine routines[] = {
> +	{ "default",
> +	  memcpy,
> +	  "Default memcpy() provided by glibc" },
> +	{ NULL,
> +	  NULL,
> +	  NULL }

{ NULL, } would be equivalent i guess.

> +};
> +
> +static const char * const bench_mem_memcpy_usage[] = {
> +	"perf bench mem memcpy <options>",
> +	NULL
> +};
> +
> +static size_t str2length(char *_str)
> +{
> +	int i, unit = 1;
> +	char *str;
> +	size_t length = -1;
> +
> +	str = calloc(strlen(_str) + 1, sizeof(char));
> +	assert(str);
> +	strcpy(str, _str);
> +
> +	if (!isdigit(str[0]))
> +		goto err;
> +
> +	for (i = 1; i < (int)strlen(str); i++) {

if 'i' was of type unsigned long then the (int) cast wouldnt be needed i 
suspect?

> +		switch ((int)str[i]) {

is the cast to 'int' needed here?

> +		case 'B':
> +		case 'b':
> +			str[i] = '\0';
> +			break;
> +		case 'K':
> +		case 'k':
> +			if (str[i + 1] != 'B' && str[i + 1] != 'b')
> +				goto err;
> +			unit = K;
> +			str[i] = '\0';
> +			break;
> +		case 'M':
> +		case 'm':
> +			if (str[i + 1] != 'B' && str[i + 1] != 'b')
> +				goto err;
> +			unit = K * K;
> +			str[i] = '\0';
> +			break;
> +		case 'G':
> +		case 'g':
> +			if (str[i + 1] != 'B' && str[i + 1] != 'b')
> +				goto err;
> +			unit = K * K * K;
> +			str[i] = '\0';
> +			break;
> +		case '\0':	/* only specified figures */
> +			unit = 1;
> +			break;
> +		default:
> +			if (!isdigit(str[i]))
> +				goto err;
> +			break;
> +		}
> +	}
> +
> +	length = atoi(str) * unit;
> +	goto end;
> +
> +err:
> +	fprintf(stderr, "Invalid length:%s\n", str);
> +end:
> +	free(str);
> +	return length;
> +}

This should go until a utils/*.c helper file i suspect.

> +
> +static double timeval2double(struct timeval *ts)
> +{
> +	return (double)ts->tv_sec +
> +		(double)ts->tv_usec / (double)1000000;
> +}
> +
> +int bench_mem_memcpy(int argc, const char **argv,
> +		     const char *prefix __used)
> +{
> +	int i;
> +	void *dst, *src;
> +	struct timeval start, stop, diff;
> +	clockcycle_t clock_start = 0, clock_diff = 0;
> +	size_t length;
> +	double bps = 0.0;
> +
> +	argc = parse_options(argc, argv, options,
> +			     bench_mem_memcpy_usage, 0);
> +
> +	/*
> +	 * Caution!
> +	 * Without the statement
> +	 * 	gettimeofday(&diff, NULL);
> +	 * compiler warns (and build environment of perf regards it as error)
> +	 * like this,
> +	 * bench/mem-memcpy.c:93: error: ‘diff.tv_sec’ may be\
> +	 * used uninitialized in this function
> +	 * bench/mem-memcpy.c:93: error: ‘diff.tv_usec’ may be\
> +	 * used uninitialized in this function
> +	 *
> +	 * hmm...
> +	 */
> +	gettimeofday(&diff, NULL);

well, because 'gettimeofday' could fail in theory and then 'diff' 
remains uninitialized. Initializing it would solve that.

> +
> +	length = str2length(length_str);
> +	if ((int)length < 0)
> +		return 1;

str2length should return a proper type instead of forcing a (int) cast 
here.

> +
> +	for (i = 0; routines[i].name; i++)
> +		if (!strcmp(routines[i].name, routine))
> +			break;

Please use { } curly braces around all non-single-line statements. I.e. 
the above should be:

	for (i = 0; routines[i].name; i++) {
		if (!strcmp(routines[i].name, routine))
			break;
	}

It's a tiny bit longer but more robust.

> +	if (!routines[i].name) {
> +		printf("Unknown routine:%s\n", routine);
> +		printf("Available routines...\n");
> +		for (i = 0; routines[i].name; i++)
> +			printf("\t%s ... %s\n",
> +			       routines[i].name, routines[i].desc);
> +		return 1;
> +	}
> +
> +	dst = calloc(length, sizeof(char));
> +	assert(dst);
> +	src = calloc(length, sizeof(char));
> +	assert(src);

Please use BUG_ON() - we try to standardize on kernel code style in perf 
tooling.

> +
> +	if (bench_format == BENCH_FORMAT_DEFAULT)
> +		printf("# Copying %s Bytes from %p to %p ...\n\n",
> +		       length_str, src, dst);

curly braces needed.

> +
> +	if (use_clockcycle) {
> +		clock_start = get_clock();
> +	} else {
> +		gettimeofday(&start, NULL);
> +	}

these curly braces are not needed. (but this code would probably go away 
if the code used perf events to retrieve cycles or time of day elapsed 
time.)

> +
> +	routines[i].fn(dst, src, length);
> +
> +	if (use_clockcycle) {
> +		clock_diff = get_clock() - clock_start;
> +	} else {
> +		gettimeofday(&stop, NULL);
> +		timersub(&stop, &start, &diff);
> +		bps = (double)((double)length / timeval2double(&diff));
> +	}
> +
> +	switch (bench_format) {
> +	case BENCH_FORMAT_DEFAULT:
> +		if (use_clockcycle)
> +			printf(" %14lf Clock/Byte\n",
> +			       (double)clock_diff / (double)length);
> +		else
> +			if (bps < K)
> +				printf(" %14lf B/Sec\n", bps);
> +			else if (bps < K * K)
> +				printf(" %14lfd KB/Sec\n", bps / 1024);
> +			else if (bps < K * K * K)
> +				printf(" %14lf MB/Sec\n", bps / 1024 / 1024);
> +			else
> +				printf(" %14lf GB/Sec\n",
> +				       bps / 1024 / 1024 / 1024);

curly braces needed.

> +		break;
> +	case BENCH_FORMAT_SIMPLE:
> +		if (use_clockcycle)
> +			printf("%lf\n",
> +			       (double)clock_diff / (double)length);
> +		else
> +			printf("%lf\n", bps);
> +		break;
> +	default:
> +		/* reaching here is something disaster */
> +		fprintf(stderr, "Unknown format:%d\n", bench_format);

could use pr_err() here i guess.

> +		exit(1);
> +		break;
> +	}
> +
> +	return 0;
> +}

Thanks,

	Ingo
