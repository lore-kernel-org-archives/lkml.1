Return-Path: <linux-kernel-owner+w=401wt.eu-S1422710AbXCBByR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422710AbXCBByR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 20:54:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422716AbXCBByR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 20:54:17 -0500
Received: from nf-out-0910.google.com ([64.233.182.186]:33762 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422715AbXCBByQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 20:54:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=j6qrT1q54NfhQYoLLWXc17e/G3TX4gKwcCReA7ogKm0I+pAY6b3ezBxOtQRCgLDqqu85rLk5lttfGSM71NdhOEbqRBHssKmjXwAY+vetrHqlWz4QIxEVJM6EBmnBRYPF24xhHyni+hTCZ7GGODdkKNLCAgSRBFVYKEO+VznmTFQ=
Message-ID: <a10e25a30703011754s65c28271v60f0a2849b3bea08@mail.gmail.com>
Date: Thu, 1 Mar 2007 17:54:01 -0800
From: "Kunal Trivedi" <ktrivedilkml@gmail.com>
To: linuxkernel <linux-kernel@vger.kernel.org>,
       "Maneesh Soni" <maneesh@in.ibm.com>,
       "Steven Rostedt" <rostedt@goodmis.org>
Subject: Kernel Null pointer dereference in sysfs_readdir()
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
I have experienced kernel OOPS in sysfs_readdir. Below is some
information about kernel version, debugging, some other reports of
OOPS. At the end of the mail I am attaching OOPS.

I also have kernel dump via which I could traverse sysfs_dirent list,
and also see dentry. (Analysis is in #4).

I could not figure out how that happen, just by reading code as most
of the things are under inode lock. But there could be some race which
is causing this crash.

#########################################################
1) SMP box with 4GB physical memory.
2) kernel is 2.6.9-34-EL (CentOS)
NOTE: I know its old kernel. But I've compared fs/sysfs code from that
kernel to latest and code had not been changed fundamentally.
Especially OOPS I've got, is very similar to other people have
reported and that portion of code had not been changed.

3) Digging archive, I've found following to threads which reports
similar issue. (Esepcially 2nd link). Though fixes commited for those
problems still not clerify situation I have encountered.
http://lkml.org/lkml/2005/11/23/101
http://lkml.org/lkml/2006/7/12/281

4) Debugging: (Oops message at the end.. And if needed, I can provide
kernel dump files)
EIP:    0060:[<e01a40c9>]
Code arround EIP is
0xe01a40b7 :   movl   %ecx,0x14(%esp,1)
0xe01a40bb :   movl   0x20(%esi),%eax
0xe01a40be :   testl  %eax,%eax
0xe01a40c0 :   je     0xe01a41e8 <sysfs_readdir+504>
0xe01a40c6 :   movl   0x10(%eax),%eax
0xe01a40c9 :   movl   0x18(%eax),%edx <----------------------Crashed Here.

Now, If i traverse sysfs_dirent from 'struct file *', I see following..
struct file *filep = ed6e7280;
And sysfs_dirent are....
1) 0xf7ddbbc0
2) 0xf7d6b100
3) 0xf7d6cc88
4) 0xf7d6fe80

1, 2 and 4 all have count = 1.
 'esi' = 0xf7d6b100  which is pointer to the sysfs_dirent

>> p *(struct sysfs_dirent *)0xf7d6b100
struct sysfs_dirent {
        s_count = atomic_t {
                counter = 1
        }
        s_sibling = struct list_head {
                next = 0xf7d6cc8c
                prev = 0xf7ddbbc4
        }
        s_children = struct list_head {
                next = 0xf7d6b10c
                prev = 0xf7d6b10c
        }
        s_element = 0xf76ed280
        s_type = 32
        s_mode = 41471
        s_dentry = (nil)        <----------------------------------
This is null....
}

But disass of sysfs_readdir(), shows that this is not possible
otherwise 'testl' would be true and it should have jumped to
sysfs_readdir() + 504 address. But testl succeeded, Not only that, we
dereference that pointer and got d_inode
#### Code #####
if (next->s_dentry)
   ino = next->s_dentry->d_inode->i_ino

but then while accessing d_inode (to get i_ino), it crashed.

That means, at one point s_dentry was NON-NULL. And next memonet it
became NULL and its inode has gone, causing this OOPS.

5) OOPS messages from console.
    <1>Unable to handle kernel NULL pointer dereference at virtual
address 00000018
    <1> printing eip:
    <4>e01a40c9
    <1>*pde = 00000000
    <1>Oops: 0000 [#1]
    <4>SMP
    <4>Modules linked in: ipt_state ip_conntrack iptable_filter
cls_u32 iptable_mangle lm85 i2c_i801 w83627hf_wdt w83627hf i2c_sensor
i2c_isa i2c_core slcmi ip_tables e7xxx_edac edac_mc
    <4>CPU:    2
    <4>EIP:    0060:[<e01a40c9>]    Tainted: PF     VLI
    <4>EFLAGS: 00010286   (2.6.9-34.EL-i386_SMP)
    <4>EIP is at sysfs_readdir+0xd9/0x210
    <4>eax: 00000000   ebx: f7d6b104   ecx: 00000006   edx: 00000020
    <4>esi: f7d6b100   edi: f7f1cb87   ebp: f7f1cb80   esp: ef432f48
    <4>ds: 007b   es: 007b   ss: 0068
    <4>Process sensors (pid: 2933, threadinfo=ef432000 task=f562c030)
    <4>Stack: 00000002 00000000 016c32f7 0000000a f7d6cc8c 00000006
f7ddbbc4 e017a670
    <4>       ef432fa0 ed6e7280 e0409ba0 ed6e7280 f6f180b0 f6f18120
e017a33f ef432fa0
    <4>       e017a670 09ce61b4 ed6e7280 fffffff7 00000000 e017a81e
09ce6204 09ce61e4
    <4>Call Trace:
    <4> [<e017a670>] filldir64+0x0/0x140
    <4> [<e017a33f>] vfs_readdir+0xaf/0xd0
    <4> [<e017a670>] filldir64+0x0/0x140
    <4> [<e017a81e>] sys_getdents64+0x6e/0xb6
    <4> [<e039bb5f>] syscall_call+0x7/0xb
    <4>Code: 26 00 89 f0 e8 89 e8 ff ff 89 c5 b9 ff ff ff ff 31 c0 89
ef f2 ae f7 d1 49 89 4c 24 14 8b 46 20 85 c0 0f 84 22 01 00 00 8b 40
10 <8b> 50 18 0f b7 46 1c 89 54 24 08 8b 4c 24 24 c1 e8 0c 89 44 24

Please advice.

Thanks
-Kunal
