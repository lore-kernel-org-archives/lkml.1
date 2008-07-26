Return-Path: <linux-kernel-owner+w=401wt.eu-S1753148AbYGZJpT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753148AbYGZJpT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 05:45:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751646AbYGZJpH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 05:45:07 -0400
Received: from nox.protox.org ([88.191.38.29]:59671 "EHLO nox.protox.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751611AbYGZJpF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 05:45:05 -0400
Date: Sat, 26 Jul 2008 11:44:58 +0200
From: Jerome Glisse <glisse@freedesktop.org>
To: Nicolai =?ISO-8859-1?Q?H=E4hnle?= <prefect@upb.de>
Cc: dri-devel@lists.sourceforge.net, Jonathan McDowell <noodles@earth.li>,
       linux-kernel@vger.kernel.org
Subject: Re: X "Hangs" with RS690 + 2.6.26
Message-Id: <20080726114458.20ab97e3.glisse@freedesktop.org>
In-Reply-To: <200807251905.04488.prefect@upb.de>
References: <20080725094334.GC30002@earth.li>
	<20080725121259.757499a9.glisse@freedesktop.org>
	<200807251905.04488.prefect@upb.de>
Organization: freedesktop.org
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Jul 2008 19:04:55 +0200
Nicolai Hähnle <prefect@upb.de> wrote:

> Am Freitag 25 Juli 2008 12:12:59 schrieb Jerome Glisse:
> > This looks like usual engine lockup followed by CP lockup so
> > that DMA buffer age never get written and we run out of DMA
> > buffer thus freelist failing in infinite loop.
> >
> > I think we now know all the reason why we lockup, while a
> > fix could be made for old ioctl we believe the best plan is
> > to work on new ioctl with this fix in mind.
> 
> I can't help but feel uneasy with that kind of plan. After all, do "we" 
> *really* know what's going on? I always had the impression that we only knew 
> things along the lines of "perhaps it's better to submit 3D stuff in indirect 
> buffers".
> 
> If you *really* know what causes the lockups, could you please document that? 
> As in, what's the actual command processor sequence that is to blame? I know  
> that running e.g. a Nexuiz demo + glxgears window above it is apparently a 
> 100% guaranteed lockup on my system (R420).
> 
> If you could share your progress in tracking down the sources of the lockups, 
> I'd happily try to write a patch against the current system.
> 
> cu,
> Nicolai
> 

Here is a brief list from top of my head for the record : 

- no RB3D_DSTCACHE twice in a row without rendering cmd in btw
- initialize all clip register to default values wait for engine idle
  after setting them
- update wptr every 32 dwords (2 dwords seems enough but that one
  is very hard to track)
- use indirect buffer
- RB3D_DSTCACHE is not pipelined if free or sync bit is not set
  thus you have to feel the fifo and wait for idle before writing
  it if none of these bits are set
- flush & wait until 3d before 2d, and flush & wait dma & 2d idle
  after 2d as well feel the fifo with dummy 2d reg to avoid unpipelined
  3d reg to get executed before idle is asserted
- avoid emitting cliprect too much
- txinval before changing texture
- avoid stuff RB3D_DSTCACHE & RB2D_DSTCACHE too much
- set ISYNC properly through CP
- CP idle is wrong we should wait for tag and not
  try to force CP to goes idle or inject flush after
  idle
- set vertex shader constant & input to default safe value

And there is other things to think about scattered in my drm.
Baiscly things should be set in some order to make sure the
engine will not be unhappy in face of a cmd stream. Some of the
above might be wrong but i use them because somehow they each
one of them seems to give me more stable drm. The last drm
i have doesn't lockup in the case of few glxgears on top
of other 3d app like celestia and likely nexuiz haven't tried
that one.

Cheers,
Jerome Glisse <glisse@freedesktop.org>
