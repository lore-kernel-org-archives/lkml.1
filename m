Return-Path: <linux-kernel-owner+w=401wt.eu-S1754171AbYHSMML@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754171AbYHSMML (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 08:12:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752901AbYHSML5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 08:11:57 -0400
Received: from smtp.extricom.com ([192.114.46.18]:58260 "HELO
	smtp.extricom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752609AbYHSML4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 08:11:56 -0400
Message-ID: <48AAB7FF.4070502@extricom.com>
Date: Tue, 19 Aug 2008 15:09:35 +0300
From: Eran Liberty <liberty@extricom.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080502)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Steven Rostedt <srostedt@redhat.com>, linux-kernel@vger.kernel.org,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       linuxppc-dev@ozlabs.org
Subject: Re: ftrace introduces instability into kernel 2.6.27(-rc2,-rc3)
References: <48591941.4070408@extricom.com> <48A92E15.2080709@extricom.com> <48A9901B.1080900@redhat.com> <48A9BEA3.10906@extricom.com> <alpine.DEB.1.10.0808181439480.796@gandalf.stny.rr.com>
In-Reply-To: <alpine.DEB.1.10.0808181439480.796@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> On Mon, 18 Aug 2008, Eran Liberty wrote:
>
>   
>> Steven Rostedt wrote:
>>     
>>> Eran Liberty wrote:
>>>       
>>>> After compiling a kernel with ftrace I started to experience all sorts of
>>>> crashes.
>>>>         
>>> Just to make sure...
>>>
>>> ftrace enables markers too, and RCU has tracing with the markers. This may
>>> not be the problem, but I just want to eliminate as many variables as
>>> possible.
>>> Could you disable ftrace, but keep the markers on too.  Also, could you
>>> enable ftrace again and turn on the FTRACE_STARTUP_TEST.
>>>       
>> for the fun of it I took out all my propriety modules; so now its a non
>> tainted kernel.
>>
>> Here is the matrix:
>>
>> !FTRACE x !MARKERS => stable
>> !FTRACE x MARKERS => stable
>> FTRACE x !MARKERS => n/a (FTRACE forces MARKERS)
>> FTRACE x MARKERS => unstable
>> FTRACE x FTRACE_STARTUP_TEST x MARKERS => unstable + tests passed
>>     
>
> Thanks
>
>   
>> Testing tracer sched_switch: PASSED
>> Testing tracer ftrace: PASSED
>> Testing dynamic ftrace: PASSED
>>
>> Oops: Exception in kernel mode, sig: 11 [#1]
>> Exsw1600
>> Modules linked in:
>> NIP: c00bbb20 LR: c00bbb20 CTR: 00000000
>>     
>
> Could you load this into gdb for me and show me the output of:
>
> gdb> li *0xc00bbb20
>
> (Assuming you compiled with debuginfo on)
>
> and...
>
> gdb> disass 0xc00bbb20
>
>   
>> REGS: dd5b1c50 TRAP: 0700   Not tainted  (2.6.27-rc2)
>> MSR: 00029000 <EE,ME>  CR: 24082282  XER: 20000000
>> TASK = ddcce060[1707] 'find' THREAD: dd5b0000
>> GPR00: 00000000 dd5b1d00 ddcce060 dd801180 dd5b1d68 dd5b1d58 dd80125b 100234ec
>> GPR08: c0800000 00019330 0000ffff dd5b1d20 24000288 100ad874 100936f8 1008a1d0
>> GPR16: 10083f80 dd5b1e2c dd5b1d68 fffffff4 c0380000 dd5b1d60 dd5b1d58 dd802084
>> GPR24: dc3d7700 dd802018 dd5b1d68 c0380000 dd801180 dd5b1d68 00000000 dd5b1d00
>> NIP [c00bbb20] d_lookup+0x40/0x90
>> LR [c00bbb20] d_lookup+0x40/0x90
>> Call Trace:
>> [dd5b1d00] [dd5b1d58] 0xdd5b1d58 (unreliable)
>> [dd5b1d20] [c00aebc4] do_lookup+0xe8/0x220
>> [dd5b1d50] [c00b0a80] __link_path_walk+0x5a4/0xd54
>> [dd5b1dc0] [c00b1288] path_walk+0x58/0xe0
>> [dd5b1df0] [c00b13f8] do_path_lookup+0x78/0x13c
>> [dd5b1e20] [c00b20f4] user_path_at+0x64/0xac
>> [dd5b1e90] [c00a9028] vfs_lstat_fd+0x34/0x74
>> [dd5b1ec0] [c00a90fc] vfs_lstat+0x30/0x48
>> [dd5b1ed0] [c00a9144] sys_lstat64+0x30/0x5c
>> [dd5b1f40] [c0010554] ret_from_syscall+0x0/0x3c
>> Instruction dump:
>> 7c0802a6 bf61000c 3f60c038 7c3f0b78 90010024 7c7c1b78 7c9d2378 83db32a0
>> 73c00001 7f83e378 7fa4eb78 4082002f <00000000> 2f830000 409e0030 801b32a0
>>     
>
> Ouch! we have a 00000000 instruction. I'm almost done with the new mcount 
> record for PPC (I have it done for ppc64, I'm just porting it to 32). I'm 
> thinking this new code may solve your issues too. I hate the daemon.
>
> -- Steve
>
>
>   

I have attached ddd. Up on crashing it points on this line

struct dentry * d_lookup(struct dentry * parent, struct qstr * name)
{
        struct dentry * dentry = NULL;
        unsigned long seq;
   
        do {
                seq = read_seqbegin(&rename_lock);
                dentry = __d_lookup(parent, name);     <==== ddd marker
                if (dentry)
                        break;
        } while (read_seqretry(&rename_lock, seq));
        return dentry;
}

(gdb) bt
#0  d_lookup (parent=0xdd801180, name=0xd99b3d68) at fs/dcache.c:1361
#1  0xc00ae7c8 in real_lookup (nd=<value optimized out>, name=<value 
optimized out>, parent=0xdd801180) at fs/namei.c:507
#2  do_lookup (nd=0xd99b3e28, name=0xd99b3d68, path=0xd99b3d58) at 
fs/namei.c:825
#3  0xc00b0684 in __link_path_walk (name=0xddc23009 "", nd=0xd99b3e28) 
at fs/namei.c:982
#4  0xc00b0e8c in link_path_walk (nd=<value optimized out>, name=<value 
optimized out>) at fs/namei.c:570
#5  path_walk (name=0xddc23000 "/proc/mtd", nd=0xd99b3e28) at 
fs/namei.c:1041
#6  0xc00b0ffc in do_path_lookup (dfd=<value optimized out>, 
name=0xddc23000 "/proc/mtd", flags=<value optimized out>, nd=0xd99b3e28) 
at fs/namei.c:1091
#7  0xc00b1cf8 in user_path_at (dfd=-100, name=<value optimized out>, 
flags=0, path=0xd99b3e98) at fs/namei.c:1334
#8  0xc00a8c98 in vfs_lstat_fd (dfd=-578809472, name=0xd99b3d68 "", 
stat=0xd99b3ed8) at fs/stat.c:83
#9  0xc00a8d6c in vfs_lstat (name=0xd99b3d68 "", stat=0xd99b3d58) at 
fs/stat.c:93
#10 0xc00a8db4 in sys_lstat64 (filename=0xdd801180 "", 
statbuf=0xbfe285d8) at fs/stat.c:381
#11 0xc0010554 in syscall_dotrace_cont ()

both cp & lr points to 0xC00BB724
(gdb) info registers
r0             0x0    0
r1             0xd99b3d00    3650829568
r2             0xddccf2e0    3721196256
r3             0xdd801180    3716157824
r4             0xd99b3d68    3650829672
r5             0xd99b3d58    3650829656
r6             0xdd822a5b    3716295259
r7             0x100234ec    268580076
r8             0xc0800000    3229614080
r9             0x19330    103216
r10            0xffff    65535
r11            0xd99b3d20    3650829600
r12            0x24000288    603980424
r13            0x100ad874    269146228
r14            0x100936f8    269039352
r15            0x1008a1d0    269001168
r16            0x10083f80    268976000
r17            0xd99b3e2c    3650829868
r18            0xd99b3d68    3650829672
r19            0xfffffff4    4294967284
r20            0xc0380000    3224895488
r21            0xd99b3d60    3650829664
r22            0xd99b3d58    3650829656
r23            0xdd802084    3716161668
r24            0xdc3fb280    3695161984
r25            0xdd802018    3716161560
r26            0xd99b3d68    3650829672
r27            0xc0380000    3224895488
r28            0xdd801180    3716157824
r29            0xd99b3d68    3650829672
r30            0x0    0
r31            0xd99b3d00    3650829568
pc             0xc00bb724    3221993252
cr             0x24082282    604512898
lr             0xc00bb724    3221993252
ctr            0x0    0
xer            0x20000000    536870912

(gdb) li *0xC00BB724
Line 1361 of "fs/dcache.c" starts at address 0xc00bb724 <d_lookup+64> 
and ends at 0xc00bb728 <d_lookup+68>.

(gdb) disassemble 0xC00BB724
Dump of assembler code for function d_lookup:
0xc00bb6e4 <d_lookup+0>:    mflr    r0
0xc00bb6e8 <d_lookup+4>:    stw     r0,4(r1)
0xc00bb6ec <d_lookup+8>:    nop
0xc00bb6f0 <d_lookup+12>:    stwu    r1,-32(r1)
0xc00bb6f4 <d_lookup+16>:    mflr    r0
0xc00bb6f8 <d_lookup+20>:    stmw    r27,12(r1)
0xc00bb6fc <d_lookup+24>:    lis     r27,-16328
0xc00bb700 <d_lookup+28>:    mr      r31,r1
0xc00bb704 <d_lookup+32>:    stw     r0,36(r1)
0xc00bb708 <d_lookup+36>:    mr      r28,r3
0xc00bb70c <d_lookup+40>:    mr      r29,r4
0xc00bb710 <d_lookup+44>:    lwz     r30,12960(r27)
0xc00bb714 <d_lookup+48>:    andi.   r0,r30,1
0xc00bb718 <d_lookup+52>:    mr      r3,r28
0xc00bb71c <d_lookup+56>:    mr      r4,r29
0xc00bb720 <d_lookup+60>:    bnela-  0x2c
0xc00bb724 <d_lookup+64>:    .long 0x0
0xc00bb728 <d_lookup+68>:    cmpwi   cr7,r3,0
0xc00bb72c <d_lookup+72>:    bne-    cr7,0xc00bb75c <d_lookup+120>
0xc00bb730 <d_lookup+76>:    lwz     r0,12960(r27)
0xc00bb734 <d_lookup+80>:    cmpw    cr7,r0,r30
0xc00bb738 <d_lookup+84>:    beq-    cr7,0xc00bb75c <d_lookup+120>
0xc00bb73c <d_lookup+88>:    mr      r30,r0
0xc00bb740 <d_lookup+92>:    andi.   r0,r30,1
0xc00bb744 <d_lookup+96>:    mr      r3,r28
0xc00bb748 <d_lookup+100>:    mr      r4,r29
0xc00bb74c <d_lookup+104>:    beq+    0xc00bb724 <d_lookup+64>
0xc00bb750 <d_lookup+108>:    lwz     r0,12960(r27)
0xc00bb754 <d_lookup+112>:    mr      r30,r0
0xc00bb758 <d_lookup+116>:    b       0xc00bb740 <d_lookup+92>
0xc00bb75c <d_lookup+120>:    lwz     r11,0(r1)
0xc00bb760 <d_lookup+124>:    lwz     r0,4(r11)
0xc00bb764 <d_lookup+128>:    lmw     r27,-20(r11)
0xc00bb768 <d_lookup+132>:    mtlr    r0
0xc00bb76c <d_lookup+136>:    mr      r1,r11
0xc00bb770 <d_lookup+140>:    blr
End of assembler dump.
(gdb)

Hope this is helpfull

Liberty



