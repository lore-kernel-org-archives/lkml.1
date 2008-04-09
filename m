Return-Path: <linux-kernel-owner+w=401wt.eu-S1754845AbYDIMro@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754845AbYDIMro (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 08:47:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751758AbYDIMrd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 08:47:33 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:57863
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750812AbYDIMrc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 08:47:32 -0400
Subject: Re: [PATCH RFC 3/5] tun: vringfd receive support.
From: Dor Laor <dor.laor@qumranet.com>
Reply-To: dor.laor@qumranet.com
To: Max Krasnyansky <maxk@qualcomm.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, virtualization@lists.linux-foundation.org
In-Reply-To: <47FBCC3B.7080104@qualcomm.com>
References: <200804052202.09157.rusty@rustcorp.com.au>
	 <200804052204.28518.rusty@rustcorp.com.au>
	 <200804052205.43824.rusty@rustcorp.com.au>  <47FBCC3B.7080104@qualcomm.com>
Content-Type: text/plain
Organization: Qumranet
Date: Wed, 09 Apr 2008 15:46:35 +0300
Message-Id: <1207745195.13196.10.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-04-08 at 12:49 -0700, Max Krasnyansky wrote:
> Rusty Russell wrote:
> > This patch modifies tun to allow a vringfd to specify the receive
> > buffer.  Because we can't copy to userspace in bh context, we queue
> > like normal then use the "pull" hook to actually do the copy.
> > 
> > More thought needs to be put into the possible races with ring
> > registration and a simultaneous close, for example (see FIXME).
> > 
> > We use struct virtio_net_hdr prepended to packets in the ring to allow
> > userspace to receive GSO packets in future (at the moment, the tun
> > driver doesn't tell the stack it can handle them, so these cases are
> > never taken).
> 
> In general the code looks good. The only thing I could not convince myself in
> is whether having generic ring buffer makes sense or not.
> At least the TUN driver would be more efficient if it had its own simple ring
>  implementation. Less indirection, fewer callbacks, fewer if()s, etc. TUN
> already has the file descriptor and having two additional fds for rx and tx
> ring is a waste (think of a VPN server that has to have a bunch of TUN fds).
> Also as I mentioned before Jamal and I wanted to expose some of the SKB fields
> through TUN device. With the rx/tx rings the natural way of doing that would
> be the ring descriptor itself. It can of course be done the same way we copy
> proto info (PI) and GSO stuff before the packet but that means more
> copy_to_user() calls and yet more checks.
> 
> So. What am I missing ? Why do we need generic ring for the TUN ? I looked at
> the lguest code a bit and it seems that we need a bunch of network specific
> code anyway. The cool thing is that you can now mmap the rings into the guest
>  directly but the same thing can be done with TUN specific rings.
> 

The idea was to use the same virtio ring that the guests use.
The thing with TUN specific ring is that the guests are the one
allocating the rings within their memory space and the opposite makes
life very complex.
Cheers,
Dor

> Max
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe netdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

