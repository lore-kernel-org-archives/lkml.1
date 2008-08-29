Return-Path: <linux-kernel-owner+w=401wt.eu-S1755558AbYH2BC7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755558AbYH2BC7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 21:02:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753364AbYH2BCu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 21:02:50 -0400
Received: from rv-out-0506.google.com ([209.85.198.229]:39370 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752233AbYH2BCt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 21:02:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=dW0xMDgU6hLlbTuhLbVZTr/nm2a1y7krFXICwxSo55Yo+9w8FKv0IvHye48mvCxHoc
         usORnJmh6pO0Ilf431uegTcT2CSdko9eJe6dEwLQNEHTxo4X5LHPfMqimyQHPYPYK78x
         UDxlZnziv4O5iY+jjAQGlqhpHdV9GDwGZ/aCo=
Message-ID: <86802c440808281802w7994d7cdjcd1f36fe3381ac76@mail.gmail.com>
Date: Thu, 28 Aug 2008 18:02:48 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: [PATCH] x86: split e820 reserved entries record to late v3
Cc: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Jesse Barnes" <jbarnes@virtuousgeek.org>, linux-kernel@vger.kernel.org
In-Reply-To: <alpine.LFD.1.10.0808281750520.3300@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1219970489-1615-1-git-send-email-yhlu.kernel@gmail.com>
	 <alpine.LFD.1.10.0808281750520.3300@nehalem.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 28, 2008 at 5:53 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
>
> On Thu, 28 Aug 2008, Yinghai Lu wrote:
>>  /*
>>   * Mark e820 reserved areas as busy for the resource manager.
>>   */
>> +struct resource __initdata *e820_res;
>
> Btw, make this one "static" - I don't think anybody outside of this file
> should ever use it anyway.

yes

>
> And this:
>
>> +             if (e820.map[i].type != E820_RESERVED || res->start < (1ULL<<20))
>> +                     insert_resource(&iomem_resource, res);
>
> is probably worthy of a comment.

how about
/*
 * don't register the region that could be conflicted with pci device
BAR resource
 * and insert them later.
 */


>
> And finally:
>
>> +void __init e820_reserve_resources_late(void)
>> +{
>> +     int i;
>> +     struct resource *res;
>> +
>> +     res = e820_res;
>> +     for (i = 0; i < e820.nr_map; i++) {
>> +             if (e820.map[i].type == E820_RESERVED && res->start >= (1ULL<<20))
>> +                     insert_resource(&iomem_resource, res);
>
> instead of duplicating the conditional and always having to worry about it
> matching, how about just making it
>
>                if (!res->parent)
>                        insert_resource(&iomem_resource, res);
>
> which basically says that "if it's not already inserted, try to re-insert
> it now".
there could be one is all zero, when 32bit/!64_RESOURCE.
so could change it to
                if (!res->parent && res->end)
                       insert_resource(&iomem_resource, res);

YH
