Return-Path: <linux-kernel-owner+w=401wt.eu-S1757386AbZHZNmu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757386AbZHZNmu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 09:42:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757315AbZHZNmt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 09:42:49 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:50996 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757304AbZHZNms (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 09:42:48 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: virtualization@lists.linux-foundation.org
Subject: Re: [PATCHv4 2/2] vhost_net: a kernel-level virtio server
Date: Wed, 26 Aug 2009 15:40:59 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-5-generic; KDE/4.3.0; x86_64; ; )
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>, kvm@vger.kernel.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, hpa@zytor.com, mingo@elte.hu,
       akpm@linux-foundation.org
References: <cover.1250693417.git.mst@redhat.com> <200908252140.41295.rusty@rustcorp.com.au> <20090825175016.GA15790@redhat.com>
In-Reply-To: <20090825175016.GA15790@redhat.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200908261540.59900.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19/IwsaTLAdS9e9XY7XJ+yCsalWDmSGyq/UE1T
 y1QWCZUYE6Xa9kOw+8OMEQ4RyxGOnJgDrFmC4mIOZn/BH+cysh
 nMPiFy4ZkhYmWTsXiW2wQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 25 August 2009, Michael S. Tsirkin wrote:
> >  I'd like to avoid that here,
> > though it's kind of ugly.  We'd need VHOST_GET_FEATURES (and ACK) to take a
> > struct like:
> > 
> >       u32 feature_size;
> >       u32 features[];

Hmm, variable length ioctl arguments, I'd rather not go there.
The ioctl infrastructure already has a length argument encoded
in the ioctl number. We can use that if we need more, e.g.

/* now */
#define VHOST_GET_FEATURES     _IOR(VHOST_VIRTIO, 0x00, __u64)
/*
 * uncomment if we run out of feature bits:

struct vhost_get_features2 {
	__u64 bits[2];
};
#define VHOST_GET_FEATURES2     _IOR(VHOST_VIRTIO, 0x00, \
			struct  vhost_get_features2)
 */

> Thinking about this proposal some more, how will the guest
> determine the size to supply the GET_FEATURES ioctl?

Wait, the *guest*?

Maybe I misunderstood something in a major way here, but
I expected the features to be negotiated between host
user space (qemu) and host kernel, as well as between
guest and qemu (as they are already), but never between
guest and kernel.

I would certainly expect the bits to be distinct from
the virtio-net feature bits. E.g. stuff like TAP frame
format opposed to TCP socket frame format (length+date)
is something we need to negotiate here but that the
guest does not care about.

> Since we are a bit tight in 32 bit space already,
> let's just use a 64 bit integer and be done with it?

Can't hurt, but don't use a struct unless you think
we are going to need more than 64 bits.

	Arnd <><
