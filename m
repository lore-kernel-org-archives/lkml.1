Return-Path: <linux-kernel-owner+w=401wt.eu-S1161232AbXEBVDU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161232AbXEBVDU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 17:03:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754534AbXEBVDU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 17:03:20 -0400
Received: from 69-30-77-85.dq1sn.easystreet.com ([69.30.77.85]:59951 "EHLO
	vonnegut.anholt.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993143AbXEBVDS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 17:03:18 -0400
X-Greylist: delayed 2351 seconds by postgrey-1.27 at vger.kernel.org; Wed, 02 May 2007 17:03:13 EDT
Subject: Re: [RFC] [PATCH] DRM TTM Memory Manager patch
From: Eric Anholt <eric@anholt.net>
To: Dave Airlie <airlied@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Thomas =?ISO-8859-1?Q?Hellstr=F6m?= <thomas@tungstengraphics.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       dri-devel@lists.sourceforge.net
In-Reply-To: <21d7e9970704252355m4765b65fyb547b9ba2763b103@mail.gmail.com>
References: <21d7e9970704252355m4765b65fyb547b9ba2763b103@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-PloopFT8CYKggzeklQiR"
Date: Wed, 02 May 2007 13:21:19 -0700
Message-Id: <1178137279.53297.114.camel@vonnegut>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.0 FreeBSD GNOME Team Port 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-PloopFT8CYKggzeklQiR
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2007-04-26 at 16:55 +1000, Dave Airlie wrote:
> Hi,
>=20
> The patch is too big to fit on the list and I've no idea how we could
> break it down further, it just happens to be a lot of new code..
>=20
> http://people.freedesktop.org/~airlied/ttm/0001-drm-Implement-TTM-Memory-=
manager-core-functionality.txt
>=20
> The patch header and diffstat are below,
>=20
> This isn't for integration yet but we'd like an initial review by
> anyone with the spare time and inclination, there is a lot stuff
> relying on getting this code bet into shape and into the kernel but
> any cleanups people can suggest now especially to the user interfaces
> would be appreciated as once we set that stuff in stone it'll be a
> pain to change... also it doesn't have any driver side code, this is
> just the generic pieces. I'll post the intel 915 side code later but
> there isn't that much to it..
>=20
> It applies on top of my drm-2.6 git tree drm-mm branch....
>=20
> -------------------------------------------------------------------------=
----------------------------
>=20
> This patch brings in the TTM (Translation Table Maps) memory
> management
> system from Thomas Hellstrom at Tungsten Graphics.
>=20
> This patch only covers the core functionality and changes to the drm
> core.
>=20
> The TTM memory manager enables dynamic mapping of memory objects in
> and
> out of the graphic card accessible memory (e.g. AGP), this implements
> the AGP backend for TTM to be used by the i915 driver.


I've been slow responding, but we've been talking a lot on IRC and at
Intel about the TTM interface recently, and trying to come up with a
concensus between us as to what we'd like to see.

1) Multiplexed ioctls hurt
The first issue I have with this version is the userland interface.
You've got two ioctls for buffer management and once for fence
management, yet these 3 ioctls are actually just attempting to be
generic interfaces for around 25 actual functions you want to call
(except for the unimplemented ones, drm_bo_fence and drm_bo_ref_fence).
So there are quasi-generic arguments to these ioctls, where most of the
members are ignored by any given function, but it's not obvious to the
caller which ones.  There's no comments or anything as to what the
arguments to these functions are or what exactly they do.  We've got 100
generic ioctl numbers allocated and unused still, so I don't think we
should be shy about having separate ioctls for separate functions, if
this is the interface we expect to use going forward.

2) Early microoptimizations
There's also apparently an unused way to chain these function calls in a
single ioctl call for the buffer object ioctl.  This is one of a couple
of microoptimizations at the expense of code clarity which have bothered
me while reviewing the TTM code, when I'm guessing no testing was done
to see if it was actually a bottleneck.

3) Fencing and flushing troubles
I'm definitely concerned by the fencing interface.  Right now, the
driver is flushing caches and fencing every buffer with EXE and its
driver-specific FLUSHED flag in dispatching command buffers.  We almost
surely don't want to be flushing for every batch buffer just in case
someone wants to do CPU reads from something.  However, with the current
mechanism, if I fence my operation with just EXE and no flush, then
somebody goes to map that buffer, they'll wait for the fence, but no
flush will be emitted.  The interface we've been imagining wouldn't have
driver-specific fence flags, but instead be only a marker of when
command execution has passed a certain point (which is what fencing is
about, anyway).  In validating buffers, you would pass whether they're
for READ or WRITE as we currently do, and you'd put it on the unfenced
read/write lists as appropriate.  Add one buffer object function for
emitting the flush, which would then determine whether the next
fence-all-unfenced call would cover just the list of unfenced reads or
the list of both unfenced reads and unfenced writes.  Then, in mapping,
check if it's on the unfenced-writes list and emit the flush and fence,
and then wait for a fence on the buffer before continuing with the
mapping.

4) Locking and deadlocking
Right now, the main rendering path I'm seeing is something like this:

lock_hardware() # I'm not really sure why this lock is here
map(texture)
write texture data
unmap(texture)
unlock_hardware()

map(some_buffer) # GL lets you have buffers mapped for a long time
write to some_buffer
map(some_buffer_2)
write to some_buffer_2

map(batchbuffer) # start some actual rendering
map(vertices)
write vertices
write commands
unmap(vertices)
unmap(batchbuffer)

unmap(some_buffer) # the GL client called this
unmap(some_buffer_2)

lock_hardware()
validate(batchbuffer)
validate(vertices)
validate(texture)
validate(some_buffer)
validate(some_buffer_2)
validate(backbuffer)
map_while_validated(batchbuffer)
write relocations in batchbuffer
unmap(batchbuffer)
emit(batchbuffer)
fence_unfenced()
unlock_hardware()

There's also a fallback path:
lock_hardware()
map(backbuffer)
map(frontbuffer)
map(vertices)
map(some_buffer)
rendering with cpu
unmaps(...)
unlock_hardware()

Note: map blocks on fencing, and if you don't pass the magic
"while-validated" flag, then validate blocks on unmap.

If we've got GL buffer objects shared between clients, we've got easy
deadlocks available:

client A map buffer 1
				client B locks
				client B validates buffer 2
client A map buffer 2 (block)
				client B validates buffer 1 (block)

I'm not sure to what extent GL allows buffer object sharing, but with
EXT_tfp we're going to need to be dealing with this for the
X Server versus GL interactions.

5) Fixing locking by not doing it
So, it looks like the existing hardware lock isn't cutting it for
avoiding deadlocks.  Additionally, we'd like to get to a point where I
can have some random app running things on my graphics card with my GUI
server clueless that it's happening (more access control would be
needed, but allowing lock pushdown is the main design issue here, I
think).  That pretty much means having a hardware lock that an app can
hold for an arbitrary amount of time has to go away.

Since we've got the lock_hardware() around any series of validates for
rendering, we've been thinking about pushing that whole series of
operations into one device-specific (probably?) ioctl:

submit_buffers(buffer_list, relocation_list, bool full_state)

There's a comment suggesting that this is a good idea on
intel_batchbuffers already.  This submit_buffers would do:

choose offsets to validate into
perform relocations
validate the buffers with the given flags
emit flush if indicated
emit the fence

For multi-context hardware, the kernel then gets to choose which
rendering context this batchbuffer will be run on.  If it can't give you
a context with the same state, it returns EBUSY or whatever and you
resubmit with full state upload and the flag saying so.  Additionally,
the kernel can then do reasonable simulation of multi-context hardware
on hardware with context save/restore, which we haven't been doing
before.

Also, since the kernel has all the buffers needed for validate at once,
it can be smarter about placing the allocations, as right now you could
possibly get aperture fragmentation from early validates which prevent
later buffer validations from succeeding.

With this and removing what appears to be an unnecessary hardware lock
from the texture write, we've got userland locking out of the hardware
rendering path, we've got a nice system for multi-context hardware and
the ability for the kernel to simulate multiple contexts if not, and we
can remove most of the userland interface, getting us down to:

bo_create
bo_map
bo_unmap
bo_ref
bo_unref
submit_buffers
fence_reference
fence_unreference
fence_wait

That's a lot less than 25 entrypoints, and I like that.  Plus, with this
and the DRM modesetting work, adding access control and batchbuffer
validation is "all" that's needed to get the kernel scheduling arbitrary
programs doing random things on the card with your gui unaware of it.

But this still leaves the map versus validate deadlocks.  The
closest we've come up with to a solution is: "Maps never block on maps,
validate blocks on unmap, and map blocks on (write-flushed if necessary)
fence completion.  It is up to threads performing submit_buffers and
maps on shared objects to arrange external synchronization to avoid
deadlock."  This has the advantage that those threads likely have some
sort of protocol requirements for rendering consistency between those
objects, and are going to be doing some sort of synchronization anyway.
I'm just not sure yet on how feasible it is to bend GL into this model.

--=20
Eric Anholt                             anholt@FreeBSD.org
eric@anholt.net                         eric.anholt@intel.com


--=-PloopFT8CYKggzeklQiR
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (FreeBSD)

iD8DBQBGOPK/HUdvYGzw6vcRAsw7AJwJor5G7ob/A2G4EQFiMRNZ1wq37ACgnMlP
icuxRMCvGcDZdoXmdCp1qoY=
=/kIx
-----END PGP SIGNATURE-----

--=-PloopFT8CYKggzeklQiR--
