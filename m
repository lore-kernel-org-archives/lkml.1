Return-Path: <linux-kernel-owner+w=401wt.eu-S1755533AbYKJOBX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755533AbYKJOBX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 09:01:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755004AbYKJOBO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 09:01:14 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:56109 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754304AbYKJOBO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 09:01:14 -0500
Date: Mon, 10 Nov 2008 08:00:46 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: akpm@linux-foundation.org, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org, takedakn@nttdata.co.jp,
       haradats@nttdata.co.jp
Subject: Re: [TOMOYO #12 (2.6.28-rc2-mm1) 06/11] Common functions for
	TOMOYOLinux.
Message-ID: <20081110140046.GA9954@us.ibm.com>
References: <20081104060847.086543472@nttdata.co.jp> <20081104060951.618445959@nttdata.co.jp> <20081105151221.d605226f.akpm@linux-foundation.org> <200811090138.GBG65138.FVOHOJOtMLQFFS@I-love.SAKURA.ne.jp> <20081110004131.GA25021@us.ibm.com> <200811100224.mAA2ORgv096549@www262.sakura.ne.jp> <20081110025245.GA28174@us.ibm.com> <200811100330.mAA3U1Q6012264@www262.sakura.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200811100330.mAA3U1Q6012264@www262.sakura.ne.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Tetsuo Handa (penguin-kernel@i-love.sakura.ne.jp):
> Hello.
> 
> Serge E. Hallyn wrote:
> > > I need to clarify reachability of "struct task_struct".
> > > 
> > > A process inside a virtualized environment cannot reach "struct task_struct"
> > > which belongs to outside the virtualized environment.
> > > 
> > > A process outside virtualized environments can reach "struct task_struct"
> > > which belongs to inside virtualized environments, can't it?
> > 
> > To be precise, there isn't a real 'inside' and 'outside' virtualized
> > environements.  Rather pid namespaces are hierarchical.
> > 
> So, processes which have non-topmost namespace cannot see processes which have
> topmost namespace (like chroot()).
> Then, it might be preferable if TOMOYO can prevent processes which have
> non-topmost namespace from modifying policy information.
> Do you think TOMOYO should do "current->nsproxy->pid_ns == &init_pid_ns"
> checking like below one?

Nah, I actually don't.  There is nothing to stop init or getty from
doing an unshare(CLONE_NEWNS|CLONE_NEWPID) so noone would be able to
make modifications.  The important thing is that the kernel won't
use another task than what userspace intended, so I think you're ok.

> static bool tomoyo_is_policy_manager(void)
> {
> 	struct tomoyo_policy_manager_entry *ptr;
> 	const char *exe;
> 	const struct task_struct *task = current;
> 	const struct tomoyo_path_info *domainname = tomoyo_domain()->domainname;
> 	bool found = false;
> 
> 	if (!tomoyo_policy_loaded)
> 	        return true;
> 	if (!tomoyo_manage_by_non_root && (task->cred->uid || task->cred->euid))

Now the point of LSM is to let you decide on your own policy, so this
is entirely up to you, but wouldn't it be nicer to use CAP_MAC_ADMIN's
presence like SMACK does?

> 	        return false;
> 	/* Don't allow modifying policy by processes not having init_pid_ns. */
> 	if (task->nsproxy->pid_ns != &init_pid_ns)
> 		return false;

No, I think it's far better to keep this out.  (Plus you'd have to use
task_nsproxy() under rcu_read_lock.)

I know at this point it might seem like I'm changing my mind left and
right (sorry), so here is the guiding principle:  pids are appropriate
for userspace to communicate to userspace and, if done right, to the
kernel.  But the kernel must not cache them internally.

(...and, if getting or sending them from/to user-space, must be careful
about the pidns, of course.)

So you're fine.

thanks,
-serge

