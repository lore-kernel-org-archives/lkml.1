Return-Path: <linux-kernel-owner+w=401wt.eu-S1751792AbZIZIxN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751792AbZIZIxN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Sep 2009 04:53:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751467AbZIZIxM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Sep 2009 04:53:12 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:60312 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751083AbZIZIxM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Sep 2009 04:53:12 -0400
Subject: Re: [RFC PATCH tracing/kprobes 4/5] perf: Support perf kprobe
 command for kprobe-event setup helper
From: Steven Rostedt <rostedt@goodmis.org>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       lkml <linux-kernel@vger.kernel.org>, systemtap <systemtap@redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>,
       "Frank Ch. Eigler" <fche@redhat.com>
In-Reply-To: <20090925191546.12939.75278.stgit@omoto>
References: <20090925191424.12939.91503.stgit@omoto>
	 <20090925191546.12939.75278.stgit@omoto>
Content-Type: text/plain
Date: Sat, 26 Sep 2009 04:52:00 -0400
Message-Id: <1253955120.12145.2.camel@frodo>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-09-25 at 12:15 -0700, Masami Hiramatsu wrote:

> +
> +#define MAX_CMDLEN 256
> +
> +static int synthesize_probepoint(struct probe_point *pp)
> +{
> +	char *buf;
> +	int i, len, ret;
> +	pp->probes[0] = buf = (char *)calloc(MAX_CMDLEN, sizeof(char));
> +	len = snprintf(buf, MAX_CMDLEN, "%s+%d", pp->function, pp->offset);

What happens if func and offset is too big for MAX_CMDLEN?

> +	for (i = 0; i < pp->nr_args; i++) {

Can you have a case where pp->nr_args == 0?

> +		ret = snprintf(&buf[len], MAX_CMDLEN - len, " %s",
> +			       pp->args[i]);
> +		if (ret <= 0 || ret >= MAX_CMDLEN - len) {
> +			free(pp->probes[0]);
> +			return -E2BIG;
> +		}
> +		len += ret;
> +	}
> +	return pp->found = 1;
> +}
> +
> +int cmd_kprobe(int argc, const char **argv, const char *prefix __used)
> +{
> +	int i, j, fd, ret, need_dwarf = 0;
> +	struct probe_point *pp;
> +	char buf[MAX_CMDLEN];
> +
> +	argc = parse_options(argc, argv, options, kprobe_usage,
> +		PARSE_OPT_STOP_AT_NON_OPTION);
> +	if (argc || session.nr_probe == 0)
> +		usage_with_options(kprobe_usage, options);
> +
> +	/* Synthesize return probes */
> +	for (j = 0; j < session.nr_probe; j++) {
> +		if (session.events[j][0] != 'r') {
> +			need_dwarf = 1;
> +			continue;
> +		}
> +		ret = synthesize_probepoint(&session.probes[j]);
> +		if (ret < 0)
> +			semantic_error("probe point is too long.");

If we have no args but the func and offset is too big, then this does
not catch it. But this depends on if we can have no args.

-- Steve

> +	}
> +
> 

