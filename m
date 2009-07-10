Return-Path: <linux-kernel-owner+w=401wt.eu-S1755125AbZGJT0C@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755125AbZGJT0C (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 15:26:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751538AbZGJTZv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 15:25:51 -0400
Received: from mx2.redhat.com ([66.187.237.31]:55419 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751401AbZGJTZu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 15:25:50 -0400
Date: Fri, 10 Jul 2009 15:25:11 -0400
From: Dave Jones <davej@redhat.com>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Linux PM List <linux-pm@lists.linux-foundation.org>,
       cpufreq@vger.kernel.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: 2.6.31-rc2+: Interrupts enabled after cpufreq_suspend
Message-ID: <20090710192511.GB6240@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Marcin Slusarz <marcin.slusarz@gmail.com>,
	LKML <linux-kernel@vger.kernel.org>,
	Linux PM List <linux-pm@lists.linux-foundation.org>,
	cpufreq@vger.kernel.org,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>
References: <4A561074.5080407@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A561074.5080407@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 09, 2009 at 05:44:52PM +0200, Marcin Slusarz wrote:
 > I find this message after resume from s2ram:
 > [  133.014802] ------------[ cut here ]------------
 > [  133.014814] WARNING: at drivers/base/sys.c:411 sysdev_suspend+0xd3/0x27b()
 > [  133.014819] Hardware name: To Be Filled By O.E.M.
 > [  133.014828] Interrupts enabled after cpufreq_suspend+0x0/0xfd
 > [  133.014832] Modules linked in:
 > [  133.014840] Pid: 6569, comm: s2ram Not tainted 2.6.31-rc2-faf80-wusb54gc #139
 > [  133.014845] Call Trace:
 > [  133.014853]  [<ffffffff8126960a>] ? sysdev_suspend+0xd3/0x27b
 > [  133.014864]  [<ffffffff810388a9>] warn_slowpath_common+0x77/0xa4
 > [  133.014873]  [<ffffffff8103894b>] warn_slowpath_fmt+0x64/0x66
 > [  133.014883]  [<ffffffff8101ac71>] ? query_values_on_cpu+0x0/0x19
 > [  133.014892]  [<ffffffff813273bc>] ? cpufreq_suspend+0x0/0xfd
 > [  133.014900]  [<ffffffff811e6d35>] ? kobject_put+0x47/0x4b
 > [  133.014908]  [<ffffffff813269fd>] ? cpufreq_cpu_put+0x1f/0x21
 > [  133.014917]  [<ffffffff813274ac>] ? cpufreq_suspend+0xf0/0xfd
 > [  133.014926]  [<ffffffff8105aeda>] ? trace_hardirqs_off+0xd/0xf
 > [  133.014934]  [<ffffffff8126960a>] sysdev_suspend+0xd3/0x27b
 > [  133.014944]  [<ffffffff81068fd8>] suspend_devices_and_enter+0xca/0x14d
 > [  133.014952]  [<ffffffff81069114>] enter_state+0xb9/0xec
 > [  133.014959]  [<ffffffff81068923>] state_store+0xb7/0xd7
 > [  133.014967]  [<ffffffff811e6b4b>] kobj_attr_store+0x17/0x19
 > [  133.014976]  [<ffffffff811094b1>] sysfs_write_file+0xe4/0x119
 > [  133.014985]  [<ffffffff810b9f57>] vfs_write+0xac/0x164
 > [  133.014991]  [<ffffffff810ba0d3>] sys_write+0x47/0x6e
 > [  133.015000]  [<ffffffff8100aee8>] system_call_fastpath+0x16/0x1b
 > [  133.015006] ---[ end trace 470f36a1cfb444d7 ]---

powernow-k8's ->get is calling smp_call_function_single which enables interrupts.

So I couldn't help wondering... why are we caring so much about the current cpu
speed when we ->suspend anyway ? Why is cpufreq_suspend doing those gymnastics at all,
instead of just doing nothing at suspend time, and just setting the frequency
to maximum speed on resume ?

The answer seems to be in 42d4dc3f4e1ec1396371aac89d0dccfdd977191b
which introduced all this code to work around some failure that only happens
on PPC...

    [PATCH] Add suspend method to cpufreq core
    
    In order to properly fix some issues with cpufreq vs. sleep on
    PowerBooks, I had to add a suspend callback to the pmac_cpufreq driver.
    I must force a switch to full speed before sleep and I switch back to
    previous speed on resume.


Ben, is there something better we can do here ?

I really don't want to add an #ifdef __powerpc__ to core code if we can help it.
I'd rather we didn't call into driver guts at all from the suspend path.

	Dave

