Return-Path: <linux-kernel-owner+w=401wt.eu-S1755529AbZFVJML@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755529AbZFVJML (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 05:12:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754046AbZFVJL6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 05:11:58 -0400
Received: from mtagate7.de.ibm.com ([195.212.29.156]:55164 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753897AbZFVJL5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 05:11:57 -0400
Date: Mon, 22 Jun 2009 11:11:58 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Maran <maranp@linux.vnet.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>, rusty@rustcorp.com.au,
       lkml <linux-kernel@vger.kernel.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [PATCH] stop_cpu() needs to use raw_smp_processor_id()
Message-ID: <20090622091158.GB4940@osiris.boeblingen.de.ibm.com>
References: <20090616111941.GA3287@in.ibm.com> <20090616115158.GB5548@osiris.boeblingen.de.ibm.com> <4A3894E4.5060907@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A3894E4.5060907@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 17, 2009 at 12:31:56PM +0530, Maran wrote:
> Heiko Carstens wrote:
>> On Tue, Jun 16, 2009 at 04:49:41PM +0530, Ananth N Mavinakayanahalli wrote:
>>   
>>> With DEBUG_PREEMPT on, on an s390 box, we are seeing:
>>>
>>> BUG: using smp_processor_id() in preemptible [00000000] code: 
>>> insmod/3006  caller is arch_arm_kprobe+0x2c/0x90                      
>>>                   CPU: 0 Not tainted 
>>> 2.6.30-rc8-tipjun10-02053-g39ae214 #7             Process insmod 
>>> (pid: 3006, task: 000000007df31410, ksp: 000000007e087a28)   
>>> 	0000000000000000 000000007e087c38 0000000000000002 0000000000000000
>>> 	000000007e087cd8 000000007e087c50 000000007e087c50 0000000000048156  
>>> 	00000000003e4de8 000000000002b830 0000000000000000 0000000000000000  
>>> 	0000000000000000 000000007e087c38 ffffffff0000000d 000000007e087ca8  
>>> 	000000000040a780 000000000001635c 000000007e087c38 000000007e087c80  
>>> Call Trace:                                                           
>>>      ([<00000000000162e6>] show_trace+0x13a/0x148)                    
>>>            [<00000000001f123a>] debug_smp_processor_id+0x136/0x13c    
>>>                 [<00000000003ddbd8>] arch_arm_kprobe+0x2c/0x90        
>>>                      [<00000000003df8cc>] register_kprobe+0x630/0x684 
>>>                           [<000003e000241056>] kprobe_init+0x56/0xa8 
>>> [kprobe_example]                [<00000000000120c2>] 
>>> do_one_initcall+0x3e/0x16c                            
>>> [<000000000007cb4c>] SyS_init_module+0xc4/0x1fc                       
>>>      [<0000000000027f42>] sysc_noemu+0x10/0x16                        
>>>           [<0000004a4493324e>] 0x4a4493324e           
>>>
> With the current linus tree (git 10), kprobe breaks. Even smoke tests  
> are failed in s390x box.
> With 2.6.30, the same warning is raised even with CONFIG_SMP enabled. I  
> have pasted the config file used.

How about the patch below? Works for me. modprobe kprobe_example and the
kprobes selftest work for me.

Subject: [PATCH] kprobes: defer setting of ctlblk state

From: Heiko Carstens <heiko.carstens@de.ibm.com>

get_krobe_ctlblk returns a per cpu kprobe control block which holds
the state of the current cpu wrt to kprobe.
When inserting/removing a kprobe the state of the cpu which replaces
the code is changed to KPROBE_SWAP_INST. This however is done when
preemption is still enabled. So the state of the current cpu doesn't
necessarily reflect the real state.
To fix this move the code that changes the state to non-preemptible
context.

Reported-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 arch/s390/kernel/kprobes.c |   18 +++++++-----------
 1 file changed, 7 insertions(+), 11 deletions(-)

Index: linux-2.6/arch/s390/kernel/kprobes.c
===================================================================
--- linux-2.6.orig/arch/s390/kernel/kprobes.c
+++ linux-2.6/arch/s390/kernel/kprobes.c
@@ -154,39 +154,35 @@ void __kprobes get_instruction_type(stru
 
 static int __kprobes swap_instruction(void *aref)
 {
+	struct kprobe_ctlblk *kcb = get_kprobe_ctlblk();
+	unsigned long status = kcb->kprobe_status;
 	struct ins_replace_args *args = aref;
+	int rc;
 
-	return probe_kernel_write(args->ptr, &args->new, sizeof(args->new));
+	kcb->kprobe_status = KPROBE_SWAP_INST;
+	rc = probe_kernel_write(args->ptr, &args->new, sizeof(args->new));
+	kcb->kprobe_status = status;
+	return rc;
 }
 
 void __kprobes arch_arm_kprobe(struct kprobe *p)
 {
-	struct kprobe_ctlblk *kcb = get_kprobe_ctlblk();
-	unsigned long status = kcb->kprobe_status;
 	struct ins_replace_args args;
 
 	args.ptr = p->addr;
 	args.old = p->opcode;
 	args.new = BREAKPOINT_INSTRUCTION;
-
-	kcb->kprobe_status = KPROBE_SWAP_INST;
 	stop_machine(swap_instruction, &args, NULL);
-	kcb->kprobe_status = status;
 }
 
 void __kprobes arch_disarm_kprobe(struct kprobe *p)
 {
-	struct kprobe_ctlblk *kcb = get_kprobe_ctlblk();
-	unsigned long status = kcb->kprobe_status;
 	struct ins_replace_args args;
 
 	args.ptr = p->addr;
 	args.old = BREAKPOINT_INSTRUCTION;
 	args.new = p->opcode;
-
-	kcb->kprobe_status = KPROBE_SWAP_INST;
 	stop_machine(swap_instruction, &args, NULL);
-	kcb->kprobe_status = status;
 }
 
 void __kprobes arch_remove_kprobe(struct kprobe *p)
