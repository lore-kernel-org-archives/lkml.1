Return-Path: <linux-kernel-owner+w=401wt.eu-S1754863AbYIQUVR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754863AbYIQUVR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 16:21:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753193AbYIQUVG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 16:21:06 -0400
Received: from relay1.sgi.com ([192.48.171.29]:45077 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752845AbYIQUVF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 16:21:05 -0400
Date: Wed, 17 Sep 2008 15:21:02 -0500
From: Jack Steiner <steiner@sgi.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Dean Nelson <dcn@sgi.com>, Ingo Molnar <mingo@elte.hu>,
       "Eric W. Biederman" <ebiederm@xmission.com>, Alan Mayer <ajm@sgi.com>,
       jeremy@goop.org, rusty@rustcorp.com.au, suresh.b.siddha@intel.com,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Yinghai Lu <Yinghai.lu@amd.com>
Subject: Re: [RFC 0/4] dynamically allocate arch specific system vectors
Message-ID: <20080917202102.GA166524@sgi.com>
References: <489C6844.9050902@sgi.com> <20080811165930.GI4524@elte.hu> <48A0737F.9010207@sgi.com> <m1y733mjdh.fsf@frodo.ebiederm.org> <20080911152304.GA13655@sgi.com> <20080914153522.GJ29290@elte.hu> <20080915215053.GA11657@sgi.com> <20080916082448.GA17287@elte.hu> <20080916204654.GA3532@sgi.com> <48D1575E.1050306@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48D1575E.1050306@zytor.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 17, 2008 at 12:15:42PM -0700, H. Peter Anvin wrote:
> Dean Nelson wrote:
> >
> >    sgi-gru driver
> >
> >The GRU is not an actual external device that is connected to an IOAPIC.
> >The gru is a hardware mechanism that is embedded in the node controller
> >(UV hub) that directly connects to the cpu socket. Any cpu (with 
> >permission)
> >can do direct loads and stores to the gru. Some of these stores will result
> >in an interrupt being sent back to the cpu that did the store.
> >
> >The interrupt vector used for this interrupt is not in an IOAPIC. Instead
> >it must be loaded into the GRU at boot or driver initialization time.
> >
> 
> Could you clarify there: is this one vector number per CPU, or are you 
> issuing a specific vector number and just varying the CPU number?

It is one vector for each cpu.

It is more efficient for software if the vector # is the same for all cpus
but the software/hardware can support a unique vector for each cpu. This
assumes, of course, that the driver can determine the irq->vector mapping for
each cpu.


<probably-more-detail-than-you-want>

Physically, the system contains a large number of blades. Each blade has
several processor sockets plus a UV hub (node controller).  There are 2 GRUs
located in each UV hub.

Each GRU supports multiple users simultaneously using the GRU.
Each user is assigned a context number (0 .. N-1). If an exception occurs,
the GRU uses the context number as an index into an array of [vector-apicid] pairs.
The [vector-apicid] identifies the cpu & vector for the interrupt.

Although supported by hardware, we do not intend to send interrupts
off-blade.

The array of [vector-apicid] pairs is located in each GRU and must be
initialized at boot time or when the driver is loaded. There is a
separate array for each GRU.

When the driver receives the interrupt, the vector number (or IRQ number) is
used by the driver to determine the GRU that sent the interrupt.


The simpliest scheme would be to assign 2 vectors - one for each GRU in the UV hub.
Vector #0 would be loaded into each "vector" of the  [vector-apicid] array for GRU
#0; vector #1 would be loaded into the [vector-apicid] array for GRU #1.

The [vector-apicid] arrays on all nodes would be identical as far as vectors are
concerned. (Apicids would be different and would target blade-local cpus).
Since interrupts are not sent offnode, the driver can use the vector (irq)
to uniquely identify the source of the interrupt.

However, we have a lot of flexibilty here. Any scheme that provides the right
information to the driver is ok. Note that servicing of these interrupts
is likely to be time critical. We need this path to be as efficient as possible.



--- jack




