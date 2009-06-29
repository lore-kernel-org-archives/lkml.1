Return-Path: <linux-kernel-owner+w=401wt.eu-S1753594AbZF2C3T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753594AbZF2C3T (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 22:29:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751983AbZF2C3I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 22:29:08 -0400
Received: from complete.lackof.org ([198.49.126.79]:38110 "EHLO
	complete.lackof.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751585AbZF2C3H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 22:29:07 -0400
Date: Sun, 28 Jun 2009 20:29:11 -0600
From: Grant Grundler <grundler@parisc-linux.org>
To: Mikael Pettersson <mikpe@it.uu.se>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org
Subject: Re: [BUG 2.6.31-rc1] HIGHMEM64G causes hang in PCI init on 32-bit
	x86
Message-ID: <20090629022911.GC20297@lackof.org>
References: <200906261559.n5QFxJH8027336@pilspetsen.it.uu.se> <19013.29264.623540.275538@pilspetsen.it.uu.se> <4A45A5C1.5080701@zytor.com> <19013.59956.144640.331854@pilspetsen.it.uu.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19013.59956.144640.331854@pilspetsen.it.uu.se>
X-Home-Page: http://www.parisc-linux.org/
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 27, 2009 at 11:45:24AM +0200, Mikael Pettersson wrote:
...
>   fff00000-fffffffe : pnp 00:09
> 100000000-1ffffffff : System RAM
> 200000000-ffffffffffffffff : RAM buffer
> 
> With 2.6.30 things look similar, except 2.6.30 does not show the
> last "200000000-ffffffffffffffff : RAM buffer" line.

BIOS e280 table didn't report that line.
I expect it's created by arch/x86/kernel/e820.c:
1398         /*
1399          * Try to bump up RAM regions to reasonable boundaries to
1400          * avoid stolen RAM:
1401          */
1402         for (i = 0; i < e820.nr_map; i++) {
1403                 struct e820entry *entry = &e820_saved.map[i];
1404                 resource_size_t start, end;
1405 
1406                 if (entry->type != E820_RAM)
1407                         continue;
1408                 start = entry->addr + entry->size;
1409                 end = round_up(start, ram_alignment(start));
1410                 if (start == end)
1411                         continue;
1412                 reserve_region_with_split(&iomem_resource, start,
1413                                                   end - 1, "RAM buffer");
1414         }

hth,
grant
