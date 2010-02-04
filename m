Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754068Ab0BDRNc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 12:13:32 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39423 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753528Ab0BDRNb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 12:13:31 -0500
Date: Thu, 4 Feb 2010 09:13:18 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: Al Viro <viro@ZenIV.linux.org.uk>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH][RFC] %pd - for printing dentry name
In-Reply-To: <20100204160206.GG6676@linux.vnet.ibm.com>
Message-ID: <alpine.LFD.2.00.1002040848330.3707@localhost.localdomain>
References: <20100201222511.GA12882@ZenIV.linux.org.uk> <alpine.LFD.2.00.1002011431490.3664@localhost.localdomain> <20100201231847.GC12882@ZenIV.linux.org.uk> <20100202065341.GF6292@linux.vnet.ibm.com> <20100203024931.GA6307@linux.vnet.ibm.com>
 <alpine.LFD.2.00.1002040715570.3707@localhost.localdomain> <20100204160206.GG6676@linux.vnet.ibm.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 4 Feb 2010, Paul E. McKenney wrote:
> 
> Ah, good point on the hash size.  And given that DNAME_INLINE_LEN_MIN
> is 40 characters on 32-bit systems and 32 characters on 64-bit systems,
> I agree that while a four-character increase might be nice, it cannot be
> said to be an emergency.

Well, what we _could_ do is to make the 'length' field be part of the name 
itself, and just keep the hash separate. The hash (and parenthood) is what 
we check most in the hot inner loop, and don't want to have any extra 
indirection (or cache misses) for. The name length we check only later, 
after we've done all other checks (and after we've gotten the spinlock, 
which is the big thing).

So qstr->len is _not_ performance critical in the same way that qstr->hash 
is.

So we might not save 4 bytes, but we _could_ try to move the length field 
into the name with something like

	struct qstr_name {
		unsigned short len;
		char name[];
	};

	struct qstr {
		unsigned int hash;
		const struct qstr_name *name;
	};

but the problem then is one of alignment (ie that pointer generally wants 
8-byte alignment on 64-bit architectures, so none of this _helps_ unless 
we also move some other 4-byte field into the qstr (we could look at 
making 'd_time' be a 32-bit entry, for example, and move it in there).

Or we could do really crazy things, and put the four first characters of 
d_iname inside the qstr etc etc. It's just that it all gets totally 
unnatural very quickly.

So 'struct dentry' is one of the most important data structures we have 
(just because you easily end up with millions of them), but since we 
already control its size by varying the inline name length, I doubt that 
playing really fancy games is worth it.

			Linus
