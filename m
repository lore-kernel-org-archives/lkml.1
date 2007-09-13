Return-Path: <linux-kernel-owner+w=401wt.eu-S1764226AbXIMWR5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764226AbXIMWR5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 18:17:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753109AbXIMWRu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 18:17:50 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53963 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753177AbXIMWRt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 18:17:49 -0400
Date: Thu, 13 Sep 2007 15:17:38 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc4-mm1 compile error for ppc 32
Message-Id: <20070913151738.4462fdf2.akpm@linux-foundation.org>
In-Reply-To: <1189269730.5972.163.camel@localhost.localdomain>
References: <20070906184011.GA1776@Krystal>
	<20070906160009.fa52e8d2.akpm@linux-foundation.org>
	<200709081136.46605.nickpiggin@yahoo.com.au>
	<1189269730.5972.163.camel@localhost.localdomain>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 08 Sep 2007 18:42:10 +0200
Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:

> 
> > > If so, the finger points at this:
> > >
> > > static __inline__ void __clear_bit_unlock(int nr, volatile unsigned long
> > > *addr) {
> > > 	__asm__ __volatile__(LWSYNC_ON_SMP ::: "memory");
> > > 	__clear_bit(nr, addr);
> > > }
> > >
> > > which was added by Nick's powerpc-lock-bitops.patch.  I am suspecting that
> > > this isn't pp32 code?
> > 
> > Hmm, when LWSYNC_ON_SMP is a noop, it seems like it should probably
> > be an empty string instead of nothing? ("") That should make behaviour
> > more consistent I think.
> 
> The wormhole is arch/ppc's hack to get to include/asm-powerpc...
> 
> As for having LWSYNC_ON_SMP be "" ... that might be the best way but I'd
> rather not take chances right now and go for the quick fix of making
> __clear_bit_unlock() do
> 
> 	LWSYNC_ON_SMP ""
> 
> instead.
> 

Like this?

--- a/include/asm-powerpc/bitops.h~powerpc-lock-bitops-fix
+++ a/include/asm-powerpc/bitops.h
@@ -226,7 +226,7 @@ static __inline__ void set_bits(unsigned
 
 static __inline__ void __clear_bit_unlock(int nr, volatile unsigned long *addr)
 {
-	__asm__ __volatile__(LWSYNC_ON_SMP ::: "memory");
+	__asm__ __volatile__(LWSYNC_ON_SMP "" ::: "memory");
 	__clear_bit(nr, addr);
 }
 
_

