Return-Path: <linux-kernel-owner+w=401wt.eu-S1753997AbZDUM6r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753997AbZDUM6r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 08:58:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750970AbZDUM6h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 08:58:37 -0400
Received: from mail-bw0-f163.google.com ([209.85.218.163]:47384 "EHLO
	mail-bw0-f163.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750743AbZDUM6h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 08:58:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=P+LsbQLD7bQSiA3Dq/6oaKuiR1hLOli3fvpTuaNnqAwOU0Fyd0IMmISGI+gHd3r9a2
         LiLMD7KwGJF2wbErr+f8+UbiyrfifR2V7thh2dq5u64tTJQD3DLFnNG5PXS/5RnuyQCF
         zPLBVCs1VTHRqUS/LKdXBdUt4pa29Lk1U8PVc=
Date: Tue, 21 Apr 2009 14:58:30 +0200
From: Andrea Righi <righi.andrea@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
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
Message-ID: <20090421125829.GD13699@linux>
References: <1240090712-1058-1-git-send-email-righi.andrea@gmail.com> <1240090712-1058-5-git-send-email-righi.andrea@gmail.com> <20090420175904.GD6822@linux.vnet.ibm.com> <20090420212225.GA5819@linux> <20090421041524.GB6939@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090421041524.GB6939@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 20, 2009 at 09:15:24PM -0700, Paul E. McKenney wrote:
> > > How does the above lock relate to the iot->lock called out in the comment
> > > headers in the earlier functions?  Hmmm...  Come to think of it, I don't
> > > see an acquisition of iot->lock anywhere.
> > > 
> > > So, what is the story here?
> > 
> > As said before, only the comment in struct iothrottle is correct, we use
> > cgroup_lock() to protect iot->list, so there's no need to introduce
> > another lock inside struct iothrottle.
> > 
> > And the other comments about iot->lock must be fixed.
> 
> Sounds good!
> 
> So this code is compiled into the kernel only when cgroups are defined,
> correct?  Otherwise, cgroup_lock() seems to be an empty function.

Right, from init/Kconfig:

config CGROUP_IO_THROTTLE
        bool "Enable cgroup I/O throttling"
        depends on CGROUPS && RESOURCE_COUNTERS && EXPERIMENTAL
...

> > > > +int iothrottle_set_page_owner(struct page *page, struct mm_struct *mm)
> > > > +{
> > > > +	struct iothrottle *iot;
> > > > +	unsigned short id = 0;
> > > > +
> > > > +	if (iothrottle_disabled())
> > > > +		return 0;
> > > > +	if (!mm)
> > > > +		goto out;
> > > > +	rcu_read_lock();
> > > > +	iot = task_to_iothrottle(rcu_dereference(mm->owner));
> > > 
> > > Given that task_to_iothrottle() calls task_subsys_state(), which contains
> > > an rcu_dereference(), why is the rcu_dereference() above required?
> > > (There might well be a good reason, just cannot see it right offhand.)
> > 
> > The first rcu_dereference() is required to safely get a task_struct from
> > mm_struct. The second rcu_dereference() inside task_to_iothrottle() is
> > required to safely get the struct iothrottle from task_struct.
> 
> Why not put the rcu_dereference() down inside task_to_iothrottle()?
> 

mmmh... it is needed only when task_struct is taken from mm->owner,
task_to_iothrottle(current) for example works fine without the
rcu_dereference(current).

-Andrea
