Return-Path: <linux-kernel-owner+w=401wt.eu-S1752974AbYIXKFt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752974AbYIXKFt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 06:05:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751688AbYIXKFk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 06:05:40 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:35455 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751685AbYIXKFk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 06:05:40 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Ingo Molnar <mingo@elte.hu>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <48D94B64.3070004@goop.org> <20080924084558.GD5576@elte.hu>
Date: Wed, 24 Sep 2008 02:54:16 -0700
In-Reply-To: <20080924084558.GD5576@elte.hu> (Ingo Molnar's message of "Wed,
	24 Sep 2008 10:45:58 +0200")
Message-ID: <m18wthna2f.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=mx04.mta.xmission.com;;;ip=24.130.11.59;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Rcpt-To: mingo@elte.hu, linux-kernel@vger.kernel.org, tglx@linutronix.de, jeremy@goop.org
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Ingo Molnar <mingo@elte.hu>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.7 BAYES_20 BODY: Bayesian spam probability is 5 to 20%
	*      [score: 0.0997]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: Should irq_chip->mask disable percpu interrupts to all cpus, or just to this cpu?
X-SA-Exim-Version: 4.2.1 (built Thu, 07 Dec 2006 04:40:56 +0000)
X-SA-Exim-Scanned: Yes (on mx04.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@elte.hu> writes:

> * Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>
>> Hi,
>> 
>> I'm reworking Xen's interrupt handling to isolate it a bit from the 
>> workings of the apic-based code, as Eric suggested a while back.
>> 
>> As I've mentioned before, Xen represents interrupts as event channels. 
>> There are two major classes of event channels: per-cpu and, erm, not 
>> percpu.  Per-cpu event channels are for things like timers and IPI 
>> function calls which are inherently per-cpu; it's meaningless to 
>> consider, for example, migrating them from cpu to cpu.  I guess 
>> they're analogous to the the local apic vectors.
>> 
>> (Non-percpu event channels can be bound to a particular cpu, and 
>> rebound at will; I'm not worried about them here.)
>> 
>> Previously I allocated an irq per percpu event channel per cpu.  This 
>> was pretty wasteful, since I need about 5-6 of them per cpu, so the 
>> number of interrupts increases quite quickly as cpus does.  There's no 
>> deep problem with that, but it gets fairly ugly in /proc/interrupts, 
>> and there's some tricky corners to manage in suspend/resume.

Every high performance device wants one irq per cpu.
So if it gets ugly in /proc/interrupts we should look at fixing
/proc/interrupts.

It looked like in Xen each of those interrupts were delivered
to different event channels.  Did I misread that code?

I really hate the notion of sharing a single irq_desc across
multiple cpus as a preferred mode of operation.  As NUMA comes
into play it guarantees we will have cross cpu memory fetches
on a fast path for irq handling.

Other than the beautiful way we print things in /proc/interrupts
IRQ_PER_CPU feels like a really bad idea.  Especially in that
it enshrines the nasty per cpu irq counters that scale horribly.

Eric
