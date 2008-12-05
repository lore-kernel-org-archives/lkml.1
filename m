Return-Path: <linux-kernel-owner+w=401wt.eu-S1756114AbYLEPIr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756114AbYLEPIr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 10:08:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752895AbYLEPIh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 10:08:37 -0500
Received: from mx2.redhat.com ([66.187.237.31]:55123 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752837AbYLEPIg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 10:08:36 -0500
Subject: Re: [PATCH] virtio: make PCI devices take a virtio_pci module ref
From: Mark McLoughlin <markmc@redhat.com>
Reply-To: Mark McLoughlin <markmc@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
       Anthony Liguori <aliguori@us.ibm.com>, Michael Tokarev <mjt@tls.msk.ru>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
In-Reply-To: <200812051043.51417.rusty@rustcorp.com.au>
References: <1228394671.3732.77.camel@blaa>
	 <200812051043.51417.rusty@rustcorp.com.au>
Content-Type: text/plain; charset=utf-8
Date: Fri, 05 Dec 2008 15:07:06 +0000
Message-Id: <1228489626.3858.37.camel@blaa>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rusty,

On Fri, 2008-12-05 at 10:43 +1030, Rusty Russell wrote:
> On Thursday 04 December 2008 23:14:31 Mark McLoughlin wrote:
> > Nothing takes a ref on virtio_pci, so even if you have
> > devices in use, rmmod will attempt to unload the module.
> > 
> > Fix by simply making each device take a ref on the module.
> 
> Hi Mark,
> 
>    Taking a reference to oneself is almost always wrong.

Yeah, it certainly seems fairly unorthodox, alright. But then again,
virtio_pci is an odd creature anyway :-)

My thinking was that the virtio abstraction is preventing there being an
explicit dependency between e.g. virtio_net and virtio_pci. If we didn't
have the abstraction, virtio_net would be calling directly into
virtio_pci and we'd have an explicit dep. So, I was just trying to
artificially mimic that.

Another example of a lack of an explicit dependency causing problems is
Fedora's mkinitrd having this hack:

    if echo $PWD | grep -q /virtio-pci/ ; then
        findmodule virtio_pci
    fi

which basically says "if this is a virtio device, don't forget to
include virtio_pci in the initrd too!". Now, mkinitrd is full of hacks,
but this is a particularly unusual one.

Í'm thinking that maybe we should default to having virtio_pci built-in
if e.g. CONFIG_KVM_GUEST is set.

> I'm a little surprised that a successful call to pci_device->probe 
> doesn't bump the module count though.

Nah, removing a module for device should actually work fine.

Anyway, with the root cause of Michael's traceback fixed, rmmod-ing
virtio_pci and re-loading it works just fine, so ...

Cheers,
Mark.

