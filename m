Return-Path: <linux-kernel-owner+w=401wt.eu-S1757776AbZJLSmR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757776AbZJLSmR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 14:42:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757667AbZJLSmQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 14:42:16 -0400
Received: from mga02.intel.com ([134.134.136.20]:48894 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757653AbZJLSmP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 14:42:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,547,1249282800"; 
   d="scan'208";a="456758923"
MIME-Version: 1.0
From: "Brandeburg, Jesse" <jesse.brandeburg@intel.com>
To: Tejun Heo <tj@kernel.org>
CC: Jesse Brandeburg <jesse.brandeburg@gmail.com>,
       Frans Pop <elendil@planet.nl>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, "hpa@zytor.com" <hpa@zytor.com>
Date: Mon, 12 Oct 2009 11:00:33 -0700
Subject: Re: bisect results of MSI-X related panic (help!)
Thread-Topic: bisect results of MSI-X related panic (help!)
Message-ID: <alpine.WNT.2.00.0910120907170.11804@jbrandeb-mobl2.amr.corp.intel.com>
References: <1252699744.3877.15.camel@jbrandeb-hc.jf.intel.com>
  <200909120623.49764.elendil@planet.nl> <4AAE0F7B.5050203@kernel.org>
  <4AAE105E.1080005@kernel.org>
 <4807377b0910091724k2a332e90i9941971f6032663c@mail.gmail.com>
 <4AD2E05A.6060700@kernel.org>
In-Reply-To: <4AD2E05A.6060700@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Alpine 2.00 (WNT 1167 2008-08-23)
x-x-sender: amrjbrandeb@imapmail.glb.intel.com
replyto: "Brandeburg, Jesse" <jesse.brandeburg@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Oct 2009, Tejun Heo wrote:
> > any other debugging tricks/ideas?
> 
> Hmm... stackprotector adds considerable amount of stack usage and it
> could be you're seeing stack overflow which would also explain the
> random crashes you've been seeing.  Do you have DEBUG_STACKOVERFLOW
> turned on?  This is on x86_64, right?

Hi, thanks for your response, 

[root@jbrandeb-hc linux-2.6.32-rc1]# grep STACKO .config
CONFIG_DEBUG_STACKOVERFLOW=y

[root@jbrandeb-hc linux-2.6.32-rc1]# grep X86_64 .config
CONFIG_X86_64=y
CONFIG_X86_64_SMP=y
CONFIG_X86_64_ACPI_NUMA=y

stack size is 8K

I tried Jarek's suggestion of CPUMASK_OFFSTACK and still panic.
[66027.266057] Kernel panic - not syncing: stack-protector: Kernel stack 
is corrupted in: ffffffff810b4eb0
[66027.266059]
[66027.266070] Kernel panic - not syncing: stack-protector: Kernel stack 
is corrupted in: ffffffff81472856
[66027.266071]
[66027.266081] Pid: 0, comm: swapper Tainted: G        W  
2.6.32-rc2-git-debug #6
[66027.266086] Call Trace:

that was all I got.  Interesting double fault, that hadn't happened 
before.

the symbols might be off slightly since I rebuilt the kernel, but this was 
initial poke at offsets above in gdb
(gdb) l *0xffffffff810b4eb0
0xffffffff810b4eb0 is in dynamic_irq_cleanup (kernel/irq/chip.c:86).
81              desc->handle_irq = handle_bad_irq;
82              desc->chip = &no_irq_chip;
83              desc->name = NULL;
84              clear_kstat_irqs(desc);
85              spin_unlock_irqrestore(&desc->lock, flags);
86      }
87
88
89      /**
90       *      set_irq_chip - set the irq chip for an irq
(gdb) l *0xffffffff8147285
No source file for address 0xffffffff8147285.
(gdb) l *0xffffffff81472856
0xffffffff81472856 is in show_kprobe_addr (kernel/kprobes.c:1306).
1301            struct hlist_head *head;
1302            struct hlist_node *node;
1303            struct kprobe *p, *kp;
1304            const char *sym = NULL;
1305            unsigned int i = *(loff_t *) v;
1306            unsigned long offset = 0;
1307            char *modname, namebuf[128];
1308
1309            head = &kprobe_table[i];
1310            preempt_disable();


