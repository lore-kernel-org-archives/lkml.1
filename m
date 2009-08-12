Return-Path: <linux-kernel-owner+w=401wt.eu-S1752833AbZHLR7y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752833AbZHLR7y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 13:59:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752040AbZHLR7x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 13:59:53 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:49422 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751336AbZHLR7w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 13:59:52 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH 2/2] vhost_net: a kernel-level virtio server
Date: Wed, 12 Aug 2009 19:59:47 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-5-generic; KDE/4.3.0; x86_64; ; )
Cc: virtualization@lists.linux-foundation.org,
       "Ira W. Snyder" <iws@ovro.caltech.edu>, netdev@vger.kernel.org,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <cover.1249930169.git.mst@redhat.com> <200908121903.22325.arnd@arndb.de> <20090812172141.GA29966@redhat.com>
In-Reply-To: <20090812172141.GA29966@redhat.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200908121959.47222.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+EN+WCl1yem1K92Qeb5IXu+ca4T99PqgzNYdP
 9SCsz2PJvKV22K78SES3vSyVYlAeJz5odAveC7ne7HcJaTRMTZ
 loYlC0kAnMbCGIX6KiHvg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 12 August 2009, Michael S. Tsirkin wrote:
> On Wed, Aug 12, 2009 at 07:03:22PM +0200, Arnd Bergmann wrote:
> > We discussed this before, and I still think this could be directly derived
> > from struct virtqueue, in the same way that vring_virtqueue is derived from
> > struct virtqueue.
> 
> I prefer keeping it simple. Much of abstraction in virtio is due to the
> fact that it needs to work on top of different hardware emulations:
> lguest,kvm, possibly others in the future.  vhost is always working on
> real hardware, using eventfd as the interface, so it does not need that.

Well, that was my point: virtio can already work on a number of abstractions,
so adding one more for vhost should not be too hard.

> > That would make it possible for simple device drivers
> > to use the same driver in both host and guest,
> 
> I don't think so. For example, there's a callback field that gets
> invoked in guest when buffers are consumed.  It could be overloaded to
> mean "buffers are available" in host but you never handle both
> situations in the same way, so what's the point?
>
...
> 
> As I pointed out earlier, most code in virtio net is asymmetrical: guest
> provides buffers, host consumes them.  Possibly, one could use virtio
> rings in a symmetrical way, but support of existing guest virtio net
> means there's almost no shared code.

The trick is to swap the virtqueues instead. virtio-net is actually
mostly symmetric in just the same way that the physical wires on a
twisted pair ethernet are symmetric (I like how that analogy fits).

virtio_net kicks the transmit virtqueue when it has data and
it kicks the receive queue when it has empty buffers to fill,
and it has callbacks when the two are done. You can do the
same in both the guest and the host, but then the guests input
virtqueue is the hosts output virtqueue and vice versa.

Once a virtqueue got kicked from both sides, the vhost_virtqueue
implementation between the two only needs to do a copy_from_user
or copy_to_user (possibly from a thread if it is in atomic context)
and then call the two callback functions. This is basically the
same thing you do already, except that you use slightly different
names for the components.

	Arnd <><
