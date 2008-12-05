Return-Path: <linux-kernel-owner+w=401wt.eu-S1758561AbYLEN10@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758561AbYLEN10 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 08:27:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752030AbYLEN1S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 08:27:18 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:48694 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751543AbYLEN1R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 08:27:17 -0500
Message-ID: <57801.10.75.179.61.1228483630.squirrel@webmail-b.css.fujitsu.com>
In-Reply-To: <20081205212450.574f498c.nishimura@mxp.nes.nec.co.jp>
References: <20081205212208.31d904e0.nishimura@mxp.nes.nec.co.jp>
    <20081205212450.574f498c.nishimura@mxp.nes.nec.co.jp>
Date: Fri, 5 Dec 2008 22:27:10 +0900 (JST)
Subject: Re: [RFC][PATCH -mmotm 3/4] memcg: avoid dead lock caused by 
     racebetween oom and cpuset_attach
From: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
To: "Daisuke Nishimura" <nishimura@mxp.nes.nec.co.jp>
Cc: "LKML" <linux-kernel@vger.kernel.org>, "linux-mm" <linux-mm@kvack.org>,
       "Balbir Singh" <balbir@linux.vnet.ibm.com>,
       "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>,
       "Pavel Emelyanov" <xemul@openvz.org>, "Li Zefan" <lizf@cn.fujitsu.com>,
       "Paul Menage" <menage@google.com>, nishimura@mxp.nes.nec.co.jp
User-Agent: SquirrelMail/1.4.3a
X-Mailer: SquirrelMail/1.4.3a
MIME-Version: 1.0
Content-Type: text/plain;charset=us-ascii
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daisuke Nishimura said:
> mpol_rebind_mm(), which can be called from cpuset_attach(), does
> down_write(mm->mmap_sem).
> This means down_write(mm->mmap_sem) can be called under cgroup_mutex.
>
> OTOH, page fault path does down_read(mm->mmap_sem) and calls
> mem_cgroup_try_charge_xxx(),
> which may eventually calls mem_cgroup_out_of_memory(). And
> mem_cgroup_out_of_memory()
> calls cgroup_lock().
> This means cgroup_lock() can be called under down_read(mm->mmap_sem).
>
good catch.

> If those two paths race, dead lock can happen.
>
> This patch avoid this dead lock by:
>   - remove cgroup_lock() from mem_cgroup_out_of_memory().
agree to this.

>   - define new mutex (memcg_tasklist) and serialize mem_cgroup_move_task()
>     (->attach handler of memory cgroup) and mem_cgroup_out_of_memory.
>
Hmm...seems temporal fix (and adding new global lock...)
But ok, we need fix. revist this later.

Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu,com>


