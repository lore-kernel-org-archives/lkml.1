Return-Path: <linux-kernel-owner+w=401wt.eu-S1754266AbZEMGJG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754266AbZEMGJG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 02:09:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752732AbZEMGIy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 02:08:54 -0400
Received: from waste.org ([66.93.16.53]:52792 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752356AbZEMGIx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 02:08:53 -0400
Date: Wed, 13 May 2009 01:08:50 -0500
From: Matt Mackall <mpm@selenic.com>
To: Chris Peterson <cpeterso@cpeterso.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [resend] drivers/net: remove network drivers' last few uses of IRQF_SAMPLE_RANDOM
Message-ID: <20090513060850.GZ31071@waste.org>
References: <alpine.DEB.2.00.0905130118140.15823@ubuntu-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0905130118140.15823@ubuntu-desktop>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 13, 2009 at 01:34:47AM -0400, Chris Peterson wrote:
> 
> I know a new "pragmatic entropy accounting model" is in the works, but 
> until then, this patch removes the network drivers' last few uses of 
> theoretically-exploitable network entropy. Only 11 net drivers are 
> affected. Headless servers should use a more secure source of entropy, 
> such as the userspace daemons.

Actually, I'd rather not do this.

I've instead become convinced that what /dev/random's entropy
accounting model is trying to achieve is not actually possible.
It requires:

a) a strict underestimate of entropy
b) from completely unobservable, uncontrollable sources
c) with no correlation to observable sources

If and only if we meet all three of those requirements for all entropy
sources can we actually reach the theoretical point where /dev/random
is actually distinct from /dev/urandom. 

Practically, we're nowhere close on any of those points. We have no
good model for estimating (a) for most sources, and almost all sources
are directly or indirectly observable or controllable to some degree.

Once we acknowledge that, it's easy to see that the right way forward
is not to aim for perfect, but instead to aim for really good. And
that means:

1) significantly more sampling sources with lower overhead
2) more defense in depth
3) working well on headless machines and with hardware RNG sources
4) simpler, more auditable code
5) never starving users

So while your current patch is 'correct' in the current theoretical
model (and one I've personally tried to push in the past), I think the
theoretical model itself needs to change and this is thus a step in
the wrong direction. The future model will continue to sample network
devices on theory that they -might- be less than 100% observable and
that can only increase our total (unmeasurable) amount of entropy.

-- 
Mathematics is the supreme nostalgia of our time.
