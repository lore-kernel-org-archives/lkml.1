Return-Path: <linux-kernel-owner+w=401wt.eu-S1762646AbYDVI7n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762646AbYDVI7n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 04:59:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761953AbYDVI7b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 04:59:31 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:60787
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1757764AbYDVI73 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 04:59:29 -0400
Date: Tue, 22 Apr 2008 01:59:31 -0700 (PDT)
Message-Id: <20080422.015931.70144614.davem@davemloft.net>
To: mingo@elte.hu
CC: linux-kernel@vger.kernel.org
Subject: Soft lockup regression from today's sched.git merge.
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The following commit:

commit 27ec4407790d075c325e1f4da0a19c56953cce23
Author: Ingo Molnar <mingo@elte.hu>
Date:   Thu Feb 28 21:00:21 2008 +0100

    sched: make cpu_clock() globally synchronous
    
    Alexey Zaytsev reported (and bisected) that the introduction of
    cpu_clock() in printk made the timestamps jump back and forth.
    
    Make cpu_clock() more reliable while still keeping it fast when it's
    called frequently.
    
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

causes watchdog triggers when a cpu exits NOHZ state when it has been
there for >= the soft lockup threshold, for example here are some
messages from a 128 cpu Niagara2 box:

[  168.106406] BUG: soft lockup - CPU#11 stuck for 128s! [dd:3239]
[  168.989592] BUG: soft lockup - CPU#21 stuck for 86s! [swapper:0]
[  168.999587] BUG: soft lockup - CPU#29 stuck for 91s! [make:4511]
[  168.999615] BUG: soft lockup - CPU#2 stuck for 85s! [swapper:0]
[  169.020514] BUG: soft lockup - CPU#37 stuck for 91s! [swapper:0]
[  169.020514] BUG: soft lockup - CPU#45 stuck for 91s! [sh:4515]
[  169.020515] BUG: soft lockup - CPU#69 stuck for 92s! [swapper:0]
[  169.020515] BUG: soft lockup - CPU#77 stuck for 92s! [swapper:0]
[  169.020515] BUG: soft lockup - CPU#61 stuck for 92s! [swapper:0]
[  169.112554] BUG: soft lockup - CPU#85 stuck for 92s! [swapper:0]
[  169.112554] BUG: soft lockup - CPU#101 stuck for 92s! [swapper:0]
[  169.112554] BUG: soft lockup - CPU#109 stuck for 92s! [swapper:0]
[  169.112554] BUG: soft lockup - CPU#117 stuck for 92s! [swapper:0]
[  169.171483] BUG: soft lockup - CPU#40 stuck for 80s! [dd:3239]
[  169.331483] BUG: soft lockup - CPU#13 stuck for 86s! [swapper:0]
[  169.351500] BUG: soft lockup - CPU#43 stuck for 101s! [dd:3239]
[  169.531482] BUG: soft lockup - CPU#9 stuck for 129s! [mkdir:4565]
[  169.595754] BUG: soft lockup - CPU#20 stuck for 93s! [swapper:0]
[  169.626787] BUG: soft lockup - CPU#52 stuck for 93s! [swapper:0]
[  169.626787] BUG: soft lockup - CPU#84 stuck for 92s! [swapper:0]
[  169.636812] BUG: soft lockup - CPU#116 stuck for 94s! [swapper:0]

It's simple enough to trigger this by doing a 10 minute sleep after a
fresh bootup then starting a parallel kernel build.

I suspect this might be reintroducing a problem we've had and fixed
before, see the thread:

http://marc.info/?l=linux-kernel&m=119546414004065&w=2

Please have a look, thank you.
