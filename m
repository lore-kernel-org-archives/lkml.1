Return-Path: <linux-kernel-owner+w=401wt.eu-S1754118AbYIWUCv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754118AbYIWUCv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 16:02:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752112AbYIWUCn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 16:02:43 -0400
Received: from gw.goop.org ([64.81.55.164]:58249 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751732AbYIWUCm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 16:02:42 -0400
Message-ID: <48D94B64.3070004@goop.org>
Date: Tue, 23 Sep 2008 13:02:44 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, "Eric W. Biederman" <ebiederm@xmission.com>,
       Thomas Gleixner <tglx@linutronix.de>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Should irq_chip->mask disable percpu interrupts to all cpus, or just
 to this cpu?
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm reworking Xen's interrupt handling to isolate it a bit from the
workings of the apic-based code, as Eric suggested a while back.

As I've mentioned before, Xen represents interrupts as event channels. 
There are two major classes of event channels: per-cpu and, erm, not
percpu.  Per-cpu event channels are for things like timers and IPI
function calls which are inherently per-cpu; it's meaningless to
consider, for example, migrating them from cpu to cpu.  I guess they're
analogous to the the local apic vectors.

(Non-percpu event channels can be bound to a particular cpu, and rebound
at will; I'm not worried about them here.)

Previously I allocated an irq per percpu event channel per cpu.  This
was pretty wasteful, since I need about 5-6 of them per cpu, so the
number of interrupts increases quite quickly as cpus does.  There's no
deep problem with that, but it gets fairly ugly in /proc/interrupts, and
there's some tricky corners to manage in suspend/resume.

This time around I'm allocating a single irq for each percpu interrupt
source (so one for timers, one for IPI, etc), and mapping each per-cpu
event channel to each.  But I'm wondering what the correct behaviour of
irq_chip->mask/unmask should be in this case.  Each event channel is
individually maskable, so when ->mask gets called, I can either mask all
the event channels associated with that irq, or just the one for this
cpu.  The latter makes most sense for me, but I don't quite understand
the irq infrastructure enough to know if it will have bad effects globally.

When I request the irq, I pass IRQF_PERCPU in the flags, but aside from
preventing migration, this only seems to have an effect on __do_IRQ(),
which looks like a legacy path anyway.   It seems to me that by setting
it that I'm giving the interrupt subsystem fair warning that ->mask() is
only going to disable the interrupt on this cpu.

Are there any other ill-effects of sharing an irq across all cpus like
this?  I guess there's some risk of contention on the irq_desc lock.

Thanks,
    J
