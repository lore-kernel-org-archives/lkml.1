Return-Path: <linux-kernel-owner+w=401wt.eu-S1754309AbYKJDal@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754309AbYKJDal (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2008 22:30:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752813AbYKJDaa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Nov 2008 22:30:30 -0500
Received: from www262.sakura.ne.jp ([202.181.97.72]:61065 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752501AbYKJDaa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2008 22:30:30 -0500
Message-Id: <200811100330.mAA3U1Q6012264@www262.sakura.ne.jp>
Subject: Re: [TOMOYO #12 (2.6.28-rc2-mm1) 06/11] Common functions for TOMOYOLinux.
From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
To: serue@us.ibm.com
Cc: akpm@linux-foundation.org, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org, takedakn@nttdata.co.jp,
       haradats@nttdata.co.jp, penguin-kernel@i-love.sakura.ne.jp
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Date: Mon, 10 Nov 2008 12:30:01 +0900
References: <20081104060847.086543472@nttdata.co.jp> <20081104060951.618445959@nttdata.co.jp> <20081105151221.d605226f.akpm@linux-foundation.org> <200811090138.GBG65138.FVOHOJOtMLQFFS@I-love.SAKURA.ne.jp> <20081110004131.GA25021@us.ibm.com> <200811100224.mAA2ORgv096549@www262.sakura.ne.jp> <20081110025245.GA28174@us.ibm.com>
In-Reply-To: <20081110025245.GA28174@us.ibm.com>
Content-Type: text/plain; charset="ISO-2022-JP"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Serge E. Hallyn wrote:
> > I need to clarify reachability of "struct task_struct".
> > 
> > A process inside a virtualized environment cannot reach "struct task_struct"
> > which belongs to outside the virtualized environment.
> > 
> > A process outside virtualized environments can reach "struct task_struct"
> > which belongs to inside virtualized environments, can't it?
> 
> To be precise, there isn't a real 'inside' and 'outside' virtualized
> environements.  Rather pid namespaces are hierarchical.
> 
So, processes which have non-topmost namespace cannot see processes which have
topmost namespace (like chroot()).
Then, it might be preferable if TOMOYO can prevent processes which have
non-topmost namespace from modifying policy information.
Do you think TOMOYO should do "current->nsproxy->pid_ns == &init_pid_ns"
checking like below one?

static bool tomoyo_is_policy_manager(void)
{
	struct tomoyo_policy_manager_entry *ptr;
	const char *exe;
	const struct task_struct *task = current;
	const struct tomoyo_path_info *domainname = tomoyo_domain()->domainname;
	bool found = false;

	if (!tomoyo_policy_loaded)
	        return true;
	if (!tomoyo_manage_by_non_root && (task->cred->uid || task->cred->euid))
	        return false;
	/* Don't allow modifying policy by processes not having init_pid_ns. */
	if (task->nsproxy->pid_ns != &init_pid_ns)
		return false;
	list1_for_each_entry(ptr, &tomoyo_policy_manager_list, list) {
		if (!ptr->is_deleted && ptr->is_domain
		    && !tomoyo_pathcmp(domainname, ptr->manager))
			return true;
	}

> (Taking another look) it looks like In is_select_one() you're doing the
> right thing - you look up the domain of a task based on
> find_task_by_vpid() on a passed-in pid.  Seems correct.
> 
I see, thanks.
