Return-Path: <linux-kernel-owner+w=401wt.eu-S932385AbXH2VxE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932385AbXH2VxE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 17:53:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755016AbXH2Vwy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 17:52:54 -0400
Received: from fk-out-0910.google.com ([209.85.128.185]:34326 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751142AbXH2Vwx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 17:52:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=h/gBW7X//ayBuMyEUXtVD7NsG8h0RvqMGUJrJXDXxdN2tXp/BVRcgmDXTMbEqAf0ka15AeeD70p1nLlvdspgwm4tnLZyF1rEXdFpvzT37L6g2muzygysebvr0OqUn1HJsPaIufJ0/PQuwtQqir/ogLWUzGjhNGbi1RueDcMTWGM=
Subject: Possible kernel lock in semaphore's __down()
From: Aleksandar Dezelin <dezelin@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Wed, 29 Aug 2007 23:52:51 +0200
Message-Id: <1188424371.8853.9.camel@synaptical>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

I'm a newbie here on the list and also as a "kernel hacker". There's a
bug reported in bugzilla (Bug 7927), cite:


> In the function __down
>  
> fastcall void __sched __down(struct semaphore * sem)
> {
>  struct task_struct *tsk = current;
>  DECLARE_WAITQUEUE(wait, tsk);
>  unsigned long flags;
>  
>  tsk->state = TASK_UNINTERRUPTIBLE;
>  spin_lock_irqsave(&sem->wait.lock, flags);
>  add_wait_queue_exclusive_locked(&sem->wait, &wait);
>  ...
> }
>  
> 
> From this code fragment, it sets the tsk->state to TASK_UNINTERRUPTIBLE before 
> gets the spinlock. Assume at that moment, a interrupt ocuur and and after the 
> interrupt handle ends, an other process is scheduled to run (assume the kernel 
> is preemptalbe). In this case, the previous process ( its state has set to 
> TASK_UNINTERRUPTIBLE) has been picked off the run queue, and it has not yet add 
> to the wait queue( sem->wait ), so it may be never waited up forever. 
> 

I have marked it as rejected as as I can see at the time this function is called,
it is guaranteed that ret_from_intr() will not call schedule() on return from an 
interrupt handler to either kernel space or user space because of the call 
to macro might_sleep() in semaphore's down(). Am I wrong?

Thanks and best regards,
Aleksandar Dezelin



