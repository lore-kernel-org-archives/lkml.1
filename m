Return-Path: <linux-kernel-owner+w=401wt.eu-S1764862AbZAPGL2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764862AbZAPGL2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 01:11:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755395AbZAPGLR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 01:11:17 -0500
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:32774
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751725AbZAPGLQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 01:11:16 -0500
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: Jamie Lokier <jamie@shareable.org>
Subject: Re: PATCH [0/3]: Simplify the kernel build by removing perl.
Date: Fri, 16 Jan 2009 00:11:09 -0600
User-Agent: KMail/1.10.1 (Linux/2.6.27-9-generic; KDE/4.1.2; x86_64; ; )
Cc: Paul Mundt <lethal@linux-sh.org>, Sam Ravnborg <sam@ravnborg.org>,
       "Mark A. Miller" <mark@mirell.org>, Bernd Petrovitsch <bernd@firmix.at>,
       Leon Woestenberg <leon.woestenberg@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Embedded Linux mailing list <linux-embedded@vger.kernel.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
References: <495FEEAF.5020005@zytor.com> <20090112103820.GF28564@linux-sh.org> <20090114025115.GB22154@shareable.org>
In-Reply-To: <20090114025115.GB22154@shareable.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200901160011.11679.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 13 January 2009 20:51:16 Jamie Lokier wrote:
> Paul Mundt wrote:
> > This happens in a lot of places, like embedded gentoo ports, where almost
> > all of the work is sent across distcc to a cross-compilation machine. In
> > systems that use package management, it is done on the host through
> > emulation, or painfully cross-compiled.
>
> Ah yes, I remember using embedded Gentoo.
>
> 95% of the time in ./configure scripts, 5% in compilations.

With SMP becoming commonplace, expect this to become the norm everywhere.  
Once you get to around quad processor, any C program with a ./configure step 
is probably going to take longer to configure than to compile.  (Of course C++ 
manages to remain slow enough that autoconf isn't so obvious a bottleneck.)

> And this is on x86!  I dread to think how slow it gets on something
> slow.

My friend Mark's been experimenting with the amazon "cloud" thing, feeding in 
an image with a qemu instance and distcc+cross-compiler, and running builds 
under that.  Renting an 8-way ~2.5 ghz server with 7 gigabytes of ram and 1.6 
terabytes of disk is 80 cents/hour through them plus another few cents/day for 
bandwidth and persistent storage and such.  That's likely to get cheaper as 
time goes on.

We're still planning to buy a build server of our own to have something in-
house, but for running nightly builds it's almost to the point where 
depreciation on the hardware is more than buying time from a server farm.  
Just _one_ of those 8-way servers is enough hardware to build an entire distro 
in an hour or so.

What this really allows us to do is experiment with "how parallel can we get 
our build"?  Because renting ten 8-way servers in a cluster is $8/hour, and 
distcc already scales trivially over that.  Down the road what Firmware Linux 
is working towards is multiple qemu instances running in parallel with a 
central instance distributing builds to each one, so each can do its own 
./configure in parallel, distribute compilation to the distccd instances as it 
has stuff to compile, and then package up the resulting binary into one of 
those portage tarballs and send it back to the central node to install on a 
network mount that the lot of 'em can mount as build context, so the packages 
can get their dependencies right.  (You don't want your build taking place in 
a network mount, but your OS being on one you never write to isn't so bad as 
long as you have local storage to build in.)

We'll probably leverage the heck out of Portage for this, and might wind up 
modifying it heavily.  Dunno yet.  (We can even force dependencies on portage 
so it doesn't need to calculate 'em, the central node can do that and then say 
"you have these packages, _build_"...)

But yeah, hobbyists with a laptop, network access, and a monthly budget of $20 
can do cluster builds these days.

Rob

P.S.  I still hope autoconf dies off and the world wakes up and moves away 
from that.  And from makefiles for that matter.  But in the meantime, I can 
work around it with enough effort.
