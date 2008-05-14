Return-Path: <linux-kernel-owner+w=401wt.eu-S1761289AbYENFQ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761289AbYENFQ0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 01:16:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753452AbYENFQH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 01:16:07 -0400
Received: from mail128.messagelabs.com ([216.82.250.131]:35449 "HELO
	mail128.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1760674AbYENFQB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 01:16:01 -0400
X-VirusChecked: Checked
X-Env-Sender: HRX378@motorola.com
X-Msg-Ref: server-7.tower-128.messagelabs.com!1210742159!2207827!1
X-StarScan-Version: 5.5.12.14.2; banners=-,-,-
X-Originating-IP: [129.188.136.8]
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: memory corruption issues in wait_table of zone"DMA"
Date: Wed, 14 May 2008 13:15:55 +0800
Message-ID: <B23AF77AA6CA8E458CC272CE0D0CB2FE020BAAB6@zmy16exm62.ds.mot.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: memory corruption issues in wait_table of zone"DMA"
thread-index: Aci1c+jtw2tJ87+mQV+bT3QPEeO5XAADUZXw
From: "ZHANG XIAO-QIN-HRX378" <HRX378@motorola.com>
To: <linux-kernel@vger.kernel.org>
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 
We have reproduce several memory corruption issue,three of them panic at
wake_up_common,one is about hrtimer,the last one,we don't get the panic
pc,but we got it's full memory.After analysis,we find there are three
kinds of memory corruptions.
 
one of the panic log:
<4>PC is at 0xc035c5d0
<4>LR is at __wake_up_common+0x54/0x80
<4>pc : [<c035c5d0>]    lr : [<c003fc04>]    Tainted: PF    
<4>sp : c357fe90  ip : c035c094  fp : c357febc
<4>r10: 00000006  r9 : c357fee0  r8 : 00000000
<4>r7 : c035c0a0  r6 : c035c090  r5 : c035c0a8  r4 : 00000001
<4>r3 : c357fee0  r2 : 00000000  r1 : 00000006  r0 : c035c094
<4>Flags: Nzcv  IRQs off  FIQs on  Mode SVC_32  Segment kernel
<4>Control: E5387F  Table: 939B0018  DAC: 00000017
<4>Process mtdblockd (pid: 13, stack limit = 0xc357e198)
<4>Backtrace: 
<4>[<c003fbb0>] (__wake_up_common+0x0/0x80) from [<c003fc6c>]
(__wake_up+0x3c/0x6c)
<4>[<c003fc30>] (__wake_up+0x0/0x6c) from [<c005b8d4>]
(__wake_up_bit+0x38/0x40)
<4> r5 = 00000000  r4 = C371F1B0 
<4>[<c005b89c>] (__wake_up_bit+0x0/0x40) from [<c0081670>]
(end_buffer_read_sync+0x58/0x74)
<4>[<c0081618>] (end_buffer_read_sync+0x0/0x74) from [<c0082f7c>]
(end_bio_bh_io_sync+0x70/0x80)
<4> r4 = C35B47A0 
<4>[<c0082f0c>] (end_bio_bh_io_sync+0x0/0x80) from [<c0086708>]
(bio_endio+0x88/0x94)
<4> r5 = C0082F0C  r4 = C35B47A0 
<4>[<c0086680>] (bio_endio+0x0/0x94) from [<c014dae8>]
(__end_that_request_first+0xf8/0x1f4)
<4> r5 = C35B47A0  r4 = 00000400 
<4>[<c014d9f0>] (__end_that_request_first+0x0/0x1f4) from [<c014dd08>]
(end_request+0x18/0x74)
<4>[<c014dcf0>] (end_request+0x0/0x74) from [<c016de0c>]
(mtd_blktrans_thread+0x2d8/0x31c)
<4> r5 = 000129E2  r4 = 00000000 
<4>[<c016db34>] (mtd_blktrans_thread+0x0/0x31c) from [<c00463a0>]
(do_exit+0x0/0xd2c)
 
Below is the corrupted memory.It is the wait_table of zone "DMA"
after corruption:

0xc035e180:     0xc035e180      0xc035e180      0xc035e188
0xc035e188
0xc035e190:     0xc035e190      0xc035e190      0xc035e198
0xc035e198
0xc035e1a0:     0xc035e1a0      0xc035e1a0      0xc035e1a8
0xc035e1a8
0xc035e1b0:     0xc035e1b0      0xc035e1b0      0xc035e1b0
0xc035e1b0(this location should be 0xc035e1b8 or a pointer to a wait,but
0xc035e1b0 which caused this panic)
0xc035e1c0:     0xc035e1c0      0xc035e1c0      0xc035e1c8
0xc035e1c8
0xc035e1d0:     0xc035e1d0      0xc035e1d0      0xc035e1d8
0xc035e1d8

 
Do you have any idea about in which condition memory will be corrupted
like this?
 
By the way,there are three kinds of similar issues.
 
1.wait_table of zone "DMA" is corrupted.
 
before corruption:
0xc035c0a0:     0xc035c0a0      0xc035c0a0      0xc035c0a8
0xc035c0a8
0xc035c0b0:     0xc035c0b0      0xc035c0b0      0xc38c1b74
0xc38c1b74
 
after corruption:

0xc035c0a0:     0xc035c0a0      0xc035c0a0      0xc035c0a0
0xc035c0a0
0xc035c0b0:     0xc035c0a0      0xc035c0a0      0xc38c1b74
0xc38c1b74

 
2.irq_desc is corrupted.
 
before corruption:
 
0xc02a4120 <irq_desc+1980>:     0xc00260d8      0x00000000
0xc0252390      0xc357e9a0
0xc02a4130 <irq_desc+1996>:     0xc02a4130      0xc02a4130
0x00000000      0x00000000
0xc02a4140 <irq_desc+2012>:     0x00000000      0x00000000
0x00000021      0x00000000
0xc02a4150 <irq_desc+2028>:     0x00000001      0xbf06f288
0x00000418      0xc00260d8
 
after corruption:
 
0xc02a4120 <irq_desc+1980>:     0xc00260d8      0x00000000
0xc00260d8      0x00000000
0xc02a4130 <irq_desc+1996>:     0xc00260d8      0x00000000
0xc0252390      0xc357e9a0
0xc02a4140 <irq_desc+2012>:     0x00000000      0x00000000
0x00000021      0x00000000
0xc02a4150 <irq_desc+2028>:     0x00000001      0xbf06f288
0x00000418      0xc00260d8 
 
3.per_cpu__tvec_bases is corrupted.
 
before corruption:
 
0xc02b05cc <per_cpu__tvec_bases+1640>:  0xc02b05cc      0xc02b05cc
0xc02b05d4      0xc02b05d4
0xc02b05dc <per_cpu__tvec_bases+1656>:  0xc02b05dc      0xc02b05dc
0xc02b05e4      0xc02b05e4
 
after corruption:
 
0xc02b05cc <per_cpu__tvec_bases+1640>:  0xc02b05dc      0xc02b05dc
0xc02b05e4      0xc02b05e4
0xc02b05dc <per_cpu__tvec_bases+1656>:  0xc02b05cc      0xc02b05cc
0xc02b05d4      0xc02b05d4
 
Thanks
Belinda

