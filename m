Return-Path: <linux-kernel-owner+w=401wt.eu-S1757006AbZFYCQY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757006AbZFYCQY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 22:16:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753621AbZFYCQP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 22:16:15 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:36873 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752094AbZFYCQP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 22:16:15 -0400
Message-ID: <4A42DDDF.2000403@jp.fujitsu.com>
Date: Thu, 25 Jun 2009 11:15:59 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.22 (Windows/20090605)
MIME-Version: 1.0
To: Robin Holt <holt@sgi.com>
CC: linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org,
       Vivek Goyal <vgoyal@redhat.com>, Haren Myneni <hbabu@us.ibm.com>,
       kexec@lists.infradead.org
Subject: Re: [PATCH 1/7] ia64, kdump: Mask MCA/INIT on freezing cpus
References: <4A39E247.4030908@jp.fujitsu.com> <4A39E2CF.80901@jp.fujitsu.com> <20090622134557.GC7084@sgi.com> <4A4022EA.1020506@jp.fujitsu.com> <20090623055536.GE6865@sgi.com> <4A408D32.9010500@jp.fujitsu.com> <20090624111415.GA6878@sgi.com>
In-Reply-To: <20090624111415.GA6878@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robin Holt wrote:
> The concern is that any time we prevent SAL from receiving control during
> an MCA/INIT, we reduce the maintainability of the machine.  Having them
> masked at any time results in the NMI/INIT not recording the PROM record
> which we use to diagnose where the hang is.

Think about servers which have no such PROM record features... Please?

The original problem here, which I wrote these patches for, is that the
INIT can block retrieving crashdump via kdump.  The crashdump is the only
record which we can use to diagnose where the hang is, if the PROM record
like SGI servers have is not supported.
(I guess the even the PROM record is supported, the crashdump is better,
 more important resource for the trouble shooting.)

My patches will mask MCA/INIT on all CPUs once kdump is invoked (via
panic or INIT), and soon unmask one of them who is going to jump in 2nd
kernel (=kdump kernel) after registering a do-nothing handler.

If there was a pending INIT, it will be received on the cpu as soon as
it is unmasked.  Then the PROM will make a record on it, pass the control
to OS_INIT which does nothing, and return to interrupted context to
continue processing the kdump.

What time point are you concerning?


> In other patches, you implemented a do-nothing handler.  Could that
> be used?

... How?  Maybe I could not catch your point.

It would be useful, but it is only available from the beginning of 2nd
kernel (to be exact, from the end of 1st kernel), until new INIT handlers
for 2nd kernel is registered.


> Alternatively, when the machine is first booted, the handler is defined
> by SAL as a SAL routine.  Could you record that during kernel boot and
> then just set the handler back to the SAL provided one prior to starting
> the kexec kernel boot?  At that point, the machine is more like the
> first boot.  Now that I think about this, this alternative seems fairly
> attractive.

I think it is definitely wrong thing if SAL provides the initial handler
as OS_INIT which can be removed/replaced by OS.

Since INIT event processes PAL_INIT -> SAL_INIT -> OS_INIT(if available),
SAL should keep the entry point of its initial handler and should use it
from SAL_INIT when OS_INIT is not registered.  Ditto to OS_MCA.


Thanks,
H.Seto

