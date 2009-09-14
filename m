Return-Path: <linux-kernel-owner+w=401wt.eu-S1756068AbZINQWg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756068AbZINQWg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 12:22:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756026AbZINQWa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 12:22:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48343 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756015AbZINQW3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 12:22:29 -0400
Message-ID: <4AAE6E85.9020002@redhat.com>
Date: Mon, 14 Sep 2009 12:25:41 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: ananth@in.ibm.com
CC: Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Jim Keniston <jkenisto@us.ibm.com>, Andi Kleen <ak@linux.intel.com>,
       Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Jason Baron <jbaron@redhat.com>, "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Tom Zanussi <tzanussi@gmail.com>
Subject: Re: [BUGFIX] kprobes: prevent re-registration of the same kprobe
 -	take2
References: <20090910235258.22412.29317.stgit@dhcp-100-2-132.bos.redhat.com> <20090910235329.22412.94731.stgit@dhcp-100-2-132.bos.redhat.com> <20090911031253.GD16396@nowhere> <20090913100713.GB14251@in.ibm.com> <4AADA0BB.4030307@redhat.com> <20090914100459.GA4446@in.ibm.com>
In-Reply-To: <20090914100459.GA4446@in.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ananth N Mavinakayanahalli wrote:
> On Sun, Sep 13, 2009 at 09:47:39PM -0400, Masami Hiramatsu wrote:
>> Ananth N Mavinakayanahalli wrote:
>>> On Fri, Sep 11, 2009 at 05:12:54AM +0200, Frederic Weisbecker wrote:
>>>> On Thu, Sep 10, 2009 at 07:53:30PM -0400, Masami Hiramatsu wrote:
>
> ...
>
>> Hmm, if we catch the second registration here, it's too late. At
>> register_kprobe(), we initialized some field of kprobe before calling
>> register_aggr_kprobe(). Especially kprobe.list is cleared.
>>
>> And this can't check the case that 'p' is already registered on
>> an aggr kprobe.
>
> Agreed. I thought of this case after sending out the earlier patch...
>
>> Thus, I think some initialization paths should be changed (kp.flag
>> field is initialized too early, yearh, that's my mistake),
>> and also, you will need to use get_valid_kprobe() to check the kprobe
>> has not been registered.
>
> __get_valid_kprobe() makes the task easy. We should just prevent
> re-registration whether or not the earlier probe is disabled.
>
> How does this patch look?
>
> ---
> Prevent re-registration of the same kprobe. This situation, though
> unlikely, needs to be flagged since it can lead to a system crash if its
> not handled.
>
> The core change itself is small, but the helper routine needed to be
> moved around a bit; hence the diffstat.
>
> Signed-off-by: Ananth N Mavinakayanahalli<ananth@in.ibm.com>
> ---
>   kernel/kprobes.c |   58 ++++++++++++++++++++++++++++++++++++-------------------
>   1 file changed, 38 insertions(+), 20 deletions(-)
>
> Index: linux-2.6.31/kernel/kprobes.c
> ===================================================================
> --- linux-2.6.31.orig/kernel/kprobes.c
> +++ linux-2.6.31/kernel/kprobes.c
> @@ -681,6 +681,40 @@ static kprobe_opcode_t __kprobes *kprobe
>   	return (kprobe_opcode_t *)(((char *)addr) + p->offset);
>   }
>
> +/* Check passed kprobe is valid and return kprobe in kprobe_table. */
> +static struct kprobe * __kprobes __get_valid_kprobe(struct kprobe *p)
> +{
> +	struct kprobe *old_p, *list_p;
> +
> +	old_p = get_kprobe(p->addr);
> +	if (unlikely(!old_p))
> +		return NULL;
> +
> +	if (p != old_p) {
> +		list_for_each_entry_rcu(list_p,&old_p->list, list)
> +			if (list_p == p)
> +			/* kprobe p is a valid probe */
> +				goto valid;
> +		return NULL;
> +	}
> +valid:
> +	return old_p;
> +}
> +
> +/* Return error if the kprobe is being re-registered */
> +static inline int check_kprobe_rereg(struct kprobe *p)
> +{
> +	int ret = 0;
> +	struct kprobe *old_p;
> +
> +	mutex_lock(&kprobe_mutex);
> +	old_p = __get_valid_kprobe(p);
> +	if (old_p == p)

Here, since __get_valid_kprobe(p) will return aggr_kprobe of 'p',
you just need to check old_p != NULL.

Other parts are OK for me.

Thank you!


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

