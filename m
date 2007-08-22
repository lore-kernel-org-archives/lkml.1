Return-Path: <linux-kernel-owner+w=401wt.eu-S1765375AbXHVRKV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765375AbXHVRKV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 13:10:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762562AbXHVRKJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 13:10:09 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:30788 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762987AbXHVRKI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 13:10:08 -0400
Date: Wed, 22 Aug 2007 10:08:02 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Marcin Kowalczyk <qrczak@knm.org.pl>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] setpgid(child) fails if the child was forked by
 sub-thread
Message-Id: <20070822100802.c2c202f9.randy.dunlap@oracle.com>
In-Reply-To: <20070822165539.GA191@tv-sign.ru>
References: <bug-8921-10286@http.bugzilla.kernel.org/>
	<20070822082517.321edfa5.akpm@linux-foundation.org>
	<20070822165539.GA191@tv-sign.ru>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Aug 2007 20:55:39 +0400 Oleg Nesterov wrote:


so "fixes http://bugzilla.kernel.org/show_bug.cgi?id=8921"  ??


> Spotted by Marcin Kowalczyk <qrczak@knm.org.pl>.
> 
> sys_setpgid(child) fails if the child was forked by sub-thread.
> 
> Fix the "is it our child" check. The previous commit
> ee0acf90d320c29916ba8c5c1b2e908d81f5057d was not complete.
> 
> (this patch asks for the new same_thread_group() helper, but mainline doesn't
>  have it yet).
> 
> Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
> 
> --- t/kernel/sys.c~SETPGID	2007-08-09 19:59:27.000000000 +0400
> +++ t/kernel/sys.c	2007-08-22 20:11:23.000000000 +0400
> @@ -1442,7 +1442,6 @@ asmlinkage long sys_times(struct tms __u
>   * Auch. Had to add the 'did_exec' flag to conform completely to POSIX.
>   * LBT 04.03.94
>   */
> -
>  asmlinkage long sys_setpgid(pid_t pid, pid_t pgid)
>  {
>  	struct task_struct *p;
> @@ -1470,7 +1469,7 @@ asmlinkage long sys_setpgid(pid_t pid, p
>  	if (!thread_group_leader(p))
>  		goto out;
>  
> -	if (p->real_parent == group_leader) {
> +	if (p->real_parent->tgid == group_leader->tgid) {
>  		err = -EPERM;
>  		if (task_session(p) != task_session(group_leader))
>  			goto out;
> 
> -

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
