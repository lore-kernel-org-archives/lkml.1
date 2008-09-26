Return-Path: <linux-kernel-owner+w=401wt.eu-S1754513AbYIZIKi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754513AbYIZIKi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 04:10:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751243AbYIZIK0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 04:10:26 -0400
Received: from rv-out-0506.google.com ([209.85.198.231]:46208 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750971AbYIZIKX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 04:10:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=Ywq7PC2jB5j1hpMrg8Ww5hpDweQ3EJeOKbqOwvKwG0ki2t9bNPG4gTc3K+RUycq6v9
         jAjdtrvI4RK/vj5540oXzcTQdQZf3CEwZNiVlIDqF+KVSzt8YVVHuf1rbRPF2/c5LNVP
         3MOMmPOkOZtt2g9AGwTFqqYbdxKZdPD/ONo+o=
Message-ID: <86802c440809260110j683af7f3vb92f7fd93e9d8ed5@mail.gmail.com>
Date: Fri, 26 Sep 2008 01:10:22 -0700
From: "Yinghai Lu" <yinghai@kernel.org>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [patch] ioremap sanity check to catch mapping requests exceeding the BAR sizes
Cc: "Suresh Siddha" <suresh.b.siddha@intel.com>, jbarnes@virtuousgeek.org,
       tglx@linutronix.de, hpa@zytor.com, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, arjan@linux.intel.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080926073902.GA30041@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080926014334.GF15609@linux-os.sc.intel.com>
	 <20080926073902.GA30041@elte.hu>
X-Google-Sender-Auth: ea531a126703935d
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 26, 2008 at 12:39 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Suresh Siddha <suresh.b.siddha@intel.com> wrote:
>
>> [patch] ioremap sanity check to catch mapping requests exceeding the BAR sizes
>>
>> Go through the iomem resource tree to check if any of the ioremap() requests
>> span more than any slot in the iomem resource tree and do a WARN_ON() if we hit
>> this check.
>>
>> This will raise a red-flag, if some driver is mapping more than what
>> is needed. And hopefully identify possible corruptions much earlier.
>>
>> Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
>
> applied to tip/core/resources, thanks Suresh.
>
> one question:
>
>> +     for (p = p->child; p ; p = r_next(NULL, p, &l)) {
>> +             /*
>> +              * We can probably skip the resources with out
>> +              * IORESOURCE_IO attribute?
>> +              */
>> +             if (p->start >= addr + size)
>> +                     continue;
>> +             if (p->end < addr)
>> +                     continue;
>> +             if (p->start <= addr && (p->end >= addr + size - 1))
>> +                     continue;
>> +             printk(KERN_WARNING "resource map sanity check conflict "
>> +                    " 0x%llx 0x%llx 0x%llx 0x%llx %s\n",
>> +                    addr, addr + size - 1, p->start, p->end, p->name);


need cast with (unsigned long long)...


>> +             err = -1;
>> +             break;
>
> i think all the checks you added are precise to the byte and you allow
> all the sensible ioremaps: which nest fully inside a single resource -
> and you reject all the other partial overlap or multiple overlap
> scenarios.
>
> One potential thing to check for would be whether addr+size overlaps a
> 4GB boundary? That would almost always be a bug, and it could also cause
> problems with the checks above if resource_t is 32 bits. The ioremap
> code should already prevent it though.

in that case,  BAR should be disabled already.

YH
