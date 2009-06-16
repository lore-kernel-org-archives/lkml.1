Return-Path: <linux-kernel-owner+w=401wt.eu-S1757023AbZFPLwV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757023AbZFPLwV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 07:52:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753470AbZFPLwN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 07:52:13 -0400
Received: from mtagate8.de.ibm.com ([195.212.29.157]:53223 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754836AbZFPLwM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 07:52:12 -0400
Date: Tue, 16 Jun 2009 13:51:58 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: rusty@rustcorp.com.au, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] stop_cpu() needs to use raw_smp_processor_id()
Message-ID: <20090616115158.GB5548@osiris.boeblingen.de.ibm.com>
References: <20090616111941.GA3287@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090616111941.GA3287@in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 16, 2009 at 04:49:41PM +0530, Ananth N Mavinakayanahalli wrote:
> With DEBUG_PREEMPT on, on an s390 box, we are seeing:
> 
> BUG: using smp_processor_id() in preemptible [00000000] code: insmod/3006  
> caller is arch_arm_kprobe+0x2c/0x90                                        
> CPU: 0 Not tainted 2.6.30-rc8-tipjun10-02053-g39ae214 #7             
> Process insmod (pid: 3006, task: 000000007df31410, ksp: 000000007e087a28)  
> 	0000000000000000 000000007e087c38 0000000000000002 0000000000000000
> 	000000007e087cd8 000000007e087c50 000000007e087c50 0000000000048156 
> 	00000000003e4de8 000000000002b830 0000000000000000 0000000000000000 
> 	0000000000000000 000000007e087c38 ffffffff0000000d 000000007e087ca8 
> 	000000000040a780 000000000001635c 000000007e087c38 000000007e087c80 
> Call Trace:                                                                
> ([<00000000000162e6>] show_trace+0x13a/0x148)                              
>  [<00000000001f123a>] debug_smp_processor_id+0x136/0x13c                   
>  [<00000000003ddbd8>] arch_arm_kprobe+0x2c/0x90                            
>  [<00000000003df8cc>] register_kprobe+0x630/0x684                          
>  [<000003e000241056>] kprobe_init+0x56/0xa8 [kprobe_example]               
>  [<00000000000120c2>] do_one_initcall+0x3e/0x16c                           
>  [<000000000007cb4c>] SyS_init_module+0xc4/0x1fc                           
>  [<0000000000027f42>] sysc_noemu+0x10/0x16                                 
>  [<0000004a4493324e>] 0x4a4493324e           
> 
> Digging further this seems to be due to stop_cpu().
> 
> Shouldn't stop_cpu() be using raw_smp_processor_id()?
> 
> Signed-off-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
> ---
>  kernel/stop_machine.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: linux-2.6.30/kernel/stop_machine.c
> ===================================================================
> --- linux-2.6.30.orig/kernel/stop_machine.c
> +++ linux-2.6.30/kernel/stop_machine.c
> @@ -68,7 +68,7 @@ static void stop_cpu(struct work_struct 
>  {
>  	enum stopmachine_state curstate = STOPMACHINE_NONE;
>  	struct stop_machine_data *smdata = &idle;
> -	int cpu = smp_processor_id();
> +	int cpu = raw_smp_processor_id();
>  	int err;

Looks to me like your kernel was compiled with !CONFIG_SMP when you triggered
the warnung. Your patch however touches code that gets only compiled with
CONFIG_SMP enabled and it shouldn't be necessary.
I was unabled to reproduce this with Linus' git tree of today. Could you
try that one and send your kernel config?
Please ignore any alloc_bootmem() warnings you might see and also don't run
it with more than 2GB.

Thanks.
