Return-Path: <linux-kernel-owner+w=401wt.eu-S1763521AbYENPeY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763521AbYENPeY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 11:34:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751302AbYENPeP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 11:34:15 -0400
Received: from E23SMTP05.au.ibm.com ([202.81.18.174]:37360 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751786AbYENPeO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 11:34:14 -0400
Message-ID: <482B066F.4010605@linux.vnet.ibm.com>
Date: Wed, 14 May 2008 21:04:07 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
User-Agent: Thunderbird 1.5.0.14ubu (X11/20080505)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       paulmck@linux.vnet.ibm.com, davem@davemloft.net,
       Andy Whitcroft <apw@shadowen.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: [BUG] 2.6.26-rc2-mm1 - kernel panic at inet_create() on powerpc
References: <20080514010129.4f672378.akpm@linux-foundation.org>
In-Reply-To: <20080514010129.4f672378.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

2.6.26-rc2-mm1 kernel panics on powerpc, while running ltp test over it.
I have attached the gdb output of the pc and lr registers. The patch
list_for_each_rcu-must-die-networking.patch points to changes made 
to the same lines listed by the gdb output.

 Unable to handle kernel paging request for data at address 0x00000000
Faulting instruction address: 0xc000000000481fa0
cpu 0x0: Vector: 300 (Data Access) at [c0000000eae37900]
    pc: c000000000481fa0: .inet_create+0xb4/0x330
    lr: c000000000413340: .__sock_create+0x190/0x280
    sp: c0000000eae37b80
   msr: 8000000000009032
   dar: 0
 dsisr: 40010000
  current = 0xc0000000cd201500
  paca    = 0xc0000000007c3480
    pid   = 6462, comm = socket01
enter ? for help
[c0000000eae37c30] c000000000413340 .__sock_create+0x190/0x280
[c0000000eae37cf0] c0000000004137e0 .sys_socket+0x40/0x98
[c0000000eae37d90] c000000000438e18 .compat_sys_socketcall+0xc0/0x234
[c0000000eae37e30] c0000000000086b4 syscall_exit+0x0/0x40
--- Exception: c01 (System Call) at 000000000ff20484
SP (ffc8f770) is in userspace


0xc000000000481fa0 is in inet_create (net/ipv4/af_inet.c:290).
285             /* Look for the requested type/protocol pair. */
286             answer = NULL;
287     lookup_protocol:
288             err = -ESOCKTNOSUPPORT;
289             rcu_read_lock();
290             list_for_each_entry_rcu(answer, &inetsw[sock->type], list) {
291
292                     /* Check the non-wild match. */
293                     if (protocol == answer->protocol) {
294                             if (protocol != IPPROTO_IP)


0xc000000000413340 is in __sock_create (net/socket.c:1171).
1166                    goto out_release;
1167
1168            /* Now protected by module ref count */
1169            rcu_read_unlock();
1170
1171            err = pf->create(net, sock, protocol);
1172            if (err < 0)
1173                    goto out_module_put;
1174
1175            /*

-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.
