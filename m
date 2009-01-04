Return-Path: <linux-kernel-owner+w=401wt.eu-S932767AbZADAYU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932767AbZADAYU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 19:24:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752780AbZADAYL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 19:24:11 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:36557 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751904AbZADAYJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 19:24:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=NmQEDJIxbhtgkPrpKz0EMaiZg7obMyERsjnQHpPVkFtag7L6FWnpioIokRyU2Ms4qb
         Wn8aSjmGsNuJowacPp4T13NuBQpFhc9aZrPUo3m3LqYsAFSGOl6QTkJ0TBoD8hPrTyNe
         JmhpY88EJqUJgAiD4m3YNcXoL691buxPC3rKw=
Message-ID: <496001A3.1040201@gmail.com>
Date: Sun, 04 Jan 2009 01:24:03 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081112)
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@gmail.com>
CC: david@lang.hm, Andi Kleen <andi@firstfloor.org>,
       LKML <linux-kernel@vger.kernel.org>, yhlu.kernel@gmail.com
Subject: Re: early exception error
References: <20090102173441.GC5372@localhost> <alpine.DEB.1.10.0901021044460.21408@asgard.lang.hm> <20090102174845.GD5372@localhost> <20090102175226.GE5372@localhost> <alpine.DEB.1.10.0901021131210.21567@asgard.lang.hm> <20090102203058.GH5372@localhost> <alpine.DEB.1.10.0901030823190.23262@asgard.lang.hm> <20090103161052.GB11093@localhost> <alpine.DEB.1.10.0901031118450.23262@asgard.lang.hm> <20090103190316.GB7367@localhost> <20090103212426.GC7367@localhost>
In-Reply-To: <20090103212426.GC7367@localhost>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/03/2009 10:24 PM, Cyrill Gorcunov wrote:
> [Cyrill Gorcunov - Sat, Jan 03, 2009 at 10:03:16PM +0300]
> | (list restored)
> | 
> | [david@lang.hm - Sat, Jan 03, 2009 at 11:19:00AM -0800]
> | ...
> | >>>
> | >>> two new screenshots at http://linux.lang.hm/linux
> | >>>
> | >>> 36 is a boot with just earlyprintk=vga
> | >>> 37 is a boot with numa=noacpi
> | >>> I also put the vmlinux file there, I'll put the System.map and config
> | >>> there later (I did enable kernel_debug on this build as well)
> | >>>
> | >>> David Lang
> | >>>
> | >>
> | >> David, I can't find vmlinux neither .config?
> | >> Maybe they have hidden attribute?
> | 
> | ok, according to failing address we've a BUG_ON
> | triggered
> | 
> | ---
> | (gdb) l *0xffffffff8096452a
> | 0xffffffff8096452a is in alloc_bootmem_core (mm/bootmem.c:442).
> | 437		unsigned long fallback = 0;
> | 438		unsigned long min, max, start, sidx, midx, step;
> | 439	
> | 440		BUG_ON(!size);
> | 441		BUG_ON(align & (align - 1));
> | 442		BUG_ON(limit && goal + size > limit);
> | 443	
> | 444		if (!bdata->node_bootmem_map)
> | 445			return NULL;
> | 446	
> | (gdb) 
> | ---
> | 
> | so we're in attempt to overrun 'limit'.
> | Hmm...
> | 
> | 		- Cyrill -
> 
> Hardly possible that we trigger BUG here since I don't
> see BUG: on the photo. Investigating.

Hint: line 442 in 2.6.28 is
if (!bdata->node_bootmem_map)
;)

It's:
0xffffffff8096452a <alloc_bootmem_core+69>:     cmpq   $0x0,0x10(%rbp)
and hence cr2 is 10.

node_data[nid] is NULL... But both of them are set up. Maybe too high nid (and
pnum in sparse_init)?
