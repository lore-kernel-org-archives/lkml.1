Return-Path: <linux-kernel-owner+w=401wt.eu-S1755084AbZF2FE3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755084AbZF2FE3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 01:04:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751085AbZF2FET
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 01:04:19 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59195 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751434AbZF2FES (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 01:04:18 -0400
Message-ID: <4A484A8A.9020704@zytor.com>
Date: Sun, 28 Jun 2009 22:00:58 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Grant Grundler <grundler@parisc-linux.org>
CC: Mikael Pettersson <mikpe@it.uu.se>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org
Subject: Re: [BUG 2.6.31-rc1] HIGHMEM64G causes hang in PCI init on 32-bit
 x86
References: <200906261559.n5QFxJH8027336@pilspetsen.it.uu.se> <19013.29264.623540.275538@pilspetsen.it.uu.se> <4A45A5C1.5080701@zytor.com> <19013.59956.144640.331854@pilspetsen.it.uu.se> <20090629022911.GC20297@lackof.org>
In-Reply-To: <20090629022911.GC20297@lackof.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Grant Grundler wrote:
> On Sat, Jun 27, 2009 at 11:45:24AM +0200, Mikael Pettersson wrote:
> ...
>>   fff00000-fffffffe : pnp 00:09
>> 100000000-1ffffffff : System RAM
>> 200000000-ffffffffffffffff : RAM buffer
>>
>> With 2.6.30 things look similar, except 2.6.30 does not show the
>> last "200000000-ffffffffffffffff : RAM buffer" line.
> 
> BIOS e280 table didn't report that line.
> I expect it's created by arch/x86/kernel/e820.c:
> 1398         /*
> 1399          * Try to bump up RAM regions to reasonable boundaries to
> 1400          * avoid stolen RAM:
> 1401          */
> 1402         for (i = 0; i < e820.nr_map; i++) {
> 1403                 struct e820entry *entry = &e820_saved.map[i];
> 1404                 resource_size_t start, end;
> 1405 
> 1406                 if (entry->type != E820_RAM)
> 1407                         continue;
> 1408                 start = entry->addr + entry->size;
> 1409                 end = round_up(start, ram_alignment(start));
> 1410                 if (start == end)
> 1411                         continue;
> 1412                 reserve_region_with_split(&iomem_resource, start,
> 1413                                                   end - 1, "RAM buffer");
> 1414         }
> 

OK, this seems more than a wee bit strange, to say the least.  We
shouldn't be reserving the entire address space; this is legitimate I/O
space.

However, the reservation suddenly being improper for the root resource
would definitely make things unhappy...

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

