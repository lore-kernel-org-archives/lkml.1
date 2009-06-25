Return-Path: <linux-kernel-owner+w=401wt.eu-S1753778AbZFYD3w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753778AbZFYD3w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 23:29:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751861AbZFYD3n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 23:29:43 -0400
Received: from relay3.sgi.com ([192.48.156.57]:39016 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750972AbZFYD3n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 23:29:43 -0400
Date: Wed, 24 Jun 2009 22:29:41 -0500
From: Robin Holt <holt@sgi.com>
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: Robin Holt <holt@sgi.com>, linux-ia64@vger.kernel.org,
       linux-kernel@vger.kernel.org, Vivek Goyal <vgoyal@redhat.com>,
       Haren Myneni <hbabu@us.ibm.com>, kexec@lists.infradead.org
Subject: Re: [PATCH 1/7] ia64, kdump: Mask MCA/INIT on freezing cpus
Message-ID: <20090625032941.GS6865@sgi.com>
References: <4A39E247.4030908@jp.fujitsu.com> <4A39E2CF.80901@jp.fujitsu.com> <20090622134557.GC7084@sgi.com> <4A4022EA.1020506@jp.fujitsu.com> <20090623055536.GE6865@sgi.com> <4A408D32.9010500@jp.fujitsu.com> <20090624111415.GA6878@sgi.com> <4A42DDDF.2000403@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A42DDDF.2000403@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Let's just leave it at you have an opinion of how things should be done
and I don't agree with that position.  If there are errors occurring
in hardware, disabling the MCA handler will do nothing but make the
kdump crash stall forever as the processor tries to consume bad data.
It also removes the ability to find out why things are broken in the event
that there are any errors in the kexec kernel which prevent the boot.
You have exceeded the amount of time I have to argue against your patches.

Good Luck,
Robin

On Thu, Jun 25, 2009 at 11:15:59AM +0900, Hidetoshi Seto wrote:
> Robin Holt wrote:
> > The concern is that any time we prevent SAL from receiving control during
> > an MCA/INIT, we reduce the maintainability of the machine.  Having them
> > masked at any time results in the NMI/INIT not recording the PROM record
> > which we use to diagnose where the hang is.
> 
> Think about servers which have no such PROM record features... Please?
> 
> The original problem here, which I wrote these patches for, is that the
> INIT can block retrieving crashdump via kdump.  The crashdump is the only
> record which we can use to diagnose where the hang is, if the PROM record
> like SGI servers have is not supported.
> (I guess the even the PROM record is supported, the crashdump is better,
>  more important resource for the trouble shooting.)
> 
> My patches will mask MCA/INIT on all CPUs once kdump is invoked (via
> panic or INIT), and soon unmask one of them who is going to jump in 2nd
> kernel (=kdump kernel) after registering a do-nothing handler.
> 
> If there was a pending INIT, it will be received on the cpu as soon as
> it is unmasked.  Then the PROM will make a record on it, pass the control
> to OS_INIT which does nothing, and return to interrupted context to
> continue processing the kdump.
> 
> What time point are you concerning?
> 
> 
> > In other patches, you implemented a do-nothing handler.  Could that
> > be used?
> 
> ... How?  Maybe I could not catch your point.
> 
> It would be useful, but it is only available from the beginning of 2nd
> kernel (to be exact, from the end of 1st kernel), until new INIT handlers
> for 2nd kernel is registered.
> 
> 
> > Alternatively, when the machine is first booted, the handler is defined
> > by SAL as a SAL routine.  Could you record that during kernel boot and
> > then just set the handler back to the SAL provided one prior to starting
> > the kexec kernel boot?  At that point, the machine is more like the
> > first boot.  Now that I think about this, this alternative seems fairly
> > attractive.
> 
> I think it is definitely wrong thing if SAL provides the initial handler
> as OS_INIT which can be removed/replaced by OS.
> 
> Since INIT event processes PAL_INIT -> SAL_INIT -> OS_INIT(if available),
> SAL should keep the entry point of its initial handler and should use it
> from SAL_INIT when OS_INIT is not registered.  Ditto to OS_MCA.
> 
> 
> Thanks,
> H.Seto
