Return-Path: <linux-kernel-owner+w=401wt.eu-S1755975AbYGUUXG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755975AbYGUUXG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 16:23:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754641AbYGUUWv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 16:22:51 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:18576 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752686AbYGUUWu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 16:22:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=n/IDD30V3z02AMZRTBYyRqDWK9ckwsK79jqZ8kuUqHSERyyXhJvgJOW55MFx0GFFgP
         +/er/9U4ITF8KclO/tQK92a03O5jlALCOvpfFOAMcyF3tZedsyy+ZuL66ALp20id6ytb
         0JcSmxKhq5ztgpJ2oFcJYNuG3nfdy8e8y8GF8=
Message-ID: <19f34abd0807211322wb1309ecsf98ae8d0a35f5ccf@mail.gmail.com>
Date: Mon, 21 Jul 2008 22:22:49 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [bug, netconsole, SLUB] BUG skbuff_head_cache: Poison overwritten
Cc: "Evgeniy Polyakov" <johnpol@2ka.mipt.ru>,
       "Christoph Lameter" <cl@linux-foundation.org>,
       "Pekka Enberg" <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       davem@davemloft.net
In-Reply-To: <20080721200554.GA15463@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080717214222.GA29449@elte.hu>
	 <Pine.LNX.4.64.0807181149460.3852@sbz-30.cs.Helsinki.FI>
	 <20080718091146.GQ6875@elte.hu> <20080721094110.GA16029@elte.hu>
	 <84144f020807210252k68d5cf65i8c7ae3c11cecc046@mail.gmail.com>
	 <20080721100627.GA5953@2ka.mipt.ru>
	 <4884B7C3.9040801@linux-foundation.org>
	 <20080721195748.GA3191@2ka.mipt.ru> <20080721200554.GA15463@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 21, 2008 at 10:05 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Evgeniy Polyakov <johnpol@2ka.mipt.ru> wrote:
>
>> It could be an interesting kmemcheck extension to catch not only
>> non-initialized memory, but also writes into just freed one, but not
>> yet returned by allocator to the next user.
>
> hm, i think kmemcheck does that mostly already. If not then I think
> kmemcheck should just turn off all buffering that might happen on the
> SLUB level (if it doesnt do it already). I.e. a kfree()d buffer should
> be marked as uninitialized immediately.

We don't catch writes (yet, because kmemcheck gets confused by SLUB's
own writes so far), but yes, we mark objects "freed" when they are
freed (until the slab page is returned to the page allocator) and we
may detect reads from this area before the object is reallocated. In
that case, a "read from freed memory" message will appear.

Unfortunately, it doesn't work quite as well as I'd like it to yet. We
did catch one real bug in ACPI in this way (read-after-free). But as I
have discovered, not all machines support single-stepping over REP
STOS instructions properly. Which means that kmemcheck breaks silently
on some machines. There's also the recent DMA patch, which might
improve things. Linus is right, it's really fragile. But we are
working on it. It is going in the right direction anyway.

(Pekka and I were also working on an extension to SLUB which delays
the freeing of objects, i.e. so that objects will remain in the
"freed" state for a certain amount of time before it can be allocated
again. But we don't really have a _good_ patch for this yet, it was
more like an ugly hack at the time.)


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
