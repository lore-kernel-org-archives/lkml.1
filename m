Return-Path: <linux-kernel-owner+w=401wt.eu-S1754077AbZGWPmg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754077AbZGWPmg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 11:42:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753498AbZGWPmf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 11:42:35 -0400
Received: from smtp111.iad.emailsrvr.com ([207.97.245.111]:39165 "EHLO
	smtp111.iad.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752906AbZGWPmf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 11:42:35 -0400
X-Greylist: delayed 544 seconds by postgrey-1.27 at vger.kernel.org; Thu, 23 Jul 2009 11:42:34 EDT
Message-ID: <4A6882C0.6020302@librato.com>
Date: Thu, 23 Jul 2009 11:33:20 -0400
From: Oren Laadan <orenl@librato.com>
Organization: Librato
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
MIME-Version: 1.0
To: "Serge E. Hallyn" <serue@us.ibm.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@osdl.org>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, linux-api@vger.kernel.org,
       Dave Hansen <dave@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Pavel Emelyanov <xemul@openvz.org>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Oren Laadan <orenl@cs.columbia.edu>
Subject: Re: [RFC v17][PATCH 22/60] c/r: external checkpoint of a task	other
 than ourself
References: <1248256822-23416-1-git-send-email-orenl@librato.com> <1248256822-23416-23-git-send-email-orenl@librato.com> <20090723144753.GA12416@us.ibm.com>
In-Reply-To: <20090723144753.GA12416@us.ibm.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Serge E. Hallyn wrote:
> Quoting Oren Laadan (orenl@librato.com):
>> +/* setup checkpoint-specific parts of ctx */
>> +static int init_checkpoint_ctx(struct ckpt_ctx *ctx, pid_t pid)
>> +{
>> +	struct task_struct *task;
>> +	struct nsproxy *nsproxy;
>> +	int ret;
>> +
>> +	/*
>> +	 * No need for explicit cleanup here, because if an error
>> +	 * occurs then ckpt_ctx_free() is eventually called.
>> +	 */
>> +
>> +	ctx->root_pid = pid;
>> +
>> +	/* root task */
>> +	read_lock(&tasklist_lock);
>> +	task = find_task_by_vpid(pid);
>> +	if (task)
>> +		get_task_struct(task);
>> +	read_unlock(&tasklist_lock);
>> +	if (!task)
>> +		return -ESRCH;
>> +	else
>> +		ctx->root_task = task;
>> +
>> +	/* root nsproxy */
>> +	rcu_read_lock();
>> +	nsproxy = task_nsproxy(task);
>> +	if (nsproxy)
>> +		get_nsproxy(nsproxy);
>> +	rcu_read_unlock();
>> +	if (!nsproxy)
>> +		return -ESRCH;
>> +	else
>> +		ctx->root_nsproxy = nsproxy;
>> +
>> +	/* root freezer */
>> +	ctx->root_freezer = task;
>> +	geT_task_struct(task);
>> +
>> +	ret = may_checkpoint_task(ctx, task);
>> +	if (ret) {
>> +		ckpt_write_err(ctx, NULL);
>> +		put_task_struct(task);
>> +		put_task_struct(task);
>> +		put_nsproxy(nsproxy);
> 
> I don't think this is safe - the ckpt_ctx_free() will
> free them a second time because you're not setting them
> to NULL, right?

Yes. Fortunately this hole chunk is removed by the 3rd-next patch.
I'll make sure it's correct here too.

Thanks,

Oren.

