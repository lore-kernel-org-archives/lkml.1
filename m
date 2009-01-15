Return-Path: <linux-kernel-owner+w=401wt.eu-S1760135AbZAOEqS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760135AbZAOEqS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 23:46:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755325AbZAOEqB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 23:46:01 -0500
Received: from e28smtp05.in.ibm.com ([59.145.155.5]:35496 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755023AbZAOEqA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 23:46:00 -0500
Date: Thu, 15 Jan 2009 10:15:57 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Pavel Emelyanov <xemul@openvz.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Paul Menage <menage@google.com>
Subject: Re: [RFC][PATCH 5/4] memcg: don't call res_counter_uncharge when
	obsolete
Message-ID: <20090115044557.GG21516@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20090113184533.6ffd2af9.nishimura@mxp.nes.nec.co.jp> <20090114175121.275ecd59.nishimura@mxp.nes.nec.co.jp> <20090114135539.GA21516@balbir.in.ibm.com> <20090115122416.e15d88a7.kamezawa.hiroyu@jp.fujitsu.com> <20090115041750.GE21516@balbir.in.ibm.com> <20090115134114.dba6b83a.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20090115134114.dba6b83a.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2009-01-15 13:41:14]:

> On Thu, 15 Jan 2009 09:47:50 +0530
> Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> 
> > * KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2009-01-15 12:24:16]:
> 
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
> 
> There was a design choice at swap_cgroup.
> 
> At rmdir, there may be used swap entry in memcg. (mem->memsw.usage can be > 0)
>   1. update all records in swap cgroup
>   2. just ignore account from swap, we can treat then at swap-in.
> 
> I implemented "2" by refcnt.
> 
> To do "1", we have to scan all used swap_cgroup but I don't want to scan all
> swap_cgroup entry at rmdir. It's heavy job.
> (*) To reduce memory usage by swap_cgroup, swap_cgroup just have a pointer to memcg
> (**) I implemented swap_cgroup as statically allocated array because I don't want
>     any dynamic memory allocation at swap-out and want to avoid unnecessary memory
>     usage.

Fair enough, but I don't like that we don't have any checks for

If parent still has children, parent should not go away. The
problem that Daisuke-San is seeing.

-- 
	Balbir
