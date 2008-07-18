Return-Path: <linux-kernel-owner+w=401wt.eu-S1754525AbYGRHEH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754525AbYGRHEH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 03:04:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752912AbYGRHDz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 03:03:55 -0400
Received: from wf-out-1314.google.com ([209.85.200.171]:2851 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752794AbYGRHDx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 03:03:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=cY5dtcFQ3vB/7kEy4ZmM9SCith+JXXpq/3WFj2iYJP1IB/XrJjZo7S8Kyp2dvwqKl4
         Qts9+ltszRm5qcctnZm2hJNA9ZHq6C0wW6t+/eHq6GqecgIhImzw2iTdhtUpq33/tVEY
         NoeB6PQmjGQrGL8j0nGqk6MBzN/ckq5umY7ME=
Message-ID: <19f34abd0807180003m7bdf832g141777751d7ea563@mail.gmail.com>
Date: Fri, 18 Jul 2008 09:03:50 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "David Miller" <davem@davemloft.net>
Subject: Re: [bug, netconsole, SLUB] BUG skbuff_head_cache: Poison overwritten
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       penberg@cs.helsinki.fi, rjw@sisk.pl
In-Reply-To: <20080717.190315.186892939.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080717214222.GA29449@elte.hu>
	 <19f34abd0807171615s5b477d4cr22d3e9444bcf65df@mail.gmail.com>
	 <20080717.190315.186892939.davem@davemloft.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 18, 2008 at 4:03 AM, David Miller <davem@davemloft.net> wrote:
>> On Thu, Jul 17, 2008 at 11:42 PM, Ingo Molnar <mingo@elte.hu> wrote:
>> >
>> > A regression to v2.6.26:
>> >
>> > I started getting this skb-head corruption message today, on a T60
>> > laptop with e1000:
>> >
>> > PM: Removing info for No Bus:vcs11
>> > device: 'vcs11': device_create_release
>> > =============================================================================
>> > BUG skbuff_head_cache: Poison overwritten
>> > -----------------------------------------------------------------------------
>> >
>> > INFO: 0xf658ae9c-0xf658ae9c. First byte 0x6a instead of 0x6b
>>
>> 1. Notice the range. It's just a single byte.
>> 2. Notice the value. It's just a ++.
>
> It's supposed to be 0x6b, this would be a "--"

You're right! Oops. In my defence, I wrote that at 2 AM last night ;-)

> Also it (more likely IMHO) could be clearing a flag with the value 0x01.

It could be. But like I said in a later e-mail, the thing is likely
sk_buff->truesize. Which is not a flags variable. It _is_ however, a
counter, which is frequently -= and atomic_sub()ed.

That field is also an int, not a byte like I suggested above. This is
fine, though. "--" on an int can of course legitimately update/change
just the lower byte of an int.

But.. it could also be some random corruption coming from elsewhere.
Maybe even bad RAM (it's just a single bit anyway). But that's less
likely.


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
