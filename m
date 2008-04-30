Return-Path: <linux-kernel-owner+w=401wt.eu-S933504AbYD3WQU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933504AbYD3WQU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 18:16:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757279AbYD3WP5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 18:15:57 -0400
Received: from smtp-out.google.com ([216.239.33.17]:17935 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764147AbYD3WP4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 18:15:56 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=UjDv5boxCgwothSvuObmHwVLrX2HJU7QMUTcmZJg7E6/2lXuYHyGJHSmoY8KRbpA0
	FFfDcbEGDH/TT9oSQeJVw==
Message-ID: <d43160c70804301515i7e02a3d5ha3b84d4b26ae68bd@mail.gmail.com>
Date: Wed, 30 Apr 2008 18:15:40 -0400
From: "Ross Biro" <rossb@google.com>
To: "Jeremy Fitzhardinge" <jeremy@goop.org>
Subject: Re: [RFC/PATH 1/2] MM: Make Page Tables Relocatable -- conditional flush
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <4818CEDA.8000908@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080429134254.635FEDC683@localhost> <4818B262.5020909@goop.org>
	 <d43160c70804301140q16aed710rcafcab95876de078@mail.gmail.com>
	 <4818CEDA.8000908@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 30, 2008 at 3:56 PM, Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>>> - How does it deal with migrating the accessed/dirty bits in ptes if
>>>  cpus can be using old versions of the pte for a while after the
>>>  copy?  Losing dirty updates can lose data, so explicitly addressing
>>>  this point in code and/or comments is important.
>>>
>>
>> It doesn't currently.  Although it's easy to fix.  Just before the
>> free, we just have to copy the dirty bits again.  Slow, but not in a
>> critical path.
>>
>
> But the issue I'm concerned about is what happens if a process writes the
> page, causing its cpu to mark the (old, in-limbo) pte dirty.  Meanwhile
> someone else is scanning the pagetables looking for things to evict.  It
> check the (shiny new) pte, finds it not dirty, and decides to evict the
> apparently clean page.
>
> What, for that matter, stops a page from being evicted from under a limboed
> mapping?  Does it get accounted for (I guess the existing tlb flushing
> should be sufficient to keep it under control).

The delimbo functions can be extended to deal with the dirty bit.
They already have to be called to make sure the cpu is looking at the
proper page flags.  The easiest solution to the races is probably to
make the delimbo pte functions flush the tlb cache to make sure the
cpu will also be looking at the correct entry to update flags.
Otherwise the atomic ptep* functions would probably need to be
modified.

    Ross
