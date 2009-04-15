Return-Path: <linux-kernel-owner+w=401wt.eu-S1759508AbZDONHv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759508AbZDONHv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 09:07:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753025AbZDONHm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 09:07:42 -0400
Received: from mail-bw0-f169.google.com ([209.85.218.169]:48715 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751919AbZDONHk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 09:07:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=FGJFQv30PK0ODLnUGmwy/+oXaeAB/W3qQmAsrtQnAz35T6/aFwZEgGmZ/UAYAPa8PC
         /lZkrh1KZ1RNByN6Jq48mfIuVOdW4+TdweF/xFFMLhv3RoZMOdZOSqviIY3y16TZvuuY
         OjCtya3d5ue1+Y7xqU3dtaaBbaEV4ye998Ez8=
Date: Wed, 15 Apr 2009 15:07:33 +0200
From: Andrea Righi <righi.andrea@gmail.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Paul Menage <menage@google.com>, Balbir Singh <balbir@linux.vnet.ibm.com>,
       Gui Jianfeng <guijianfeng@cn.fujitsu.com>, agk@sourceware.org,
       akpm@linux-foundation.org, axboe@kernel.dk, baramsori72@gmail.com,
       Carl Henrik Lunde <chlunde@ping.uio.no>, dave@linux.vnet.ibm.com,
       Divyesh Shah <dpshah@google.com>, eric.rannaud@gmail.com,
       fernando@oss.ntt.co.jp, Hirokazu Takahashi <taka@valinux.co.jp>,
       Li Zefan <lizf@cn.fujitsu.com>, matt@bluehost.com,
       dradford@bluehost.com, ngupta@google.com, randy.dunlap@oracle.com,
       roberto@unbit.it, Ryo Tsuruta <ryov@valinux.co.jp>,
       Satoshi UCHIDA <s-uchida@ap.jp.nec.com>, subrata@linux.vnet.ibm.com,
       yoshikawa.takuya@oss.ntt.co.jp, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/9] bio-cgroup controller
Message-ID: <20090415130729.GA16735@linux>
Mail-Followup-To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
	Paul Menage <menage@google.com>,
	Balbir Singh <balbir@linux.vnet.ibm.com>,
	Gui Jianfeng <guijianfeng@cn.fujitsu.com>, agk@sourceware.org,
	akpm@linux-foundation.org, axboe@kernel.dk, baramsori72@gmail.com,
	Carl Henrik Lunde <chlunde@ping.uio.no>, dave@linux.vnet.ibm.com,
	Divyesh Shah <dpshah@google.com>, eric.rannaud@gmail.com,
	fernando@oss.ntt.co.jp, Hirokazu Takahashi <taka@valinux.co.jp>,
	Li Zefan <lizf@cn.fujitsu.com>, matt@bluehost.com,
	dradford@bluehost.com, ngupta@google.com, randy.dunlap@oracle.com,
	roberto@unbit.it, Ryo Tsuruta <ryov@valinux.co.jp>,
	Satoshi UCHIDA <s-uchida@ap.jp.nec.com>, subrata@linux.vnet.ibm.com,
	yoshikawa.takuya@oss.ntt.co.jp,
	containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
References: <1239740480-28125-1-git-send-email-righi.andrea@gmail.com> <1239740480-28125-4-git-send-email-righi.andrea@gmail.com> <20090415111528.b796519a.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090415111528.b796519a.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 15, 2009 at 11:15:28AM +0900, KAMEZAWA Hiroyuki wrote:
> > +/*
> > + * This function is used to make a given page have the bio-cgroup id of
> > + * the owner of this page.
> > + */
> > +void bio_cgroup_set_owner(struct page *page, struct mm_struct *mm)
> > +{
> > +	struct bio_cgroup *biog;
> > +	struct page_cgroup *pc;
> > +
> > +	if (bio_cgroup_disabled())
> > +		return;
> > +	pc = lookup_page_cgroup(page);
> > +	if (unlikely(!pc))
> > +		return;
> > +
> > +	pc->bio_cgroup_id = 0;	/* 0: default bio_cgroup id */
> > +	if (!mm)
> > +		return;
> > +	/*
> > +	 * Locking "pc" isn't necessary here since the current process is
> > +	 * the only one that can access the members related to bio_cgroup.
> > +	 */
> > +	rcu_read_lock();
> > +	biog = bio_cgroup_from_task(rcu_dereference(mm->owner));
> > +	if (unlikely(!biog))
> > +		goto out;
> > +	/*
> > +	 * css_get(&bio->css) isn't called to increment the reference
> > +	 * count of this bio_cgroup "biog" so pc->bio_cgroup_id might turn
> > +	 * invalid even if this page is still active.
> > +	 * This approach is chosen to minimize the overhead.
> > +	 */
> > +	pc->bio_cgroup_id = biog->id;
> > +out:
> > +	rcu_read_unlock();
> > +}
> > +
> > +/*
> > + * Change the owner of a given page if necessary.
> > + */
> > +void bio_cgroup_reset_owner(struct page *page, struct mm_struct *mm)
> > +{
> > +	/*
> > +	 * A little trick:
> > +	 * Just call bio_cgroup_set_owner() for pages which are already
> > +	 * active since the bio_cgroup_id member of page_cgroup can be
> > +	 * updated without any locks. This is because an integer type of
> > +	 * variable can be set a new value at once on modern cpus.
> > +	 */
> > +	bio_cgroup_set_owner(page, mm);
> > +}
> Hmm ? I think all operations are under lock_page() and there are no races.
> Isn't it ?

ehm.. no. Adding this in bio_cgroup_set_owner():

 WARN_ON_ONCE(!test_bit(PG_locked, &page->flags));

produces the following:

[    1.641186] WARNING: at mm/biotrack.c:77 bio_cgroup_set_owner+0xe2/0x100()
[    1.644534] Hardware name:
[    1.646955] Modules linked in:
[    1.650526] Pid: 1, comm: swapper Not tainted 2.6.30-rc2 #77
[    1.653499] Call Trace:
[    1.656004]  [<ffffffff80269370>] warn_slowpath+0xd0/0x120
[    1.659062]  [<ffffffff8023d69a>] ? save_stack_trace+0x2a/0x50
[    1.662357]  [<ffffffff80291f7f>] ? save_trace+0x3f/0xb0
[    1.670214]  [<ffffffff802e3abd>] ? handle_mm_fault+0x40d/0x8b0
[    1.673321]  [<ffffffff8029586b>] ? __lock_acquire+0x63b/0x1de0
[    1.676446]  [<ffffffff802921ba>] ? get_lock_stats+0x2a/0x60
[    1.679657]  [<ffffffff802921fe>] ? put_lock_stats+0xe/0x30
[    1.682673]  [<ffffffff802e3abd>] ? handle_mm_fault+0x40d/0x8b0
[    1.685706]  [<ffffffff80300e72>] bio_cgroup_set_owner+0xe2/0x100
[    1.688852]  [<ffffffff802e3abd>] ? handle_mm_fault+0x40d/0x8b0
[    1.692280]  [<ffffffff802e3ae2>] handle_mm_fault+0x432/0x8b0
[    1.695261]  [<ffffffff802e408f>] __get_user_pages+0x12f/0x430
[    1.703507]  [<ffffffff802e43c2>] get_user_pages+0x32/0x40
[    1.706947]  [<ffffffff80308bab>] get_arg_page+0x4b/0xb0
[    1.710287]  [<ffffffff80308e3d>] copy_strings+0xfd/0x200
[    1.714028]  [<ffffffff80308f69>] copy_strings_kernel+0x29/0x40
[    1.717058]  [<ffffffff8030a651>] do_execve+0x2c1/0x400
[    1.720291]  [<ffffffff8022d739>] sys_execve+0x49/0x80
[    1.723209]  [<ffffffff802300b8>] kernel_execve+0x68/0xd0
[    1.726309]  [<ffffffff8020930b>] ? init_post+0x18b/0x1b0
[    1.729585]  [<ffffffff80af069b>] kernel_init+0x198/0x1b0
[    1.735754]  [<ffffffff8023003a>] child_rip+0xa/0x20
[    1.738690]  [<ffffffff8022fa00>] ? restore_args+0x0/0x30
[    1.741663]  [<ffffffff80af0503>] ? kernel_init+0x0/0x1b0
[    1.744683]  [<ffffffff80230030>] ? child_rip+0x0/0x20
[    1.747820] ---[ end trace b9f530261e455c85 ]---

In do_anonymous_page(), bio_cgroup_set_owner() seems to be called
without lock_page() held.

-Andrea
