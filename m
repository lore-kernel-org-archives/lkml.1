Return-Path: <linux-kernel-owner+w=401wt.eu-S1753806AbZF3Hrl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753806AbZF3Hrl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 03:47:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752295AbZF3Hrc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 03:47:32 -0400
Received: from smtp-out.google.com ([216.239.33.17]:19320 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751515AbZF3Hra (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 03:47:30 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=WMoqK/4vcXRkb4+C7SWsGjk/P2vBolVOrqfvtgqUhoIzJTu9jJCgbhPGJ5a5KhmHq
	rO7AoC8rJvIMt9TafTB2A==
Date: Tue, 30 Jun 2009 00:47:25 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: Larry Finger <Larry.Finger@lwfinger.net>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Johannes Berg <johannes@sipsolutions.net>,
       Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [Bug #13319] Page allocation failures with b43 and p54usb
In-Reply-To: <84144f020906292355o7cf63f7ch47bd19961cf92da3@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.0906300032310.11018@chino.kir.corp.google.com>
References: <etTXaRqGgAC.A.SaE.6iASKB@chimera> <5Hhc7UkUKEO.A.fNH.4kASKB@chimera> <4A48F114.1010702@lwfinger.net> <alpine.DEB.2.00.0906291642520.17663@chino.kir.corp.google.com> <84144f020906292355o7cf63f7ch47bd19961cf92da3@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="497827084-588220262-1246348047=:11018"
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--497827084-588220262-1246348047=:11018
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT

On Tue, 30 Jun 2009, Pekka Enberg wrote:

> > I'd disagree with disabling slub debugging by default for caches where
> > oo_order(s->min) increases as the result of using it.  This particular
> > page allocation failure is happening for, presumably, kmalloc-4096, and
> > the system has 4K pages.  Disabling debugging for that cache (and any of
> > its aliases) implicitly will lead to errors going undiagnosed as a result.
> 
> Well, I obviously don't agree here because kmalloc-4096 debugging
> causes problems in the real world.

I don't think CONFIG_SLUB_DEBUG_ON is generally the configuration used in 
the real world.

The option has a clear and well-defined purpose and that is to enable 
debugging on all slab caches.  If you modify its definition, users will 
generally ignore the warning about debugging being disabled when "the 
minimum possible order at which slab may be allocated is higher than 
without."  And unless they check the kernel log for such a warning to boot 
with `slab_debug=,kmalloc-4096', we lose testing coverage because we 
cannot enable redzoning or tracing after boot.

> Furthermore, SLUB never supported
> debugging for objects that big historically because of page allocator
> passthrough. And with Mel Gorman's page allocator optimizations, we
> might be going back to that.
> 

Even when page allocation is fast enough, it would still be helpful to 
configure slub to not do passthrough purely for the lightweight debugging 
opportunities.

> So we should fix SLUB debugging as outlined by Mel Gorman and
> Christoph Lameter. I simply haven't had the time to do it. Patches are
> welcome!
> 

You're referring to `slub_debug=A'?  I think CONFIG_SLUB_DEBUG_ON should 
continue to enable debugging on all slab caches and in instances where it 
causes page allocation failures such in Larry's case because 
oo_order(s->min) with debugging on is greater than oo_order(s->min) with 
debugging off, you can emit a friendly warning in your recently added 
slab_out_of_memory() about using `slab_debug=-,<cache>'.

We have a disagreement about which is the default behavior, but I would 
opt on the side of adding exemptions to a debug configuration option as 
opposed to requiring additional command line parameters to be fully 
enabled.
--497827084-588220262-1246348047=:11018--
