Return-Path: <linux-kernel-owner+w=401wt.eu-S1757650AbXEWEGc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757650AbXEWEGc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 00:06:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756017AbXEWEGX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 00:06:23 -0400
Received: from www.osadl.org ([213.239.205.134]:48880 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755961AbXEWEGX (ORCPT <rfc822;Linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 00:06:23 -0400
Subject: Re: LOCKDEP: possible irq lock inversion dependency detected
From: Thomas Gleixner <tglx@linutronix.de>
To: Sven-Thorsten Dietrich <sven@thebigcorporation.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <Linux-kernel@vger.kernel.org>
In-Reply-To: <1179879569.25500.74.camel@sx.thebigcorporation.com>
References: <1179879569.25500.74.camel@sx.thebigcorporation.com>
Content-Type: text/plain
Date: Wed, 23 May 2007 06:06:20 +0200
Message-Id: <1179893180.12708.145.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-05-22 at 17:19 -0700, Sven-Thorsten Dietrich wrote:
> swapper/1 just changed the state of lock:                                       
>  (rtc_lock#2){-...}, at: [<ffffffff8085b185>] sbf_init+0x25/0xe0                
> but this lock was taken by another, hard-irq-safe lock in the past:             
>  (xtime_lock){+...}                                                             
>                                                                                 
> and interrupts could create inverse lock ordering between them.                 
>                                                                                 
>                                                                                 
> other info that might help us debug this:                                       
> no locks held by swapper/1.                                                     
>                                                                                 
> the first lock's dependencies:                                                  
> -> (rtc_lock#2){-...} ops: 2 {                                                  
>    initial-use  at:                                                             
>                         [<ffffffff8025d383>] mark_lock+0xf3/0x5b0               
>                         [<ffffffff8025e6f4>] __lock_acquire+0x664/0xf80         
>                         [<ffffffff8025f098>] lock_acquire+0x88/0xc0             
>                         [<ffffffff8047e2c5>] rt_spin_lock+0x35/0x40             
>                         [<ffffffff8020e162>] read_persistent_clock+0x22/0x1b0   
>                         [<ffffffff80867e86>] timekeeping_init+0x86/0x100        
>                         [<ffffffff808537af>] start_kernel+0x1bf/0x350           
>                         [<ffffffff80853179>] _sinittext+0x179/0x180             
>                         [<ffffffffffffffff>] 0xffffffffffffffff 

Hmm. That's the code in question:

void __init timekeeping_init(void)                                                                                                                    
{                                                                                                                                                     
        unsigned long flags;                                                                                                                          
        unsigned long sec = read_persistent_clock();                                                                                                  
                                                                                                                                                      
        write_seqlock_irqsave(&xtime_lock, flags);  

The rtc_lock is never taken inside the xtime_lock.

Looks like code reordering due to gcc extra magic. Which compiler ? 	

Thanks,

	tglx


