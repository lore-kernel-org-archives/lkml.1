Return-Path: <linux-kernel-owner+w=401wt.eu-S1754073AbZHJWQ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754073AbZHJWQ1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 18:16:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754019AbZHJWQ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 18:16:26 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:50143 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753934AbZHJWQZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 18:16:25 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH 2/2] vhost_net: a kernel-level virtio server
Date: Mon, 10 Aug 2009 22:16:22 +0000
User-Agent: KMail/1.11.2 (Linux/2.6.29; KDE/4.2.2; x86_64; ; )
Cc: virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <cover.1249930169.git.mst@redhat.com> <200908102151.18529.arnd@arndb.de> <20090810201044.GA16899@redhat.com>
In-Reply-To: <20090810201044.GA16899@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908102216.22410.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+/ST2JTFufgynSX0LsSSe56xHdNwbOTvZibPf
 XFTkk5n10ixS2VLlJqswPG4e3bA73tiBWEdcX74N+nOW7zKrx0
 /PMblAcMfDHojrHVoP4dw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 10 August 2009 20:10:44 Michael S. Tsirkin wrote:
> On Mon, Aug 10, 2009 at 09:51:18PM +0200, Arnd Bergmann wrote:
> > what is the difference between vhost_net_reset_owner(n)
> > and vhost_net_set_socket(n, -1)?
> 
> set socket to -1 will only stop the device.
> 
> reset owner will let another process take over the device.
> It also needs to reset all parameters to make it safe for that
> other process, so in particular the device is stopped.

ok
 
> I tried explaining this in the header vhost.h - does the comment
> there help, or do I need to clarify it?

No, I just didn't get there yet.

> I had the impression that if there's no compat_ioctl,
> unlocked_ioctl will get called automatically. No?

It will issue a kernel warning but not call unlocked_ioctl,
so you need either a compat_ioctl method or list the numbers
in fs/compat_ioctl.c, which I try to avoid.

> > Why do you need a kernel thread here? If the data transfer functions
> > all get called from a guest intercept, shouldn't you already be
> > in the right mm?
> 
> several reasons :)
> - I get called under lock, so can't block
> - eventfd can be passed to another process, and I won't be in guest context at all
> - this also gets called outside guest context from socket poll
> - vcpu is blocked while it's doing i/o. it is better to free it up
>   as all the packet copying might take a while

Ok.

> > I guess that this is where one could plug into macvlan directly, using
> > sock_alloc_send_skb/memcpy_fromiovec/dev_queue_xmit directly,
> > instead of filling a msghdr for each, if we want to combine this
> > with the work I did on that.
> 
> quite possibly. Or one can just bind a raw socket to macvlan :)

Right, that works as well, but may get more complicated once we
try to add zero-copy or other optimizations.

	Arnd <><
