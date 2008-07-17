Return-Path: <linux-kernel-owner+w=401wt.eu-S1757270AbYGQJ6J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757270AbYGQJ6J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 05:58:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754905AbYGQJ54
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 05:57:56 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:44291 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754289AbYGQJ54 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 05:57:56 -0400
Date: Thu, 17 Jul 2008 11:54:11 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jean Delvare <khali@linux-fr.org>
Cc: john stultz <johnstul@us.ibm.com>, Greg KH <gregkh@suse.de>,
       LKML <linux-kernel@vger.kernel.org>, Linux I2C <i2c@lm-sensors.org>,
       Ulrich Drepper <drepper@redhat.com>
Subject: Re: [crash, bisected] I2C,  kobject (ffff81003e8c4160): tried to
	init an initialized object
Message-ID: <20080717095411.GA23322@elte.hu>
References: <20080714224945.629446fa@hyperion.delvare> <20080716082352.GA30483@elte.hu> <20080716110702.3ca61eb2@hyperion.delvare> <20080716120801.3e9b4c80@hyperion.delvare> <20080716141826.1d88d05e@hyperion.delvare> <20080717092655.GA6115@elte.hu> <20080717094930.GA9044@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080717094930.GA9044@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> found another bootup crash on an Athlon 64 X2 testsystem:
> 
> [   19.610000] bus: 'pci': add driver amd756_smbus
> [   19.615204] initcall amd756_init+0x0/0x20 returned 0 after 9 msecs
> [   19.620000] calling  amd756_s4882_init+0x0/0x2d7
> [   19.624242] ------------[ cut here ]------------
> [   19.628415] WARNING: at kernel/mutex.c:134 mutex_lock_nested+0xc0/0x267()
> [   19.630000] Pid: 1, comm: swapper Not tainted 2.6.26-tip #20066

> [   19.630000] ---[ end trace 0e79313125261797 ]---
> [   19.630000] BUG: unable to handle kernel NULL pointer dereference at 0000000000000000
> [   19.630000] IP: [<ffffffff80861c66>] mutex_lock_nested+0x10d/0x267

turning off CONFIG_I2C_AMD756_S4882 works around this bug (as expected), 
via the patch below.

	Ingo

--------------------------->
commit 3f6403ab0bfdfca0cefbbc414afedc62734392f3
Author: Ingo Molnar <mingo@elte.hu>
Date:   Thu Jul 17 11:52:41 2008 +0200

    i2c: work around boot crash in amd756_s4882_init()
    
    work around:
    
    [   19.610000] bus: 'pci': add driver amd756_smbus
    [   19.615204] initcall amd756_init+0x0/0x20 returned 0 after 9 msecs
    [   19.620000] calling  amd756_s4882_init+0x0/0x2d7
    [   19.624242] ------------[ cut here ]------------
    [   19.628415] WARNING: at kernel/mutex.c:134 mutex_lock_nested+0xc0/0x267()
    [   19.630000] Pid: 1, comm: swapper Not tainted 2.6.26-tip #20066
    [   19.630000]
    [   19.630000] Call Trace:
    [   19.630000]  [<ffffffff802358f5>] warn_on_slowpath+0x58/0x7f
    [   19.630000]  [<ffffffff80263ac6>] ? ftrace_record_ip+0x20c/0x263
    [   19.630000]  [<ffffffff80514faa>] ? _raw_spin_unlock+0x8e/0x93
    [   19.630000]  [<ffffffff80507c44>] ? debug_locks_off+0x4/0x3c
    [   19.630000]  [<ffffffff80263ac6>] ? ftrace_record_ip+0x20c/0x263
    [   19.630000]  [<ffffffff8020b3a4>] ? mcount_call+0x5/0x31
    [   19.630000]  [<ffffffff80861c19>] mutex_lock_nested+0xc0/0x267
    [   19.630000]  [<ffffffff806e8ffd>] ? i2c_smbus_xfer+0x59/0x49c
    [   19.630000]  [<ffffffff80cc8575>] ? amd756_s4882_init+0x0/0x2d7
    [   19.630000]  [<ffffffff8020b3a4>] ? mcount_call+0x5/0x31
    [   19.630000]  [<ffffffff806e8ffd>] i2c_smbus_xfer+0x59/0x49c
    [   19.630000]  [<ffffffff80263ac6>] ? ftrace_record_ip+0x20c/0x263
    [   19.630000]  [<ffffffff80514faa>] ? _raw_spin_unlock+0x8e/0x93
    [   19.630000]  [<ffffffff80cc8584>] ? amd756_s4882_init+0xf/0x2d7
    [   19.630000]  [<ffffffff80263ac6>] ? ftrace_record_ip+0x20c/0x263
    [   19.630000]  [<ffffffff80cc8575>] ? amd756_s4882_init+0x0/0x2d7
    [   19.630000]  [<ffffffff8020b3a4>] ? mcount_call+0x5/0x31
    [   19.630000]  [<ffffffff80cc8575>] ? amd756_s4882_init+0x0/0x2d7
    [   19.630000]  [<ffffffff80cc85b6>] amd756_s4882_init+0x41/0x2d7
    [   19.630000]  [<ffffffff8024e325>] ? getnstimeofday+0x3f/0xa1
    [   19.630000]  [<ffffffff8024bf25>] ? ktime_get_ts+0x4e/0x53
    [   19.630000]  [<ffffffff80cc8575>] ? amd756_s4882_init+0x0/0x2d7
    [   19.630000]  [<ffffffff80ca49a0>] kernel_init+0x143/0x2a4
    [   19.630000]  [<ffffffff80863721>] ? _spin_unlock_irq+0x2b/0x37
    [   19.630000]  [<ffffffff8020c9f9>] child_rip+0xa/0x11
    [   19.630000]  [<ffffffff80ca485d>] ? kernel_init+0x0/0x2a4
    [   19.630000]  [<ffffffff8020c9ef>] ? child_rip+0x0/0x11
    [   19.630000]
    [   19.630000] ---[ end trace 0e79313125261797 ]---
    [   19.630000] BUG: unable to handle kernel NULL pointer dereference at 0000000000000000
    [   19.630000] IP: [<ffffffff80861c66>] mutex_lock_nested+0x10d/0x267
    
    which occurs with:
    
      http://redhat.com/~mingo/misc/config-Thu_Jul_17_11_34_08_CEST_2008.bad
    
    Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 drivers/i2c/busses/Kconfig |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/i2c/busses/Kconfig b/drivers/i2c/busses/Kconfig
index 2213fab..ead9209 100644
--- a/drivers/i2c/busses/Kconfig
+++ b/drivers/i2c/busses/Kconfig
@@ -56,6 +56,9 @@ config I2C_AMD756
 config I2C_AMD756_S4882
 	tristate "SMBus multiplexing on the Tyan S4882"
 	depends on I2C_AMD756 && EXPERIMENTAL
+	# broke an Athlon 64 X2 Asus A8N-E with:
+	# http://redhat.com/~mingo/misc/config-Thu_Jul_17_11_34_08_CEST_2008.bad
+	depends on 0
 	help
 	  Enabling this option will add specific SMBus support for the Tyan
 	  S4882 motherboard.  On this 4-CPU board, the SMBus is multiplexed
