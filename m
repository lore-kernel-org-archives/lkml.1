Return-Path: <linux-kernel-owner+w=401wt.eu-S1753408AbZLAGzx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753408AbZLAGzx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 01:55:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753155AbZLAGzw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 01:55:52 -0500
Received: from g1t0027.austin.hp.com ([15.216.28.34]:41356 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751138AbZLAGzv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 01:55:51 -0500
Subject: Re: [PATCH] PCI: Always set prefetchable base/limit upper32
 registers
From: Alex Williamson <alex.williamson@hp.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: jbarnes@virtuousgeek.org, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <4B14B928.2000108@kernel.org>
References: <20091130212228.7555.43533.stgit@debian.lart>
	 <4B143AE5.7040702@kernel.org> <1259617381.8949.281.camel@8530w.home>
	 <4B143E83.6020105@kernel.org> <1259618496.8949.290.camel@8530w.home>
	 <4B144346.50608@kernel.org> <1259619578.8949.295.camel@8530w.home>
	 <4B1455FD.90002@kernel.org> <1259625224.8949.319.camel@8530w.home>
	 <4B145C9D.70601@kernel.org> <1259632564.10482.10.camel@2710p.home>
	 <4B147EE0.8080209@kernel.org>  <4B148485.3000107@kernel.org>
	 <1259637804.10482.20.camel@2710p.home>  <4B14B928.2000108@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 30 Nov 2009 23:55:54 -0700
Message-ID: <1259650554.10482.52.camel@2710p.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-11-30 at 22:35 -0800, Yinghai Lu wrote:
> Alex Williamson wrote:
> > 
> > The upper32 base register works as advertised, that's not where we clear
> > the MEM_64 flag.  I tracked that down to pbus_size_mem().  So, we have a
> > MEM_64 capable prefetchable base, but we want to use it to map a 32bit
> > resource behind the bridge (a ROM in this case), so we drop the MEM_64
> > flag, causing us to hit pci_setup_bridge() with the flag clear and thus
> > not touching UPPER32.  I think your second patch would also solve this
> > since it separates the desired resource size from the register size.
> > However, it seems much more simple to unconditionally write the upper32
> > registers as was done for all 2.6 kernels up to 2.6.30.  Thanks,
> 
> if the bridge self does not support 64bit pref mmio, we should not touch
> upper32 reg.

Does touching it actually cause any problems?  The spec states:
        
        If the Prefetchable Memory Base and Prefetchable Memory Limit
        registers indicate support for 32-bit addressing, then the
        Prefetchable Base Upper 32 Bits and Prefetchable Limit Upper 32
        Bits registers are both implemented as read-only registers that
        return zero when read.
        
So even if the bridge only supports 32bit prefetchable, the upper32
registers are still present and writes will be dropped.  This is the way
the code worked for a long, long time.  I'm wondering why we need to
make it more complicated.

Alex


