Return-Path: <linux-kernel-owner+w=401wt.eu-S1758283AbZAOFZg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758283AbZAOFZg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 00:25:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751278AbZAOFZR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 00:25:17 -0500
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:38153 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750915AbZAOFZQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 00:25:16 -0500
Date: Thu, 15 Jan 2009 10:47:17 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Pavel Emelyanov <xemul@openvz.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Paul Menage <menage@google.com>
Subject: Re: [RFC][PATCH 5/4] memcg: don't call res_counter_uncharge when
	obsolete
Message-ID: <20090115051717.GH21516@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20090113184533.6ffd2af9.nishimura@mxp.nes.nec.co.jp> <20090114175121.275ecd59.nishimura@mxp.nes.nec.co.jp> <20090114135539.GA21516@balbir.in.ibm.com> <20090115122416.e15d88a7.kamezawa.hiroyu@jp.fujitsu.com> <20090115041750.GE21516@balbir.in.ibm.com> <20090115135223.1789e639.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20090115135223.1789e639.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2009-01-15 13:52:23]:

> On Thu, 15 Jan 2009 09:47:50 +0530
> Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> 
> > * KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2009-01-15 12:24:16]:
> > 
> > > On Wed, 14 Jan 2009 19:25:39 +0530
> > > Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> > > 
> > > > * Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp> [2009-01-14 17:51:21]:
> > > > 
> > > > > This is a new one. Please review.
> > > > > 
> > > > > ===
> > > > > From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
> > > > > 
> > > > > mem_cgroup_get ensures that the memcg that has been got can be accessed
> > > > > even after the directory has been removed, but it doesn't ensure that parents
> > > > > of it can be accessed: parents might have been freed already by rmdir.
> > > > > 
> > > > > This causes a bug in case of use_hierarchy==1, because res_counter_uncharge
> > > > > climb up the tree.
> > > > > 
> > > > > Check if the memcg is obsolete, and don't call res_counter_uncharge when obsole.
> > > > > 
> > > > > Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
> > > > 
> > > > I liked the earlier, EBUSY approach that ensured that parents could
> > > > not go away if children exist. IMHO, the code has gotten too complex
> > > > and has too many corner cases. Time to revisit it.
> > > > 
> > > 
> > > But I don't like -EBUSY ;)
> > > 
> > > When rmdir() returns -EBUSY even if there are no (visible) children and tasks,
> > > our customer will take kdump and send it to me "please explain this kernel bug"
> > > 
> > > I'm sure it will happen ;)
> > >
> > 
> > OK, but memory.stat can show why the group is busy and with
> > move_to_parent() such issues should not occur right? I'll relook at
> > the code. Thanks for your input.
> > 
> Write a shell script as following ?
> ==
>   TASKS=`cat /xxx/xxx/xxx/tasks`
>   if [ -n $TASKS ]; then
> 	echo "there is alive tasks in group /xxx/xxx/xxx/"
>   fi
>   
>   rmdir /xxx/xxx/xxx/
>   CODE=$?
>   if [ $CODE = EBUSY ]; then
> 	investigate why....
>   fi
> ==
> I don't want.
> 

I agree with that.

> I think rmdir() should succeed everywhen "there are no tasks and children".
> And that can be done.
>

All I am saying is that let rmdir() fail if there are tasks or
children, which I suspect cgroup takes care of. The second thing to do would
be to add a mem_cgroup_get_hierarchical() and _put_hierarchical() API's so
that we can get references all the way up to the parents. My concern
is that not calling res_counter_uncharge() can lead to dangling
references and bad behaviour.
 
> With Paul's suggestion, I'll add wait_queue for rmdir of cgroup.
> 

That might be a good idea and also a good idea to maintain the
hierarchy (since we will walk up when we do uncharge) until we know
that css reference count is down to 0.

-- 
	Balbir
