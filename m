Return-Path: <linux-kernel-owner+w=401wt.eu-S1755521AbZHNLlF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755521AbZHNLlF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 07:41:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754285AbZHNLlE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 07:41:04 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:49377 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753490AbZHNLlB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 07:41:01 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: virtualization@lists.linux-foundation.org
Subject: Re: [PATCHv3 2/2] vhost_net: a kernel-level virtio server
Date: Fri, 14 Aug 2009 13:40:36 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-5-generic; KDE/4.3.0; x86_64; ; )
Cc: "Michael S. Tsirkin" <mst@redhat.com>, netdev@vger.kernel.org,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org, mingo@elte.hu,
       linux-mm@kvack.org, akpm@linux-foundation.org, hpa@zytor.com,
       gregory.haskins@gmail.com
References: <cover.1250187913.git.mst@redhat.com> <20090813182931.GC6585@redhat.com>
In-Reply-To: <20090813182931.GC6585@redhat.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200908141340.36176.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/LNImHYhQeMmxSI+e/f3pKCyopJDMAg2UoT9q
 PURcy8qMyd1+HWZ2jVa4t+sgXpoHfnFQOJCFBU+N0NVvOgpfQG
 UieoyKXUDJvU4rmAbu9Cw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 13 August 2009, Michael S. Tsirkin wrote:
> What it is: vhost net is a character device that can be used to reduce
> the number of system calls involved in virtio networking.
> Existing virtio net code is used in the guest without modification.

AFAICT, you have addressed all my comments, mostly by convincing me
that you got it right anyway ;-).

I hope this gets into 2.6.32, good work!

> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

Acked-by: Arnd Bergmann <arnd@arndb.de>

One idea though:

> +	/* Parameter checking */
> +	if (sock->sk->sk_type != SOCK_RAW) {
> +		r = -ESOCKTNOSUPPORT;
> +		goto done;
> +	}
> +
> +	r = sock->ops->getname(sock, (struct sockaddr *)&uaddr.sa,
> +			       &uaddr_len, 0);
> +	if (r)
> +		goto done;
> +
> +	if (uaddr.sa.sll_family != AF_PACKET) {
> +		r = -EPFNOSUPPORT;
> +		goto done;
> +	}

You currently limit the scope of the driver by only allowing raw packet
sockets to be passed into the network driver. In qemu, we currently support
some very similar transports:

* raw packet (not in a release yet)
* tcp connection
* UDP multicast
* tap character device
* VDE with Unix local sockets

My primary interest right now is the tap support, but I think it would
be interesting in general to allow different file descriptor types
in vhost_net_set_socket. AFAICT, there are two major differences
that we need to handle for this:

* most of the transports are sockets, tap uses a character device.
  This could be dealt with by having both a struct socket * in
  struct vhost_net *and* a struct file *, or by always keeping the
  struct file and calling vfs_readv/vfs_writev for the data transport
  in both cases.

* Each transport has a slightly different header, we have
  - raw ethernet frames (raw, udp multicast, tap)
  - 32-bit length + raw frames, possibly fragmented (tcp)
  - 80-bit header + raw frames, possibly fragmented (tap with vnet_hdr)
  To handle these three cases, we need either different ioctl numbers
  so that vhost_net can choose the right one, or a flags field in
  VHOST_NET_SET_SOCKET, like

  #define VHOST_NET_RAW		1
  #define VHOST_NET_LEN_HDR	2
  #define VHOST_NET_VNET_HDR	4

  struct vhost_net_socket {
	unsigned int flags;
	int fd;
  };
  #define VHOST_NET_SET_SOCKET _IOW(VHOST_VIRTIO, 0x30, struct vhost_net_socket)

If both of those are addressed, we can treat vhost_net as a generic
way to do network handling in the kernel independent of the qemu
model (raw, tap, ...) for it. 

Your qemu patch would have to work differently, so instead of 

qemu -net nic,vhost=eth0

you would do the same as today with the raw packet socket extension

qemu -net nic -net raw,ifname=eth0 

Qemu could then automatically try to use vhost_net, if it's available
in the kernel, or just fall back on software vlan otherwise.
Does that make sense?

	Arnd <>
