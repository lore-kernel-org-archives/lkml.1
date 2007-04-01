Return-Path: <linux-kernel-owner+w=401wt.eu-S1750944AbXDAXon@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750944AbXDAXon (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 19:44:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751048AbXDAXon
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 19:44:43 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:27761 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750944AbXDAXom (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 19:44:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=BcEDN+mPObmED6hOhJ5NlTZOuEWgUyHoLkmDfrGjw5vONCBlkCzXdDD8nhjRoWLtpijbcVvKXB7A0EOrbDh0fX10otFVwtMpwM0igaS6bV9QGAJBOeQ5j0Vr+2aBfk58ZLfKuCJZTBjT9zXm395zfj3aJrg9x2FVJxNQ/GGuGy8=
Message-ID: <21d7e9970704011644n3adbef2brc6bfeb288f5d0866@mail.gmail.com>
Date: Mon, 2 Apr 2007 09:44:41 +1000
From: "Dave Airlie" <airlied@gmail.com>
To: "Linux Kernel" <linux-kernel@vger.kernel.org>,
       dri-devel <dri-devel@lists.sourceforge.net>
Subject: drm + 4GB RAM + swiotlb = drm craps out
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Okay I've got a bug reported before and now again about > 4GB + radeon
blows up the DRM... on Intel hw...

What the drm currently does for the PCI GART table is it allocates a
chunk of memory (8MB) with vmalloc_32(), then when it decides to use
it it goes through every page of it calls pci_map_single() (with
PCI_DMA_TODEVICE, which is probably wrong...) with every page from the
vmalloc mapping and puts the bus addresses of the pages into the PCI
GART table on the GPU.

So when swiotlb happens, as you can guess it all falls apart as the
drm never calls sync functions at any stage...

The main problem is the ring buffer and scratch write back, these
values are read/write from both the CPU and GPU quite a lot, so this
leads me to think I should really just be using dma_alloc_coherent for
the whole lot, however this is an 8MB mapping and possibly could be
getting larger in the future and dynamic as we do dynamic PCIEGART
support for the radeons...

So I suppose I'm asking for ideas on the "correct" way to do this, and
perhaps any quick way to patch up the problem I'm seeing now by making
swiotlb not get involved ....

Regards,
Dave.
