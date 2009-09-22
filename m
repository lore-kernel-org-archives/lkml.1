Return-Path: <linux-kernel-owner+w=401wt.eu-S1755998AbZIVLTE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755998AbZIVLTE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 07:19:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756003AbZIVLTB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 07:19:01 -0400
Received: from mail.gmx.net ([213.165.64.20]:34877 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755994AbZIVLTA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 07:19:00 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19c+Q17iKJc2bqN+c4sTxD0LqAquMMgvBNG2njiX7
	kp42FSPCdWqoqs
Subject: Re: mailing list for trace users
From: Mike Galbraith <efault@gmx.de>
To: Avi Kivity <avi@redhat.com>
Cc: rostedt@goodmis.org, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Masami Hiramatsu <mhiramat@redhat.com>, postmaster@vger.kernel.org
In-Reply-To: <4AB89520.2050900@redhat.com>
References: <1253132182.20020.242.camel@gandalf.stny.rr.com>
	 <4AB89520.2050900@redhat.com>
Content-Type: text/plain
Date: Tue, 22 Sep 2009 13:18:54 +0200
Message-Id: <1253618334.13917.9.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.48
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-09-22 at 12:13 +0300, Avi Kivity wrote:
> Yes please.  Here's a question to start it off - how to I 'perf 
> annotate' a symbol in a module?
> 
> $ perf report
> # Samples: 68202
> #
> # Overhead          Command  Shared Object  Symbol
> # ........  ...............  .............  ......
> #
>      84.17%  qemu-system-x86  [kernel]       [k] vmx_vcpu_run    [kvm_intel]
>       4.28%  qemu-system-x86  [kernel]       [k] kvm_arch_vcpu_ioctl_run 
> [kvm]
>       0.88%  qemu-system-x86  [kernel]       [k] add_preempt_count
>       0.75%  qemu-system-x86  [kernel]       [k] _spin_unlock_irqrestore
>       0.68%  qemu-system-x86  [kernel]       [k] _spin_lock_irq
> 
> $ perf annotate -k ~avi/kvm/linux-2.6/vmlinux -m vmx_vcpu_run
>   Error: symbol 'vmx_vcpu_run' not present amongst the samples.
> 
> builtin symbols work.
> 

Hm, dunno.  Using tip v2.6.31-7960-gf3da2f6, module annotation seems to
work fine here.

marge:/root/tmp # perf report -k vmlinux -m -d [kernel]|grep ahci_interrupt
     1.21%          swapper  [k] ahci_interrupt [ahci]
     0.11%            :7222  [k] ahci_interrupt [ahci]
     0.04%            :4876  [k] ahci_interrupt [ahci]
     0.02%            :6628  [k] ahci_interrupt [ahci]
     0.01%            :7452  [k] ahci_interrupt [ahci]
     0.01%            :7407  [k] ahci_interrupt [ahci]
marge:/root/tmp # perf annotate -k vmlinux -m ahci_interrupt|grep -C 20 Disassembly


------------------------------------------------
 Percent |      Source code & Disassembly of ahci.ko
------------------------------------------------
         :
         :
         :
         :      Disassembly of section .text:
         :
         :      0000000000002a49 <ahci_interrupt>:
         :                      ata_port_freeze(ap);
         :              }
         :      }
         :
         :      static irqreturn_t ahci_interrupt(int irq, void *dev_instance)
         :      {
    0.00 :          2a49:       55                      push   %rbp
    0.69 :          2a4a:       48 89 e5                mov    %rsp,%rbp
    0.00 :          2a4d:       41 57                   push   %r15
    0.00 :          2a4f:       49 89 f7                mov    %rsi,%r15
    0.00 :          2a52:       41 56                   push   %r14
    0.00 :          2a54:       41 55                   push   %r13
    0.00 :          2a56:       41 54                   push   %r12
    0.00 :          2a58:       53                      push   %rbx
    0.00 :          2a59:       48 83 ec 58             sub    $0x58,%rsp
         :      { asm volatile("mov" size " %0,%1": :reg (val), \
         :      "m" (*(volatile type __force *)addr) barrier); }
         :
marge:/root/tmp #


