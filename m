Return-Path: <linux-kernel-owner+w=401wt.eu-S1752720AbZLADXX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752720AbZLADXX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 22:23:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752557AbZLADXW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 22:23:22 -0500
Received: from g6t0184.atlanta.hp.com ([15.193.32.61]:29580 "EHLO
	g6t0184.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751724AbZLADXV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 22:23:21 -0500
Subject: Re: [PATCH] PCI: Always set prefetchable base/limit upper32
 registers
From: Alex Williamson <alex.williamson@hp.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: jbarnes@virtuousgeek.org, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <4B148485.3000107@kernel.org>
References: <20091130212228.7555.43533.stgit@debian.lart>
	 <4B143AE5.7040702@kernel.org> <1259617381.8949.281.camel@8530w.home>
	 <4B143E83.6020105@kernel.org> <1259618496.8949.290.camel@8530w.home>
	 <4B144346.50608@kernel.org> <1259619578.8949.295.camel@8530w.home>
	 <4B1455FD.90002@kernel.org> <1259625224.8949.319.camel@8530w.home>
	 <4B145C9D.70601@kernel.org> <1259632564.10482.10.camel@2710p.home>
	 <4B147EE0.8080209@kernel.org>  <4B148485.3000107@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 30 Nov 2009 20:23:24 -0700
Message-ID: <1259637804.10482.20.camel@2710p.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-11-30 at 18:50 -0800, Yinghai Lu wrote:
> Yinghai Lu wrote:
> > Alex Williamson wrote:
> >> Ok, sorry I missed this.  Yes, this is getting called, but when we get
> >> back to pci_setup_bridge() that flag is missing IORESOURCE_MEM_64.
> >> Perhaps these are different resources?  I'm still tracing the code to
> >> find out what happened to that flag.
> >>
> >> Also, I'm running 64bit(x86_64), and if lspci is wrong, then so is
> >> setpci.  I don't think there's an "ignore upper32" anywhere, so the
> >> result of 0xffffffffabc00000 - 0x00000000abc00000 is that base > limit
> >> thus the range is disabled at the bridge and the ROM resource we
> >> assigned into the window behind the bridge is inaccessible.
> > 
> > can you check
[snip]

The upper32 base register works as advertised, that's not where we clear
the MEM_64 flag.  I tracked that down to pbus_size_mem().  So, we have a
MEM_64 capable prefetchable base, but we want to use it to map a 32bit
resource behind the bridge (a ROM in this case), so we drop the MEM_64
flag, causing us to hit pci_setup_bridge() with the flag clear and thus
not touching UPPER32.  I think your second patch would also solve this
since it separates the desired resource size from the register size.
However, it seems much more simple to unconditionally write the upper32
registers as was done for all 2.6 kernels up to 2.6.30.  Thanks,

Alex

