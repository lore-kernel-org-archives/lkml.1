Return-Path: <linux-kernel-owner+w=401wt.eu-S1754589AbYLBKkn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754589AbYLBKkn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 05:40:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754513AbYLBKkS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 05:40:18 -0500
Received: from wine.ocn.ne.jp ([122.1.235.145]:57818 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753284AbYLBKkQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 05:40:16 -0500
To: sds@tycho.nsa.gov
Cc: akpm@linux-foundation.org, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org, dhowells@redhat.com, jmorris@namei.org,
       takedakn@nttdata.co.jp, haradats@nttdata.co.jp,
       penguin-kernel@I-love.SAKURA.ne.jp
Subject: Re: [TOMOYO #13 (mmotm 2008-11-19-02-19) 09/11] LSM adapter functions.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <20081120112543.799450455@I-love.SAKURA.ne.jp>
	<20081120112735.226630772@I-love.SAKURA.ne.jp>
	<1228162257.18720.220.camel@moss-spartans.epoch.ncsc.mil>
In-Reply-To: <1228162257.18720.220.camel@moss-spartans.epoch.ncsc.mil>
Message-Id: <200812021940.BBD43761.FLQtMOHJFSVOOF@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.50 PL2]
X-Accept-Language: ja,en
Date: Tue, 2 Dec 2008 19:40:14 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Stephen Smalley wrote:
> > Removal of security_task_alloc() and security_task_free() by introduction of
> > COW credentials will become a nightmare when TOMOYO tries to add "u32".
> > Of cource, if TOMOYO is allowed to add "u32" to "struct task_struct",
> > COW credentials won't become a nightmare.
> 
> Can you explain exactly how you are using this per-task state and why it
> is a problem to create a new cred in the situations where you need to
> modify it?  I think that this issue needs to be addressed up front.
> 
Use of COW credentials saves memory usage as long as per-task variable doesn't
change, but creating a new cred after fork() introduces new error paths
(i.e. memory allocation failure) when per-task variable changes, and COW
credentials will no longer save memory if per-task variable differs each other.

I use this per-task variable for tracking and restricting access requests
issued by a process.
http://tomoyo.sourceforge.jp/cgi-bin/lxr/source/fs/tomoyo_audit.c#L284
TOMOYO (version 1.6.x) provides "ability to change what request a process can
issue without involving execve()" according to "requests that process issued in
the past".
It is similar to AppArmor's chhat(), but it is done by the kernel and it is
done without modifying userland programs.

I use this per-task variable for remembering "whether the process is allowed to
modify policy or not". Since "the pathname of a program which is allowed to
modify policy" can be changed by package manager (e.g. "rpm" and "dpkg"),
I have to remember "whether the process ever had a pathname which is allowed to
modify policy or not".
http://tomoyo.sourceforge.jp/cgi-bin/lxr/source/fs/ccs_common.c#L1420
http://tomoyo.sourceforge.jp/cgi-bin/lxr/source/fs/tomoyo_domain.c#L1700

I use this per-task variable for holding "type of the process".
TOMOYO (version 1.6.x) provides "ability to record/verify/modify parameters
passed to execve()" by executing a userland helper instead of a program
passed to execve().
http://tomoyo.sourceforge.jp/cgi-bin/lxr/source/fs/tomoyo_domain.c#L1736

And maybe more in future.
Worrying about memory allocation failure complicates things. Thus I want to
allocate memory on fork() and not after fork(). For that purpose, directly
assigning "u32" to "struct task_struct" is preferable over allocating on
demand.

Regards.
