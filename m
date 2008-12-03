Return-Path: <linux-kernel-owner+w=401wt.eu-S1753195AbYLCRHw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753195AbYLCRHw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 12:07:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751322AbYLCRHn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 12:07:43 -0500
Received: from waste.org ([66.93.16.53]:39210 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751298AbYLCRHn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 12:07:43 -0500
Subject: Re: mmotm 2008-12-01-19-41: early exception (page fault -- deref
	of 0x20)
From: Matt Mackall <mpm@selenic.com>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jiri Slaby <jirislaby@gmail.com>, linux-kernel@vger.kernel.org,
       tytso@mit.edu
In-Reply-To: <4935C9CC.8070308@linux.intel.com>
References: <4935C03A.7030603@gmail.com>
	 <20081202153336.7b765ec7.akpm@linux-foundation.org>
	 <1228261328.3196.174.camel@calx>  <4935C9CC.8070308@linux.intel.com>
Content-Type: text/plain
Date: Wed, 03 Dec 2008 11:07:00 -0600
Message-Id: <1228324020.3255.24.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-12-02 at 15:50 -0800, Arjan van de Ven wrote: 
> Matt Mackall wrote:
> > 
> > If we oops or warn while picking a timesource, we'll have lots of fun?
> > 
> 
> we really only need to mix in the tsc; ktime_get() is just an arch friendly way to get that
> I supposed (wrongly).
> 
> but yes we need to do a few things
> 1) seed on demand with a platform time source

Currently we use jiffies + get_cycles(). That's going to have somewhere
between, oh, 3 bits of entropy (very stable boot with only jiffies) and
25 bits of entropy (TSC with lots of waiting for hardware) at boot. 
Ideally, we'd have access to a wall clock of some sort as well. But
that's also a fairly limited source - wall clocks are both low
resolution and predictable/collision-prone.

> 2) have a way where arch init can just hand semi random data during the boot process to
>     increase the randomness (even if it doesn't count as entropy)

A simple wrapper around mix_pool_bytes probably fits the ticket.

But I don't think this will solve the general problem of 'large numbers
of practically identical machines booting up with the same pre-init
random number pools'. Beyond things like MAC addresses and serial
numbers (predictable/observable but at least not collision-prone), we
have no way to differentiate some boxes. We may need to forcibly
generate some timing entropy. Perhaps something like this:

http://markmail.org/message/xwsbywr6ziil2qu2

(which is way too slow in its current form)

There's a related problem of systems with no way to store a seed across
boots.

-- 
Mathematics is the supreme nostalgia of our time.

