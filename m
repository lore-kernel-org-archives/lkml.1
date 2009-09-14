Return-Path: <linux-kernel-owner+w=401wt.eu-S1754738AbZINBqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754738AbZINBqT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Sep 2009 21:46:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752956AbZINBqS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Sep 2009 21:46:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57836 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751770AbZINBqR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Sep 2009 21:46:17 -0400
Message-ID: <4AADA0BB.4030307@redhat.com>
Date: Sun, 13 Sep 2009 21:47:39 -0400
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
References: <20090910235258.22412.29317.stgit@dhcp-100-2-132.bos.redhat.com> <20090910235329.22412.94731.stgit@dhcp-100-2-132.bos.redhat.com> <20090911031253.GD16396@nowhere> <20090913100713.GB14251@in.ibm.com>
In-Reply-To: <20090913100713.GB14251@in.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ananth N Mavinakayanahalli wrote:
> On Fri, Sep 11, 2009 at 05:12:54AM +0200, Frederic Weisbecker wrote:
>> On Thu, Sep 10, 2009 at 07:53:30PM -0400, Masami Hiramatsu wrote:
> 
> ...
> 
>> Is it possible to have two kprobes having the exact same
>> properties? (pointing to the same address, having the same
>> probe handlers, etc...)
> 
> Yes, this is possible with two *different* kprobes. However, we have a bug
> with the current code where there is insufficient scaffolding to prevent
> re-registration of the same kprobe. Here is a patch...

Indeed, that is a bug, or spec. I didn't expect that user register
same kprobes twice.

> ---
> Prevent re-registration of the same kprobe. Current code allows this,
> albeit with disastrous consequences. Its not a common case, but should
> be flagged nonetheless.
> 
> Signed-off-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
> ---
>  kernel/kprobes.c |    3 +++
>  1 file changed, 3 insertions(+)
> 
> Index: ptrace-10sep/kernel/kprobes.c
> ===================================================================
> --- ptrace-10sep.orig/kernel/kprobes.c
> +++ ptrace-10sep/kernel/kprobes.c
> @@ -589,6 +589,9 @@ static int __kprobes register_aggr_kprob
>  	int ret = 0;
>  	struct kprobe *ap = old_p;
>  
> +	if (old_p == p)
> +		/* Attempt to re-register the same kprobe.. fail */
> +		return -EINVAL;
>  	if (old_p->pre_handler != aggr_pre_handler) {
>  		/* If old_p is not an aggr_probe, create new aggr_kprobe. */
>  		ap = kzalloc(sizeof(struct kprobe), GFP_KERNEL);


Hmm, if we catch the second registration here, it's too late. At
register_kprobe(), we initialized some field of kprobe before calling
register_aggr_kprobe(). Especially kprobe.list is cleared.

And this can't check the case that 'p' is already registered on
an aggr kprobe.

Thus, I think some initialization paths should be changed (kp.flag
field is initialized too early, yearh, that's my mistake),
and also, you will need to use get_valid_kprobe() to check the kprobe
has not been registered.

Thank you,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

