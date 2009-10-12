Return-Path: <linux-kernel-owner+w=401wt.eu-S932816AbZJLRii@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932816AbZJLRii (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 13:38:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932607AbZJLRih
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 13:38:37 -0400
Received: from mail-ew0-f208.google.com ([209.85.219.208]:62239 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932548AbZJLRig (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 13:38:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ay7QWedi5nJZ30ZCTyYwQK/vwkbtQIPnGQWp6qwfbiawHw7STvuIbbwsy4qrNV2lWc
         TZB8ZF+Q+DbEYraiGnqeUtHauOcVuQlw9OvakhiP+M2S2e/mgzJBlrmkehnK4Ps22lG1
         kvR7QL/IF4VM3UUHP/Wv35SeTIc9Ss0PcdAZw=
Date: Mon, 12 Oct 2009 19:37:54 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
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
Subject: Re: [PATCH tracing/kprobes v3 4/7] tracing/kprobes: Avoid field
	name confliction
Message-ID: <20091012173752.GB5059@nowhere>
References: <20091007222733.1684.32035.stgit@dhcp-100-2-132.bos.redhat.com> <20091007222807.1684.26880.stgit@dhcp-100-2-132.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091007222807.1684.26880.stgit@dhcp-100-2-132.bos.redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 07, 2009 at 06:28:07PM -0400, Masami Hiramatsu wrote:
> Check whether the argument name is conflict with other field names.
> 
> Changes in v3:
>  - Check strcmp() == 0 instead of !strcmp().
> 
> Changes in v2:
>  - Add common_lock_depth to reserved name list.
> 
> Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Mike Galbraith <efault@gmx.de>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Christoph Hellwig <hch@infradead.org>
> Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
> Cc: Jim Keniston <jkenisto@us.ibm.com>
> Cc: Frank Ch. Eigler <fche@redhat.com>
> ---
> 
>  kernel/trace/trace_kprobe.c |   65 +++++++++++++++++++++++++++++++++++--------
>  1 files changed, 53 insertions(+), 12 deletions(-)
> 
> diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
> index 030f28c..e3b824a 100644
> --- a/kernel/trace/trace_kprobe.c
> +++ b/kernel/trace/trace_kprobe.c
> @@ -38,6 +38,25 @@
>  #define MAX_EVENT_NAME_LEN 64
>  #define KPROBE_EVENT_SYSTEM "kprobes"
>  
> +/* Reserved field names */
> +#define FIELD_STRING_IP "ip"
> +#define FIELD_STRING_NARGS "nargs"
> +#define FIELD_STRING_RETIP "ret_ip"
> +#define FIELD_STRING_FUNC "func"
> +
> +const char *reserved_field_names[] = {
> +	"common_type",
> +	"common_flags",
> +	"common_preempt_count",
> +	"common_pid",
> +	"common_tgid",
> +	"common_lock_depth",
> +	FIELD_STRING_IP,
> +	FIELD_STRING_NARGS,
> +	FIELD_STRING_RETIP,
> +	FIELD_STRING_FUNC,
> +};
> +
>  /* currently, trace_kprobe only supports X86. */
>  
>  struct fetch_func {
> @@ -537,6 +556,20 @@ static int parse_probe_arg(char *arg, struct fetch_func *ff, int is_return)
>  	return ret;
>  }
>  
> +/* Return 1 if name is reserved or already used by another argument */
> +static int conflict_field_name(const char *name,
> +			       struct probe_arg *args, int narg)
> +{
> +	int i;
> +	for (i = 0; i < ARRAY_SIZE(reserved_field_names); i++)
> +		if (strcmp(reserved_field_names[i], name) == 0)
> +			return 1;
> +	for (i = 0; i < narg; i++)
> +		if (strcmp(args[i].name, name) == 0)
> +			return 1;
> +	return 0;
> +}
> +
>  static int create_trace_probe(int argc, char **argv)
>  {
>  	/*
> @@ -637,6 +670,12 @@ static int create_trace_probe(int argc, char **argv)
>  			*arg++ = '\0';
>  		else
>  			arg = argv[i];
> +
> +		if (conflict_field_name(argv[i], tp->args, i)) {
> +			ret = -EINVAL;



The conflict issue might not be obvious for a user desperately trying to set
a kprobe. Even for other failcases, it might not be obvious (blacklisted
symbols, syntax errors...)

May be should you improve the error granularity and print a KERN_DEBUG
message?

Thanks.

