Return-Path: <linux-kernel-owner+w=401wt.eu-S1753081AbZG3Vax@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753081AbZG3Vax (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 17:30:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753016AbZG3Vaw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 17:30:52 -0400
Received: from smtp-out.google.com ([216.239.33.17]:56083 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753008AbZG3Vav (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 17:30:51 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=EOumy3uJkGkQKlfSyPOCs71lFPkkmdNGnpXyqytYqdeG9lnibsV1LBhSOtg0dShe3
	i9YcmU8s1tbvnmhfDv7QQ==
Date: Thu, 30 Jul 2009 14:30:42 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Stephan von Krawczynski <skraw@ithnet.com>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Justin Piszcz <jpiszcz@lucidpixels.com>,
       Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
       Jesse Brandeburg <jesse.brandeburg@intel.com>,
       "David S. Miller" <davem@davemloft.com>
Subject: Re: [Bug #13648] nfsd: page allocation failure
In-Reply-To: <20090727130420.1514cf5c.skraw@ithnet.com>
Message-ID: <alpine.DEB.2.00.0907301423250.18531@chino.kir.corp.google.com>
References: <DizPU9GBfHF.A.kgF.iWObKB@chimera> <H5-1lZIIeYK.A.HXG.DXObKB@chimera> <20090727130420.1514cf5c.skraw@ithnet.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Jul 2009, Stephan von Krawczynski wrote:

> This is no regression between 2.6.29 and 2.6.30.
> In fact we could reproduce the problem with kernel versions:
> 
> 2.6.27.26 < X <= 2.6.30.3
> 
> (Meaning 2.6.27.26 is the last one _not_ showing the problem).
> 

And 2.6.28.10 is showing the exact same problem as initially reported, 
right?

I noticed your /var/log/messages is showing you're using slub as opposed 
to slab (which Justin was using, and causing order-0 allocations errors).  
SLUB uses order-1 allocations for this cache growth and it's failing 
because of memory fragmentation, not because you're truly oom.

The only thing that is immediately apparent that changed in this path over 
these kernel versions (there were significant changes to e1000e) is the 
CRC stripping.  If it's loaded as a module, perhaps you could try

	modprobe e1000e CrcStripping=0,0

(assuming you have two adapters).

I've cc'd some relevant e1000e driver people in the hopes they'll be able 
to diagnose this problem.  Memory fragmentation as the result of page 
group changes wouldn't affect order-0 allocations such as this on slab, so 
it's doubtful the VM regressed if you can reproduce the problem with 
CONFIG_SLAB.
