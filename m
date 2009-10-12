Return-Path: <linux-kernel-owner+w=401wt.eu-S1758421AbZJLV3K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758421AbZJLV3K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 17:29:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758408AbZJLV3I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 17:29:08 -0400
Received: from mail-ew0-f228.google.com ([209.85.219.228]:64971 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758402AbZJLV3G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 17:29:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=RJeSrNdCVttQjYAWXFYdJm47j9T3FpE6NZFsFU3WTxDepJF+FYhVvQkj7/uX8CjJow
         vzR6hsEJLGpU3MWKsBW1Ckp1P68JPEcdosb6jXuwkOLlQpO0s4FjT5BVsIIf00cXbeZt
         xNBUxCIoizzHGThPzhVqEW+g2uH7CoCT9JWbU=
Date: Mon, 12 Oct 2009 23:28:26 +0200
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
Subject: Re: [PATCH tracing/kprobes v3 3/7] tracing/kprobes: Rename special
	variables
Message-ID: <20091012212824.GE4748@nowhere>
References: <20091007222733.1684.32035.stgit@dhcp-100-2-132.bos.redhat.com> <20091007222759.1684.3319.stgit@dhcp-100-2-132.bos.redhat.com> <4AD39D89.6070609@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AD39D89.6070609@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 12, 2009 at 05:20:09PM -0400, Masami Hiramatsu wrote:
> Masami Hiramatsu wrote:
>> @@ -427,28 +427,17 @@ static int parse_probe_vars(char *arg, struct fetch_func *ff, int is_return)
>>   	int ret = 0;
>>   	unsigned long param;
>>
>> -	switch (arg[0]) {
>> -	case 'a':	/* argument */
>> -		ret = strict_strtoul(arg + 1, 10,&param);
>> -		if (ret || param>  PARAM_MAX_ARGS)
>> -			ret = -EINVAL;
>> -		else {
>> -			ff->func = fetch_argument;
>> -			ff->data = (void *)param;
>> -		}
>> -		break;
>> -	case 'r':	/* retval or retaddr */
>> -		if (is_return&&  arg[1] == 'v') {
>> +	if (strcmp(arg, "retval") == 0) {
>> +		if (is_return) {
>>   			ff->func = fetch_retvalue;
>>   			ff->data = NULL;
>>   		} else
>>   			ret = -EINVAL;
>> -		break;
>> -	case 's':	/* stack */
>> -		if (arg[1] == 'a') {
>> +	} else if (strncmp(arg, "stack", 5) == 0) {
>> +		if (arg[5] == '\0') {
>>   			ff->func = fetch_stack_address;
>>   			ff->data = NULL;
>> -		} else {
>> +		} else if (isdigit(arg[5])) {
>>   			ret = strict_strtoul(arg + 1, 10,&param);
>                                              ^^^^^^^ this should be arg + 5.
>
>> @@ -456,11 +445,18 @@ static int parse_probe_vars(char *arg, struct fetch_func *ff, int is_return)
>>   				ff->func = fetch_stack;
>>   				ff->data = (void *)param;
>>   			}
>> +		} else
>> +			ret = -EINVAL;
>> +	} else if (strncmp(arg, "arg", 3) == 0&&  isdigit(arg[4])) {



And this should be isdigit(arg[3]) actually, what you want to test is the
first character after arg, right?



>> +		ret = strict_strtoul(arg + 1, 10,&param);
>                                      ^^^^^^^ here too, arg + 3.

