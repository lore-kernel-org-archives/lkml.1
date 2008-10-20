Return-Path: <linux-kernel-owner+w=401wt.eu-S1755719AbYJTXMt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755719AbYJTXMt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 19:12:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751789AbYJTXMm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 19:12:42 -0400
Received: from rv-out-0506.google.com ([209.85.198.227]:54884 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751822AbYJTXMl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 19:12:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=YPGqzt8AiqWwVbTQbBJIm6NhgKSPv/HH3o82vk1FjJ0qV5NYQhdTd3OKGoJnza6BN/
         hdS/yNdKRYRp3ykSnCs7AhhQP3coFor+7Uq7cl2N6LuyJsfE0PS5ga8jcyisv4H9gVMq
         GB1Nhb2126NcazcyOgSvtVWPEWl402rpooHhQ=
Message-ID: <86802c440810201612q6c6191bfva1ba2eaecb9353a9@mail.gmail.com>
Date: Mon, 20 Oct 2008 16:12:40 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: tip is broken with NOHZ: restart tick device from irq_enter()
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

all my servers are broken with following commit.


yhlu@linux-zpir:~/xx/xx/
kernel/tip/linux-2.6> git bisect bad
fb02fbc14d17837b4b7b02dbb36142c16a7bf208 is first bad commit
commit fb02fbc14d17837b4b7b02dbb36142c16a7bf208
Author: Thomas Gleixner <tglx@linutronix.de>
Date:   Fri Oct 17 10:01:23 2008 +0200

    NOHZ: restart tick device from irq_enter()

    We did not restart the tick device from irq_enter() to avoid double
    reprogramming and extra events in the return immediate to idle case.

    But long lasting softirqs can lead to a situation where jiffies become
    stale:

    idle()
      tick stopped (reprogrammed to next pending timer)
      halt()
       interrupt
         jiffies updated from irq_enter()
         interrupt handler
         softirq function 1 runs 20ms
         softirq function 2 arms a 10ms timer with a stale jiffies value
         jiffies updated from irq_exit()
         timer wheel has now an already expired timer
         (the one added in function 2)
         timer fires and timer softirq runs

    This was discovered when debugging a timer problem which happend only
    when the ath5k driver is active. The debugging proved that there is a
    softirq function running for more than 20ms, which is a bug by itself.

    To solve this we restart the tick timer right from irq_enter(), but do
    not go through the other functions which are necessary to return from
    idle when need_resched() is set.

    Reported-by: Elias Oltmanns <eo@nebensachen.de>
    Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
    Tested-by: Elias Oltmanns <eo@nebensachen.de>

:040000 040000 d36218956b6a233bac4f56acfa0b106f6301c0bd
cf494796e1b4e824ec6da6f337569c4b090e
                                                        f9c5 M  kernel
yhlu@linux-zpir:~/xx/xx/kernel/tip/linux-2.6> git bisect log
git-bisect start
# bad: [8600bfdb4112c49ad09e7339010221e4a531716d] Merge branch 'warnings/simple'
git-bisect bad 8600bfdb4112c49ad09e7339010221e4a531716d
# good: [9601fd2e889cda328dbe66c2a907973916567c11] Merge branch 'sched/urgent'
git-bisect good 9601fd2e889cda328dbe66c2a907973916567c11
# good: [0cfd81031a26717fe14380d18275f8e217571615] Merge
git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb-2.6
git-bisect good 0cfd81031a26717fe14380d18275f8e217571615
# good: [2414719fbef90730a7521efb0074b8fb5905557f] Merge branch 'sched/urgent'
git-bisect good 2414719fbef90730a7521efb0074b8fb5905557f
# bad: [49ee4ff800b1d624fcd8bfa1ea3a55d1227635c3] Merge branch 'x86/doc'
git-bisect bad 49ee4ff800b1d624fcd8bfa1ea3a55d1227635c3
# bad: [0c4a0feaeb867cfa9486cef7555e1f23ceca2609] Merge branch 'tracing/urgent'
git-bisect bad 0c4a0feaeb867cfa9486cef7555e1f23ceca2609
# bad: [a597cb549361f6211d98edc99e672555899838f9] manual merge of
timers/range-hrtimers
git-bisect bad a597cb549361f6211d98edc99e672555899838f9
# bad: [14fedb9d17f5cb35ba805e39b5db9b48cee44c7e] manual merge of timers/nohz
git-bisect bad 14fedb9d17f5cb35ba805e39b5db9b48cee44c7e
# good: [322acf6585f3c4e82ee32a246b0483ca0f6ad3f4] fix documentation
of sysrq-q really
git-bisect good 322acf6585f3c4e82ee32a246b0483ca0f6ad3f4
# good: [c34bec5a44e9486597d78e7a686b2f9088a0564c] NOHZ: split
tick_nohz_restart_sched_tick()
git-bisect good c34bec5a44e9486597d78e7a686b2f9088a0564c
# bad: [fb02fbc14d17837b4b7b02dbb36142c16a7bf208] NOHZ: restart tick
device from irq_enter()
git-bisect bad fb02fbc14d17837b4b7b02dbb36142c16a7bf208
