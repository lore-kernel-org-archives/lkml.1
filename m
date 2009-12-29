Return-Path: <linux-kernel-owner+w=401wt.eu-S1752730AbZL2JFw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752730AbZL2JFw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 04:05:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752579AbZL2JFt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 04:05:49 -0500
Received: from mms3.broadcom.com ([216.31.210.19]:4081 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751642AbZL2JFp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 04:05:45 -0500
X-Server-Uuid: B55A25B1-5D7D-41F8-BC53-C57E7AD3C201
Subject: Re: BNX2: Kernel crashes with 2.6.31 and 2.6.31.9
From: "Benjamin Li" <benli@broadcom.com>
To: "Bruno =?ISO-8859-1?Q?Pr=E9mont?=" <bonbons@linux-vserver.org>
cc: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "Michael Chan" <mchan@broadcom.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20091229084929.54912c0c@pluto.restena.lu>
References: <20091229084929.54912c0c@pluto.restena.lu>
Date: Tue, 29 Dec 2009 01:05:40 -0800
Message-ID: <1262077540.12520.4.camel@localhost>
MIME-Version: 1.0
X-Mailer: Evolution 2.26.3
X-WSS-ID: 672719EF3J850715327-01-01
Content-Type: text/plain;
 charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bruno,

It looks like the the NULL dereference is happening at a0fc.

a0f8:       48 8b 42 70             mov 0x70(%rdx),%rax 
a0fc:       0f b7 10                movzwl (%rax),%edx
a0ff:       31 c0                   xor    %eax,%eax

The offset of 0x70 is the bp field in the bnx2_napi structure.  (Seen in
the bnx2_napi structure dump below)  These lines are found in the
routine, bnx2_get_hw_tx_cons() which look like they were inlined by the
compiler.  More specifically it looks like the dereference of the
hw_tx_cons_ptr failed.

cons = *bnapi->hw_tx_cons_ptr;

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=blob;f=drivers/net/bnx2.c;h=06b901152d4487fa04164437cc179661b44657fe;hb=74fca6a42863ffacaf7ba6f1936a9f228950f657#l2761

To be sure this is the case, could you send the .config file you are
using or if you could send me the bnx2 kernel module built with the
CFLAG '-g', then we can definitely verify where in the code it is
crashing.

Did you see anything suspicious in the system kernel logs?  If you could
isolate the logs from when the machine booted to when it crash and send
it to us it would be very helpful. 

Thanks again for your time.

-Ben


<--snip snip structure dump from pahole-->
struct bnx2_napi {
        struct napi_struct         napi;                 /*     0    96
*/
        /* --- cacheline 1 boundary (64 bytes) was 32 bytes ago --- */
        struct bnx2 *              bp;                   /*    96     8
*/
        union {
                struct status_block * msi;               /*           8
*/
                struct status_block_msix * msix;         /*           8
*/
        } status_blk;                                    /*   104     8
*/
        u16 *                      hw_tx_cons_ptr;       /*   112     8
*/
        u16 *                      hw_rx_cons_ptr;       /*   120     8
*/
        /* --- cacheline 2 boundary (128 bytes) --- */
        u32                        last_status_idx;      /*   128     4
*/
        u32                        int_num;              /*   132     4
*/
        struct bnx2_rx_ring_info   rx_ring;              /*   136   360
*/
        /* --- cacheline 7 boundary (448 bytes) was 48 bytes ago --- */
        struct bnx2_tx_ring_info   tx_ring;              /*   496    48
*/
        /* --- cacheline 8 boundary (512 bytes) was 32 bytes ago --- */

        /* size: 576, cachelines: 9 */
        /* padding: 32 */
};
<--snip snip-->

On Mon, 2009-12-28 at 23:49 -0800, Bruno Prémont wrote: 
> On a system that was running 2.6.31 since last September I got two
> crashes this December at night (cause unknown), yesterday after second
> crash I updated kernel to 2.6.31.9 and enabled netconsole in the hope
> to get some information about the cause of the crash.
> 
> Today system crashed once again and all I got is the following
> incomplete trace on the receiving side of netconsole:
> 
> [24701.841185] BUG: unable to handle kernel NULL pointer dereference at (null)
> [24701.841188] IP: [<ffffffffa00610fc>] bnx2_poll_work+0x2c/0x12d0 [bnx2]
> [24701.841197] PGD 16509067 PUD 4e776067 PMD 0
> [24701.841199] Oops: 0000 [#1] SMP
> [24701.841202] last sysfs file: /sys/kernel/uevent_seqnum
> [24701.841204] CPU 0
> [24701.841205] Modules linked in: ipmi_devintf squashfs ext2
> zlib_inflate netconsole configfs loop dm_round_robin scsi_dh_rdac
> dm_multipath scsi_dh dm_mod sg sr_mod cdrom ata_piix i pmi_si
> ipmi_msghandler qla2xxx ahci bnx2 hpwdt uhci_hcd ehci_hcd libata
> [24701.841218] Pid: 11273, comm: php-cgi Not tainted 2.6.31.9-x86_64 #1 ProLiant DL360 G5
> [24701.841220] RIP: 0010:[<ffffffffa00610fc>]  [<ffffffffa00610fc>] bnx2_poll_work+0x2c/0x12d0 [bnx2]
> 
> 
> Running objdump on the bnx2.ko module I get the following:
> 000000000000a0d0 <bnx2_poll_work>:
>     a0d0:       41 57                   push   %r15
>     a0d2:       41 56                   push   %r14
>     a0d4:       41 55                   push   %r13
>     a0d6:       41 54                   push   %r12
>     a0d8:       55                      push   %rbp
>     a0d9:       53                      push   %rbx
>     a0da:       48 81 ec 28 01 00 00    sub    $0x128,%rsp
>     a0e1:       48 89 7c 24 18          mov    %rdi,0x18(%rsp)
>     a0e6:       48 89 74 24 10          mov    %rsi,0x10(%rsp)
>     a0eb:       89 54 24 0c             mov    %edx,0xc(%rsp)
>     a0ef:       89 4c 24 08             mov    %ecx,0x8(%rsp)
>     a0f3:       48 8b 54 24 10          mov    0x10(%rsp),%rdx
>     a0f8:       48 8b 42 70             mov    0x70(%rdx),%rax
>     a0fc:       0f b7 10                movzwl (%rax),%edx
>     a0ff:       31 c0                   xor    %eax,%eax
>     a101:       48 8b 4c 24 10          mov    0x10(%rsp),%rcx
>     a106:       80 fa ff                cmp    $0xff,%dl
>     a109:       0f 94 c0                sete   %al
>     a10c:       01 c2                   add    %eax,%edx
>     a10e:       66 39 91 1a 02 00 00    cmp    %dx,0x21a(%rcx)
>     a115:       0f 84 78 01 00 00       je     a293 <bnx2_poll_work+0x1c3>
>     a11b:       48 8b 57 08             mov    0x8(%rdi),%rdx
>     a11f:       48 89 f8                mov    %rdi,%rax
>     a122:       48 8b 9a 00 03 00 00    mov    0x300(%rdx),%rbx
>     a129:       48 83 c0 40             add    $0x40,%rax
>     a12d:       48 29 c1                sub    %rax,%rcx
>     a130:       48 89 c8                mov    %rcx,%rax
>     a133:       48 c1 f8 06             sar    $0x6,%rax
>     a137:       69 c0 39 8e e3 38       imul   $0x38e38e39,%eax,%eax
>     a13d:       48 c1 e0 07             shl    $0x7,%rax
>     a141:       48 01 d8                add    %rbx,%rax
>     a144:       48 89 44 24 20          mov    %rax,0x20(%rsp)
>     a149:       48 8b 7c 24 10          mov    0x10(%rsp),%rdi
>     a14e:       48 8b 47 70             mov    0x70(%rdi),%rax
>     a152:       44 0f b7 30             movzwl (%rax),%r14d
>     a156:       31 c0                   xor    %eax,%eax
>     a158:       0f b7 9f 18 02 00 00    movzwl 0x218(%rdi),%ebx
>     a15f:       41 80 fe ff             cmp    $0xff,%r14b
>     a163:       0f 94 c0                sete   %al
>     a166:       45 31 ff                xor    %r15d,%r15d
>     a169:       41 01 c6                add    %eax,%r14d
>     a16c:       66 44 39 f3             cmp    %r14w,%bx
>     a170:       0f 84 ee 00 00 00       je     a264 <bnx2_poll_work+0x194>
>     a176:       66 2e 0f 1f 84 00 00    nopw   %cs:0x0(%rax,%rax,1)
>     a17d:       00 00 00 
>     a180:       0f b6 cb                movzbl %bl,%ecx
>     a183:       48 8b 44 24 10          mov    0x10(%rsp),%rax
>     a188:       44 0f b7 e1             movzwl %cx,%r12d
>     a18c:       49 c1 e4 04             shl    $0x4,%r12
>     a190:       4c 03 a0 10 02 00 00    add    0x210(%rax),%r12
>     a197:       4d 8b 2c 24             mov    (%r12),%r13
>     a19b:       66 41 83 7c 24 08 00    cmpw   $0x0,0x8(%r12)
>     a1a2:       41 0f 18 8d bc 00 00    prefetcht0 0xbc(%r13)
>     a1a9:       00 
>                 ...
> 
> 
> Kernel is compiled on Gentoo (64bit):
>   Linux version 2.6.31.9-x86_64 () (gcc version 4.3.4 (Gentoo 4.3.4 p1.0, pie-10.1.5) ) #1 SMP Mon Dec 28 15:49:16 CET 2009
> The affected server (HP DL360 G5) is running OpenSuSE-11.1,
> 32bit userspace
> 
> Any idea if there is a recent patch that could fix this issue? At the
> crashing time the server was not specifically loaded and had around
> 200 packets/s network traffic.
> 
> Regards,
> Bruno
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 


