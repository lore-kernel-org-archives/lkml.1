Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756383Ab0BLSUe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 13:20:34 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50578 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755452Ab0BLSUd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 13:20:33 -0500
Date: Fri, 12 Feb 2010 10:19:57 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jeff Mahoney <jeffm@suse.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: [PATCH] delayacct: align to 8 byte boundary on 64-bit systems
Message-Id: <20100212101957.9f4a4a3a.akpm@linux-foundation.org>
In-Reply-To: <4B75865B.8000307@suse.com>
References: <4B75865B.8000307@suse.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Feb 2010 11:48:27 -0500
Jeff Mahoney <jeffm@suse.com> wrote:

>  prepare_reply sets up an skb for the response. If I understand it correctly,
>  the payload contains:
> 
>  +--------------------------------+
>  | genlmsghdr - 4 bytes           |
>  +--------------------------------+
>  | NLA header - 4 bytes           | /* Aggregate header */
>  +-+------------------------------+
>  | | NLA header - 4 bytes         | /* PID header */
>  | +------------------------------+
>  | | pid/tgid   - 4 bytes         |

So we put another four zero bytes in here and add four to the "PID header".

>  | +------------------------------+
>  | | NLA header - 4 bytes         | /* stats header */
>  | + -----------------------------+ <- oops. aligned on 4 byte boundary
>  | | struct taskstats - 328 bytes |
>  +-+------------------------------+
> 
>  The start of the taskstats struct must be 8 byte aligned on IA64 (and other
>  systems with 8 byte alignment rules for 64-bit types) or runtime alignment
>  warnings will be issued.
> 
>  This patch pads the pid/tgid field out to sizeof(long), which forces
>  the alignment of taskstats. The getdelays userspace code is ok with this
>  since it assumes 32-bit pid/tgid and then honors that header's length field.
> 
>  An array is used to avoid exposing kernel memory contents to userspace in the
>  response.
> 
> Signed-off-by: Jeff Mahoney <jeffm@suse.com>
> ---
>  kernel/taskstats.c |    8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> --- a/kernel/taskstats.c
> +++ b/kernel/taskstats.c
> @@ -362,6 +362,12 @@ static struct taskstats *mk_reply(struct
>  	struct nlattr *na, *ret;
>  	int aggr;
>  
> +	/* If we don't pad, we end up with alignment on a 4 byte boundary.
> +	 * This causes lots of runtime warnings on systems requiring 8 byte
> +	 * alignment */
> +	u32 pids[2] = { pid, 0 };
> +	int pid_size = ALIGN(sizeof(pid), sizeof(long));
> +
>  	aggr = (type == TASKSTATS_TYPE_PID)
>  			? TASKSTATS_TYPE_AGGR_PID
>  			: TASKSTATS_TYPE_AGGR_TGID;
> @@ -369,7 +375,7 @@ static struct taskstats *mk_reply(struct
>  	na = nla_nest_start(skb, aggr);
>  	if (!na)
>  		goto err;
> -	if (nla_put(skb, type, sizeof(pid), &pid) < 0)
> +	if (nla_put(skb, type, pid_size, pids) < 0)
>  		goto err;
>  	ret = nla_reserve(skb, TASKSTATS_TYPE_STATS, sizeof(struct taskstats));
>  	if (!ret)

So any code which assumes that the pid/tgid field is four bytes long
will break.  Code which takes that length from the netlink message
header will work OK.

32-bit architectures are unaltered.

Seems safe enough.  We'd be safer still if we didn't do this on 64-bit
architectures which don't need it.  ie: x86_64.  But if we do that we
add a risk that people will develop shoddy code which works on x86_64
and doesn't work on ia64.

hmm.
