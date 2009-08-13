Return-Path: <linux-kernel-owner+w=401wt.eu-S1754542AbZHMNi4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754542AbZHMNi4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 09:38:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754526AbZHMNiy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 09:38:54 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:50901 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753857AbZHMNiv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 09:38:51 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH 2/2] vhost_net: a kernel-level virtio server
Date: Thu, 13 Aug 2009 15:38:43 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-5-generic; KDE/4.3.0; x86_64; ; )
Cc: virtualization@lists.linux-foundation.org,
       "Ira W. Snyder" <iws@ovro.caltech.edu>, netdev@vger.kernel.org,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <cover.1249930169.git.mst@redhat.com> <200908121959.47222.arnd@arndb.de> <20090813060615.GC3029@redhat.com>
In-Reply-To: <20090813060615.GC3029@redhat.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200908131538.44465.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/JEDJT2qGntojMJRdXOSUJBrOuj17237Cie1n
 NvwP91FLyU7fHUiS4k2EoAxi3RvcMP5pJLzgXcLBgz06U6XIAD
 KnhPNaulUmKVAswPfikLQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 13 August 2009, Michael S. Tsirkin wrote:
> On Wed, Aug 12, 2009 at 07:59:47PM +0200, Arnd Bergmann wrote:
> > The trick is to swap the virtqueues instead. virtio-net is actually
> > mostly symmetric in just the same way that the physical wires on a
> > twisted pair ethernet are symmetric (I like how that analogy fits).
> 
> You need to really squint hard for it to look symmetric.
> 
> For example, for RX, virtio allocates an skb, puts a descriptor on a
> ring and waits for host to fill it in. Host system can not do the same:
> guest does not have access to host memory.
> 
> You can do a copy in transport to hide this fact, but it will kill
> performance.

Yes, that is what I was suggesting all along. The actual copy operation
has to be done by the host transport, which is obviously different from
the guest transport that just calls the host using vring_kick().

Right now, the number of copy operations in your code is the same.
You are doing the copy a little bit later in skb_copy_datagram_iovec(),
which is indeed a very nice hack. Changing to a virtqueue based method
would imply that the host needs to add each skb_frag_t to its outbound
virtqueue, which then gets copied into the guests inbound virtqueue.

Unfortunately, this also implies that you could no longer simply use the
packet socket interface as you do currently, as I realized only now.
This obviously has a significant impact on your user space interface.

	Arnd <><
