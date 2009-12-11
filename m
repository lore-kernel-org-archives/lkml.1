Return-Path: <linux-kernel-owner+w=401wt.eu-S1758804AbZLKPOW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758804AbZLKPOW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 10:14:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758394AbZLKPOS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 10:14:18 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:53915 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758291AbZLKPOR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 10:14:17 -0500
X-Authority-Analysis: v=1.0 c=1 a=1se4N-GdtywA:10 a=7U3hwN5JcxgA:10 a=omOdbC7AAAAA:8 a=EDTNLUuTHAAQgI_Qld8A:9 a=dzwvGMuYXJ6SUjfEAvO3Ex_QH7wA:4
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH 4/4] tracing/filters: Fix MATCH_EBD_ONLY filter matching
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Wenji Huang <wenji.huang@oracle.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4B22180E.6090907@cn.fujitsu.com>
References: <4B2217D0.5000308@cn.fujitsu.com>
	 <4B22180E.6090907@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Fri, 11 Dec 2009 10:14:18 -0500
Message-ID: <1260544458.2146.362.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-12-11 at 17:59 +0800, Li Zefan wrote:
> For '*foo' pattern, we should allow any string ending with
> 'foo', but tracing filter incorrectly disallows strings
> matching regex expression ".*foo.*foo".
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> ---
>  kernel/trace/trace_events_filter.c |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
> index bd492ce..9f96339 100644
> --- a/kernel/trace/trace_events_filter.c
> +++ b/kernel/trace/trace_events_filter.c
> @@ -276,9 +276,10 @@ static int regex_match_middle(char *str, struct regex *r, int len)
>  
>  static int regex_match_end(char *str, struct regex *r, int len)
>  {
> -	char *ptr = strstr(str, r->pattern);
> +	int strlen = len - 1;
>  
> -	if (ptr && (ptr[r->len] == 0))
> +	if (strlen >= r->len &&
> +	    !memcmp(str + strlen - r->len, r->pattern, r->len))

Please use memcmp() == 0, I've seen too many bugs with !*cmp as well as
with *cmp, because humans tend to think instinctively when reading this
that ! is not a match. With "== 0" we think that "==" is a match and
 "!=" is a miss.

Thanks,


-- Steve

>  		return 1;
>  	return 0;
>  }


