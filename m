Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756072Ab0CDWNL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 17:13:11 -0500
Received: from mail-gx0-f217.google.com ([209.85.217.217]:62644 "EHLO
	mail-gx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755975Ab0CDWNA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 17:13:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=EcVATLxo5giJtd3FwULfxxs8+ui33VI1ZFwaIP5KExGc4Y2rqb+yiW5gGoCrapxRfH
         4eIwStuK2wLUNFQ8jcPLXB4Srt4ReVIN6miaFgoHeQIl/oeS4BE+hcsb1hDCB6esyTsh
         G6nTGjlPalLEBM4jU+lPkoRLkayU+NPS2GV8E=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1003041142250.3751@localhost.localdomain>
References: <alpine.DEB.2.00.1003022345100.4099@skynet.skynet.ie>
	 <alpine.LFD.2.00.1003041015080.3588@localhost.localdomain>
	 <20100304103655.0b14343f@jbarnes-piketon>
	 <20100304103929.6eb81d45@jbarnes-piketon>
	 <alpine.LFD.2.00.1003041047400.3751@localhost.localdomain>
	 <20100304105624.70fe845e@jbarnes-piketon>
	 <alpine.LFD.2.00.1003041101390.3751@localhost.localdomain>
	 <21d7e9971003041125x1aee3b3ew1e407ca6695e10fc@mail.gmail.com>
	 <alpine.LFD.2.00.1003041142250.3751@localhost.localdomain>
Date: Fri, 5 Mar 2010 08:06:57 +1000
Message-ID: <21d7e9971003041406n53d9cae0h53374abf3dca494e@mail.gmail.com>
Subject: Re: [git pull] drm request 3
From: Dave Airlie <airlied@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Dave Airlie <airlied@linux.ie>,
       linux-kernel@vger.kernel.org, dri-devel@lists.sf.net
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Can we try to make it less of a pain in the ass at some other level?
>
> For example, I realize that it's a real pain - both for the kernel _and_
> for the user space library - to dynamically have to support multiple
> versions of some interface.
>
> And doing it _statically_ (with a compile option) isn't much better,
> because you end up not only with source code from hell, you still end up
> with the problem of having to compile the libraries and the kernel for the
> same interface, and not being able to mix.
>
> So let's say that we live with an API that changes, where none of the
> binaries (and no single version of the source code either) really support
> anything but _their_ version of the interface.
>
> Why does it then have to be such an effing pain for the _user_?
>
> (And by being such an effing pain for the user, it also becomes indirectly
> a pain for the distribution too - now you have all those nasty
> dependencies where you really cannot mix things up at all, and you can't
> upgrade one piece without upgrading the other).
>
>> Now I can ask Ben if he'd like to try and supply a libdrm that could in
>> theory deal with both as a favour, but I'm not expecting the nouveau
>> project guys to care, we pretty much got ourselves into this corner, and
>> we'll pretty much have to get ourselves out.
>
> Quite frankly, I really don't think that's a wonderful option either.
> Havign dynamic conditionals in code not only makes things worse to
> maintain, they slow things down too, and make code bigger.
>
> So what I'd look for is a sane technical solution to the technical problem
> of "that ABI screwed up".
>
> And it's not like this is a new issue. We've had this several times
> before. It's called versioning, and the solution tends to pretty much
> _always_ boil down to two cases:
>
>  - don't _ever_ change the ABI in backwards-incompatible ways, and have
>   "feature flags" to say what level of support ther is.
>
>   This is quite common, but it really does require that backwards
>   compatibility. You can add features, but every time you add a feature,
>   you still maintain the old ones _and_ new users need to check the
>   feature flag first (and fall back on the old way of doing things if the
>   new feature isn't there)
>
>   Clearly this one doesn't seem to work for DRM. And quite frankly, I
>   suspect it's at least partly because some DRM people aren't even
>   _trying_ - possibly because they aren't even thinking about these kinds
>   of issues.

We've done this exactly like this since the drm went upstream, I think
there has been one interface incompatible change in the kernel drm since
it was upstream, in i810 back in the XFree86 days. KMS required new config
options since moving the card init into the kernel, was going to break
or be broken
by a userspace driver reiniting that card, and we've retained compatiblity
with older drivers fine.

So you are tarring the whole drm with the interface to one driver
which is clearly
marked as having an unstable ABI. Nouveau is different, they have had no
reason to version or make a stable interface until they could design
an interface
that would expose the features of the hw that they are trying to build
a driver for.
They've also used the timing to drop all support for legacy user modesetting
drivers while they could, before it was deployed on a lot of people's machines
in a lot of places.


>   I really don't understand why this wouldn't solve all your distro
>   problems, _and_ solve my kind of user problems too. It's simply not
>   acceptable to just say "ok, X doesn't work". Why aren't the libdrm
>   libraries simply _versioned_?

This would require redesigning the whole way distros build and distribute
packages. Having to build 4-5 versions of nouveau for each version of Fedora
would be a major increase in overheads for a minimal amount of return.

>
>   IOW, why can't we just have
>
>        /usr/lib64/xorg/modules/drivers/nouveau_drv-0.0.15.so
>        /usr/lib64/xorg/modules/drivers/nouveau_drv-0.0.16.so
>
>   living happily side-by-side? Why can't we just switch between Fedora
>   11, 12 and 13 kernels, and automatically get the right library? The
>   glibc people do it based on hardware features. It's just a "dlopen()"
>   away.
>
> This isn't rocket science. I shouldn't need to complain. I think it would
> make the life of even the _developers_ much easier.
>
> Who was the less-than-rocket-scientist that decided that the right thing
> to do was to "check the kernel DRM version support, and exit with an error
> if it doesn't match"?
>
> See what I'm saying? What I care about is that right now, it's impossible
> to switch kernels on a particular setup. That makes it effectively
> impossible to test new kernels sanely. And that really is a _technical_
> problem.
>
> Btw, I'm sure there are other approaches too. But I really suspect that it
> should be pretty trivial to change nouveau (and I suspect this has nothing
> nouveau-specific in it - it migth even be the X server itself that does
> the DRM version test) to instead of dying, just doing a dlopen() of the
> right version.
>
> Wouldn't the radeon and intel driver people love to be able to do
> something like that -too-?

Speaking as distro maintainer here,

No because we've got versioned interfaces and we are happy to support them
yes it would be nice sometimes to dream about this, but its a major explosion in
the testing matrix. You have to realise the more codepaths a distro ships, the
more codepath it has to keep track off for security issues, for bug fixes, etc.

When to we decide to stop shipping nouveau_drv-0.0.13? when do we find
out it has a security issue? Here's the thing, distros are trying to ship an
OS with a consistent set of packages, not a pick-n-mix.

I'm going to talk to Ben when we both make it to the same place, from a
nouveau point-of-view I'm quite happy what they've done is technically the
correct solution for them, because otherwise you end up with too many
versions of things to support, and you get distros who aren't willing to put
any developer effort into the project, shipping 3 different versions of things,
(this happens with binary drivers, and its a nightmare).

The thing with redesigning the whole stack like you say, its you are optimising
for the wrong use case, this isn't a common case, this is one off
event that we've
been forced into by merging nouveau upstream. I'd rather not optimise
for this case
if we can get away with it.

Dave.
