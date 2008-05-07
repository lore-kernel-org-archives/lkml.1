Return-Path: <linux-kernel-owner+w=401wt.eu-S1763833AbYEGHkj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763833AbYEGHkj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 03:40:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757296AbYEGHk3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 03:40:29 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:59691 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754664AbYEGHk1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 03:40:27 -0400
Date: Wed, 7 May 2008 16:45:26 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "Paul Menage" <menage@google.com>
Cc: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       "Li Zefan" <lizf@cn.fujitsu.com>
Subject: Re: [PATCH] mm/cgroup.c add error check
Message-Id: <20080507164526.884208f9.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <6599ad830805062208if98157cwaca4bafa01b8d097@mail.gmail.com>
References: <20080506195216.4A6D.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	<6599ad830805062208if98157cwaca4bafa01b8d097@mail.gmail.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 May 2008 22:08:08 -0700
"Paul Menage" <menage@google.com> wrote:

> On Tue, May 6, 2008 at 4:02 AM, KOSAKI Motohiro
> <kosaki.motohiro@jp.fujitsu.com> wrote:
> >
> >  on heavy workload, call_usermodehelper() may failure
> >  because it use kzmalloc(GFP_ATOMIC).
> >
> >  but userland want receive release notificcation even heavy workload.
> >
> >  thus, We should retry if -ENOMEM happend.
> >
> >
> >  Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> >  CC: "Paul Menage" <menage@google.com>
> >  CC: Li Zefan <lizf@cn.fujitsu.com>
> >
> >  ---
> >   kernel/cgroup.c |   10 +++++++++-
> >   1 file changed, 9 insertions(+), 1 deletion(-)
> >
> >  Index: b/kernel/cgroup.c
> >  ===================================================================
> >  --- a/kernel/cgroup.c   2008-04-29 18:00:53.000000000 +0900
> >  +++ b/kernel/cgroup.c   2008-05-06 20:28:23.000000000 +0900
> >  @@ -3072,6 +3072,8 @@ void __css_put(struct cgroup_subsys_stat
> >   */
> >   static void cgroup_release_agent(struct work_struct *work)
> >   {
> >  +       int err;
> >  +
> >         BUG_ON(work != &release_agent_work);
> >         mutex_lock(&cgroup_mutex);
> >         spin_lock(&release_list_lock);
> >  @@ -3111,7 +3113,13 @@ static void cgroup_release_agent(struct
> >                  * since the exec could involve hitting disk and hence
> >                  * be a slow process */
> >                 mutex_unlock(&cgroup_mutex);
> >  -               call_usermodehelper(argv[0], argv, envp, UMH_WAIT_EXEC);
> >  +
> >  +retry:
> >  +               err = call_usermodehelper(argv[0], argv, envp, UMH_WAIT_EXEC);
> >  +               if (err == -ENOMEM) {
> >  +                       schedule();
> >  +                       goto retry;
> >  +               }
> 
> I'm not sure that an infinite loop retry is a great idea. Assuming
> that call_usermodehelper() is changed to not use GFP_ATOMIC (which
> should be safe at least in the case when UMG_WAIT_EXEC is set, since
> we can clearly sleep in that case) then I'd be inclined not to check.
> If we're so low on memory that we can't fork/exec, then the helper
> binary itself could just as easily OOM as soon as we've launched it.
> So there's still no guarantee. Userspace should just have to check for
> empty cgroups occasionally even if they are using notify_on_release.
> 
Hmm, but It seems call_usermodehelper()'s fails in silent, no messages.
A notify which can be silently dropped is useless.
Can we add 'printk("notify_on_release: ... is failed")' or some workaround ?

Thanks,
-Kame



