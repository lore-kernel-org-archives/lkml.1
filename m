Return-Path: <linux-kernel-owner+w=401wt.eu-S933604AbXEMNSX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933604AbXEMNSX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 09:18:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760430AbXEMNSO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 09:18:14 -0400
Received: from dtp.xs4all.nl ([80.126.206.180]:34513 "HELO abra2.bitwizard.nl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1760414AbXEMNSK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 09:18:10 -0400
Date: Sun, 13 May 2007 15:18:07 +0200
From: Rogier Wolff <R.E.Wolff@BitWizard.nl>
To: linux-kernel@vger.kernel.org
Subject: Nbd problem now oopses. 
Message-ID: <20070513131807.GA10663@bitwizard.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: BitWizard.nl
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,


After turning on the debugging for allocations and locks, I 
now get a kernel ooops. 


[ 5628.608000] BUG: unable to handle kernel NULL pointer dereference at virtual address 00000000
[ 5628.608000]  printing eip:
[ 5628.608000] c0293210
[ 5628.608000] *pde = 00000000
[ 5628.608000] Oops: 0002 [#1]
[ 5628.608000] Modules linked in: nbd
[ 5628.608000] CPU:    0
[ 5628.608000] EIP:    0060:[<c0293210>]    Not tainted VLI
[ 5628.608000] EFLAGS: 00010246   (2.6.21 #8)
[ 5628.608000] EIP is at tcp_sendmsg+0x726/0xab3
[ 5628.608000] eax: 00000000   ebx: c24576b8   ecx: 00000000   edx: 00000000
[ 5628.608000] esi: c30a006c   edi: 00000840   ebp: 00000000   esp: c3f8fc5c
[ 5628.608000] ds: 007b   es: 007b   fs: 00d8  gs: 0000  ss: 0068
[ 5628.608000] Process kblockd/0 (pid: 34, ti=c3f8e000 task=c3f89550 task.ti=c3f8e000)
[ 5628.608000] Stack: 00000002 0000012b 00000001 00000046 0000000a c011ad49 00000000 c100dea0 
[ 5628.608000]        00000001 00000000 00000000 c2b2c7c0 00000840 000007c0 0000baa8 000005a8 
[ 5628.608000]        0000c000 00000000 c3f8fdf8 c3f8e000 00001000 7fffffff c03a3820 c30a006c 
[ 5628.608000] Call Trace:
[ 5628.608000]  [<c011ad49>] __do_softirq+0x35/0x73
[ 5628.608000]  [<c02ab61c>] inet_sendmsg+0x39/0x43
[ 5628.608000]  [<c026c744>] sock_sendmsg+0xbc/0xd4
...
[ 5628.608000] Code: d2 89 d5 74 26 83 be 80 01 00 00 00 0f 85 7b 03 00 00 c7 86 88 01 00 00 00 00 00 00 8b 5c 24 1c 89 9e 80 01 00 00 e9 62 03 00 00 [ 5628.608000] EIP: [<c0293210>] tcp_sendmsg+0x726/0xab3 SS:ESP 0068:c3f8fc5c


which seems to be: 

0xc02931f1 <tcp_sendmsg+1799>:  jne    0xc0293572 <tcp_sendmsg+2696>
0xc02931f7 <tcp_sendmsg+1805>:  movl   $0x0,0x188(%esi)
0xc0293201 <tcp_sendmsg+1815>:  mov    0x1c(%esp),%ebx
0xc0293205 <tcp_sendmsg+1819>:  mov    %ebx,0x180(%esi)
0xc029320b <tcp_sendmsg+1825>:  jmp    0xc0293572 <tcp_sendmsg+2696>

EIP points here: 
0xc0293210 <tcp_sendmsg+1830>:  cmpl   $0x0,0x24(%esp)
0xc0293215 <tcp_sendmsg+1835>:  mov    0x98(%ebx),%edx
0xc029321b <tcp_sendmsg+1841>:  je     0xc0293232 <tcp_sendmsg+1864>
0xc029321d <tcp_sendmsg+1843>:  mov    0x20(%esp),%ecx
0xc0293221 <tcp_sendmsg+1847>:  movzwl 0x12(%edx,%ecx,8),%eax
0xc0293226 <tcp_sendmsg+1852>:  add    %edi,%eax
0xc0293228 <tcp_sendmsg+1854>:  mov    %ax,0x12(%edx,%ecx,8)
0xc029322d <tcp_sendmsg+1859>:  jmp    0xc02932b4 <tcp_sendmsg+1994>


which is 

790                                 if (err) {
791                                         /* If this page was new, give it to the
792                                          * socket so it does not get leaked.
793                                          */
794                                         if (!TCP_PAGE(sk)) {
795                                                 TCP_PAGE(sk) = page;
796                                                 TCP_OFF(sk) = 0;
797                                         }
798                                         goto do_error;
799                                 }
800 
801                                 /* Update the skb. */

EIP Points here..... 
802                                 if (merge) {
803                                         skb_shinfo(skb)->frags[i - 1].size +=
804                                                                         copy;


and now the question is: How can the 
	cmpl   $0x0,0x24(%esp)
trap at address 0? 

How can "if (merge)" cause a segmentation fault?

If EIP is a bit off, it could be a line erarlier or further. So, could it
crash on the jmp tcp_sendmsg+2696? I dont' thinks so. 

How about "mov    0x98(%ebx),%edx"? If ebx is invalid, this should 
crash. (ebx apparently holds skb if I understand things correctly). 
But from the dump, ebx holds c24576b8, and if that's invalid it would
not say 
  BUG: unable to handle kernel NULL pointer dereference at virtual address 00000000
right?

	Roger. 

-- 
** R.E.Wolff@BitWizard.nl ** http://www.BitWizard.nl/ ** +31-15-2600998 **
**    Delftechpark 26 2628 XH  Delft, The Netherlands. KVK: 27239233    **
*-- BitWizard writes Linux device drivers for any device you may have! --*
Q: It doesn't work. A: Look buddy, doesn't work is an ambiguous statement. 
Does it sit on the couch all day? Is it unemployed? Please be specific! 
Define 'it' and what it isn't doing. --------- Adapted from lxrbot FAQ
