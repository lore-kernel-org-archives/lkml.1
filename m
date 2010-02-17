Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757224Ab0BQVrv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 16:47:51 -0500
Received: from cantor2.suse.de ([195.135.220.15]:37467 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750927Ab0BQVrt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 16:47:49 -0500
Message-ID: <4B7C6400.7050300@suse.com>
Date: Wed, 17 Feb 2010 16:47:44 -0500
From: Jeff Mahoney <jeffm@suse.com>
Organization: SUSE Labs, Novell, Inc
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100111 SUSE/3.0.1-1.1 Thunderbird/3.0.1
MIME-Version: 1.0
To: balbir@linux.vnet.ibm.com
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] delayacct: align to 8 byte boundary on 64-bit systems
References: <4B75865B.8000307@suse.com> <20100212101957.9f4a4a3a.akpm@linux-foundation.org> <20100213021420.GE11364@balbir.in.ibm.com>
In-Reply-To: <20100213021420.GE11364@balbir.in.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/12/2010 09:14 PM, Balbir Singh wrote:
> * Andrew Morton <akpm@linux-foundation.org> [2010-02-12 10:19:57]:
> 
>> On Fri, 12 Feb 2010 11:48:27 -0500
>> Jeff Mahoney <jeffm@suse.com> wrote:
>>
>>>  prepare_reply sets up an skb for the response. If I understand it correctly,
>>>  the payload contains:
>>>
>>>  +--------------------------------+
>>>  | genlmsghdr - 4 bytes           |
>>>  +--------------------------------+
>>>  | NLA header - 4 bytes           | /* Aggregate header */
>>>  +-+------------------------------+
>>>  | | NLA header - 4 bytes         | /* PID header */
>>>  | +------------------------------+
>>>  | | pid/tgid   - 4 bytes         |
>>
>> So we put another four zero bytes in here and add four to the "PID header".
>>
> 
> Do you know if these breaks existing applications?

AFAIK it doesn't. The initial problem was reported by a partner and
there have been no reports of breakage since the fix was shipped in a
maintenance update for SLE11 in October. I think Andrew's guess about
users just copying the getdelays.c code is probably pretty accurate.

>>>  | +------------------------------+
>>>  | | NLA header - 4 bytes         | /* stats header */
>>>  | + -----------------------------+ <- oops. aligned on 4 byte boundary
>>>  | | struct taskstats - 328 bytes |
>>>  +-+------------------------------+
>>>
>>>  The start of the taskstats struct must be 8 byte aligned on IA64 (and other
>>>  systems with 8 byte alignment rules for 64-bit types) or runtime alignment
>>>  warnings will be issued.
>>>
>>>  This patch pads the pid/tgid field out to sizeof(long), which forces
>>>  the alignment of taskstats. The getdelays userspace code is ok with this
>>>  since it assumes 32-bit pid/tgid and then honors that header's length field.
>>>
> 
> Could you define OK above? Does the application work without
> recompiling? Have you checked for endianness issues?

Yes, it seemed to work as before. I just used getdelays.c to test it.

>>>  An array is used to avoid exposing kernel memory contents to userspace in the
>>>  response.
>>>
>>> Signed-off-by: Jeff Mahoney <jeffm@suse.com>
>>> ---
>>>  kernel/taskstats.c |    8 +++++++-
>>>  1 file changed, 7 insertions(+), 1 deletion(-)
>>>
>>> --- a/kernel/taskstats.c
>>> +++ b/kernel/taskstats.c
>>> @@ -362,6 +362,12 @@ static struct taskstats *mk_reply(struct
>>>  	struct nlattr *na, *ret;
>>>  	int aggr;
>>>  
>>> +	/* If we don't pad, we end up with alignment on a 4 byte boundary.
>>> +	 * This causes lots of runtime warnings on systems requiring 8 byte
>>> +	 * alignment */
>>> +	u32 pids[2] = { pid, 0 };
> 
> Shouldn't this be endianness dependent?

It could if the user casts to a 64-bit type instead of a 32-bit type,
but that assumption was covered in the comment about the pids and tgids
being 32-bit.

>>> +	int pid_size = ALIGN(sizeof(pid), sizeof(long));
>>> +
>>>  	aggr = (type == TASKSTATS_TYPE_PID)
>>>  			? TASKSTATS_TYPE_AGGR_PID
>>>  			: TASKSTATS_TYPE_AGGR_TGID;
>>> @@ -369,7 +375,7 @@ static struct taskstats *mk_reply(struct
>>>  	na = nla_nest_start(skb, aggr);
>>>  	if (!na)
>>>  		goto err;
>>> -	if (nla_put(skb, type, sizeof(pid), &pid) < 0)
>>> +	if (nla_put(skb, type, pid_size, pids) < 0)
>>>  		goto err;
>>>  	ret = nla_reserve(skb, TASKSTATS_TYPE_STATS, sizeof(struct taskstats));
>>>  	if (!ret)
>>
>> So any code which assumes that the pid/tgid field is four bytes long
>> will break.  Code which takes that length from the netlink message
>> header will work OK.
>>
> 
> I think we assume that PID/TGID is 32 bits long, we use the length to
> extract the rest of the message. We cast NLA_DATA to int* in
> getdelays.c.
> 
>> 32-bit architectures are unaltered.
>>
>> Seems safe enough.  We'd be safer still if we didn't do this on 64-bit
>> architectures which don't need it.  ie: x86_64.  But if we do that we
>> add a risk that people will develop shoddy code which works on x86_64
>> and doesn't work on ia64.
>>
> 
> May be, this deserves an ABI and version bump in taskstats. I'll test
> this patch soon. 

That could be too. Though if an ABI bump is in the works, then it's
probably better to not fix it this way and have an empty attribute type
instead.

-Jeff

-- 
Jeff Mahoney
SuSE Labs
