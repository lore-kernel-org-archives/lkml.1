Return-Path: <linux-kernel-owner+w=401wt.eu-S1760771AbXJSLUu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760771AbXJSLUu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 07:20:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751320AbXJSLUn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 07:20:43 -0400
Received: from rv-out-0910.google.com ([209.85.198.188]:22651 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751081AbXJSLUm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 07:20:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=ijfBVVsIIGi0oeOPss6Q7vUicS+zYohhybORr5VdJUv43v9BR7Rdc/Vugkn8DYKz7wQFG60X5nloH09R9raaaC9cVDGfHgmMHnK58aMGLXiGLMQPRhFQ9ojAGfiNnpqviCrLuFMbaMrmEbjj/RI+U4V8/IKEqmlAH4Se5S9ZanM=
Message-ID: <602211f80710190420j3c71fca5ka4ffe94db0009256@mail.gmail.com>
Date: Fri, 19 Oct 2007 13:20:41 +0200
From: "Romano Giannetti" <romano.giannetti@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: [REGRESSION] locks with v2.6.23-5734-gd85714d (suspend- or bio- related?)
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

        I was testing yesterday release of kernel, and I have had a lot of
problem with the new kernel. It boots ok, the first time it
suspend/resume ok, and then at the second or third attempt to suspend,
the suspend process will not go though (I suspend using s2ram -f
-p -m); it will just lock the screen (I think that's in Ubuntu
scripts) and nothing more. Coming back, there is a message of
the style "DBUS locked up, but recovered" (if you need more
precise information tell me and I'll do my best).

After that, sometime there are processes that go to D state forever... one
sure form os triggering it here is to try to do "sudo something". At this
point, no new windows opens in gnome; switching to a VT works, and I can
start a shutdown, but it locks saying something on the line "soft lockup on
CPU#0 detected, 11 seconds stall" forever. I need to d a SysRq-B to restart.

I got a track of locked processes with SysRq-T. The common denominator
is __mutex_lock_slowpath() here. I do not know if the system fails to
suspend given that problem or the other way around.

2.6.23 worked like a charm. The system is a toshiba laptop
A305-S5077, sata disk, pretty standard I think.


Greetings,
        Romano

First time, one process in D state:

[   52.876178] sudo          D 00000000     0  6913   6179
[   52.876182]        c29d01f0 00000086 00000000 00000000 c01a42b7
c012105c c29d0324 c17fba00
[   52.876193]        c0433080 c0433080 c0433080 0007a120 00000000
0007a120 00000000 eec8a6ec
[   52.876204]        ffffffff c03c3c94 c03c3c9c c03c3c98 c29d01f0
c02ed645 c2d3dd3c cab39ec0
[   52.876215] Call Trace:
[   52.876219]  [bio_add_page+55/80] bio_add_page+0x37/0x50
[   52.876225]  [__load_balance_iterator+28/48]
__load_balance_iterator+0x1c/0x30
[   52.876237]  [__mutex_lock_slowpath+85/144] __mutex_lock_slowpath+0x55/0x90
[   52.876245]  [mutex_lock+20/32] mutex_lock+0x14/0x20
[   52.876250]  [rtnetlink_rcv+8/32] rtnetlink_rcv+0x8/0x20
[   52.876257]  [netlink_unicast+502/544] netlink_unicast+0x1f6/0x220
[   52.876262]  [copy_from_user+46/112] copy_from_user+0x2e/0x70
[   52.876269]  [memcpy_fromiovec+56/80] memcpy_fromiovec+0x38/0x50
[   52.876277]  [netlink_sendmsg+485/704] netlink_sendmsg+0x1e5/0x2c0
[   52.876290]  [sock_sendmsg+273/304] sock_sendmsg+0x111/0x130
[   52.876302]  [autoremove_wake_function+0/80]
autoremove_wake_function+0x0/0x50
[   52.876309]  [__wait_on_bit_lock+91/112] __wait_on_bit_lock+0x5b/0x70
[   52.876316]  [__lock_page+115/128] __lock_page+0x73/0x80
[   52.876326]  [find_lock_page+47/176] find_lock_page+0x2f/0xb0
[   52.876334]  [filemap_fault+498/1024] filemap_fault+0x1f2/0x400
[   52.876340]  [netlink_insert+206/336] netlink_insert+0xce/0x150
[   52.876347]  [copy_from_user+46/112] copy_from_user+0x2e/0x70
[   52.876355]  [sys_sendto+307/384] sys_sendto+0x133/0x180
[   52.876362]  [__do_fault+534/1008] __do_fault+0x216/0x3f0
[   52.876375]  [handle_mm_fault+280/1824] handle_mm_fault+0x118/0x720
[   52.876383]  [sock_attach_fd+128/192] sock_attach_fd+0x80/0xc0
[   52.876396]  [sys_socketcall+408/640] sys_socketcall+0x198/0x280
[   52.876407]  [sysenter_past_esp+107/161] sysenter_past_esp+0x6b/0xa1

Second time:


[  129.820154] sudo          D cae8fd20     0  7562   6096
[  129.820163]        c257f630 00000082 00000002 cae8fd20 cae8fd18
00000000 c257f764 c17fba00
[  129.820181]        c0433080 c0433080 c0433080 000170e3 00000000
000000ff 00000000 00000000
[  129.820199]        00000000 c03c3c94 c03c3c9c c03c3c98 c257f630
c02ed645 c27f9d3c c2e07d3c
[  129.820217] Call Trace:
[  129.820240]  [__mutex_lock_slowpath+85/144] __mutex_lock_slowpath+0x55/0x90
[  129.820258]  [mutex_lock+20/32] mutex_lock+0x14/0x20
[  129.820267]  [rtnetlink_rcv+8/32] rtnetlink_rcv+0x8/0x20
[  129.820278]  [netlink_unicast+502/544] netlink_unicast+0x1f6/0x220
[  129.820290]  [copy_from_user+46/112] copy_from_user+0x2e/0x70
[  129.820302]  [memcpy_fromiovec+56/80] memcpy_fromiovec+0x38/0x50
[  129.820316]  [netlink_sendmsg+485/704] netlink_sendmsg+0x1e5/0x2c0
[  129.820342]  [sock_sendmsg+273/304] sock_sendmsg+0x111/0x130
[  129.820367]  [autoremove_wake_function+0/80]
autoremove_wake_function+0x0/0x50
[  129.820396]  [find_lock_page+47/176] find_lock_page+0x2f/0xb0
[  129.820411]  [filemap_fault+498/1024] filemap_fault+0x1f2/0x400
[  129.820420]  [netlink_insert+206/336] netlink_insert+0xce/0x150
[  129.820434]  [copy_from_user+46/112] copy_from_user+0x2e/0x70
[  129.820450]  [sys_sendto+307/384] sys_sendto+0x133/0x180
[  129.820461]  [__do_fault+534/1008] __do_fault+0x216/0x3f0
[  129.820488]  [handle_mm_fault+280/1824] handle_mm_fault+0x118/0x720
[  129.820502]  [sock_attach_fd+128/192] sock_attach_fd+0x80/0xc0
[  129.820528]  [sys_socketcall+408/640] sys_socketcall+0x198/0x280
[  129.820548]  [sysenter_past_esp+107/161] sysenter_past_esp+0x6b/0xa1
[  129.820574]  =======================

[  205.438026] sudo          D cae8fd20     0  7562   6096
[  205.438032]        c257f630 00000082 00000002 cae8fd20 cae8fd18
00000000 c257f764 c17fba00
[  205.438044]        c0433080 c0433080 c0433080 000170e3 00000000
000000ff 00000000 00000000
[  205.438055]        00000000 c03c3c94 c03c3c9c c03c3c98 c257f630
c02ed645 c27f9d3c c2e07d3c
[  205.438066] Call Trace:
[  205.438088]  [__mutex_lock_slowpath+85/144] __mutex_lock_slowpath+0x55/0x90
[  205.438103]  [mutex_lock+20/32] mutex_lock+0x14/0x20
[  205.438111]  [rtnetlink_rcv+8/32] rtnetlink_rcv+0x8/0x20
[  205.438119]  [netlink_unicast+502/544] netlink_unicast+0x1f6/0x220
[  205.438128]  [copy_from_user+46/112] copy_from_user+0x2e/0x70
[  205.438139]  [memcpy_fromiovec+56/80] memcpy_fromiovec+0x38/0x50
[  205.438150]  [netlink_sendmsg+485/704] netlink_sendmsg+0x1e5/0x2c0
[  205.438174]  [sock_sendmsg+273/304] sock_sendmsg+0x111/0x130
[  205.438197]  [autoremove_wake_function+0/80]
autoremove_wake_function+0x0/0x50
[  205.438222]  [find_lock_page+47/176] find_lock_page+0x2f/0xb0
[  205.438235]  [filemap_fault+498/1024] filemap_fault+0x1f2/0x400
[  205.438242]  [netlink_insert+206/336] netlink_insert+0xce/0x150
[  205.438253]  [copy_from_user+46/112] copy_from_user+0x2e/0x70
[  205.438266]  [sys_sendto+307/384] sys_sendto+0x133/0x180
[  205.438275]  [__do_fault+534/1008] __do_fault+0x216/0x3f0
[  205.438299]  [handle_mm_fault+280/1824] handle_mm_fault+0x118/0x720
[  205.438312]  [sock_attach_fd+128/192] sock_attach_fd+0x80/0xc0
[  205.438335]  [sys_socketcall+408/640] sys_socketcall+0x198/0x280
[  205.438354]  [sysenter_past_esp+107/161] sysenter_past_esp+0x6b/0xa1
[  205.438377]  =======================
