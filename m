Return-Path: <linux-kernel-owner+w=401wt.eu-S1761419AbYGOCM6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761419AbYGOCM6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 22:12:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761357AbYGOCMq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 22:12:46 -0400
Received: from ozlabs.org ([203.10.76.45]:55690 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761352AbYGOCMp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 22:12:45 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [PATCH] stopmachine: add stopmachine_timeout
Date: Tue, 15 Jul 2008 11:14:58 +1000
User-Agent: KMail/1.9.9
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Christian Borntraeger <borntraeger@de.ibm.com>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
       Zachary Amsden <zach@vmware.com>
References: <487B05CE.1050508@jp.fujitsu.com> <487BA152.1070102@goop.org> <20080714212026.GA6705@osiris.boeblingen.de.ibm.com>
In-Reply-To: <20080714212026.GA6705@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807151114.59562.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 15 July 2008 07:20:26 Heiko Carstens wrote:
> On Mon, Jul 14, 2008 at 11:56:18AM -0700, Jeremy Fitzhardinge wrote:
> > Rusty Russell wrote:
> > > On Monday 14 July 2008 21:51:25 Christian Borntraeger wrote:
> > >> Am Montag, 14. Juli 2008 schrieb Hidetoshi Seto:
> > >>> +	/* Wait all others come to life */
> > >>> +	while (cpus_weight(prepared_cpus) != num_online_cpus() - 1) {
> > >>> +		if (time_is_before_jiffies(limit))
> > >>> +			goto timeout;
> > >>> +		cpu_relax();
> > >>> +	}
> > >>> +
> > >>
> > >> Hmm. I think this could become interesting on virtual machines. The
> > >> hypervisor might be to busy to schedule a specific cpu at certain load
> > >> scenarios. This would cause a failure even if the cpu is not really
> > >> locked up. We had similar problems with the soft lockup daemon on
> > >> s390.
> > >
> > > 5 seconds is a fairly long time.  If all else fails we could have a
> > > config option to simply disable this code.
>
> Hmm.. probably a stupid question: but what could happen that a real cpu
> (not virtual) becomes unresponsive so that it won't schedule a
> MAX_RT_PRIO-1 prioritized task for 5 seconds?

Yes.  That's exactly what we're trying to detect.  Currently the entire 
machine will wedge.  With this patch we can often limp along.

Hidetoshi's original problem was a client whose machine had one CPU die, then 
got wedged as the emergency backup tried to load a module.

Along these lines, I found VMWare's relaxed co-scheduling interesting, BTW:
http://communities.vmware.com/docs/DOC-4960

> cpu_relax() translates to a hypervisor yield on s390. Probably makes sense
> if other architectures would do the same.

Yes, I think so too.  Actually, doing a random yield-to-other-VCPU on 
cpu_relax is arguable the right semantic (in Linux it's used for spinning, 
almost exclusively to wait for other cpus).

Cheers,
Rusty.

