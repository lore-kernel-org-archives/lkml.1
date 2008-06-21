Return-Path: <linux-kernel-owner+w=401wt.eu-S1755300AbYFUJLg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755300AbYFUJLg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2008 05:11:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752659AbYFUJL1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jun 2008 05:11:27 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:41741 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752356AbYFUJL0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2008 05:11:26 -0400
Date: Sat, 21 Jun 2008 18:10:39 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: balbir@linux.vnet.ibm.com
Subject: Re: [PATCH] introduce task cgroup v2
Cc: kosaki.motohiro@jp.fujitsu.com, Paul Menage <menage@google.com>,
       Pavel Emelianov <xemul@openvz.org>, containers@lists.osdl.org,
       LKML <linux-kernel@vger.kernel.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <485CC255.9010504@linux.vnet.ibm.com>
References: <6599ad830806210056n44c7ff37g7cd643f95aef4aa0@mail.gmail.com> <485CC255.9010504@linux.vnet.ibm.com>
Message-Id: <20080621180530.E82D.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Bad performance on the charge/uncharge?
> > 
> > The only difference I can see is that res_counter uses
> > spin_lock_irqsave()/spin_unlock_irqrestore(), and you're using plain
> > spin_lock()/spin_unlock().
> > 
> > Is the overhead of a pushf/cli/popf really going to matter compared
> > with the overhead of forking/exiting a task?
> > 
> > Or approaching this from the other side, does res_counter really need
> > irq-safe locking, or is it just being cautious?
> 
> We really need irq-safe locking. We can end up uncharging from reclaim context
> (called under zone->lru_lock and mem->zone->lru_lock - held with interrupts
> disabled)
> 
> I am going to convert the spin lock to a reader writers lock, so that reads from
> user space do not cause contention. I'll experiment and look at the overhead.

Sorry, late responce.
I'm working on fix current -mm tree regression recently ;)

Note:

I am going to convert spinlock in task limit cgroup to atomic_t.
task limit cgroup has following caractatics.
	- many write (fork, exit)
	- few read 
	- fork() is performance sensitive systemcall.
	  if increase fork overhead, system total performance cause degression.



