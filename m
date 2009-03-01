Return-Path: <linux-kernel-owner+w=401wt.eu-S1756269AbZCAAHZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756269AbZCAAHZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 19:07:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752217AbZCAAHM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 19:07:12 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:48007
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752063AbZCAAHK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 19:07:10 -0500
Date: Sat, 28 Feb 2009 16:06:51 -0800 (PST)
Message-Id: <20090228.160651.228301019.davem@davemloft.net>
To: torvalds@linux-foundation.org
Cc: arjan@infradead.org, mingo@elte.hu, nickpiggin@yahoo.com.au,
       sqazi@google.com, linux-kernel@vger.kernel.org, tglx@linutronix.de,
       hpa@zytor.com, andi@firstfloor.org
Subject: Re: [patch] x86, mm: pass in 'total' to __copy_from_user_*nocache()
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LFD.2.00.0902280935010.3111@localhost.localdomain>
References: <alpine.LFD.2.00.0902280904271.3111@localhost.localdomain>
	<20090228092450.3ded2db5@infradead.org>
	<alpine.LFD.2.00.0902280935010.3111@localhost.localdomain>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 28 Feb 2009 09:42:18 -0800 (PST)

> On Sat, 28 Feb 2009, Arjan van de Ven wrote:
> > 
> > it invalidates all caches in the hierarchy
> 
> Yeah, now that I look at the intel pdf's, I see that.
> 
> > afaik this is what Intel cpus do; but I also thought this behavior was
> > quite architectural as well...
> 
> Ok, I really think we should definitely not use non-temporal stores for 
> anything smaller than one full page in that case. In fact, I wonder if 
> even any of the old streaming benchmarks are even true. I thought it would 
> still stay in the L3, but yes, it literally seems to make the access 
> totally noncached and WC.
> 
> That's almost unacceptable in the long run. With a 8MB L3 cache - and a 
> compile sequence, do we really want to go out to memory to write the .S 
> file, and then have the assembler go out to memory to read it back? For a 
> compile, that _probably_ is all fine (the compiler in particular will have 
> enough data structures around that it's not going to fit in the cache 
> anyway), but I'm seeing leaner compilers and other cases where forcing 
> things out all the way on the bus is simply the wrong thing.

I think this is an accurate analysis as well, it's really unfortunate
the non-temporal stuff on x86 doesn't preserve existing cache lines
when present.

I thought that was the whole point.  Don't pollute the caches, but
if cache lines are already loaded there, use them and don't purge!
