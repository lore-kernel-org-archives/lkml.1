Return-Path: <linux-kernel-owner+w=401wt.eu-S1759635AbZAOEmc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759635AbZAOEmc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 23:42:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755757AbZAOEmX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 23:42:23 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:37755 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755734AbZAOEmX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 23:42:23 -0500
Date: Thu, 15 Jan 2009 13:41:14 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: balbir@linux.vnet.ibm.com
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Pavel Emelyanov <xemul@openvz.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Paul Menage <menage@google.com>
Subject: Re: [RFC][PATCH 5/4] memcg: don't call res_counter_uncharge when
 obsolete
Message-Id: <20090115134114.dba6b83a.kamezawa.hiroyu@jp.fujitsu.com>
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

There was a design choice at swap_cgroup.

At rmdir, there may be used swap entry in memcg. (mem->memsw.usage can be > 0)
  1. update all records in swap cgroup
  2. just ignore account from swap, we can treat then at swap-in.

I implemented "2" by refcnt.

To do "1", we have to scan all used swap_cgroup but I don't want to scan all
swap_cgroup entry at rmdir. It's heavy job.
(*) To reduce memory usage by swap_cgroup, swap_cgroup just have a pointer to memcg
(**) I implemented swap_cgroup as statically allocated array because I don't want
    any dynamic memory allocation at swap-out and want to avoid unnecessary memory
    usage.

Thanks,
-Kame

