Return-Path: <linux-kernel-owner+w=401wt.eu-S1759220AbZAOExk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759220AbZAOExk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 23:53:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754374AbZAOExb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 23:53:31 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:38483 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753343AbZAOExb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 23:53:31 -0500
Date: Thu, 15 Jan 2009 13:52:23 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: balbir@linux.vnet.ibm.com
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Pavel Emelyanov <xemul@openvz.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Paul Menage <menage@google.com>
Subject: Re: [RFC][PATCH 5/4] memcg: don't call res_counter_uncharge when
 obsolete
Message-Id: <20090115135223.1789e639.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090115041750.GE21516@balbir.in.ibm.com>
References: <20090113184533.6ffd2af9.nishimura@mxp.nes.nec.co.jp>
	<20090114175121.275ecd59.nishimura@mxp.nes.nec.co.jp>
	<20090114135539.GA21516@balbir.in.ibm.com>
	<20090115122416.e15d88a7.kamezawa.hiroyu@jp.fujitsu.com>
	<20090115041750.GE21516@balbir.in.ibm.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Jan 2009 09:47:50 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> * KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2009-01-15 12:24:16]:
> 
> > On Wed, 14 Jan 2009 19:25:39 +0530
> > Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> > 
> > > * Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp> [2009-01-14 17:51:21]:
> > > 
> > > > This is a new one. Please review.
> > > > 
> > > > ===
> > > > From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
> > > > 
> > > > mem_cgroup_get ensures that the memcg that has been got can be accessed
> > > > even after the directory has been removed, but it doesn't ensure that parents
> > > > of it can be accessed: parents might have been freed already by rmdir.
> > > > 
> > > > This causes a bug in case of use_hierarchy==1, because res_counter_uncharge
> > > > climb up the tree.
> > > > 
> > > > Check if the memcg is obsolete, and don't call res_counter_uncharge when obsole.
> > > > 
> > > > Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
> > > 
> > > I liked the earlier, EBUSY approach that ensured that parents could
> > > not go away if children exist. IMHO, the code has gotten too complex
> > > and has too many corner cases. Time to revisit it.
> > > 
> > 
> > But I don't like -EBUSY ;)
> > 
> > When rmdir() returns -EBUSY even if there are no (visible) children and tasks,
> > our customer will take kdump and send it to me "please explain this kernel bug"
> > 
> > I'm sure it will happen ;)
> >
> 
> OK, but memory.stat can show why the group is busy and with
> move_to_parent() such issues should not occur right? I'll relook at
> the code. Thanks for your input.
> 
Write a shell script as following ?
==
  TASKS=`cat /xxx/xxx/xxx/tasks`
  if [ -n $TASKS ]; then
	echo "there is alive tasks in group /xxx/xxx/xxx/"
  fi
  
  rmdir /xxx/xxx/xxx/
  CODE=$?
  if [ $CODE = EBUSY ]; then
	investigate why....
  fi
==
I don't want.

I think rmdir() should succeed everywhen "there are no tasks and children".
And that can be done.

With Paul's suggestion, I'll add wait_queue for rmdir of cgroup.

-Kame

