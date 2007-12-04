Return-Path: <linux-kernel-owner+w=401wt.eu-S1753953AbXLDSCo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753953AbXLDSCo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 13:02:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751661AbXLDSCh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 13:02:37 -0500
Received: from waste.org ([66.93.16.53]:43670 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750944AbXLDSCg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 13:02:36 -0500
Date: Tue, 4 Dec 2007 12:01:59 -0600
From: Matt Mackall <mpm@selenic.com>
To: Ray Lee <ray@madrabbit.org>
Cc: Adrian Bunk <bunk@kernel.org>, Marc Haber <mh+linux-kernel@zugschlus.de>,
       linux-kernel@vger.kernel.org
Subject: Re: Why does reading from /dev/urandom deplete entropy so much?
Message-ID: <20071204180158.GT19691@waste.org>
References: <20071204114125.GA17310@torres.zugschlus.de> <20071204161811.GB15974@stusta.de> <2c0942db0712040854u17a830b9see663742b2716457@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2c0942db0712040854u17a830b9see663742b2716457@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 04, 2007 at 08:54:52AM -0800, Ray Lee wrote:
> (Why hasn't anyone been cc:ing Matt on this?)
> 
> On Dec 4, 2007 8:18 AM, Adrian Bunk <bunk@kernel.org> wrote:
> > On Tue, Dec 04, 2007 at 12:41:25PM +0100, Marc Haber wrote:
> >
> > > While debugging Exim4's GnuTLS interface, I recently found out that
> > > reading from /dev/urandom depletes entropy as much as reading from
> > > /dev/random would. This has somehow surprised me since I have always
> > > believed that /dev/urandom has lower quality entropy than /dev/random,
> > > but lots of it.
> >
> > man 4 random
> >
> > > This also means that I can "sabotage" applications reading from
> > > /dev/random just by continuously reading from /dev/urandom, even not
> > > meaning to do any harm.
> > >
> > > Before I file a bug on bugzilla,
> > >...
> >
> > The bug would be closed as invalid.
> >
> > No matter what you consider as being better, changing a 12 years old and
> > widely used userspace interface like /dev/urandom is simply not an
> > option.
> 
> You seem to be confused. He's not talking about changing any userspace
> interface, merely how the /dev/urandom data is generated.
> 
> For Matt's benefit, part of the original posting:
> 
> > Before I file a bug on bugzilla, can I ask why /dev/urandom wasn't
> > implemented as a PRNG which is periodically (say, every 1024 bytes or
> > even more) seeded from /dev/random? That way, /dev/random has a much
> > higher chance of holding enough entropy for applications that really
> > need "good" entropy.
> 
> A PRNG is clearly unacceptable. But roughly restated, why not have
> /dev/urandom supply merely cryptographically strong random numbers,
> rather than a mix between the 'true' random of /dev/random down to the
> cryptographically strong stream it'll provide when /dev/random is
> tapped? In principle, this'd leave more entropy available for
> applications that really need it, especially on platforms that don't
> generate a lot of entropy in the first place (servers).

The original /dev/urandom behavior was to use all the entropy that was
available, and then degrade into a pure PRNG when it was gone. The
intent is for /dev/urandom to be precisely as strong as /dev/random
when entropy is readily available.

The current behavior is to deplete the pool when there is a large
amount of entropy, but to always leave enough entropy for /dev/random
to be read. This means we never completely starve the /dev/random
side. The default amount is twice the read wakeup threshold (128
bits), settable in /proc/sys/kernel/random/.

But there's really not much point in changing this threshold. If
you're reading the /dev/random side at the same rate or more often
that entropy is appearing, you'll run out regardless of how big your
buffer is.

-- 
Mathematics is the supreme nostalgia of our time.
