Return-Path: <linux-kernel-owner+w=401wt.eu-S1755893AbYHGRLf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755893AbYHGRLf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 13:11:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753086AbYHGRLO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 13:11:14 -0400
Received: from oslproxyp1.tandberg.com ([194.0.215.2]:34932 "EHLO
	oslproxyp1.tandberg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752778AbYHGRLL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 13:11:11 -0400
X-Greylist: delayed 611 seconds by postgrey-1.27 at vger.kernel.org; Thu, 07 Aug 2008 13:11:11 EDT
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Subject: OOPS, ip -f inet6 route get fec0::1, linux-2.6.26, ip6_route_output, rt6_fill_node+0x175
Date: Thu, 7 Aug 2008 19:00:56 +0200
Message-ID: <9F6ACAE02B6DD040A1E259977622CFDB033590C3@oslexcp1.eu.tandberg.int>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: OOPS, ip -f inet6 route get fec0::1, linux-2.6.26, ip6_route_output, rt6_fill_node+0x175
Thread-Index: Acj4ryivieZHj4/eSxyA1rTV+RDuiQ==
From: "John Gumb" <john.gumb@tandberg.com>
To: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 07 Aug 2008 17:00:57.0612 (UTC) FILETIME=[294FCCC0:01C8F8AF]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Folks

Looks like we have an issue with linux-2.6.26 & ipv6

Scenario: no ipv6 default route set.

Repro: Enter command 

# ip -f inet6 route get fec0::1

And we get BUG: unable to handle kernel NULL pointer deref....

This has been an issue since linux-2.6.26-rc4. It's taken a while to
nail it. We are currently testing linux-2.6.26.2.

This appears to have been an issue in the past. This is where I got the
magic ip route command from.

http://www.ussg.iu.edu/hypermail/linux/kernel/0510.2/0522.html

http://www.ussg.iu.edu/hypermail/linux/kernel/0510.2/0535.html

http://www.ussg.iu.edu/hypermail/linux/kernel/0510.2/1522.html

~ # ip -f inet6 route get fec0::1

Produces, with linux-2.6.26.2,

BUG: unable to handle kernel NULL pointer dereference at 00000000

IP: [<c0369b85>] rt6_fill_node+0x175/0x3b0

*pdpt = 0000000036466001 *pde = 0000000000000000

Oops: 0000 [#1] SMP

Modules linked in: pcnet32 smsc47m192 i2c_i801 i2c_dev i2c_core r8169
coretemp i
t87 hwmon_vid lcm e1000e

 

Pid: 3033, comm: ip Not tainted (2.6.26.2 #1)

EIP: 0060:[<c0369b85>] EFLAGS: 00010246 CPU: 1

EIP is at rt6_fill_node+0x175/0x3b0

EAX: 00000000 EBX: f7115bbc ECX: 00000000 EDX: f7115c60

ESI: f7c1f100 EDI: f7548f00 EBP: f7115bdc ESP: f7115ba4

 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068

Process ip (pid: 3033, ti=f7114000 task=f64cbc50 task.ti=f7114000)

Stack: f7115bbc 00000000 f7115c54 f7115bc0 f7115c60 f6d75078 00000000
f7115bdc  
       c036a5f0 c036b360 00000000 f75487a0 00000000 f7548f00 f7115c9c
c036c30e  
       f7115c70 00000000 00000018 00000bd9 489b2024 00000000 00000000
00000000  
Call Trace:

 [<c036a5f0>] ? ip6_route_output+0x50/0xa0

 [<c036b360>] ? ip6_pol_route_output+0x0/0x20

 [<c036c30e>] ? inet6_rtm_getroute+0x16e/0x200

 [<c036c1a0>] ? inet6_rtm_getroute+0x0/0x200

 [<c030ef19>] ? rtnetlink_rcv_msg+0x1b9/0x1f0

 [<c030ed60>] ? rtnetlink_rcv_msg+0x0/0x1f0

 [<c031426d>] ? netlink_rcv_skb+0x8d/0xb0

 [<c030ed57>] ? rtnetlink_rcv+0x17/0x20

 [<c031402d>] ? netlink_unicast+0x23d/0x270

 [<c030162a>] ? memcpy_fromiovec+0x4a/0x70

 [<c0314811>] ? netlink_sendmsg+0x1c1/0x290

 [<c02fa165>] ? sock_sendmsg+0xc5/0xf0

 [<c01363a0>] ? autoremove_wake_function+0x0/0x50

 [<c01363a0>] ? autoremove_wake_function+0x0/0x50

 [<c02fa165>] ? sock_sendmsg+0xc5/0xf0

 [<c0217f37>] ? copy_from_user+0x37/0x70

 [<c03018ec>] ? verify_iovec+0x2c/0x90

 [<c02fa29a>] ? sys_sendmsg+0x10a/0x220

 [<c015ab08>] ? __inc_zone_page_state+0x18/0x20

 [<c01642ed>] ? __page_set_anon_rmap+0x2d/0x40

 [<c0164325>] ? page_add_new_anon_rmap+0x25/0x30

 [<c015eda6>] ? handle_mm_fault+0x606/0x750

 [<c0160f5e>] ? vma_adjust+0xfe/0x410

 [<c0113156>] ? do_page_fault+0x126/0x830

 [<c02fb343>] ? sys_socketcall+0x233/0x260

 [<c0102f39>] ? sysenter_past_esp+0x6a/0x91

 =======================

Code: 62 01 00 00 c6 43 01 80 8b 45 0c 85 c0 0f 85 13 02 00 00 8b 45 d8
85 c0 74
 3c 8b 86 88 00 00 00 8d 5d e0 31 c9 89 1c 24 8b 55 d8 <8b> 00 e8 d4 e3
ff ff 85
 c0 75 20 b9 10 00 00 00 ba 07 00 00 00

EIP: [<c0369b85>] rt6_fill_node+0x175/0x3b0 SS:ESP 0068:f7115ba4

---[ end trace e9f2563374550ae8 ]---


I will look into producing a patch.

Best regards

John Gumb 
