Return-Path: <linux-kernel-owner+w=401wt.eu-S1759183AbZCWQlb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759183AbZCWQlb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 12:41:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759185AbZCWQkk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 12:40:40 -0400
Received: from mail-ew0-f165.google.com ([209.85.219.165]:62899 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759181AbZCWQki (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 12:40:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=grBylvm/RG5LSDJJAKDwIDJQyxEDo1ZOl/B+hlSHaJOe3nXvf6oJUT6Tbzo7qmrL52
         D+K2GB/c/WGG9KVqx3j92VuO0Aj74l/6sHslWccqH0ebs6dBHwKpvBVJq3H2E+Yoc0KE
         3c+yLoMLth7hUGmArIVuKxajb/sf4r9ZplX8k=
Date: Mon, 23 Mar 2009 17:40:31 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Daniel Mack <daniel@caiaq.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kernel/trace/trace_functions_graph.c: fix nsecs_str
	buffer size
Message-ID: <20090323164030.GA5988@nowhere>
References: <1237824637-28190-1-git-send-email-daniel@caiaq.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1237824637-28190-1-git-send-email-daniel@caiaq.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 23, 2009 at 05:10:37PM +0100, Daniel Mack wrote:
> In kernel/trace/trace_functions_graph.c, print_graph_duration(), len can
> be as low as 1 or 2, which could make snprintf() write beyond the
> buffer bounds. (Found by cppcheck, no real-world bug occured)
> 
> Signed-off-by: Daniel Mack <daniel@caiaq.de>


Hi Daniel,


It can't really happen because nsecs_rem is a rest of a division
per 1000, so it will not exceed 3 digits (so it should be [4] and not
[5], btw).

I must confess I should have added a better comment on this
area.

We are printing a duration in usec with a part in nsec with the following
constraints:

_ never exceed 7 characters unless we are are upper 9999999 usecs
_ always keep the usecs consistants

Which means that while we have 4 or lesser digits for the usecs, we can
print the 3 digits of the nanosecs.

If we need 5 for usecs, drop the least significant nanosec digit.
If we need 6 for usecs, drop the two least significant nanosec digits

6754.543 is correct
67545.543 must become 67545.54
etc...

That's why we have:

len = strlen(msecs_str);

	/* Print nsecs (we don't want to exceed 7 numbers) */
	if (len < 7) {
		snprintf(nsecs_str, 8 - len, "%03lu", nsecs_rem);

The 8 - len inside snprintf is not a security against overflow but a
precision set. We know that it will never go upper 3 digits, but if we
have 6 digits for usecs, we want only 8 - 6 = 2 nsecs

Hmm, may be it should be 7 -len. I don't remember. Anyway, this part
must be fixed to handle msecs and align the row to the left...


Frederic.


> ---
>  kernel/trace/trace_functions_graph.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
> index 930c08e..7533b25 100644
> --- a/kernel/trace/trace_functions_graph.c
> +++ b/kernel/trace/trace_functions_graph.c
> @@ -281,7 +281,7 @@ print_graph_duration(unsigned long long duration, struct trace_seq *s)
>  	unsigned long nsecs_rem = do_div(duration, 1000);
>  	/* log10(ULONG_MAX) + '\0' */
>  	char msecs_str[21];
> -	char nsecs_str[5];
> +	char nsecs_str[8];
>  	int ret, len;
>  	int i;
>  
> -- 
> 1.6.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

