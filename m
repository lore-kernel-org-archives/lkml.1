Return-Path: <linux-kernel-owner+w=401wt.eu-S1754531Ab0ASWCv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754531Ab0ASWCv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 17:02:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754162Ab0ASWCu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 17:02:50 -0500
Received: from mail-fx0-f215.google.com ([209.85.220.215]:46878 "EHLO
	mail-fx0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751947Ab0ASWCu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 17:02:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=X7DIkrG5fy0q5vNX8pKoIqb3RN1V0ULO5vsva0xvU2fOM+HoiaY+uAo8lUWn0FmJW+
         ZzxC9OTcGqOr/jRvJCIO12bXuI/DWW7FfON1MxnepYHPiVqhoorCNFg7XeTZRoJIsjb8
         PJc5Wlq0lvZ923APSti4BOzDNgRMF2nD/1G0o=
Message-ID: <4B562C05.6080404@gmail.com>
Date: Tue, 19 Jan 2010 23:02:45 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-17.1 Thunderbird/3.0
MIME-Version: 1.0
To: Johannes Weiner <hannes@cmpxchg.org>
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       Ralf Baechle <ralf@linux-mips.org>, x86@kernel.org
Subject: Re: [RFC 1/1] bootmem: move big allocations behing 4G
References: <1263855390-32497-1-git-send-email-jslaby@suse.cz> <20100119143355.GB7932@cmpxchg.org>
In-Reply-To: <20100119143355.GB7932@cmpxchg.org>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/19/2010 03:33 PM, Johannes Weiner wrote:
> On Mon, Jan 18, 2010 at 11:56:30PM +0100, Jiri Slaby wrote:
>> Hi, I'm fighting a bug where Grub loads the kernel just fine, whereas
>> isolinux doesn't. I found out, it's due to different addresses of
>> loaded initrd. On a machine with 128G of memory, grub loads the
>> initrd at 895M in our case and flat mem_map (2G long) is allocated
>> above 4G due to 2-4G BIOS reservation.
>>
>> On the other hand, with isolinux, the 0-2G is free and mem_map is
>> placed there leaving no space for others, hence kernel panics for
>> swiotlb which needs to be below 4G.
> 
> Bootmem already protects the lower 16MB DMA zone for the obvious reasons,
> how about shifting the default bootmem goal above the DMA32 zone if it exists?

Hi, I think it makes sense.

> I tested the below on a rather dull x86_64 machine and it seems to work.  Would
> this work in your case as well?  The goal for mem_map should now be above 4G.

It seems that it will. I'll give it a try later (it needs to be set up)
and report back.

> From 1c11ce1e82c6209f0eda72e3340ab0c55cd6f330 Mon Sep 17 00:00:00 2001
> From: Johannes Weiner <jw@emlix.com>
> Date: Tue, 19 Jan 2010 14:14:44 +0100
> Subject: [patch] bootmem: avoid DMA32 zone, if any, by default
> 
> x86_64 and mips define a DMA32 zone additionally to the old DMA
> zone of 16MB.  Bootmem already avoids the old DMA zone if the
> allocation site did not request otherwise.
> 
> But since DMA32 is also a limited resource, avoid using it as well
> by default, if defined.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

So for the time being:
Reviewed-by: Jiri Slaby <jirislaby@gmail.com>

thanks,
-- 
js
