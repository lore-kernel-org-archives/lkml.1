Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932313Ab0CDUCO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 15:02:14 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36435 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932292Ab0CDUCL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 15:02:11 -0500
Date: Thu, 4 Mar 2010 12:01:28 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Dave Airlie <airlied@gmail.com>
cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Dave Airlie <airlied@linux.ie>,
       linux-kernel@vger.kernel.org, dri-devel@lists.sf.net
Subject: Re: [git pull] drm request 3
In-Reply-To: <21d7e9971003041125x1aee3b3ew1e407ca6695e10fc@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.1003041142250.3751@localhost.localdomain>
References: <alpine.DEB.2.00.1003022345100.4099@skynet.skynet.ie>  <alpine.LFD.2.00.1003041015080.3588@localhost.localdomain>  <20100304103655.0b14343f@jbarnes-piketon>  <20100304103929.6eb81d45@jbarnes-piketon>  <alpine.LFD.2.00.1003041047400.3751@localhost.localdomain>
  <20100304105624.70fe845e@jbarnes-piketon>  <alpine.LFD.2.00.1003041101390.3751@localhost.localdomain> <21d7e9971003041125x1aee3b3ew1e407ca6695e10fc@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 5 Mar 2010, Dave Airlie wrote:
> 
> At the moment in Fedora we deal with this for our users, we have 
> dependencies between userspace and kernel space and we upgrade the bits 
> when they upgrade the kernels, its a pain in the ass, but its what we 
> accepted we needed to do to get nouveau in front of people. We are 
> currently maintain 3 nouveau APIs across F11, F12 and F13.

Can we try to make it less of a pain in the ass at some other level?

For example, I realize that it's a real pain - both for the kernel _and_ 
for the user space library - to dynamically have to support multiple 
versions of some interface. 

And doing it _statically_ (with a compile option) isn't much better, 
because you end up not only with source code from hell, you still end up 
with the problem of having to compile the libraries and the kernel for the 
same interface, and not being able to mix.

So let's say that we live with an API that changes, where none of the 
binaries (and no single version of the source code either) really support 
anything but _their_ version of the interface.

Why does it then have to be such an effing pain for the _user_?

(And by being such an effing pain for the user, it also becomes indirectly 
a pain for the distribution too - now you have all those nasty 
dependencies where you really cannot mix things up at all, and you can't 
upgrade one piece without upgrading the other).

> Now I can ask Ben if he'd like to try and supply a libdrm that could in 
> theory deal with both as a favour, but I'm not expecting the nouveau 
> project guys to care, we pretty much got ourselves into this corner, and 
> we'll pretty much have to get ourselves out.

Quite frankly, I really don't think that's a wonderful option either. 
Havign dynamic conditionals in code not only makes things worse to 
maintain, they slow things down too, and make code bigger.

So what I'd look for is a sane technical solution to the technical problem 
of "that ABI screwed up". 

And it's not like this is a new issue. We've had this several times 
before. It's called versioning, and the solution tends to pretty much 
_always_ boil down to two cases:

 - don't _ever_ change the ABI in backwards-incompatible ways, and have 
   "feature flags" to say what level of support ther is.

   This is quite common, but it really does require that backwards 
   compatibility. You can add features, but every time you add a feature, 
   you still maintain the old ones _and_ new users need to check the 
   feature flag first (and fall back on the old way of doing things if the 
   new feature isn't there)

   Clearly this one doesn't seem to work for DRM. And quite frankly, I 
   suspect it's at least partly because some DRM people aren't even
   _trying_ - possibly because they aren't even thinking about these kinds 
   of issues.

 - Install multiple versions concurrently, and know they are incompatible, 
   but pick the right one automatically.

   I really don't understand why this wouldn't solve all your distro 
   problems, _and_ solve my kind of user problems too. It's simply not 
   acceptable to just say "ok, X doesn't work". Why aren't the libdrm 
   libraries simply _versioned_?

   IOW, why can't we just have 

	/usr/lib64/xorg/modules/drivers/nouveau_drv-0.0.15.so
	/usr/lib64/xorg/modules/drivers/nouveau_drv-0.0.16.so

   living happily side-by-side? Why can't we just switch between Fedora 
   11, 12 and 13 kernels, and automatically get the right library? The 
   glibc people do it based on hardware features. It's just a "dlopen()" 
   away.

This isn't rocket science. I shouldn't need to complain. I think it would 
make the life of even the _developers_ much easier.

Who was the less-than-rocket-scientist that decided that the right thing 
to do was to "check the kernel DRM version support, and exit with an error 
if it doesn't match"?

See what I'm saying? What I care about is that right now, it's impossible 
to switch kernels on a particular setup. That makes it effectively 
impossible to test new kernels sanely. And that really is a _technical_ 
problem.

Btw, I'm sure there are other approaches too. But I really suspect that it 
should be pretty trivial to change nouveau (and I suspect this has nothing 
nouveau-specific in it - it migth even be the X server itself that does 
the DRM version test) to instead of dying, just doing a dlopen() of the 
right version.

Wouldn't the radeon and intel driver people love to be able to do 
something like that -too-?

Seriously. The current situation is not just crap, it's _stupid_ crap.

		Linus
