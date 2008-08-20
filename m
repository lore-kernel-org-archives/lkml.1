Return-Path: <linux-kernel-owner+w=401wt.eu-S1753562AbYHTSZw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753562AbYHTSZw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 14:25:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751542AbYHTSZn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 14:25:43 -0400
Received: from smtp1.extricom.com ([212.235.24.249]:46004 "HELO
	smtp.extricom.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with SMTP id S1751103AbYHTSZm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 14:25:42 -0400
Message-ID: <48AC6120.1080400@extricom.com>
Date: Wed, 20 Aug 2008 21:23:28 +0300
From: Eran Liberty <liberty@extricom.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080502)
MIME-Version: 1.0
To: Jon Smirl <jonsmirl@gmail.com>
CC: Steven Rostedt <rostedt@goodmis.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Steven Rostedt <srostedt@redhat.com>, Alan Modra <amodra@au1.ibm.com>,
       Scott Wood <scottwood@freescale.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: ftrace introduces instability into kernel 2.6.27(-rc2,-rc3)
References: <48591941.4070408@extricom.com> <1219114600.8062.15.camel@pasglop>	 <alpine.DEB.1.10.0808182304300.13401@gandalf.stny.rr.com>	 <1219119431.8062.35.camel@pasglop> <1219216705.21386.46.camel@pasglop>	 <alpine.DEB.1.10.0808200913070.13132@gandalf.stny.rr.com>	 <alpine.DEB.1.10.0808200916090.13132@gandalf.stny.rr.com>	 <48AC1DD8.9080702@extricom.com>	 <alpine.DEB.1.10.0808200941560.13132@gandalf.stny.rr.com>	 <48AC23F4.80900@extricom.com> <9e4733910808200755y1128ae56p6a1235684bfbb3ec@mail.gmail.com>
In-Reply-To: <9e4733910808200755y1128ae56p6a1235684bfbb3ec@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jon Smirl wrote:
> Manually edit the broken binary to change the order of the restore and
> see if the problem disappears. That will keep everything else
> constant.
>
>   
checked with objdump where __d_lookup()

 > powerpc-linux-gnu-objdump -dr --start-address=0xc0065790 vmlinux | 
grep "<__d_lookup>:"
c00b91d8 <__d_lookup>:

 > liberty@liberty:~/svn/exsw1600-2.6.27-rc2$ powerpc-linux-gnu-objdump 
-dr --start-address=0xc00b91d8 vmlinux| head -n 100

vmlinux:     file format elf32-powerpc

Disassembly of section .text:

c00b91d8 <__d_lookup>:
c00b91d8:       7c 08 02 a6     mflr    r0
c00b91dc:       90 01 00 04     stw     r0,4(r1)
 ....

c00b92bc:       4e 80 04 21     bctrl
c00b92c0:       2f 83 00 00     cmpwi   cr7,r3,0
c00b92c4:       41 9e 00 50     beq-    cr7,c00b9314 <__d_lookup+0x13c>
c00b92c8:       83 de 00 00     lwz     r30,0(r30)
c00b92cc:       2f 9e 00 00     cmpwi   cr7,r30,0
c00b92d0:       40 9e ff 98     bne+    cr7,c00b9268 <__d_lookup+0x90>
c00b92d4:       38 60 00 00     li      r3,0
c00b92d8:       81 61 00 00     lwz     r11,0(r1)
c00b92dc:       80 0b 00 04     lwz     r0,4(r11)
c00b92e0:       7d 61 5b 78     mr      r1,r11
       <=== As explained by Steve, these two should be replaced ===>
c00b92e4:       bb 0b ff e0     lmw     r24,-32(r11)
c00b92e8:       7c 08 03 a6     mtlr    r0
c00b92ec:       4e 80 00 20     blr
c00b92f0:       80 04 00 04     lwz     r0,4(r4)
  ....
c00b9330:       7f a3 eb 78     mr      r3,r29
c00b9334:       4b ff ff a4     b       c00b92d8 <__d_lookup+0x100>

c00b9338 <d_lookup>:
c00b9338:       7c 08 02 a6     mflr    r0

on the target I fired up xmon and replaced them.

~ # echo x > /proc/sysrq-trigger
SysRq : Entering xmon
Vector: 0  at [df51fdb8]
    pc: c0025960: sysrq_handle_xmon+0x60/0x64
    lr: c0025960: sysrq_handle_xmon+0x60/0x64
    sp: df51fe80
   msr: 21000
  current = 0xdc22a9a0
    pid   = 1698, comm = echo
WARNING: exception is not recoverable, can't continue
enter ? for help
[df51fe90] c0193c38 __handle_sysrq+0xa8/0x178
[df51fec0] c00ee818 write_sysrq_trigger+0x78/0x7c
[df51fed0] c00e65e4 proc_reg_write+0x5c/0x84
[df51fef0] c00a299c vfs_write+0xc8/0x180
[df51ff10] c00a2f40 sys_write+0x5c/0xa4
[df51ff40] c0010554 ret_from_syscall+0x0/0x3c
SP (bffe87e0) is in userspace

mon> di c00b92d0
c00b92d0  409eff98      bne     cr7,c00b9268    # __d_lookup+0x90/0x160
c00b92d4  38600000      li      r3,0
c00b92d8  81610000      lwz     r11,0(r1)
c00b92dc  800b0004      lwz     r0,4(r11)
c00b92e0  7d615b78      mr      r1,r11
  <=== wrong order ===>
c00b92e4  bb0bffe0      lmw     r24,-32(r11)
c00b92e8  7c0803a6      mtlr    r0
c00b92ec  4e800020      blr
c00b92f0  80040004      lwz     r0,4(r4)
c00b92f4  7f80c800      cmpw    cr7,r0,r25
c00b92f8  409eff64      bne     cr7,c00b925c    # __d_lookup+0x84/0x160
c00b92fc  80640008      lwz     r3,8(r4)
c00b9300  7f25cb78      mr      r5,r25
c00b9304  7f04c378      mr      r4,r24
c00b9308  4bf5ccf1      bl      c0015ff8        # memcmp+0x0/0x30
c00b930c  2f830000      cmpwi   cr7,r3,0
mon> m c00b92e0
c00b92e0  7d l
c00b92e0  7d615b78 bb0bffe0
c00b92e4  bb0bffe0 7d615b78
c00b92e8  7c0803a6 x
mon> di c00b92d0
c00b92d0  409eff98      bne     cr7,c00b9268    # __d_lookup+0x90/0x160
c00b92d4  38600000      li      r3,0
c00b92d8  81610000      lwz     r11,0(r1)
c00b92dc  800b0004      lwz     r0,4(r11)
c00b92e0  bb0bffe0      lmw     r24,-32(r11)
  <=== right order ===>
c00b92e4  7d615b78      mr      r1,r11
c00b92e8  7c0803a6      mtlr    r0
c00b92ec  4e800020      blr
c00b92f0  80040004      lwz     r0,4(r4)
c00b92f4  7f80c800      cmpw    cr7,r0,r25
c00b92f8  409eff64      bne     cr7,c00b925c    # __d_lookup+0x84/0x160
c00b92fc  80640008      lwz     r3,8(r4)
c00b9300  7f25cb78      mr      r5,r25
c00b9304  7f04c378      mr      r4,r24
c00b9308  4bf5ccf1      bl      c0015ff8        # memcmp+0x0/0x30
c00b930c  2f830000      cmpwi   cr7,r3,0
mon> X
~ #

And took it for a test drive
~# while [ 1 ] ; do find / > /dev/null ; echo .  ; done
.
.
.
[ 10 min later ]
.
.
.

Stable! Yeepee.

So how do we get this to be right in the first place and everywhere?

-- Liberty

