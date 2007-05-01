Return-Path: <linux-kernel-owner+w=401wt.eu-S1945974AbXEAVtP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945974AbXEAVtP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 17:49:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945976AbXEAVtP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 17:49:15 -0400
Received: from netblock-66-245-252-131.dslextreme.com ([66.245.252.131]:44883
	"EHLO Angel.zoy.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945974AbXEAVtN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 17:49:13 -0400
Date: Tue, 1 May 2007 14:49:12 -0700
From: Michel Lespinasse <walken@zoy.org>
To: Chuck Ebbert <cebbert@redhat.com>
Cc: linux-kernel@vger.kernel.org, Dave Jones <davej@redhat.com>,
       Jeb Cramer <cramerj@intel.com>, John Ronciak <john.ronciak@intel.com>,
       Jesse Brandeburg <jesse.brandeburg@intel.com>,
       Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
       Auke Kok <auke-jan.h.kok@intel.com>
Subject: Re: 24 lost ticks with 2.6.20.10 kernel
Message-ID: <20070501214912.GA4048@zoy.org>
References: <20070501130715.GB29131@zoy.org> <46375E04.5030506@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46375E04.5030506@redhat.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

(I've added the E1000 maintainers to the thread as I found the issue
seems to go away after I compile out that driver. For reference, I was
trying to figure out why I lose exactly 24 ticks about every two
seconds, as shown with report_lost_ticks. This is with a DQ965GF
motherboard with onboard E1000).

On Tue, May 01, 2007 at 11:34:28AM -0400, Chuck Ebbert wrote:
> Michel Lespinasse wrote:
> > running with report_lost_ticks, I see the following:
> > 
> > May  1 12:58:57 server kernel: time.c: Lost 24 timer tick(s)! rip _spin_unlock_irqrestore+0x8/0x9)
> > May  1 12:58:59 server kernel: time.c: Lost 24 timer tick(s)! rip _spin_unlock_irqrestore+0x8/0x9)

> Try disabling CONFIG_CPU_FREQ?

OK, so I tried a few things.

Disabling CONFIG_CPU_FREQ does not fix the issue.

Running with 2.6.16.49 did fix the issue, but my onboard E1000 is not
    detected then (I do see the 'Intel Pro/1000 network driver' message
    at boot time, but ifconfig -a does not show an ethernet interface)

Going back to 2.6.20.10 with no E1000 driver (so really no
    network devices at all): aaaaaah, lost ticks are gone.
    I can even re-enable CONFIG_CPU_FREQ.

With 2.6.20.10, E1000 compiled in, without NAPI: I do see the lost ticks.

With 2.6.20.10, modular E1000 with NAPI: I did not get any lost ticks.
    However the network did not work correctly after boot up.
    The e1000 module was loaded, the routes were set etc... but I could
    not ping anything. The switch lights seemed to indicate no packets
    were coming out. After ifdown eth0 and ifup eth0 again, the network
    came up fine, but at 100 megabit speed (full duplex) instead of gigabit.
    A few log messages come up:
e1000: eth0: e1000_probe: Intel(R) PRO/1000 Network Connection
e1000: eth0: e1000_watchdog: NIC Link is Up 1000 Mbps Full Duplex
e1000: eth0: e1000_watchdog: NIC Link is Down
e1000: eth0: e1000_watchdog: NIC Link is Up 100 Mbps Full Duplex
e1000: eth0: e1000_watchdog: 10/100 speed: disabling TSO
    Which is slightly strange since the box is connected to a gigabit switch.

The default kernel from debian etch, 2.6.18 based with modular e1000,
connects at gigabit speeds but loses ticks on this machine.

> > One last thing: I have another box which is fairly similar, with a
> > DG965RY motherboard. That other box does *not* seem to lose any ticks,
> > running the same kernel that works so poorly on the DQ965GF board.
> > Does that point to a hardware/bios issue then ?????
> 
> Is it running the exact same kernel, with the same cpufreq settings at
> runtime (governor, controller, etc?)

I have not been running 2.6.20.10 on the DG965RY yet. However, the kernel
I use on the DG965RY (2.6.20.7 with statically compiled E1000 driver),
which does not lose ticks there, does lose ticks when I move it to the DQ965GF.

If it makes any difference, the DQ965GF is running with BIOS version 5882
dated 4/13/2007. The DG965RY runs with BIOS version 1676 (same date).
I have not changed any settings in the 'management engine' BIOS menu
(actually I have not entered it since it'd require me to set a password,
and I thought I'd avoid features I dont fully understand :)

Anything else I should try ?

Thanks,

-- 
Michel "Walken" Lespinasse
"Bill Gates is a monocle and a Persian cat away from being the villain
in a James Bond movie." -- Dennis Miller
