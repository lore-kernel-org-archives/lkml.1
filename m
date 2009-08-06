Return-Path: <linux-kernel-owner+w=401wt.eu-S1756117AbZHFPkN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756117AbZHFPkN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 11:40:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756103AbZHFPkK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 11:40:10 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:53872 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754523AbZHFPkH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 11:40:07 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Gregory Haskins" <ghaskins@novell.com>
Subject: Re: [PATCH 0/7] AlacrityVM guest drivers Reply-To:
Date: Thu, 6 Aug 2009 17:40:04 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-5-generic; KDE/4.2.98; x86_64; ; )
Cc: "Avi Kivity" <avi@redhat.com>, alacrityvm-devel@lists.sourceforge.net,
       "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
References: <20090803171030.17268.26962.stgit@dev.haskins.net> <4A7AE150.7040009@redhat.com> <4A7AAB1A0200005A00051BED@sinclair.provo.novell.com>
In-Reply-To: <4A7AAB1A0200005A00051BED@sinclair.provo.novell.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200908061740.04276.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX198FlLw4Ym2bv5gnJvEKvQqBn7MNYZj/YobHeh
 S3MtGkbFrYovTRvtoSkQA6c6fK/bAxhIaL8hPvLjZf4hvtlwAn
 rh7A2z4uKwEnGOhXMN4sA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 06 August 2009, Gregory Haskins wrote:
> We can exchange out the "virtio-pci" module like this:
> 
>   (guest-side)
> |--------------------------
> | virtio-net
> |--------------------------
> | virtio-ring
> |--------------------------
> | virtio-bus
> |--------------------------
> | virtio-vbus
> |--------------------------
> | vbus-proxy
> |--------------------------
> | vbus-connector
> |--------------------------
>                       |
>                    (vbus)
>                       |
> |--------------------------
> | kvm.ko
> |--------------------------
> | vbus-connector
> |--------------------------
> | vbus
> |--------------------------
> | virtio-net-tap (vbus model)
> |--------------------------
> | netif
> |--------------------------
>      (host-side)
> 
> 
> So virtio-net runs unmodified.  What is "competing" here is "virtio-pci" vs "virtio-vbus".
> Also, venet vs virtio-net are technically competing.  But to say "virtio vs vbus" is inaccurate, IMO.


I think what's confusing everyone is that you are competing on multiple
issues:

1. Implementation of bus probing: both vbus and virtio are backed by
PCI devices and can be backed by something else (e.g. virtio by lguest
or even by vbus).

2. Exchange of metadata: virtio uses a config space, vbus uses devcall
to do the same.

3. User data transport: virtio has virtqueues, vbus has shm/ioq.

I think these three are the main differences, and the venet vs. virtio-net
question comes down to which interface the drivers use for each aspect. Do
you agree with this interpretation?

Now to draw conclusions from each of these is of course highly subjective,
but this is how I view it:

1. The bus probing is roughly equivalent, they both work and the
virtio method seems to need a little less code but that could be fixed
by slimming down the vbus code as I mentioned in my comments on the
pci-to-vbus bridge code. However, I would much prefer not to have both
of them, and virtio came first.

2. the two methods (devcall/config space) are more or less equivalent
and you should be able to implement each one through the other one. The
virtio design was driven by making it look similar to PCI, the vbus
design was driven by making it easy to implement in a host kernel. I
don't care too much about these, as they can probably coexist without
causing any trouble. For a (hypothetical) vbus-in-virtio device,
a devcall can be a config-set/config-get pair, for a virtio-in-vbus,
you can do a config-get and a config-set devcall and be happy. Each
could be done in a trivial helper library.

3. The ioq method seems to be the real core of your work that makes
venet perform better than virtio-net with its virtqueues. I don't see
any reason to doubt that your claim is correct. My conclusion from
this would be to add support for ioq to virtio devices, alongside
virtqueues, but to leave out the extra bus_type and probing method.

	Arnd <><
