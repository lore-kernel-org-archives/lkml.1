Return-Path: <linux-kernel-owner+w=401wt.eu-S1754149AbYKDRt7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754149AbYKDRt7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 12:49:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751877AbYKDRtt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 12:49:49 -0500
Received: from mx2.redhat.com ([66.187.237.31]:41210 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751398AbYKDRtr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 12:49:47 -0500
Date: Tue, 4 Nov 2008 15:51:11 -0200
From: Glauber Costa <glommer@redhat.com>
To: Nick Piggin <npiggin@suse.de>
Cc: Avi Kivity <avi@redhat.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, aliguori@codemonkey.ws,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Krzysztof Helt <krzysztof.h1@poczta.fm>
Subject: Re: [PATCH] regression: vmalloc easily fail.
Message-ID: <20081104175111.GA27481@poweredge.glommer>
References: <1225234513-3996-1-git-send-email-glommer@redhat.com> <20081028232944.GA3759@wotan.suse.de> <20081029094856.GD4269@poweredge.glommer> <20081029101145.GB5953@wotan.suse.de> <49083B14.6070402@redhat.com> <20081029104333.GD5953@wotan.suse.de> <20081029220737.GF11532@poweredge.glommer> <20081030044941.GA9470@wotan.suse.de> <20081030112854.GA18634@poweredge.glommer> <20081031071644.GD19268@wotan.suse.de>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="rwEMma7ioTxnRzrJ"
Content-Disposition: inline
In-Reply-To: <20081031071644.GD19268@wotan.suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--rwEMma7ioTxnRzrJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Oct 31, 2008 at 08:16:44AM +0100, Nick Piggin wrote:
> On Thu, Oct 30, 2008 at 09:28:54AM -0200, Glauber Costa wrote:
> > On Thu, Oct 30, 2008 at 05:49:41AM +0100, Nick Piggin wrote:
> > > On Wed, Oct 29, 2008 at 08:07:37PM -0200, Glauber Costa wrote:
> > > > On Wed, Oct 29, 2008 at 11:43:33AM +0100, Nick Piggin wrote:
> > > > > On Wed, Oct 29, 2008 at 12:29:40PM +0200, Avi Kivity wrote:
> > > > > > Nick Piggin wrote:
> > > > > > >Hmm, spanning <30MB of memory... how much vmalloc space do you have?
> > > > > > >
> > > > > > >  
> > > > > > 
> > > > > > From the original report:
> > > > > > 
> > > > > > >VmallocTotal:     122880 kB
> > > > > > >VmallocUsed:       15184 kB
> > > > > > >VmallocChunk:      83764 kB
> > > > > > 
> > > > > > So it seems there's quite a bit of free space.
> > > > > > 
> > > > > > Chunk is the largest free contiguous region, right?  If so, it seems the 
> > > > > 
> > > > > Yes.
> > > > > 
> > > > > 
> > > > > > problem is unrelated to guard pages, instead the search isn't finding a 
> > > > > > 1-page area (with two guard pages) for some reason, even though lots of 
> > > > > > free space is available.
> > > > > 
> > > > > Hmm. The free area search could be buggy...
> > > > Do you want me to grab any specific info of it? Or should I just hack myself
> > > > randomly into it? I'll probably have some time for that tomorrow.
> > > 
> > > I took a bit of a look. Does this help you at all?
> > > 
> > > I still think we should get rid of the guard pages in non-debug kernels
> > > completely, but hopefully this will fix your problems?
> > unfortunately, it doesn't.
> > problem still happen in a kernel with this patch.
> 
> That's weird. Any chance you could dump a list of all the vmap area start
> and end adresses and their flags before returning failure?

by the way, a slightly modified version of your patch, without this snippet:

@@ -362,7 +363,7 @@ retry:
                                goto found;
                }

-               while (addr + size >= first->va_start && addr + size <= vend) {
+               while (addr + size > first->va_start && addr + size <= vend) {
                        addr = ALIGN(first->va_end + PAGE_SIZE, align);

                        n = rb_next(&first->rb_node);


WFM nicely so far.

I'm attaching /proc/vmallocinfo during kvm execution


--rwEMma7ioTxnRzrJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="vmalloc.works"

0xf8800000-0xf8802000    8192 hpet_enable+0x2f/0x26b phys=fed00000 ioremap
0xf8802000-0xf8804000    8192 acpi_os_map_memory+0x15/0x1e phys=7fed1000 ioremap
0xf8804000-0xf8806000    8192 acpi_os_map_memory+0x15/0x1e phys=7fef2000 ioremap
0xf8806000-0xf8808000    8192 acpi_os_map_memory+0x15/0x1e phys=7fef2000 ioremap
0xf8808000-0xf880a000    8192 acpi_os_map_memory+0x15/0x1e phys=7fef2000 ioremap
0xf880a000-0xf880c000    8192 acpi_os_map_memory+0x15/0x1e phys=7fede000 ioremap
0xf880c000-0xf880f000   12288 acpi_os_map_memory+0x15/0x1e phys=7fef2000 ioremap
0xf8810000-0xf881f000   61440 acpi_os_map_memory+0x15/0x1e phys=7fed1000 ioremap
0xf8820000-0xf8822000    8192 acpi_os_map_memory+0x15/0x1e phys=7fef4000 ioremap
0xf8822000-0xf8824000    8192 acpi_os_map_memory+0x15/0x1e phys=7fede000 ioremap
0xf8824000-0xf8826000    8192 acpi_os_map_memory+0x15/0x1e phys=7fef4000 ioremap
0xf8826000-0xf8828000    8192 acpi_os_map_memory+0x15/0x1e phys=7fed1000 ioremap
0xf8828000-0xf882a000    8192 acpi_os_map_memory+0x15/0x1e phys=7fede000 ioremap
0xf882a000-0xf882c000    8192 acpi_os_map_memory+0x15/0x1e phys=7fede000 ioremap
0xf882c000-0xf882e000    8192 acpi_os_map_memory+0x15/0x1e phys=7fede000 ioremap
0xf882e000-0xf8830000    8192 acpi_os_map_memory+0x15/0x1e phys=7fede000 ioremap
0xf8830000-0xf883c000   49152 zisofs_init+0xd/0x1c pages=11 vmalloc
0xf883c000-0xf883e000    8192 acpi_os_map_memory+0x15/0x1e phys=7fef1000 ioremap
0xf883e000-0xf8840000    8192 acpi_os_map_memory+0x15/0x1e phys=7fef1000 ioremap
0xf8840000-0xf8843000   12288 acpi_os_map_memory+0x15/0x1e phys=7fef1000 ioremap
0xf8844000-0xf8846000    8192 acpi_os_map_memory+0x15/0x1e phys=7fef1000 ioremap
0xf8846000-0xf8848000    8192 usb_hcd_pci_probe+0x168/0x30c phys=ee404000 ioremap
0xf8848000-0xf884a000    8192 dm_vcalloc+0x24/0x4c [dm_mod] pages=1 vmalloc
0xf884a000-0xf884c000    8192 pci_iomap+0xb6/0xc2 phys=ee404000 ioremap
0xf884d000-0xf8851000   16384 vmalloc_exec+0x13/0x15 pages=3 vmalloc
0xf8851000-0xf885b000   40960 vmalloc_exec+0x13/0x15 pages=9 vmalloc
0xf885b000-0xf8862000   28672 vmalloc_exec+0x13/0x15 pages=6 vmalloc
0xf8862000-0xf8869000   28672 vmalloc_exec+0x13/0x15 pages=6 vmalloc
0xf8869000-0xf8876000   53248 vmalloc_exec+0x13/0x15 pages=12 vmalloc
0xf8877000-0xf8882000   45056 vmalloc_exec+0x13/0x15 pages=10 vmalloc
0xf8882000-0xf88a1000  126976 vmalloc_exec+0x13/0x15 pages=30 vmalloc
0xf88a1000-0xf88a3000    8192 dm_vcalloc+0x24/0x4c [dm_mod] pages=1 vmalloc
0xf88a3000-0xf88bf000  114688 vmalloc_exec+0x13/0x15 pages=27 vmalloc
0xf88bf000-0xf88c7000   32768 vmalloc_exec+0x13/0x15 pages=7 vmalloc
0xf88c7000-0xf88cf000   32768 vmalloc_exec+0x13/0x15 pages=7 vmalloc
0xf88cf000-0xf88d1000    8192 __kvm_set_memory_region+0x155/0x304 [kvm] pages=1 vmalloc
0xf88d1000-0xf88d4000   12288 vmalloc_exec+0x13/0x15 pages=2 vmalloc
0xf88d4000-0xf88d8000   16384 vmalloc_exec+0x13/0x15 pages=3 vmalloc
0xf88d8000-0xf88db000   12288 vmalloc_exec+0x13/0x15 pages=2 vmalloc
0xf88db000-0xf88dd000    8192 dm_vcalloc+0x24/0x4c [dm_mod] pages=1 vmalloc
0xf88dd000-0xf88df000    8192 dm_vcalloc+0x24/0x4c [dm_mod] pages=1 vmalloc
0xf88df000-0xf88e5000   24576 vmalloc_exec+0x13/0x15 pages=5 vmalloc
0xf88e5000-0xf88ee000   36864 vmalloc_exec+0x13/0x15 pages=8 vmalloc
0xf88ef000-0xf8911000  139264 vmalloc_exec+0x13/0x15 pages=33 vmalloc
0xf8911000-0xf8917000   24576 vmalloc_exec+0x13/0x15 pages=5 vmalloc
0xf8918000-0xf891a000    8192 iTCO_wdt_probe+0xb6/0x281 [iTCO_wdt] phys=fed1f000 ioremap
0xf891b000-0xf891f000   16384 vmalloc_exec+0x13/0x15 pages=3 vmalloc
0xf8920000-0xf8928000   32768 vmalloc_exec+0x13/0x15 pages=7 vmalloc
0xf8928000-0xf892b000   12288 vmalloc_exec+0x13/0x15 pages=2 vmalloc
0xf892b000-0xf892e000   12288 vmalloc_exec+0x13/0x15 pages=2 vmalloc
0xf892e000-0xf8931000   12288 vmalloc_exec+0x13/0x15 pages=2 vmalloc
0xf8932000-0xf894a000   98304 vmalloc_exec+0x13/0x15 pages=23 vmalloc
0xf894a000-0xf894d000   12288 vmalloc_exec+0x13/0x15 pages=2 vmalloc
0xf894d000-0xf8952000   20480 vmalloc_exec+0x13/0x15 pages=4 vmalloc
0xf8952000-0xf8959000   28672 vmalloc_exec+0x13/0x15 pages=6 vmalloc
0xf8959000-0xf895e000   20480 vmalloc_exec+0x13/0x15 pages=4 vmalloc
0xf895e000-0xf8961000   12288 vmalloc_exec+0x13/0x15 pages=2 vmalloc
0xf8961000-0xf8965000   16384 vmalloc_exec+0x13/0x15 pages=3 vmalloc
0xf8965000-0xf8968000   12288 vmalloc_exec+0x13/0x15 pages=2 vmalloc
0xf8968000-0xf896b000   12288 vmalloc_exec+0x13/0x15 pages=2 vmalloc
0xf896b000-0xf8970000   20480 vmalloc_exec+0x13/0x15 pages=4 vmalloc
0xf8970000-0xf8972000    8192 pci_iomap+0xb6/0xc2 phys=edf00000 ioremap
0xf8972000-0xf8974000    8192 __kvm_set_memory_region+0x1c0/0x304 [kvm] pages=1 vmalloc
0xf8974000-0xf8978000   16384 vmalloc_exec+0x13/0x15 pages=3 vmalloc
0xf8978000-0xf897e000   24576 vmalloc_exec+0x13/0x15 pages=5 vmalloc
0xf897e000-0xf8980000    8192 yenta_probe+0x108/0x572 [yenta_socket] phys=e4300000 ioremap
0xf8980000-0xf89a1000  135168 e1000_probe+0x1ad/0xa01 [e1000e] phys=ee000000 ioremap
0xf89a1000-0xf89a7000   24576 vmalloc_exec+0x13/0x15 pages=5 vmalloc
0xf89a7000-0xf89ab000   16384 vmalloc_exec+0x13/0x15 pages=3 vmalloc
0xf89ab000-0xf89b1000   24576 vmalloc_exec+0x13/0x15 pages=5 vmalloc
0xf89b1000-0xf89b5000   16384 vmalloc_exec+0x13/0x15 pages=3 vmalloc
0xf89b6000-0xf89c0000   40960 vmalloc_exec+0x13/0x15 pages=9 vmalloc
0xf89c0000-0xf89c6000   24576 vmalloc_exec+0x13/0x15 pages=5 vmalloc
0xf89c6000-0xf89cb000   20480 vmalloc_exec+0x13/0x15 pages=4 vmalloc
0xf89cb000-0xf89ce000   12288 vmalloc_exec+0x13/0x15 pages=2 vmalloc
0xf89ce000-0xf89d1000   12288 vmalloc_exec+0x13/0x15 pages=2 vmalloc
0xf89d1000-0xf89d4000   12288 vmalloc_exec+0x13/0x15 pages=2 vmalloc
0xf89d4000-0xf89dc000   32768 vmalloc_exec+0x13/0x15 pages=7 vmalloc
0xf89dc000-0xf89df000   12288 e1000e_setup_tx_resources+0x1d/0xba [e1000e] pages=2 vmalloc
0xf89df000-0xf89f8000  102400 vmalloc_exec+0x13/0x15 pages=24 vmalloc
0xf89f8000-0xf89fe000   24576 vmalloc_exec+0x13/0x15 pages=5 vmalloc
0xf89fe000-0xf8a03000   20480 vmalloc_exec+0x13/0x15 pages=4 vmalloc
0xf8a03000-0xf8a07000   16384 vmalloc_exec+0x13/0x15 pages=3 vmalloc
0xf8a07000-0xf8a0c000   20480 drm_ht_create+0x7e/0xbb [drm] pages=4 vmalloc
0xf8a0c000-0xf8a10000   16384 vmalloc_exec+0x13/0x15 pages=3 vmalloc
0xf8a10000-0xf8a14000   16384 vmalloc_exec+0x13/0x15 pages=3 vmalloc
0xf8a14000-0xf8a22000   57344 vmalloc_exec+0x13/0x15 pages=13 vmalloc
0xf8a22000-0xf8a29000   28672 vmalloc_exec+0x13/0x15 pages=6 vmalloc
0xf8a29000-0xf8a2c000   12288 e1000e_setup_rx_resources+0x1d/0xf4 [e1000e] pages=2 vmalloc
0xf8a2c000-0xf8a58000  180224 vmalloc_exec+0x13/0x15 pages=43 vmalloc
0xf8a58000-0xf8a7e000  155648 vmalloc_exec+0x13/0x15 pages=37 vmalloc
0xf8a7e000-0xf8a8b000   53248 vmalloc_exec+0x13/0x15 pages=12 vmalloc
0xf8a8b000-0xf8a95000   40960 vmalloc_exec+0x13/0x15 pages=9 vmalloc
0xf8a95000-0xf8a9e000   36864 vmalloc_exec+0x13/0x15 pages=8 vmalloc
0xf8a9f000-0xf8aaf000   65536 vmalloc_exec+0x13/0x15 pages=15 vmalloc
0xf8ab0000-0xf8ab5000   20480 azx_probe+0x29a/0x88e [snd_hda_intel] phys=ee400000 ioremap
0xf8ab5000-0xf8aba000   20480 drm_ht_create+0x7e/0xbb [drm] pages=4 vmalloc
0xf8aba000-0xf8abe000   16384 vmalloc_exec+0x13/0x15 pages=3 vmalloc
0xf8abe000-0xf8aca000   49152 vmalloc_exec+0x13/0x15 pages=11 vmalloc
0xf8aca000-0xf8adb000   69632 snd_malloc_sgbuf_pages+0x143/0x169 [snd_page_alloc] vmap
0xf8adb000-0xf8aec000   69632 snd_malloc_sgbuf_pages+0x143/0x169 [snd_page_alloc] vmap
0xf8aec000-0xf8afd000   69632 snd_malloc_sgbuf_pages+0x143/0x169 [snd_page_alloc] vmap
0xf8afd000-0xf8b02000   20480 vmalloc_exec+0x13/0x15 pages=4 vmalloc
0xf8b02000-0xf8b06000   16384 vmalloc_exec+0x13/0x15 pages=3 vmalloc
0xf8b06000-0xf8b08000    8192 __kvm_set_memory_region+0x155/0x304 [kvm] pages=1 vmalloc
0xf8b08000-0xf8b13000   45056 vmalloc_exec+0x13/0x15 pages=10 vmalloc
0xf8b13000-0xf8b33000  131072 vmalloc_exec+0x13/0x15 pages=31 vmalloc
0xf8b33000-0xf8b83000  327680 vmalloc_exec+0x13/0x15 pages=79 vmalloc
0xf8b83000-0xf8ba0000  118784 vmalloc_exec+0x13/0x15 pages=28 vmalloc
0xf8ba0000-0xf8bb1000   69632 drm_addmap_core+0x171/0x4bc [drm] phys=ee100000 ioremap
0xf8bb1000-0xf8bb7000   24576 vmalloc_exec+0x13/0x15 pages=5 vmalloc
0xf8bb7000-0xf8bbd000   24576 vmalloc_exec+0x13/0x15 pages=5 vmalloc
0xf8bbd000-0xf8bc0000   12288 vmalloc_exec+0x13/0x15 pages=2 vmalloc
0xf8bc0000-0xf8bc3000   12288 vmalloc_user+0x14/0x4a pages=2 vmalloc user
0xf8bc3000-0xf8bc6000   12288 vmalloc_32+0x13/0x15 pages=2 vmalloc
0xf8bc6000-0xf8bc8000    8192 __kvm_set_memory_region+0x1c0/0x304 [kvm] pages=1 vmalloc
0xf8bc9000-0xf8bcc000   12288 vmalloc_exec+0x13/0x15 pages=2 vmalloc
0xf8bcc000-0xf8bcf000   12288 vmalloc_exec+0x13/0x15 pages=2 vmalloc
0xf8bcf000-0xf8bd4000   20480 vmalloc_exec+0x13/0x15 pages=4 vmalloc
0xf8bd4000-0xf8bd7000   12288 __kvm_set_memory_region+0x1c0/0x304 [kvm] pages=2 vmalloc
0xf8bd7000-0xf8bd9000    8192 __kvm_set_memory_region+0x155/0x304 [kvm] pages=1 vmalloc
0xf8bd9000-0xf8bdd000   16384 vmalloc_exec+0x13/0x15 pages=3 vmalloc
0xf8bdd000-0xf8be0000   12288 vmalloc_exec+0x13/0x15 pages=2 vmalloc
0xf8be0000-0xf8be7000   28672 vmalloc_exec+0x13/0x15 pages=6 vmalloc
0xf8be7000-0xf8c22000  241664 vmalloc_exec+0x13/0x15 pages=58 vmalloc
0xf8c22000-0xf8c47000  151552 vmalloc_exec+0x13/0x15 pages=36 vmalloc
0xf8c47000-0xf9448000 8392704 vmalloc_32+0x13/0x15 pages=2048 vmalloc vpages
0xf9448000-0xf9541000 1019904 sys_swapon+0x485/0xa55 pages=248 vmalloc
0xf9541000-0xf954f000   57344 vmalloc_exec+0x13/0x15 pages=13 vmalloc
0xf954f000-0xf9553000   16384 vmalloc_exec+0x13/0x15 pages=3 vmalloc
0xf9553000-0xf9556000   12288 vmalloc_exec+0x13/0x15 pages=2 vmalloc
0xf9556000-0xf955c000   24576 vmalloc_exec+0x13/0x15 pages=5 vmalloc
0xf955c000-0xf955e000    8192 __kvm_set_memory_region+0x1c0/0x304 [kvm] pages=1 vmalloc
0xf955f000-0xf956c000   53248 vmalloc_exec+0x13/0x15 pages=12 vmalloc
0xf956c000-0xf9576000   40960 vmalloc_exec+0x13/0x15 pages=9 vmalloc
0xf9576000-0xf957b000   20480 vmalloc_exec+0x13/0x15 pages=4 vmalloc
0xf957b000-0xf95a2000  159744 vmalloc_exec+0x13/0x15 pages=38 vmalloc
0xf95a2000-0xf95af000   53248 vmalloc_exec+0x13/0x15 pages=12 vmalloc
0xf95b0000-0xf95b9000   36864 drm_core_ioremap+0x112/0x11d [drm] phys=dbff8000 ioremap
0xf95b9000-0xf95bb000    8192 __kvm_set_memory_region+0x155/0x304 [kvm] pages=1 vmalloc
0xf95bb000-0xf95bd000    8192 __kvm_set_memory_region+0x1c0/0x304 [kvm] pages=1 vmalloc
0xf95bd000-0xf95bf000    8192 __kvm_set_memory_region+0x155/0x304 [kvm] pages=1 vmalloc
0xf95bf000-0xf95c1000    8192 __kvm_set_memory_region+0x1c0/0x304 [kvm] pages=1 vmalloc
0xf95c1000-0xf95c6000   20480 __kvm_set_memory_region+0x155/0x304 [kvm] pages=4 vmalloc
0xf95c6000-0xf95c8000    8192 __kvm_set_memory_region+0x1c0/0x304 [kvm] pages=1 vmalloc
0xf95c9000-0xf95d6000   53248 vmalloc_exec+0x13/0x15 pages=12 vmalloc
0xf95d6000-0xf96d7000 1052672 __kvm_set_memory_region+0x155/0x304 [kvm] pages=256 vmalloc
0xf96d7000-0xf96d9000    8192 __kvm_set_memory_region+0x236/0x304 [kvm] pages=1 vmalloc

--rwEMma7ioTxnRzrJ--
