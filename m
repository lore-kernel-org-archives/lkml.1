Return-Path: <linux-kernel-owner+w=401wt.eu-S1755921AbZGBV3G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755921AbZGBV3G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 17:29:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754563AbZGBV24
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 17:28:56 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37011 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754289AbZGBV24 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 17:28:56 -0400
Date: Thu, 2 Jul 2009 14:28:23 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Eric Dumazet <eric.dumazet@gmail.com>
cc: David Howells <dhowells@redhat.com>, mingo@elte.hu,
       akpm@linux-foundation.org, paulus@samba.org, arnd@arndb.de,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] FRV: Implement atomic64_t
In-Reply-To: <4A4D2239.5000602@gmail.com>
Message-ID: <alpine.LFD.2.01.0907021419560.3210@localhost.localdomain>
References: <20090701144913.GA28172@elte.hu> <20090701164700.29780.15103.stgit@warthog.procyon.org.uk> <alpine.LFD.2.01.0907011004000.3605@localhost.localdomain> <4A4D2239.5000602@gmail.com>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 2 Jul 2009, Eric Dumazet wrote:
> 
> Using a fixed initial value (instead of __atomic64_read()) is even faster, 
> it apparently permits cpu to use an appropriate bus transaction.

Yeah, I guess it does a "read-for-write-ownership" and allows the thing to 
be done as a single cache transaction.

If we read it first, it will first get the cacheline for shared-read, and 
then the cmpxchg8b will need to turn it from shared to exclusive.

Of course, the _optimal_ situation would be if the cmpxchg8b didn't 
actually do the write at all when the value matches (and all cores could 
just keep it shared), but I guess that's not going to happen.

Too bad there is no pure 8-byte read op. Using MMX has too many downsides.

Btw, your numbers imply that for the atomic64_add_return(), we really 
would be much better off not reading the original value at all. Again, in 
that case, we really do want the "read-for-write-ownership" cache 
transaction, not a read.

		Linus
