Return-Path: <linux-kernel-owner+w=401wt.eu-S1752705AbXLHTF1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752705AbXLHTF1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 14:05:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751136AbXLHTFQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 14:05:16 -0500
Received: from tomts25-srv.bellnexxia.net ([209.226.175.188]:39894 "EHLO
	tomts25-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750853AbXLHTFO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 14:05:14 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aq4HACN6WkdMROHU/2dsb2JhbACBWg
Date: Sat, 8 Dec 2007 14:05:04 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Ingo Molnar <mingo@elte.hu>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [patch-early-RFC 00/10] LTTng architecture dependent
	instrumentation
Message-ID: <20071208190504.GA30538@Krystal>
References: <20071206025650.451824066@polymtl.ca> <20071206101112.GB17299@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20071206101112.GB17299@elte.hu>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 13:45:52 up 34 days, 23:51,  2 users,  load average: 0.42, 0.70,
	0.54
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ingo Molnar (mingo@elte.hu) wrote:
> 
> hi Mathieu,
> 
> * Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
> 
> > Hi,
> > 
> > Here is the architecture dependent instrumentation for LTTng. [...]
> 
> A fundamental observation about markers, and i raised this point many 
> many months ago already, so it might sound repetitive, but i'm unsure 
> wether it's addressed. Documentation/markers.txt still says:
> 
> | * Purpose of markers
> |
> | A marker placed in code provides a hook to call a function (probe) 
> | that you can provide at runtime. A marker can be "on" (a probe is 
> | connected to it) or "off" (no probe is attached). When a marker is 
> | "off" it has no effect, except for adding a tiny time penalty 
> | (checking a condition for a branch) and space penalty (adding a few 
> | bytes for the function call at the end of the instrumented function 
> | and adds a data structure in a separate section).
> 
> could you please eliminate the checking of the flag, and insert a pure 
> NOP sequence by default (no extra branches), which is then patched in 
> with a function call instruction sequence, when the trace point is 
> turned on? (on architectures that have code patching infrastructure - 
> such as x86)
> 

Hi Ingo,

Here are the results of a test I made, hacking a binary to put nops
instead of a function call.

The test is 20000 loops calling a function that contains a marker with
interrupts disabled. It is performed on a x86 32, Pentium 4 3GHz.

__my_trace_mark(0, kernel_debug_test, NULL, "%d %d %ld %ld", 2, current->pid,
  arg, arg2);

The number here include the function call (present in both cases) the
counter increment/tests and the marker.

* No marker at all

240300 cycles total
12.02 cycles per loop

void test(unsigned long arg, unsigned long arg2)
{
   0:   55                      push   %ebp
   1:   89 e5                   mov    %esp,%ebp
        asm volatile ("");
}
   3:   5d                      pop    %ebp
   4:   c3                      ret    


* With my marker implementation (load immediate 0, branch predicted) :

between 200355 and 200580 cycles total (avg 200400 cycles)
10.02 cycles per loop (yes, adding the marker increases performance)


void test(unsigned long arg, unsigned long arg2)
{
  4d:   55                      push   %ebp
  4e:   89 e5                   mov    %esp,%ebp
  50:   83 ec 1c                sub    $0x1c,%esp
  53:   89 c1                   mov    %eax,%ecx
        __my_trace_mark(0, kernel_debug_test, NULL, "%d %d %ld %ld", 2, current-
>pid, arg, arg2);
  55:   b0 00                   mov    $0x0,%al
  57:   84 c0                   test   %al,%al
  59:   75 02                   jne    5d <test+0x10>
}
  5b:   c9                      leave  
  5c:   c3                      ret    


* With NOPs :

avg around 410000 cycles total
20.5 cycles/loop (slowdown of 2)

void test(unsigned long arg, unsigned long arg2)
{
  4d:   55                      push   %ebp
  4e:   89 e5                   mov    %esp,%ebp
  50:   83 ec 1c                sub    $0x1c,%esp
struct task_struct;

DECLARE_PER_CPU(struct task_struct *, current_task);
static __always_inline struct task_struct *get_current(void)
{
        return x86_read_percpu(current_task);
  53:   64 8b 0d 00 00 00 00    mov    %fs:0x0,%ecx
        __my_trace_mark(0, kernel_debug_test, NULL, "%d %d %ld %ld", 2, current-
>pid, arg, arg2);
  5a:   89 54 24 18             mov    %edx,0x18(%esp)
  5e:   89 44 24 14             mov    %eax,0x14(%esp)
  62:   8b 81 c4 00 00 00       mov    0xc4(%ecx),%eax
  68:   89 44 24 10             mov    %eax,0x10(%esp)
  6c:   c7 44 24 0c 02 00 00    movl   $0x2,0xc(%esp)
  73:   00 
  74:   c7 44 24 08 0e 00 00    movl   $0xe,0x8(%esp)
  7b:   00 
  7c:   c7 44 24 04 00 00 00    movl   $0x0,0x4(%esp)
  83:   00 
  84:   c7 04 24 00 00 00 00    movl   $0x0,(%esp)
  8b:   90                      nop    
  8c:   90                      nop    
  8d:   90                      nop    
  8e:   90                      nop    
  8f:   90                      nop    
}
  90:   c9                      leave  
  91:   c3                      ret    


Therefore, because of the cost of stack setup, the load immediate and
conditionnal branch seems to be _much_ faster than the NOP alternative.

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
