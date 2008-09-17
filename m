Return-Path: <linux-kernel-owner+w=401wt.eu-S1756783AbYIQWZp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756783AbYIQWZp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 18:25:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753852AbYIQWZZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 18:25:25 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:56820 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756457AbYIQWZW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 18:25:22 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Jack Steiner <steiner@sgi.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Dean Nelson <dcn@sgi.com>,
       Ingo Molnar <mingo@elte.hu>, Alan Mayer <ajm@sgi.com>, jeremy@goop.org,
       rusty@rustcorp.com.au, suresh.b.siddha@intel.com,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Yinghai Lu <Yinghai.lu@amd.com>
References: <489C6844.9050902@sgi.com> <20080811165930.GI4524@elte.hu>
	<48A0737F.9010207@sgi.com> <m1y733mjdh.fsf@frodo.ebiederm.org>
	<20080911152304.GA13655@sgi.com> <20080914153522.GJ29290@elte.hu>
	<20080915215053.GA11657@sgi.com> <20080916082448.GA17287@elte.hu>
	<20080916204654.GA3532@sgi.com> <48D1575E.1050306@zytor.com>
	<20080917202102.GA166524@sgi.com>
Date: Wed, 17 Sep 2008 15:15:07 -0700
In-Reply-To: <20080917202102.GA166524@sgi.com> (Jack Steiner's message of
	"Wed, 17 Sep 2008 15:21:02 -0500")
Message-ID: <m1zlm6zafo.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=mx04.mta.xmission.com;;;ip=24.130.11.59;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Rcpt-To: too long (recipient list exceeded maximum allowed size of 128 bytes)
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Jack Steiner <steiner@sgi.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.0 BAYES_50 BODY: Bayesian spam probability is 40 to 60%
	*      [score: 0.4995]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [RFC 0/4] dynamically allocate arch specific system vectors
X-SA-Exim-Version: 4.2.1 (built Thu, 07 Dec 2006 04:40:56 +0000)
X-SA-Exim-Scanned: Yes (on mx04.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jack Steiner <steiner@sgi.com> writes:

> On Wed, Sep 17, 2008 at 12:15:42PM -0700, H. Peter Anvin wrote:
>> Dean Nelson wrote:
>> >
>> >    sgi-gru driver
>> >
>> >The GRU is not an actual external device that is connected to an IOAPIC.
>> >The gru is a hardware mechanism that is embedded in the node controller
>> >(UV hub) that directly connects to the cpu socket. Any cpu (with 
>> >permission)
>> >can do direct loads and stores to the gru. Some of these stores will result
>> >in an interrupt being sent back to the cpu that did the store.
>> >
>> >The interrupt vector used for this interrupt is not in an IOAPIC. Instead
>> >it must be loaded into the GRU at boot or driver initialization time.
>> >
>> 
>> Could you clarify there: is this one vector number per CPU, or are you 
>> issuing a specific vector number and just varying the CPU number?
>
> It is one vector for each cpu.
>
> It is more efficient for software if the vector # is the same for all cpus
Why?  Especially in terms of irq counting that would seem to lead to cache
line conflicts.

> but the software/hardware can support a unique vector for each cpu. This
> assumes, of course, that the driver can determine the irq->vector mapping for
> each cpu.
>
>
> <probably-more-detail-than-you-want>
>
> Physically, the system contains a large number of blades. Each blade has
> several processor sockets plus a UV hub (node controller).  There are 2 GRUs
> located in each UV hub.
>
> Each GRU supports multiple users simultaneously using the GRU.
> Each user is assigned a context number (0 .. N-1). If an exception occurs,
> the GRU uses the context number as an index into an array of [vector-apicid]
> pairs.
> The [vector-apicid] identifies the cpu & vector for the interrupt.
>
> Although supported by hardware, we do not intend to send interrupts
> off-blade.
>
> The array of [vector-apicid] pairs is located in each GRU and must be
> initialized at boot time or when the driver is loaded. There is a
> separate array for each GRU.
>
> When the driver receives the interrupt, the vector number (or IRQ number) is
> used by the driver to determine the GRU that sent the interrupt.
>
>
> The simpliest scheme would be to assign 2 vectors - one for each GRU in the UV
> hub.
> Vector #0 would be loaded into each "vector" of the [vector-apicid] array for
> GRU
> #0; vector #1 would be loaded into the [vector-apicid] array for GRU #1.
>
> The [vector-apicid] arrays on all nodes would be identical as far as vectors are
> concerned. (Apicids would be different and would target blade-local cpus).
> Since interrupts are not sent offnode, the driver can use the vector (irq)
> to uniquely identify the source of the interrupt.
>
> However, we have a lot of flexibilty here. Any scheme that provides the right
> information to the driver is ok. Note that servicing of these interrupts
> is likely to be time critical. We need this path to be as efficient as possible.

That sounds like you have a non-standard MSI-X vector.  You certainly have all of
the same properties.  At which point create_irq() sounds like what you want.

One irq per cpu, per device.

It is the trend.  Don't worry all of the high performance drivers are doing it.
That is the path that will be optimized.

What you are proposing is some silly side path that will be ignored, and will be
increasingly less well supported over time as no other hardware does that.  Please
join the rest of the world.  Weird formats formats for programming irq information
into the hardware are easier to support than many other weird restrictions.

What function does the GRU perform that makes it more important and more special
than other hardware devices that requires it to have a high priority interrupt?

Eric

