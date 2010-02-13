Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755502Ab0BMCO2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 21:14:28 -0500
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:51817 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753689Ab0BMCO1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 21:14:27 -0500
Date: Sat, 13 Feb 2010 07:44:21 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jeff Mahoney <jeffm@suse.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] delayacct: align to 8 byte boundary on 64-bit systems
Message-ID: <20100213021420.GE11364@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <4B75865B.8000307@suse.com>
 <20100212101957.9f4a4a3a.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20100212101957.9f4a4a3a.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Andrew Morton <akpm@linux-foundation.org> [2010-02-12 10:19:57]:

> On Fri, 12 Feb 2010 11:48:27 -0500
> Jeff Mahoney <jeffm@suse.com> wrote:
> 
> >  prepare_reply sets up an skb for the response. If I understand it correctly,
> >  the payload contains:
> > 
> >  +--------------------------------+
> >  | genlmsghdr - 4 bytes           |
> >  +--------------------------------+
> >  | NLA header - 4 bytes           | /* Aggregate header */
> >  +-+------------------------------+
> >  | | NLA header - 4 bytes         | /* PID header */
> >  | +------------------------------+
> >  | | pid/tgid   - 4 bytes         |
> 
> So we put another four zero bytes in here and add four to the "PID header".
>

Do you know if these breaks existing applications?
 
> >  | +------------------------------+
> >  | | NLA header - 4 bytes         | /* stats header */
> >  | + -----------------------------+ <- oops. aligned on 4 byte boundary
> >  | | struct taskstats - 328 bytes |
> >  +-+------------------------------+
> > 
> >  The start of the taskstats struct must be 8 byte aligned on IA64 (and other
> >  systems with 8 byte alignment rules for 64-bit types) or runtime alignment
> >  warnings will be issued.
> > 
> >  This patch pads the pid/tgid field out to sizeof(long), which forces
> >  the alignment of taskstats. The getdelays userspace code is ok with this
> >  since it assumes 32-bit pid/tgid and then honors that header's length field.
> > 

Could you define OK above? Does the application work without
recompiling? Have you checked for endianness issues?

> >  An array is used to avoid exposing kernel memory contents to userspace in the
> >  response.
> > 
> > Signed-off-by: Jeff Mahoney <jeffm@suse.com>
> > ---
> >  kernel/taskstats.c |    8 +++++++-
> >  1 file changed, 7 insertions(+), 1 deletion(-)
> > 
> > --- a/kernel/taskstats.c
> > +++ b/kernel/taskstats.c
> > @@ -362,6 +362,12 @@ static struct taskstats *mk_reply(struct
> >  	struct nlattr *na, *ret;
> >  	int aggr;
> >  
> > +	/* If we don't pad, we end up with alignment on a 4 byte boundary.
> > +	 * This causes lots of runtime warnings on systems requiring 8 byte
> > +	 * alignment */
> > +	u32 pids[2] = { pid, 0 };

Shouldn't this be endianness dependent?

> > +	int pid_size = ALIGN(sizeof(pid), sizeof(long));
> > +
> >  	aggr = (type == TASKSTATS_TYPE_PID)
> >  			? TASKSTATS_TYPE_AGGR_PID
> >  			: TASKSTATS_TYPE_AGGR_TGID;
> > @@ -369,7 +375,7 @@ static struct taskstats *mk_reply(struct
> >  	na = nla_nest_start(skb, aggr);
> >  	if (!na)
> >  		goto err;
> > -	if (nla_put(skb, type, sizeof(pid), &pid) < 0)
> > +	if (nla_put(skb, type, pid_size, pids) < 0)
> >  		goto err;
> >  	ret = nla_reserve(skb, TASKSTATS_TYPE_STATS, sizeof(struct taskstats));
> >  	if (!ret)
> 
> So any code which assumes that the pid/tgid field is four bytes long
> will break.  Code which takes that length from the netlink message
> header will work OK.
> 

I think we assume that PID/TGID is 32 bits long, we use the length to
extract the rest of the message. We cast NLA_DATA to int* in
getdelays.c.

> 32-bit architectures are unaltered.
> 
> Seems safe enough.  We'd be safer still if we didn't do this on 64-bit
> architectures which don't need it.  ie: x86_64.  But if we do that we
> add a risk that people will develop shoddy code which works on x86_64
> and doesn't work on ia64.
>

May be, this deserves an ABI and version bump in taskstats. I'll test
this patch soon. 

-- 
	Three Cheers,
	Balbir
