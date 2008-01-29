Return-Path: <linux-kernel-owner+w=401wt.eu-S1753887AbYA2Rfg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753887AbYA2Rfg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 12:35:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752017AbYA2Rf2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 12:35:28 -0500
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:41031 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751601AbYA2Rf1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 12:35:27 -0500
Date: Tue, 29 Jan 2008 09:41:53 -0800
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: Re: [PATCH 2/2] x86_64: make early_node_mem return align address
In-reply-to: <200801291033.29871.ak@suse.de>
To: Andi Kleen <ak@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>, Christoph Lameter <clameter@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Message-id: <200801290941.54145.yinghai.lu@sun.com>
Organization: Sun
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 8BIT
Content-disposition: inline
References: <200801290053.45776.yinghai.lu@sun.com>
 <200801290105.03438.yinghai.lu@sun.com> <200801291033.29871.ak@suse.de>
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 29 January 2008 01:33:29 am Andi Kleen wrote:
> On Tuesday 29 January 2008 10:05, Yinghai Lu wrote:
> > [PATCH 2/2] x86_64: make early_node_mem return align address
> >
> > boot oops when system get 64g or 128g installed
> 
> Probably it should just use reserve_early(). Does this patch work?
>  
> The alignment change is needed at some point too, but only to 
> relax the alignment to not force all early allocations to be page
> padded.

No, my patch doesn't force all early allocations to be page padded.
for find_e820_mem, i just change PAGE_ALIGN to be aligned align parameter....

only make early_node_mem have aligned data. because it seems it like to...and assume that.

I think your patch will get early panic about overlap between bss and bootmem...
like the 256g machine, bss is overlapped with early page table...

so could change 

-       node_data[nodeid] = early_node_mem(nodeid, start, end, pgdat_size);
+       node_data[nodeid] = early_node_mem(nodeid, start, end, pgdat_size,
+                                          ZONE_ALIGN);

===>

-       node_data[nodeid] = early_node_mem(nodeid, start, end, pgdat_size);
+       node_data[nodeid] = early_node_mem(nodeid, start, end, pgdat_size,
+                                          PAGE_SIZE);


or

-       if (mem != -1L)
+       if (mem != -1L) {
+               mem = round_up(mem, PAGE_SIZE);
                return __va(mem);
+       }

YH

