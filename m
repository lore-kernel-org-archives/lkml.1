Return-Path: <linux-kernel-owner+w=401wt.eu-S1752958AbZKIHgx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752958AbZKIHgx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 02:36:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752802AbZKIHgx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 02:36:53 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:44128 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752417AbZKIHgw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 02:36:52 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 9 Nov 2009 16:34:20 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: balbir@linux.vnet.ibm.com
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       cl@linux-foundation.org,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/2] memcg make use of new percpu implementations
Message-Id: <20091109163420.5a2fa803.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20091109070421.GD3042@balbir.in.ibm.com>
References: <20091106175242.6e13ee29.kamezawa.hiroyu@jp.fujitsu.com>
	<20091109070421.GD3042@balbir.in.ibm.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Nov 2009 12:34:21 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> * KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2009-11-06 17:52:42]:
> 
> > Hi,
> > 
> > Recent updates on dynamic percpu allocation looks good and I tries to rewrite
> > memcg's poor implementation of percpu status counter.
> > (It's not NUMA-aware ...)
> > Thanks for great works.
> > 
> > For this time. I added Christoph to CC because I'm not fully sure my usage of
> > __this_cpu_xxx is correct...I'm glad if you check the usage when you have time.
> > 
> > 
> > Patch 1/2 is just clean up (prepare for patch 2/2)
> > Patch 2/2 is for percpu.
> > 
> > Tested on my 8cpu box and works well.
> > Pathcesa are against the latest mmotm.
> 
> How do the test results look? DO you see a significant boost? 

Because my test enviroment is just an SMP (not NUMA), improvement will
not be siginificant (visible), I think.

But It's good to make use of recent updates of per_cpu implementation. We
can make use of offset calculation methods of them and one-instruction-access
macros. 

This is code size (PREEMPT=y)

[Before patch]
[kamezawa@bluextal mmotm-2.6.32-Nov2]$ size mm/memcontrol.o
   text    data     bss     dec     hex filename
  22403    3420    4132   29955    7503 mm/memcontrol.o

[After patch]
[kamezawa@bluextal mmotm-2.6.32-Nov2]$ size mm/memcontrol.o
   text    data     bss     dec     hex filename
  22188    3420    4132   29740    742c mm/memcontrol.o

Then, text size is surely reduced.

One example is mem_cgroup_swap_statistics(). This function is inlined
after this patch.

this code: mem_cgroup_uncharge_swap(), modifies percpu counter.
==
        memcg = mem_cgroup_lookup(id);
        if (memcg) {
                /*
                 * We uncharge this because swap is freed.
                 * This memcg can be obsolete one. We avoid calling css_tryget
                 */
                if (!mem_cgroup_is_root(memcg))
                        res_counter_uncharge(&memcg->memsw, PAGE_SIZE);
                mem_cgroup_swap_statistics(memcg, false);
                mem_cgroup_put(memcg);
        }
==


[before patch]
mem_cgroup_swap_statistics() is not inlined and uses 0x69 bytes.

0000000000001d30 <mem_cgroup_swap_statistics>:
    1d30:       push   %rbp
    1d31:       mov    %rsp,%rbp
    1d34:       push   %r12
<snip>
    1d88:       callq  1d8d <mem_cgroup_swap_statistics+0x5d>
    1d8d:       nopl   (%rax)
    1d90:       jmp    1d83 <mem_cgroup_swap_statistics+0x53>
    1d92:       nopw   %cs:0x0(%rax,%rax,1)
    1d99:       

[After patch] 
mem_cgroup_uncharge_swap()'s inlined code.

    3b67:       cmp    0x0(%rip),%rax        # 3b6e <mem_cgroup_uncharge_swap+0
xbe>
    3b6e:       je     3b81 <mem_cgroup_uncharge_swap+0xd1>   <=== check mem_cgroup_is_root
    3b70:       lea    0x90(%rax),%rdi
    3b77:       mov    $0x1000,%esi
    3b7c:       callq  3b81 <mem_cgroup_uncharge_swap+0xd1>  <===  calling res_counter_uncahrge()
    3b81:       48 89 df                mov    %rbx,%rdi
    3b84:       48 8b 83 70 01 00 00    mov    0x170(%rbx),%rax   <=== get offset of mem->cpustat
    3b8b:       65 48 83 40 30 ff       addq   $0xffffffffffffffff,%gs:0x30(%rax)  mem->cpustat.count[index]--;
    
    3b91:       e8 6a e0 ff ff          callq  1c00 <mem_cgroup_put>

This uses 2 instruction.

Then, code size reduction is enough large, I think.

>BTW, I've been experimenting a bit with the earlier percpu counter patches,
> I might post an iteration once I have some good results.
> 
Thank you, it's helpful.

Regards,
-Kame

