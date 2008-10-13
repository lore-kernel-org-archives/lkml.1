Return-Path: <linux-kernel-owner+w=401wt.eu-S1759641AbYJMKSk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759641AbYJMKSk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 06:18:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764006AbYJMKPl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 06:15:41 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:50808 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763938AbYJMKPi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 06:15:38 -0400
Message-ID: <8190546.1223892929320.SLOX.WebMail.wwwrun@exchange.deltacomputer.de>
Date: Mon, 13 Oct 2008 12:15:29 +0200 (CEST)
From: Oliver Weihe <o.weihe@deltacomputer.de>
To: Andi Kleen <ak@suse.de>
Subject: NUMA allocator on Opteron systems does non-local allocation on node0
Cc: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Priority: 3 (normal)
X-Mailer: SuSE Linux Openexchange Server 4 - WebMail (Build 2.4160)
X-Operating-System: Linux 2.4.21-295-smp i386 (JVM 1.3.1_13)
Organization: Delta Computer Products GmbH
X-AVK-Virus-Check: AVF 19.98;12.10.2008
X-AVK-Spam-Check: 1;str=0001.0A090207.48F31FC2.029B,ss=1,fgs=0
X-Provags-ID: V01U2FsdGVkX1+lIDhh+ZXabo2LKruXpk4ARhxZbP5O9YMZzZv
 RYjbtnPHJ98Y0ruVljZr0b23SZOk53LOPZ4TqAkv3Kd04A2BO9
 xVkVxuzEV1Yoq3Up81MLA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andi,

I'm not sure if you're the right person for this but I hope you are!

I've notived that the memory allocation on NUMA systems (Opterons) does
memory allocation on non-local nodes for processes running node0 even if
local memory is available. (Kernel 2.6.25 and above)

Currently I'm playing around with a quadsocket quadcore Opteron but I've
observed this behavior on other Opteron systems aswell.

Hardware specs:
1x Supermicro H8QM3-2
4x Quadcore Opteron
16x 2GiB (8 GiB memory per node)

OS:
currently openSUSE 10.3 but I've observed this on other distros aswell
Kernel: 2.6.22.* (openSUSE) / 2.6.25.4 / 2.6.25.5 / 2.6.27 (vanilla
config)

Steps to reproduce:
Start an application which needs alot of memory and watch the memory
usage per node (I'm using "watch -n 1 numastat --hardware" to watch the
memory usage per node)
A quick&dirty code which allocates a big array and writes data into the
array is enough!

In my setup I'm allocating an array of ~7GiB memory size in a
singlethreaded application.
Startup: numactl --cpunodebind=X ./app
For X=1,2,3 it works as expected, all memory is allocated on the local
node.
For X=0 I can see the memory beeing allocated on node0 as long as ~3GiB
are "free" on node0. At this point the kernel starts using memory from
node1 for the app!

For parallel realworld apps I've seen a performance penalty of 30%
compared to older kernels!

numactl --cpunodebind=0 --membind=0 ./app "solves" the problem in this
case but thats not the point!

-- 

Regards,
Oliver Weihe

