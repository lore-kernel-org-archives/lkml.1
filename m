Return-Path: <linux-kernel-owner+w=401wt.eu-S1753801AbZIWBNN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753801AbZIWBNN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 21:13:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753711AbZIWBNN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 21:13:13 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:60941 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753598AbZIWBNM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 21:13:12 -0400
Message-ID: <4AB975DD.9040205@cn.fujitsu.com>
Date: Wed, 23 Sep 2009 09:11:57 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Jim Keniston <jkenisto@us.ibm.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Andi Kleen <ak@linux.intel.com>, Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Jason Baron <jbaron@redhat.com>, "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Tom Zanussi <tzanussi@gmail.com>
Subject: Re: [PATCH 19/24] ftrace: Fix trace_add_event_call() to initialize
 list
References: <1253648302-5771-1-git-send-email-fweisbec@gmail.com> <1253648302-5771-20-git-send-email-fweisbec@gmail.com>
In-Reply-To: <1253648302-5771-20-git-send-email-fweisbec@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
> index ba34920..83cc2c0 100644
> --- a/kernel/trace/trace_events.c
> +++ b/kernel/trace/trace_events.c
> @@ -1010,9 +1010,12 @@ static int __trace_add_event_call(struct ftrace_event_call *call)
>  		return -ENOENT;
>  
>  	list_add(&call->list, &ftrace_events);
> -	return event_create_dir(call, d_events, &ftrace_event_id_fops,
> +	ret = event_create_dir(call, d_events, &ftrace_event_id_fops,
>  				&ftrace_enable_fops, &ftrace_event_filter_fops,
>  				&ftrace_event_format_fops);
> +	if (ret < 0)
> +		list_del(&call->list);
> +	return ret;

seems it's a bit better to call list_add() after event_create_dir()
returns 0.

>  }
>  
>  /* Add an additional event_call dynamically */
