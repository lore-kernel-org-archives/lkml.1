Return-Path: <linux-kernel-owner+w=401wt.eu-S932074AbXCMSST@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932074AbXCMSST (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 14:18:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932067AbXCMSST
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 14:18:19 -0400
Received: from wr-out-0506.google.com ([64.233.184.228]:31883 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753308AbXCMSSS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 14:18:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=MWyyNF/uQnXUV1dqxrER46SolMjYXpdXMPBnwyYwKRfDrOQVbYTwKGHxWHCBrGRvX5C2v26mZkY46o6gYqi5z4Ppt6z9+zTIkgu8/OzehZG+xjKwVzkPPlLNugZt281qGAjiMSHuni9+967IZ3eL1QE+YE/AhHnOh+k1AeOY6h8=
Date: Tue, 13 Mar 2007 21:18:15 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org
Subject: /proc/kallsyms race vs module unload
Message-ID: <20070313181815.GA5580@martell.zuzino.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Steps to reproduce:

	while true; do modprobe xfs; rmmod xfs; done
		vs
	while true; do cat /proc/kallsyms >/dev/null; done


[where xfs could be any module, I haven't tried]

BUG: unable to handle kernel paging request at virtual address e19f808c
 printing eip:
c01dc361
*pde = 1ff5f067
*pte = 00000000
Oops: 0000 [#1]
PREEMPT
Modules linked in:
CPU:    0
EIP:    0060:[<c01dc361>]    Not tainted VLI
EFLAGS: 00010297   (2.6.21-rc3-8b9909ded6922c33c221b105b26917780cfa497d #2)
EIP is at vsnprintf+0x2af/0x48c
eax: e19f808c   ebx: ffffffff   ecx: e19f808c   edx: fffffffe
esi: dbe7aa84   edi: dbe2bf3c   ebp: ffffffff   esp: dbe2bec4
ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
Process cat (pid: 7242, ti=dbe2b000 task=df5790b0 task.ti=dbe2b000)
Stack: e19d6fde 00000000 00000010 00000008 ffffffff 00000001 00000598 dbe7aa68
       0002f362 00000010 dbe7b000 00000000 ffffffff c034bbe0 dbe7aa68 dfd31880
       dfa31e80 00001000 c01586b0 dbe2bf2c dbe2bf2c dfd31880 dfd31880 c01289f6
Call Trace:
 [<c01586b0>] seq_printf+0x2e/0x4b
 [<c01289f6>] s_show+0x4b/0x7f
 [<c0158c6e>] seq_read+0x196/0x278
 [<c0158ad8>] seq_read+0x0/0x278
 [<c0143c35>] vfs_read+0x72/0x93
 [<c0143f1c>] sys_read+0x41/0x67
 [<c0102486>] sysenter_past_esp+0x5f/0x85
 =======================
Code: 74 24 28 73 03 c6 06 20 46 4d 85 ed 7f f1 e9 b9 00 00 00 8b 0f 81 f9 ff 0f 00 00 b8 ea 45 36 c0 0f 46 c8 8b 54 24 30 89 c8 eb 06 <80> 38 00 74 07 40 4a 83 fa ff 75 f4 29 c8 89 c3 89 e8 f6 44 24
EIP: [<c01dc361>] vsnprintf+0x2af/0x48c SS:ESP 0068:dbe2bec4



What happens is that module_get_kallsym() drops module_mutex,
returns "struct module *", module unloaded, "struct module *"
used.

