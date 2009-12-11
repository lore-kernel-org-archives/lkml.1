Return-Path: <linux-kernel-owner+w=401wt.eu-S934887AbZLKIPS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934887AbZLKIPS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 03:15:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760919AbZLKIPP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 03:15:15 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:52247 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1760914AbZLKIPO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 03:15:14 -0500
Message-ID: <4B21FF84.3010509@cn.fujitsu.com>
Date: Fri, 11 Dec 2009 16:15:00 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Wenji Huang <wenji.huang@oracle.com>
CC: linux-kernel@vger.kernel.org, rostedt@goodmis.org, fweisbec@gmail.com,
       tzanussi@gmail.com
Subject: Re: [PATCH]tracing: Fix inaccurate function definition in trace_events_filter.c
References: <1260518338-16034-1-git-send-email-wenji.huang@oracle.com>
In-Reply-To: <1260518338-16034-1-git-send-email-wenji.huang@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wenji Huang wrote:
> Use strcmp instead of strncmp to do full match.
> 

It's intended to use strncmp instead of strcmp..

field(char, name, size) will be treated as a STATIC_STRING by
filter code. But this field isn't necessarily a string, it
can be an array of chars, which may not be ended with '\0'.
So in this case, we can't use strcmp.

So do you really see incorrect filter results?

I think STATIC_STRING and DYN_STRING should be fine, because
the "len" parameter is not the length of the string, but
the length of the array, which including the tailing '\0'.

For FILTER_PTR_STRING, the filter is not working correctly:

  # echo 'func == vt' > events/bkl/lock_kernel/filter
  # echo 1 > events/bkl/lock_kernel/enable
  ...
  # cat trace
   Xorg-1484  [000]  1973.392586: lock_kernel: ... func=vt_ioctl()
    gpm-1402  [001]  1974.027740: lock_kernel: ... func=vt_ioctl()

Actually I already made 2 patches to fix this, and fix another
bug in regex_match_end(). I'll send them out soon.

> Signed-off-by: Wenji Huang <wenji.huang@oracle.com>
> ---
>  kernel/trace/trace_events_filter.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
> index 50504cb..06dc376 100644
> --- a/kernel/trace/trace_events_filter.c
> +++ b/kernel/trace/trace_events_filter.c
> @@ -254,7 +254,7 @@ static int filter_pred_none(struct filter_pred *pred, void *event,
>  /* Basic regex callbacks */
>  static int regex_match_full(char *str, struct regex *r, int len)
>  {
> -	if (strncmp(str, r->pattern, len) == 0)
> +	if (strcmp(str, r->pattern) == 0)
>  		return 1;
>  	return 0;
>  }
