Return-Path: <linux-kernel-owner+w=401wt.eu-S1750796AbXBMNrc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750796AbXBMNrc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 08:47:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750789AbXBMNrc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 08:47:32 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:43773 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750787AbXBMNrb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 08:47:31 -0500
Date: Tue, 13 Feb 2007 13:47:30 +0000
From: Al Viro <viro@ftp.linux.org.uk>
To: linux-kernel@vger.kernel.org
Cc: selinux@tycho.nsa.gov, Linus Torvalds <torvalds@linux-foundation.org>,
       linux-security-module@vger.kernel.org
Subject: [RFC] security_getprocattr() API idiocy
Message-ID: <20070213134730.GA28151@ftp.linux.org.uk>
References: <20070213134555.GG4095@ftp.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070213134555.GG4095@ftp.linux.org.uk>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[apologies for resend, bogus address on the original mail]

	security_getprocattr() takes a buffer + length, copies data
to it and return the actual length.  If buffer is NULL, it just returns
the right length, a-la snprintf().  Observations:
	* at least selinux ends up actually allocating the buffer of the
right size, filling it, then copying its contents to buffer and freeing
what had been allocating.
	* all users allocate buffer, then call security_getprocattr() to
fill just allocated one.
	* one place does even worse - it calls security_getprocattr() passing
it NULL and uses obtained length to allocate buffer and call
security_getprocattr() _again_.

It's bloody bogus.  In all cases we would be just as happy if it returned
the buffer it'd allocated itself.  In the best case we end up with two
allocations; in the worst it's _three_, not to mention recalculating the
contents and size.  We end up doing
	* calculate size
	* allocate buffer of that size with GFP_ATOMIC
	* fill it
	* free it
	* allocate buffer of that size with GFP_KERNEL
	* caluclate the same size
	* allocate buffer of that size with GFP_ATOMIC
	* fill it with the same string
	* copy it to buffer we's allocated with GFP_KERNEL
	* free the buffer we'd allocated with GFP_ATOMIC
I'm sorry, but could we please not mix the kernel with Vogon poetry contest?

AFAICS, the sane solution is to make security_getprocattr() return the
allocated buffer instead.  All callers would be only happy with that.
Alternatively, we can introduce a new LSM hook (security_getprocattr_sane())
and leave the original as-is.

So, do we want to keep the original variant and add a saner one in parallel
to it or should we just switch to saner API?
