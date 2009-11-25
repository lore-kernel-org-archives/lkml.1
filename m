Return-Path: <linux-kernel-owner+w=401wt.eu-S1758575AbZKYJwZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758575AbZKYJwZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 04:52:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758549AbZKYJwY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 04:52:24 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:40387 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758514AbZKYJwW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 04:52:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=edHVYWwiAo30rnKhm5yo59nwmkiKeHY+rDC1zrVjaMjWCj27uVd8Fj9EjciW4i0jIm
         MLFGRiT0sw8J8DLRGgYwVNI5oCj13DZ2wmyHpOeXCEfn7FXFmzgzbB3TopcNLcwo4idu
         zPgG6zGFjQDo4u17K0vbwUnoyQafI/F6D+HQc=
MIME-Version: 1.0
Date: Wed, 25 Nov 2009 04:52:26 -0500
Message-ID: <523e55a00911250152n773f2cbeu9251180c44f0b9a@mail.gmail.com>
Subject: NULL pointer dereference at 2.6.32-rc8:net/ipv4/ip_fragment.c:566
From: David Ford <firefighterblu3@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: david@blue-labs.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When running openvasd, it seems there's an unlikely condition
instigating the following oops.  It doesn't happen normally with idle
or low traffic conditions nor does it happen with a large SCP.  I
haven't tried running tcpdump to see what might be in flight because
the machine locks up solid immediately and the only thing left is the
queued data draining out of the serial console.  I'm slowly regressing
trying to find the last good kernel version.

-david



[ 1287.971356] BUG: unable to handle kernel NULL pointer dereference
at 000003a0
[ 1288.046063] IP: [<c1424046>] ip_defrag+0x71d/0x7e3
[ 1288.046063] *pde = 00000000
[ 1288.046063] Oops: 0000 [#1] SMP DEBUG_PAGEALLOC
[ 1288.046063] last sysfs file: /sys/kernel/mm/ksm/run
[ 1288.046063] Modules linked in: iTCO_wdt iTCO_vendor_support fuse
ext2 raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor
xor async_tx raid6_pq raid1 raid0 md_mod dm_snapshot dm_crypt
dm_mirror dm_region_hash dm_log dm_mod scsi_wait_scan
[ 1288.046063]
[ 1288.046063] Pid: 8202, comm: openvasd Tainted: G        W
(2.6.32-rc8-VSE #1)
[ 1288.046063] EIP: 0060:[<c1424046>] EFLAGS: 00010246 CPU: 0
[ 1288.046063] EIP is at ip_defrag+0x71d/0x7e3
[ 1288.046063] EAX: f564dbb4 EBX: fffffff9 ECX: c15295c9 EDX: 00000000
[ 1288.046063] ESI: c1728354 EDI: f564db40 EBP: ef947c84 ESP: ef947c40
[ 1288.046063]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[ 1288.046063] Process openvasd (pid: 8202, ti=ef946000 task=f6383160
task.ti=ef946000)
[ 1288.046063] Stack:
[ 1288.046063]  00000001 f27e0c00 f564db54 000102c0 00000000 ef947c60
f27e0c20 c1e82054
[ 1288.046063] <0> 000102d4 c13ed452 f27e0b00 0000fd00 efabf2b0
00000003 00000003 f27e0c00
[ 1288.046063] <0> 00000003 ef947c94 c145c022 c17be034 ef947cd8
ef947cb8 c14103bc f7316120
[ 1288.046063] Call Trace:
[ 1288.046063]  [<c13ed452>] ? sock_def_write_space+0x8b/0x93
[ 1288.046063]  [<c145c022>] ? ipv4_conntrack_defrag+0x50/0x76
[ 1288.046063]  [<c14103bc>] ? nf_iterate+0x34/0x67
[ 1288.046063]  [<c143e3f8>] ? dst_output+0x0/0x10
[ 1288.046063]  [<c1410579>] ? nf_hook_slow+0x5e/0xca
[ 1288.046063]  [<c143e3f8>] ? dst_output+0x0/0x10
[ 1288.046063]  [<c143ecb0>] ? raw_sendmsg+0x547/0x6e9
[ 1288.046063]  [<c143e3f8>] ? dst_output+0x0/0x10
[ 1288.046063]  [<c1446fee>] ? inet_sendmsg+0x40/0x4d
[ 1288.046063]  [<c13ea5e2>] ? __sock_sendmsg+0x4a/0x53
[ 1288.046063]  [<c13eadcc>] ? sock_sendmsg+0xbd/0xd3
[ 1288.046063]  [<c104bf24>] ? autoremove_wake_function+0x0/0x38
[ 1288.046063]  [<c10ab522>] ? might_fault+0x47/0x81
[ 1288.046063]  [<c122dd24>] ? copy_from_user+0x2f/0x117
[ 1288.046063]  [<c13eb787>] ? move_addr_to_kernel+0x3e/0x46
[ 1288.046063]  [<c13eb883>] ? sys_sendto+0xf4/0x12d
[ 1288.046063]  [<c10ab522>] ? might_fault+0x47/0x81
[ 1288.046063]  [<c10ab522>] ? might_fault+0x47/0x81
[ 1288.046063]  [<c13ec268>] ? sys_socketcall+0xf1/0x193
[ 1288.046063]  [<c1002bdb>] ? sysenter_do_call+0x12/0x32
[ 1288.046063] Code: e2 fd ff bb f9 ff ff ff 85 c0 74 1c 8d 47 74 bb
f9 ff ff ff 50 68 54 83 72 c1 e8 37 36 10 00 5e 58 eb 05 bb f4 ff ff
ff 8b 55 cc <8b> 82 a0 03 00 00 64 8b 15 4c 69 85 c1 8b 80 94 00 00 00
03 04
[ 1288.046063] EIP: [<c1424046>] ip_defrag+0x71d/0x7e3 SS:ESP
0068:ef947c40
[ 1288.046063] CR2: 00000000000003a0
[ 1290.945085] ---[ end trace 67211354562061a6 ]---



Reading symbols from /usr/src/linux-2.6.32-rc8/vmlinux...done.
(gdb) p ip_defrag
$1 = {int (struct sk_buff *, u32)} 0xc1423929 <ip_defrag>
(gdb) l *(0xc1423929+0x71d)
0xc1424046 is in ip_defrag (net/ipv4/ip_fragment.c:566).
561     out_oversize:
562             if (net_ratelimit())
563                     printk(KERN_INFO "Oversized IP packet from %pI4.\n",
564                             &qp->saddr);
565     out_fail:
566             IP_INC_STATS_BH(dev_net(dev), IPSTATS_MIB_REASMFAILS);
567             return err;
568     }
569
570     /* Process an incoming IP datagram fragment. */

hmm.  that shows a patch of code which is just prior to ip_defrag(), i.e.:

    565 out_fail:
    566         IP_INC_STATS_BH(dev_net(dev), IPSTATS_MIB_REASMFAILS);
    567         return err;
    568 }
    569
    570 /* Process an incoming IP datagram fragment. */
    571 int ip_defrag(struct sk_buff *skb, u32 user)
    572 {
    573         struct ipq *qp;
    574         struct net *net;



objdump –disassemble foo.o
00000000 <foo>:
   0:   e2 fd                   loop   ffffffff <foo+0xffffffff>
   2:   ff                      (bad)
   3:   bb f9 ff ff ff          mov    $0xfffffff9,%ebx
   8:   85 c0                   test   %eax,%eax
   a:   74 1c                   je     28 <foo+0x28>
   c:   8d 47 74                lea    0x74(%edi),%eax
   f:   bb f9 ff ff ff          mov    $0xfffffff9,%ebx
  14:   50                      push   %eax
  15:   68 54 83 72 c1          push   $0xc1728354
  1a:   e8 37 36 10 00          call   103656 <foo+0x103656>
  1f:   5e                      pop    %esi
  20:   58                      pop    %eax
  21:   eb 05                   jmp    28 <foo+0x28>
  23:   bb f4 ff ff ff          mov    $0xfffffff4,%ebx
  28:   8b 55 cc                mov    -0x34(%ebp),%edx
  2b:   8b 82 a0 03 00 00       mov    0x3a0(%edx),%eax
  31:   64 8b 15 4c 69 85 c1    mov    %fs:0xc185694c,%edx
  38:   8b 80 94 00 00 00       mov    0x94(%eax),%eax
  3e:   03                      .byte 0x3
  3f:   04                      .byte 0x4


out_fail:
 a8e:   bb f4 ff ff ff          mov    $0xfffffff4,%ebx
        IP_INC_STATS_BH(dev_net(dev), IPSTATS_MIB_REASMFAILS);
 a93:   8b 55 cc                mov    -0x34(%ebp),%edx
 a96:   8b 82 a0 03 00 00       mov    0x3a0(%edx),%eax
 a9c:   64 8b 15 00 00 00 00    mov    %fs:0x0,%edx
 aa3:   8b 80 94 00 00 00       mov    0x94(%eax),%eax
 aa9:   03 04 95 00 00 00 00    add    0x0(,%edx,4),%eax
 ab0:   ff 40 44                incl   0x44(%eax)
 ab3:   eb 52                   jmp    b07 <ip_defrag+0x78e>



Linux bocava01 2.6.32-rc8-VSE #1 SMP Wed Nov 25 02:22:27 EST 2009 i686
Intel(R) Xeon(TM) CPU 2.40GHz GenuineIntel GNU/Linux

Gnu C                  4.3.4
Gnu make               3.81
binutils               2.20
util-linux             2.16.1
mount                  support
module-init-tools      3.11
e2fsprogs              1.41.9
Linux C Library        2.11
Dynamic linker (ldd)   2.11
Procps                 3.2.8
Net-tools              1.60
Kbd                    1.15.1
Sh-utils               7.6
Modules Loaded         iTCO_wdt iTCO_vendor_support fuse ext2 raid10
raid456 async_raid6_recov async_memcpy async_pq async_xor xor async_tx
raid6_pq raid1 raid0 md_mod dm_snapshot dm_crypt dm_mirror
dm_region_hash dm_log dm_mod scsi_wait_scan
