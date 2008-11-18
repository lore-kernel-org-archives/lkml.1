Return-Path: <linux-kernel-owner+w=401wt.eu-S1753179AbYKROdv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753179AbYKROdv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 09:33:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751147AbYKROdn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 09:33:43 -0500
Received: from gv-out-0910.google.com ([216.239.58.191]:18684 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751920AbYKROdm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 09:33:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=ej++4jc1evbkILssnYNbE3HB0lBFmUCaQiRHXmMxkmpcDl6tEDEEtQ59ltXw81Qez5
         sLsDsy+o5fBmr8vhXeK044urB7LElqNiV1m+Bw1PxgYaumT56cnrF9v0OuZEOW/lu68D
         UFpz2dnuRKwJcs21OKbveHfsBGe8ku07h0k7A=
From: Eric Lacombe <goretux@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Subject: [x86] do_arch_prctl - bug?
Date: Tue, 18 Nov 2008 15:33:32 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.27.5; KDE/4.1.3; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811181533.33108.goretux@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I would like to know why the ARCH_SET_GS action of sys_arch_prctl, write the 
MSR MSR_KERNEL_GS_BASE and not the MSR MSR_GS_BASE when the variable "doit" 
equals 1? Is that a bug?

In other words, why the following code :
...
	if (doit) {
        	load_gs_index(0);
                ret = checking_wrmsrl(MSR_KERNEL_GS_BASE, addr)
	} 
...
is not the following one :
...
	if (doit) {
		ret = checking_wrmsrl(MSR_GS_BASE, addr)
        	load_gs_index(0);
	} 
...

I copy for clarity the beginning of the function "do_arch_prctl" :

long do_arch_prctl(struct task_struct *task, int code, unsigned long addr)
{ 
        int ret = 0; 
        int doit = task == current;
        int cpu;

        switch (code) { 
        case ARCH_SET_GS:
                if (addr >= TASK_SIZE_OF(task))
                        return -EPERM; 
                cpu = get_cpu();
                /* handle small bases via the GDT because that's faster to 
                   switch. */
                if (addr <= 0xffffffff) {  
                        set_32bit_tls(task, GS_TLS, addr); 
                        if (doit) { 
                                load_TLS(&task->thread, cpu);
                                load_gs_index(GS_TLS_SEL); 
                        }
                        task->thread.gsindex = GS_TLS_SEL; 
                        task->thread.gs = 0;
                } else { 
                        task->thread.gsindex = 0;
                        task->thread.gs = addr;
                        if (doit) {
                              load_gs_index(0);
                              ret = checking_wrmsrl(MSR_KERNEL_GS_BASE, addr);
                        } 
                }
                put_cpu();
                break;
[...]

Regards,

	Eric
