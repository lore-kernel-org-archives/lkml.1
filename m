Return-Path: <linux-kernel-owner+w=401wt.eu-S934224AbZLPAEd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934224AbZLPAEd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 19:04:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759979AbZLPAEa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 19:04:30 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:50672 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758647AbZLPAE3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 19:04:29 -0500
Date: Wed, 16 Dec 2009 00:04:22 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Emese Revfy <re.emese@gmail.com>
Cc: Pavel Machek <pavel@ucw.cz>, Arjan van de Ven <arjan@infradead.org>,
       Paul Mundt <lethal@linux-sh.org>, Matthew Wilcox <matthew@wil.cx>,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH 0/1] Constify struct address_space_operations for
	2.6.32-git-053fe57ac v2
Message-ID: <20091216000422.GY14381@ZenIV.linux.org.uk>
References: <4B2595E7.701@gmail.com> <20091214021916.GB12196@linux-sh.org> <4B25E47C.1010803@gmail.com> <20091214112656.GB1959@elf.ucw.cz> <20091214080049.19930729@infradead.org> <20091214212526.GB9213@elf.ucw.cz> <20091214141757.73606259@infradead.org> <4B26BF14.3040709@gmail.com> <20091215181403.GB24406@elf.ucw.cz> <4B281BA4.8090806@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B281BA4.8090806@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 16, 2009 at 12:28:36AM +0100, Emese Revfy wrote:

> Notice how you got an error for line 12 (p->g assignment) but no warning or error
> at all for line 11 (p->f assignment). This example illustrates what I was explaining
> so far:
> 
> if you dynamically allocate an ops structure (the result of which is a pointer type like
> p in the above example) then with a non-const structure field you get no indication
> from the compiler that you are doing something undesired, whereas with a const
> structure field you get an error immediately. This is what helps a future developer
> as it gives him a hint that he is doing something wrong and if he still insists on his
> way of dynamic allocation, he will have to come up with ugly code
> (e.g., void *(**)(void))(&p->g) = 0) that will not pass human review. You can teach gcc,
> sparse, checkpatch, etc to recognize some of this ugliness but you cannot
> programmatically detect all possible ways of evasion.
> And if the compiler can help the developers, why not make use of it?

Sigh...  Could you please stop assuming that nobody knows C?  Your point
about const members of struct making the entire lvalue non-modifiable
is *NOT* *ARGUED*.  It is correct.

HOWEVER, such use of const is highly non-idiomatic.  Combined with the
general clumsiness of syntax for qualifiers, it creates a stumbling
block for human readers.

Compiler is not the only thing that has to parse C; programmers need to do
the same and hitting slow paths in our parsers is a Bad Thing(tm).
_The_ requirement for any kind of annotations is non-intrusiveness for
casual human reader.  And that's what is violated here.

You are trying to express a property of struct; however, it ends up spread
all over the members' declarators.  Bad for readers...
