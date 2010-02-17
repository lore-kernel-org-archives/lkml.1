Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753522Ab0BQWNG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 17:13:06 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50585 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752659Ab0BQWNE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 17:13:04 -0500
Date: Wed, 17 Feb 2010 14:10:28 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Zachary Amsden <zamsden@redhat.com>
cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       x86@kernel.org, Avi Kivity <avi@redhat.com>
Subject: Re: [PATCH] x86 rwsem optimization extreme
In-Reply-To: <1266443901-3646-1-git-send-email-zamsden@redhat.com>
Message-ID: <alpine.LFD.2.00.1002171403160.4141@localhost.localdomain>
References: <1266443901-3646-1-git-send-email-zamsden@redhat.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 17 Feb 2010, Zachary Amsden wrote:
>
> The x86 instruction set provides the ability to add an additional
> bit into addition or subtraction by using the carry flag.
> It also provides instructions to directly set or clear the
> carry flag.  By forcibly setting the carry flag, we can then
> represent one particular 64-bit constant, namely
> 
>    0xffffffff + 1 = 0x100000000
> 
> using only 32-bit values.  In particular we can optimize the rwsem
> write lock release by noting it is of exactly this form.

Don't do this.

Just shift the constants down by two, and suddenly you don't need any 
clever tricks, because all the constants fit in 32 bits anyway, 
regardless of sign issues.

So just change the 

	# define RWSEM_ACTIVE_MASK              0xffffffffL

line into

	# define RWSEM_ACTIVE_MASK              0x3fffffffL

and you're done.

The cost of 'adc' may happen to be identical in this case, but I suspect 
you didn't test on UP, where the 'lock' prefix goes away. An unlocked 
'add' tends to be faster than an unlocked 'adc'.

(It's possible that some micro-architectures don't care, since it's a 
memory op, and they can see that 'C' is set. But it's a fragile assumption 
that it would always be ok).

			Linus
