Return-Path: <linux-kernel-owner+w=401wt.eu-S1753821AbYHRPsA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753821AbYHRPsA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 11:48:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752099AbYHRPrw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 11:47:52 -0400
Received: from tomts22-srv.bellnexxia.net ([209.226.175.184]:41257 "EHLO
	tomts22-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751423AbYHRPrv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 11:47:51 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AisFAFEwqUhMRKxB/2dsb2JhbACBYrJGgVg
Date: Mon, 18 Aug 2008 11:47:47 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Steven Rostedt <srostedt@redhat.com>
Cc: Eran Liberty <liberty@extricom.com>, linux-kernel@vger.kernel.org,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       linuxppc-dev@ozlabs.org, rostedt@goodmis.org
Subject: Re: ftrace introduces instability into kernel 2.6.27(-rc2,-rc3)
Message-ID: <20080818154746.GA26835@Krystal>
References: <48591941.4070408@extricom.com> <48A92E15.2080709@extricom.com> <48A9901B.1080900@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <48A9901B.1080900@redhat.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 11:43:38 up 74 days, 20:24,  6 users,  load average: 0.53, 0.73,
	0.74
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (srostedt@redhat.com) wrote:
> Eran Liberty wrote:
>> After compiling a kernel with ftrace I started to experience all sorts of 
>> crashes.
>
> Just to make sure...
>
> ftrace enables markers too, and RCU has tracing with the markers. This may 
> not be the problem, but I just want to eliminate as many variables as 
> possible.
> Could you disable ftrace, but keep the markers on too.  Also, could you 
> enable ftrace again and turn on the FTRACE_STARTUP_TEST.
>

Steve ? I just noticed this :


ftrace_modify_code(unsigned long ip, unsigned char *old_code,
                   unsigned char *new_code)
{
        unsigned replaced;
        unsigned old = *(unsigned *)old_code;
        unsigned new = *(unsigned *)new_code;
        int faulted = 0;

        /*
         * Note: Due to modules and __init, code can
         *  disappear and change, we need to protect against faulting
         *  as well as code changing.
         *
         * No real locking needed, this code is run through
         * kstop_machine.
         */
        asm volatile (
                "1: lwz         %1, 0(%2)\n"
                "   cmpw        %1, %5\n"
                "   bne         2f\n"
                "   stwu        %3, 0(%2)\n"
                "2:\n"
                ".section .fixup, \"ax\"\n"
                "3:     li %0, 1\n"
                "       b 2b\n"
                ".previous\n"
                ".section __ex_table,\"a\"\n"
                _ASM_ALIGN "\n"
                _ASM_PTR "1b, 3b\n"
                ".previous"
                : "=r"(faulted), "=r"(replaced)
                : "r"(ip), "r"(new),
                  "0"(faulted), "r"(old)
                : "memory");

        if (replaced != old && replaced != new)
                faulted = 2;

        if (!faulted)
                flush_icache_range(ip, ip + 8);

        return faulted;
}

What happens if you are really unlucky and get the following execution
sequence ?


Load module A at address 0xddfc3e00
Populate ftrace function table while the system runs
Unload module A
Load module B at address 0xddfc3e00
Activate ftrace
-> At that point, since there is another module loaded in the same
address space, it won't fault. If there happens to be an instruction
which looks exactly like the instruction we are replacing at the same
location, we are introducing a bug. True both on x86 ans powerpc...

Mathieu




> Thanks,
>
> -- Steve
>
>> I have a powerpc env which closly resemble mpc8548cds_defconfig.
>>
>> I have produced the crash in seconds by issuing:
>> > while [ 1 ] ; do find / > /dev/null ; echo .  ; done
>>
>> Liberty
>>
>> here are some of the kernel crashes:
>> ---
>> ~ # find /proc/ -name kft
>> find: /proc/150/net/softnet_stat: No such file or direOops: Exception in 
>> kernel mode, sig: 11 [#1]
>> Exsw1600
>> Modules linked in:
>> NIP: c00bd6fc LR: c00bd6fc CTR: 00000000
>> REGS: ddfc3d50 TRAP: 0700   Not tainted  (2.6.27-rc2)
>> MSR: 00029000 <EE,ME>  CR: 20002284  XER: 20000000
>> TASK = ddcccde0[1699] 'find' THREAD: ddfc2000
>> GPR00: 00000000 ddfc3e00 ddcccde0 dd895580 ddfc3e30 c00b5da0 ddfc3e90 
>> 00000003
>> GPR08: c00ece54 00000370 00145505 00000003 80002282 100ad874 10083ca0 
>> 10083cd8
>> GPR16: 10083cd0 00000008 00000000 c00b5da0 ddfc3f18 c00ece54 00000000 
>> df465720
>> GPR24: d7431900 ddfc3e30 dd895580 c0380000 dd895580 ddfc3e30 00000000 
>> ddfc3e00
>> NIP [c00bd6fc] d_lookup+0x40/0x90
>> LR [c00bd6fc] d_lookup+0x40/0x90
>> Call Trace:
>> [ddfc3e00] [c006ade4] rcu_process_callbacks+0x48/0x60 (unreliable)
>> [ddfc3e20] [c00eb514] proc_fill_cache+0x94/0x1b0
>> [ddfc3e80] [c00ef720] proc_task_readdir+0x294/0x3c4
>> [ddfc3ee0] [c00b60fc] vfs_readdir+0xb8/0xd8
>> [ddfc3f10] [c00b619c] sys_getdents64+0x80/0x104
>> [ddfc3f40] [c0010554] ret_from_syscall+0x0/0x3c
>> Instruction dump:
>> 7c0802a6 bf61000c 3f60c038 7c3f0b78 90010024 7c7c1b78 7c9d2378 83db52a0
>> 73c00001 7f83e378 7fa4eb78 4082002f <00000000> 2f830000 409e0030 801b52a0
>> ctory
>> ---[ end trace 6b059a7f5ba5a55a ]---
>>
>> ---
>>
>> Oops: Exception in kernel mode, sig: 11 [#1]
>> Exsw1600
>> Modules linked in: gplonly_api
>> NIP: c00bd6fc LR: c00bd6fc CTR: 00000000
>> REGS: df52dc40 TRAP: 0700   Not tainted  (2.6.27-rc2)
>> MSR: 00029000 <EE,ME>  CR: 20082422  XER: 20000000
>> TASK = ddc2e060[2294] 'eeprom' THREAD: df52c000
>> GPR00: 00000000 df52dcf0 ddc2e060 dd82c700 df52dd58 df52dd48 dd82c75e 
>> 00000000
>> GPR08: c0800000 000311f0 0000ffff df52dd10 20002488 1001e75c 100b0000 
>> 1008e90c
>> GPR16: bfd15a50 df52de6c df52dd58 fffffff4 c0380000 df52dd50 df52dd48 
>> dd9303fc
>> GPR24: dc3a6800 dd930390 df52dd58 c0380000 dd82c700 df52dd58 00000006 
>> df52dcf0
>> NIP [c00bd6fc] d_lookup+0x40/0x90
>> LR [c00bd6fc] d_lookup+0x40/0x90
>> Call Trace:
>> [df52dcf0] [df52dd48] 0xdf52dd48 (unreliable)
>> [df52dd10] [c00b07a0] do_lookup+0xe8/0x220
>> [df52dd40] [c00b222c] __link_path_walk+0x174/0xd54
>> [df52ddb0] [c00b2e64] path_walk+0x58/0xe0
>> [df52dde0] [c00b2fd4] do_path_lookup+0x78/0x13c
>> [df52de10] [c00b3f3c] __path_lookup_intent_open+0x68/0xdc
>> [df52de40] [c00b3fd8] path_lookup_open+0x28/0x40
>> [df52de50] [c00b4234] do_filp_open+0xa0/0x798
>> [df52df00] [c00a3b80] do_sys_open+0x70/0x114
>> [df52df30] [c00a3c98] sys_open+0x38/0x50
>> [df52df40] [c0010554] ret_from_syscall+0x0/0x3c
>> Instruction dump:
>> 7c0802a6 bf61000c 3f60c038 7c3f0b78 90010024 7c7c1b78 7c9d2378 83db52a0
>> 73c00001 7f83e378 7fa4eb78 4082002f <00000000> 2f830000 409e0030 801b52a0
>> om_version(Canno---[ end trace 0cef3c8cb49d09de ]---
>>
>> ---
>>
>> Oops: Exception in kernel mode, sig: 11 [#1]
>> Exsw1600
>> Modules linked in: bridge stp llc tun beacon_freescale(P) 80211(P) 
>> shm_freescale(P) ath_remote_regs_freescale(P) exsw 
>> load_local_fpga_freescale 8021q poe_fi
>> NIP: c00bd6fc LR: c00bd6fc CTR: 00000000
>> REGS: dd555c50 TRAP: 0700   Tainted: P           (2.6.27-rc2)
>> MSR: 00029000 <EE,ME>  CR: 24082282  XER: 20000000
>> TASK = df4669a0[4976] 'find' THREAD: dd554000
>> GPR00: 00000000 dd555d00 df4669a0 dd82ae00 dd555d68 dd555d58 dd82ae5b 
>> 100234ec
>> GPR08: c0800000 0002dd0c 0000ffff dd555d20 24000288 100ad874 100936f8 
>> 1008a1d0
>> GPR16: 10083f80 dd555e2c dd555d68 fffffff4 c0380000 dd555d60 dd555d58 
>> dd9565d4
>> GPR24: dc3db480 dd956568 dd555d68 c0380000 dd82ae00 dd555d68 00000000 
>> dd555d00
>> NIP [c00bd6fc] d_lookup+0x40/0x90
>> LR [c00bd6fc] d_lookup+0x40/0x90
>> Call Trace:
>> [dd555d00] [dd555d58] 0xdd555d58 (unreliable)
>> [dd555d20] [c00b07a0] do_lookup+0xe8/0x220
>> [dd555d50] [c00b265c] __link_path_walk+0x5a4/0xd54
>> [dd555dc0] [c00b2e64] path_walk+0x58/0xe0
>> [dd555df0] [c00b2fd4] do_path_lookup+0x78/0x13c
>> [dd555e20] [c00b3cd0] user_path_at+0x64/0xac
>> [dd555e90] [c00aac04] vfs_lstat_fd+0x34/0x74
>> [dd555ec0] [c00aacd8] vfs_lstat+0x30/0x48
>> [dd555ed0] [c00aad20] sys_lstat64+0x30/0x5c
>> [dd555f40] [c0010554] ret_from_syscall+0x0/0x3c
>> Instruction dump:
>> 7c0802a6 bf61000c 3f60c038 7c3f0b78 90010024 7c7c1b78 7c9d2378 83db52a0
>> 73c00001 7f83e378 7fa4eb78 4082002f <00000000> 2f830000 409e0030 801b52a0
>> 76/auxv
>> /proc/4---[ end trace 0deef0827ce9df4b ]---
>>
>> ---
>> Oops: Exception in kernel mode, sig: 11 [#1]
>> Exsw1600
>> Modules linked in: bridge stp llc tun beacon_freescale(P) 80211(P) 
>> shm_freescale(P) ath_remote_regs_freescale(P) exsw 
>> load_local_fpga_freescale 8021q poe_fi
>> NIP: c00bd6fc LR: c00bd6fc CTR: 00000000
>> REGS: d57e7c40 TRAP: 0700   Tainted: P           (2.6.27-rc2)
>> MSR: 00029000 <EE,ME>  CR: 24482482  XER: 20000000
>> TASK = db3cc940[2054] 'eapd' THREAD: d57e6000
>> GPR00: 00000000 d57e7cf0 db3cc940 dd82a500 d57e7d58 d57e7d48 dd82a55a 
>> 00000000
>> GPR08: c0800000 00016c64 0000ffff d57e7d10 24422488 1008f700 4802cd38 
>> 100763e8
>> GPR16: 4801d818 d57e7e6c d57e7d58 fffffff4 c0380000 d57e7d50 d57e7d48 
>> dd956c74
>> GPR24: dc3db680 dd956c08 d57e7d58 c0380000 dd82a500 d57e7d58 00000000 
>> d57e7cf0
>> NIP [c00bd6fc] d_lookup+0x40/0x90
>> LR [c00bd6fc] d_lookup+0x40/0x90
>> Call Trace:
>> [d57e7cf0] [d57e7d48] 0xd57e7d48 (unreliable)
>> [d57e7d10] [c00b07a0] do_lookup+0xe8/0x220
>> [d57e7d40] [c00b265c] __link_path_walk+0x5a4/0xd54
>> [d57e7db0] [c00b2e64] path_walk+0x58/0xe0
>> [d57e7de0] [c00b2fd4] do_path_lookup+0x78/0x13c
>> [d57e7e10] [c00b3f3c] __path_lookup_intent_open+0x68/0xdc
>> [d57e7e40] [c00b3fd8] path_lookup_open+0x28/0x40
>> [d57e7e50] [c00b4234] do_filp_open+0xa0/0x798
>> [d57e7f00] [c00a3b80] do_sys_open+0x70/0x114
>> [d57e7f30] [c00a3c98] sys_open+0x38/0x50
>> [d57e7f40] [c0010554] ret_from_syscall+0x0/0x3c
>> Instruction dump:
>> 7c0802a6 bf61000c 3f60c038 7c3f0b78 90010024 7c7c1b78 7c9d2378 83db52a0
>> 73c00001 7f83e378 7fa4eb78 4082002f <00000000> 2f830000 409e0030 801b52a0
>> ---[ end trace ffb4a6e37d78370a ]---
>>
>> ---
>> Oops: Exception in kernel mode, sig: 11 [#1]
>> Exsw1600
>> Modules linked in: bridge stp llc tun beacon_freescale(P) 80211(P) 
>> shm_freescale(P) ath_remote_regs_freescale(P) exsw 
>> load_local_fpga_freescale 8021q poe_fi
>> NIP: c00bd6fc LR: c00bd6fc CTR: c00bd6c8
>> REGS: decd5cf0 TRAP: 0700   Tainted: P           (2.6.27-rc2)
>> MSR: 00029000 <EE,ME>  CR: 22228882  XER: 20000000
>> TASK = d9f5a9a0[6897] 'sh' THREAD: decd4000
>> GPR00: 00000000 decd5da0 d9f5a9a0 dd801180 decd5de8 00000000 00000004 
>> fffffff9
>> GPR08: fffffffa 00000000 00d5ca28 decd5d90 2ccc1686 100ad874 1fffb200 
>> 00000000
>> GPR16: 007fff00 decd5ec4 00000008 c02fe298 00200200 00000000 c031aa34 
>> decd5de8
>> GPR24: decd5df4 00001af2 dd507d00 c0380000 dd801180 decd5de8 00000000 
>> decd5da0
>> NIP [c00bd6fc] d_lookup+0x40/0x90
>> LR [c00bd6fc] d_lookup+0x40/0x90
>> Call Trace:
>> [decd5dc0] [c00bd7d8] d_hash_and_lookup+0x8c/0xc4
>> [decd5de0] [c00ed728] proc_flush_task+0xb4/0x268
>> [decd5e40] [c0032894] release_task+0x6c/0x39c
>> [decd5e70] [c0033238] wait_consider_task+0x674/0x920
>> [decd5eb0] [c0033610] do_wait+0x12c/0x3d4
>> [decd5f20] [c0033954] sys_wait4+0x9c/0xe8
>> [decd5f40] [c0010554] ret_from_syscall+0x0/0x3c
>> Instruction dump:
>> 7c0802a6 bf61000c 3f60c038 7c3f0b78 90010024 7c7c1b78 7c9d2378 83db52a0
>> 73c00001 7f83e378 7fa4eb78 4082002f <00000000> 2f830000 409e0030 801b52a0
>> ---[ end trace 00106ff4ec3b9c22 ]---
>>
>>
>>
>>
>

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
