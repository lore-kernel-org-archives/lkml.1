Return-Path: <linux-kernel-owner+w=401wt.eu-S1755624AbZEEJXZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755624AbZEEJXZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 05:23:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752239AbZEEJXQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 05:23:16 -0400
Received: from wa4ehsobe005.messaging.microsoft.com ([216.32.181.15]:41282
	"EHLO WA4EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752159AbZEEJXP convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 05:23:15 -0400
X-BigFish: VPS-18(zz1432R98dR1805M936fJzz1202hzzz32i6bh15fn43j61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-WSS-ID: 0KJ5ZEF-01-8YO-01
Date: Tue, 5 May 2009 11:22:38 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Andi Kleen <andi@firstfloor.org>
CC: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] x86: adapt CPU topology detection for AMD
	Magny-Cours
Message-ID: <20090505092238.GB29045@alberich.amd.com>
References: <20090504173330.GF28728@alberich.amd.com> <87vdogbp4g.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <87vdogbp4g.fsf@basil.nowhere.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 05 May 2009 09:22:59.0885 (UTC) FILETIME=[1541A5D0:01C9CD63]
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 04, 2009 at 10:16:15PM +0200, Andi Kleen wrote:
> Andreas Herrmann <andreas.herrmann3@amd.com> writes:
> 
> > Following patches add support for AMD Magny-Cours CPU.
> >
> > I slightly change struct cpuinfo where I'd like to introduce
> > cpu_node_id to reflect CPU topology for AMD Magny-Cours CPU which
> > consists of two internal-nodes.
> 
> It's unclear to me why you need this special case versus 
> just using the normal NUMA distances to represent the internal
> nodes as "nearby nodes" versus sockets as "farer away".

NUMA memory allocation and scheduling based on SRAT works just fine
w/o that fix. But the patches are _not_ for NUMA node detection.

This is for CPU topology detection -- which cores are using the same
northbridge.

> Essentially it should be just two level NUMA which can be already
> described fine for the scheduler or VM using the existing SRAT
> mechanism.

It doesn't suffice to rely on SRAT here.

Best example is node interleaving. Usually you won't get a SRAT table
on such a system. Thus you see just one NUMA node in
/sys/devices/system/node.  But on such a configuration you still see
(and you want to see) the correct CPU topology information in
/sys/devices/system/cpu/cpuX/topology. Based on that you always can
figure out which cores are on the same physical package independent of
availability and contents of SRAT and even with kernels that are
compiled w/o NUMA support.

A big change with Magny-Cours in contrast to other AMD
CPUs is that instead of

   physical package == one northbridge (one node)

we have

   physical package == two northbridges (two nodes)

and this needs to be represented somehow in the kernel.

> Who needs this additional information?

The kernel needs to know this when accessing processor configuration
space, when accessing shared MSRs or for counting northbridge specific
events.


Regards,
Andreas 

-- 
Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632


