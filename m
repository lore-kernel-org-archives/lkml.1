Return-Path: <linux-kernel-owner+w=401wt.eu-S1758253AbZJLVRS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758253AbZJLVRS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 17:17:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758228AbZJLVRR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 17:17:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45706 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757738AbZJLVRQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 17:17:16 -0400
Message-ID: <4AD39D89.6070609@redhat.com>
Date: Mon, 12 Oct 2009 17:20:09 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-2.7.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Masami Hiramatsu <mhiramat@redhat.com>
CC: Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>,
       "Frank Ch. Eigler" <fche@redhat.com>
Subject: Re: [PATCH tracing/kprobes v3 3/7] tracing/kprobes: Rename special
 variables
References: <20091007222733.1684.32035.stgit@dhcp-100-2-132.bos.redhat.com> <20091007222759.1684.3319.stgit@dhcp-100-2-132.bos.redhat.com>
In-Reply-To: <20091007222759.1684.3319.stgit@dhcp-100-2-132.bos.redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Masami Hiramatsu wrote:
> @@ -427,28 +427,17 @@ static int parse_probe_vars(char *arg, struct fetch_func *ff, int is_return)
>   	int ret = 0;
>   	unsigned long param;
>
> -	switch (arg[0]) {
> -	case 'a':	/* argument */
> -		ret = strict_strtoul(arg + 1, 10,&param);
> -		if (ret || param>  PARAM_MAX_ARGS)
> -			ret = -EINVAL;
> -		else {
> -			ff->func = fetch_argument;
> -			ff->data = (void *)param;
> -		}
> -		break;
> -	case 'r':	/* retval or retaddr */
> -		if (is_return&&  arg[1] == 'v') {
> +	if (strcmp(arg, "retval") == 0) {
> +		if (is_return) {
>   			ff->func = fetch_retvalue;
>   			ff->data = NULL;
>   		} else
>   			ret = -EINVAL;
> -		break;
> -	case 's':	/* stack */
> -		if (arg[1] == 'a') {
> +	} else if (strncmp(arg, "stack", 5) == 0) {
> +		if (arg[5] == '\0') {
>   			ff->func = fetch_stack_address;
>   			ff->data = NULL;
> -		} else {
> +		} else if (isdigit(arg[5])) {
>   			ret = strict_strtoul(arg + 1, 10,&param);
                                              ^^^^^^^ this should be arg + 5.

> @@ -456,11 +445,18 @@ static int parse_probe_vars(char *arg, struct fetch_func *ff, int is_return)
>   				ff->func = fetch_stack;
>   				ff->data = (void *)param;
>   			}
> +		} else
> +			ret = -EINVAL;
> +	} else if (strncmp(arg, "arg", 3) == 0&&  isdigit(arg[4])) {
> +		ret = strict_strtoul(arg + 1, 10,&param);
                                      ^^^^^^^ here too, arg + 3.

Thank you,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

