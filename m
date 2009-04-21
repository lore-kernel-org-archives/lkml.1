Return-Path: <linux-kernel-owner+w=401wt.eu-S1756654AbZDUODo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756654AbZDUODo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 10:03:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752969AbZDUODf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 10:03:35 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:57248 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751542AbZDUODe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 10:03:34 -0400
Date: Tue, 21 Apr 2009 07:03:23 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Andrea Righi <righi.andrea@gmail.com>
Cc: Paul Menage <menage@google.com>, Balbir Singh <balbir@linux.vnet.ibm.com>,
       Gui Jianfeng <guijianfeng@cn.fujitsu.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, agk@sourceware.org,
       akpm@linux-foundation.org, axboe@kernel.dk, baramsori72@gmail.com,
       Carl Henrik Lunde <chlunde@ping.uio.no>, dave@linux.vnet.ibm.com,
       Divyesh Shah <dpshah@google.com>, eric.rannaud@gmail.com,
       fernando@oss.ntt.co.jp, Hirokazu Takahashi <taka@valinux.co.jp>,
       Li Zefan <lizf@cn.fujitsu.com>, matt@bluehost.com,
       dradford@bluehost.com, ngupta@google.com, randy.dunlap@oracle.com,
       roberto@unbit.it, Ryo Tsuruta <ryov@valinux.co.jp>,
       Satoshi UCHIDA <s-uchida@ap.jp.nec.com>, subrata@linux.vnet.ibm.com,
       yoshikawa.takuya@oss.ntt.co.jp, Nauman Rafique <nauman@google.com>,
       fchecconi@gmail.com, paolo.valente@unimore.it,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/7] io-throttle controller infrastructure
Message-ID: <20090421140323.GA6642@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1240090712-1058-1-git-send-email-righi.andrea@gmail.com> <1240090712-1058-5-git-send-email-righi.andrea@gmail.com> <20090420175904.GD6822@linux.vnet.ibm.com> <20090420212225.GA5819@linux> <20090421041524.GB6939@linux.vnet.ibm.com> <20090421125829.GD13699@linux>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090421125829.GD13699@linux>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 21, 2009 at 02:58:30PM +0200, Andrea Righi wrote:
> On Mon, Apr 20, 2009 at 09:15:24PM -0700, Paul E. McKenney wrote:
> > > > How does the above lock relate to the iot->lock called out in the comment
> > > > headers in the earlier functions?  Hmmm...  Come to think of it, I don't
> > > > see an acquisition of iot->lock anywhere.
> > > > 
> > > > So, what is the story here?
> > > 
> > > As said before, only the comment in struct iothrottle is correct, we use
> > > cgroup_lock() to protect iot->list, so there's no need to introduce
> > > another lock inside struct iothrottle.
> > > 
> > > And the other comments about iot->lock must be fixed.
> > 
> > Sounds good!
> > 
> > So this code is compiled into the kernel only when cgroups are defined,
> > correct?  Otherwise, cgroup_lock() seems to be an empty function.
> 
> Right, from init/Kconfig:
> 
> config CGROUP_IO_THROTTLE
>         bool "Enable cgroup I/O throttling"
>         depends on CGROUPS && RESOURCE_COUNTERS && EXPERIMENTAL
> ...

Fair enough!

> > > > > +int iothrottle_set_page_owner(struct page *page, struct mm_struct *mm)
> > > > > +{
> > > > > +	struct iothrottle *iot;
> > > > > +	unsigned short id = 0;
> > > > > +
> > > > > +	if (iothrottle_disabled())
> > > > > +		return 0;
> > > > > +	if (!mm)
> > > > > +		goto out;
> > > > > +	rcu_read_lock();
> > > > > +	iot = task_to_iothrottle(rcu_dereference(mm->owner));
> > > > 
> > > > Given that task_to_iothrottle() calls task_subsys_state(), which contains
> > > > an rcu_dereference(), why is the rcu_dereference() above required?
> > > > (There might well be a good reason, just cannot see it right offhand.)
> > > 
> > > The first rcu_dereference() is required to safely get a task_struct from
> > > mm_struct. The second rcu_dereference() inside task_to_iothrottle() is
> > > required to safely get the struct iothrottle from task_struct.
> > 
> > Why not put the rcu_dereference() down inside task_to_iothrottle()?
> 
> mmmh... it is needed only when task_struct is taken from mm->owner,
> task_to_iothrottle(current) for example works fine without the
> rcu_dereference(current).

OK...  But please note that rcu_dereference() is extremely lightweight,
a couple orders of magnitude cheaper than an uncontended lock.  So there
is almost no penalty for using it on the task_to_iothrottle() path.

							Thanx, Paul
