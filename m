Return-Path: <linux-kernel-owner+w=401wt.eu-S1751287AbZHSJGG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751287AbZHSJGG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 05:06:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750923AbZHSJGF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 05:06:05 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:51781 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750883AbZHSJGD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 05:06:03 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCHv3 2/2] vhost_net: a kernel-level virtio server
Date: Wed, 19 Aug 2009 11:04:50 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-5-generic; KDE/4.3.0; x86_64; ; )
Cc: virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org, mingo@elte.hu,
       linux-mm@kvack.org, akpm@linux-foundation.org, hpa@zytor.com,
       gregory.haskins@gmail.com, Or Gerlitz <ogerlitz@voltaire.com>
References: <cover.1250187913.git.mst@redhat.com> <200908141340.36176.arnd@arndb.de> <20090816065110.GA3008@redhat.com>
In-Reply-To: <20090816065110.GA3008@redhat.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200908191104.50672.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/xEYq6V4r7YlW85jvOfyIxAOYp5WdJnV/fVxj
 VrbEhTjWRJ6c29Va6i2HxattS3N0hrk5V/HcgYL6mDjhwZO1pu
 TtDh/ZOQ6MQZYv2piCgvQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 16 August 2009, Michael S. Tsirkin wrote:
> On Fri, Aug 14, 2009 at 01:40:36PM +0200, Arnd Bergmann wrote:
> > 
> > * most of the transports are sockets, tap uses a character device.
> >   This could be dealt with by having both a struct socket * in
> >   struct vhost_net *and* a struct file *, or by always keeping the
> >   struct file and calling vfs_readv/vfs_writev for the data transport
> >   in both cases.
> 
> I am concerned that character devices might have weird side effects with
> read/write operations and that calling them from kernel thread the way I
> do might have security implications. Can't point at anything specific
> though at the moment.

I understand your feelings about passing a chardev fd into your driver
and I agree that we need to be very careful if we want to allow it.

Maybe we could instead extend the 'splice' system call to work on a
vhost_net file descriptor. If we do that, we can put the access back
into a user thread (or two) that stays in splice indefinetely to
avoid some of the implications of kernel threads like the missing
ability to handle transfer errors in user space.

> I wonder - can we expose the underlying socket used by tap, or will that
> create complex lifetime issues?

I think this could get more messy in the long run than calling vfs_readv
on a random fd. It would mean deep internal knowledge of the tap driver
in vhost_net, which I really would prefer to avoid.

> > * Each transport has a slightly different header, we have
> >   - raw ethernet frames (raw, udp multicast, tap)
> >   - 32-bit length + raw frames, possibly fragmented (tcp)
> >   - 80-bit header + raw frames, possibly fragmented (tap with vnet_hdr)
> >   To handle these three cases, we need either different ioctl numbers
> >   so that vhost_net can choose the right one, or a flags field in
> >   VHOST_NET_SET_SOCKET, like
> > 
> >   #define VHOST_NET_RAW		1
> >   #define VHOST_NET_LEN_HDR	2
> >   #define VHOST_NET_VNET_HDR	4
> > 
> >   struct vhost_net_socket {
> > 	unsigned int flags;
> > 	int fd;
> >   };
> >   #define VHOST_NET_SET_SOCKET _IOW(VHOST_VIRTIO, 0x30, struct vhost_net_socket)
> 
> It seems we can query the socket to find out the type, 

yes, I understand that you can do that, but I still think that decision
should be left to user space. Adding a length header for TCP streams but
not for UDP is something that we would normally want to do, but IMHO
vhost_net should not need to know about this.

> or use the features ioctl.

Right, I had forgotten about that one. It's probably equivalent
to the flags I suggested, except that one allows you to set features
after starting the communication, while the other one prevents
you from doing that.

> > Qemu could then automatically try to use vhost_net, if it's available
> > in the kernel, or just fall back on software vlan otherwise.
> > Does that make sense?
> 
> I agree, long term it should be enabled automatically when possible.

So how about making the qemu command line interface an extension to
what Or Gerlitz has done for the raw packet sockets?

	Arnd <><
