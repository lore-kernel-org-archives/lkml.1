Return-Path: <linux-kernel-owner+w=401wt.eu-S1751568AbZI2LCu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751568AbZI2LCu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 07:02:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750859AbZI2LCu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 07:02:50 -0400
Received: from mtagate1.de.ibm.com ([195.212.17.161]:39270 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750699AbZI2LCt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 07:02:49 -0400
From: Christian Borntraeger <borntraeger@de.ibm.com>
Organization: IBM
To: Amit Shah <amit.shah@redhat.com>
Subject: Re: [PATCH] virtio_console: Add support for multiple ports for generic guest and host communication
Date: Tue, 29 Sep 2009 13:02:51 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31-release; KDE/4.3.1; i686; ; )
Cc: Rusty Russell <rusty@rustcorp.com.au>, Alan Cox <alan@linux.intel.com>,
       virtualization@lists.linux-foundation.org, linux-kernel@vger.kernel.org
References: <1252678386-17404-1-git-send-email-amit.shah@redhat.com> <200909291209.25775.borntraeger@de.ibm.com> <20090929103354.GA3766@amit-x200.redhat.com>
In-Reply-To: <20090929103354.GA3766@amit-x200.redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200909291302.51432.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag 29 September 2009 12:33:54 schrieben Sie:
> I've tested old qemu new kernel, new qemu old kernel, new qemu, new
> kernel and all the cases work fine.

The patch breaks at least s390 causing the following oops.

    <0>------------[ cut here ]------------                                                                       
    <2>Kernel BUG at 000000000087d902 [verbose debug info unavailable]                                            
    <4>illegal operation: 0001 [#1] SMP                                                                           
    <4>Modules linked in:                                                                                         
    <4>CPU: 0 Not tainted 2.6.31-selfgit-08936-g851b147-dirty #137                                                
    <4>Process swapper (pid: 1, task: 000000000c6de758, ksp: 000000000c6e3838)                                    
    <4>Krnl PSW : 0404200180000000 000000000087d902 (early_put_chars+0x6/0x98)                                    
    <4>           R:0 T:1 IO:0 EX:0 Key:0 M:1 W:0 P:0 AS:0 CC:2 PM:0 EA:3                                         
    <4>Krnl GPRS: 0000000000000007 000000000087d8fc 0000000000000000 000000000c6e3c68                             
    <4>           0000000000000010 0000000000834408 0000000000000000 0000000000000000                             
    <4>           000000000c6e3c68 0000000000000000 0000000000000010 000000000000001a                             
    <4>           0000000000000010 0000000000558848 00000000003b6b32 000000000c6e3bc0                             
    <4>Krnl Code:>000000000087d902: cccccccccccc        unknown                                                   
    <4>           000000000087d908: cccccccccccc        unknown                                                   
    <4>           000000000087d90e: cccccccccccc        unknown                                                   
    <4>           000000000087d914: cccccccccccc        unknown                                                   
    <4>           000000000087d91a: cccccccccccc        unknown                                                   
    <4>Call Trace:                                                                                                
    <4>([<000000000c6e3cc8>] 0xc6e3cc8)                                                                           
    <4> [<000000000013f7cc>] __call_console_drivers+0xcc/0xe8                                                     
    <4> [<000000000013fdfa>] release_console_sem+0x1e2/0x29c                                                      
    <4> [<0000000000140606>] vprintk+0x316/0x498                                                                  
    <4> [<000000000051a846>] printk+0x52/0x64                                                                     
    <4> [<0000000000100240>] init_post+0x28/0x1a4                                                                 
    <4> [<000000000085a48e>] kernel_init+0x2d2/0x3b4                                                              
    <4> [<000000000010a212>] kernel_thread_starter+0x6/0xc                                                        
    <4> [<000000000010a20c>] kernel_thread_starter+0x0/0xc                                                        
    <4>Last Breaking-Event-Address:                                                                               
    <4> [<00000000003b6b30>] hvc_console_print+0x8c/0x12c                                                         
    <4>                                                                                                           
    <4>---[ end trace 1e5e8c448b0f2e2b ]--- 


I took a dump and had a look. It looks that this message thing is indeed not
the problem. Our early_put_chars method was marked as __init and the old code
replaced the put_chars method quickly enough to never make a problem.
Removing the __init from early_put_chars solved this kernel bug, but the tty
performance is now horribly slow. I will test, if the put_chars method is
replaced at all.

Christian


