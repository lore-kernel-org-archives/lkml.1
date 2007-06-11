Return-Path: <linux-kernel-owner+w=401wt.eu-S1755088AbXFKVQW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755088AbXFKVQW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 17:16:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750830AbXFKVQO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 17:16:14 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:48758 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750706AbXFKVQN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 17:16:13 -0400
Date: Mon, 11 Jun 2007 17:16:04 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Eduard-Gabriel Munteanu <maxdamage@aladin.ro>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] UML: fix missing non-blocking I/O, now DEBUG_SHIRQ works
Message-ID: <20070611211604.GA8859@c2.user-mode-linux.org>
References: <1181512917.3157.8.camel@localhost> <20070611173154.GA6889@c2.user-mode-linux.org> <466DA50C.5050301@aladin.ro>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <466DA50C.5050301@aladin.ro>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 11, 2007 at 10:39:56PM +0300, Eduard-Gabriel Munteanu wrote:
> No offense, but this is an ugly hack. 

I'm not going to defend it too much, but the alternatives don't seem any
better to me.

> What if sizeof(int) !=  sizeof(long)?

Doesn't matter - the casting will preserve the value.  Of greater
concern is the relationship between sizeof(void *) and sizeof(long).
That's not guaranteed by the standard, but is by gcc.

> You're calling glibc functions
> with that fd as a parameter. On some arches, compiling will issue
> warnings or simply fail. 

Which ones?

> An alternative would be to use kmalloc instead of a global static 
> variable. Do you like this one more?

No, that trades the global variable for a new point of failure.

The main reason I like the current casting better than your global
(not by a lot) is that globals have to be audited for SMP safety.  So,
I don't want any globals which don't need to be.  This implies a
local, and to minimize the machinery associated with that (kmalloc, or
passing a pointer and synchronizing to avoid returning too soon), just
passing the descriptor in the pointer and accepting the casting needed
to get it through the compiler.

				Jeff

-- 
Work email - jdike at linux dot intel dot com
