Return-Path: <linux-kernel-owner+w=401wt.eu-S1752223AbXF3TDT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752223AbXF3TDT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2007 15:03:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750742AbXF3TDL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jun 2007 15:03:11 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:4591 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750738AbXF3TDK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2007 15:03:10 -0400
X-AuthUser: davidel@xmailserver.org
Date: Sat, 30 Jun 2007 12:03:07 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Kyle Moffett <mrmacman_g4@mac.com>
cc: Andy Isaacson <adi@hexapodia.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Rik van Riel <riel@redhat.com>
Subject: Re: [patch 0/4] MAP_NOZERO v2 - VM_NOZERO/MAP_NOZERO early summer
 madness
In-Reply-To: <D65DCB84-F812-4C3B-8E68-EACA0CA8A0C0@mac.com>
Message-ID: <Pine.LNX.4.64.0706291711320.31176@alien.or.mcafeemobile.com>
References: <send-serie.davidel@xmailserver.org.5792.1183056564.0>
 <EC4CE052-5514-465E-92D2-9D50DA970DDC@mac.com> <20070629193954.GL9157@hexapodia.org>
 <Pine.LNX.4.64.0706291306220.31176@alien.or.mcafeemobile.com>
 <D65DCB84-F812-4C3B-8E68-EACA0CA8A0C0@mac.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Jun 2007, Kyle Moffett wrote:

> Well I would be very interested in actually being able to use this feature
> under SELinux, I think that just the underlying "can-I-use-this-page" logic
> needs modification.  Maybe "MAP_REUSABLE"?  That would both imply that we can
> accept reused (IE: nonzeroed) memory *AND* that the current page may be reused
> (IE: remapped without zeroing), although you could conceivably have one flag
> for each case.  The userspace allocator should be able to (when prompted by
> MAP_REUSABLE) look in a page "pool" of sorts before falling back to a zeroed
> page.  The pool would be created for a given "key" the first time it unmaps
> MAP_REUSABLE pages, possibly using the memory freed by said unmap.

Hmm, why would you need MAP_REUSABLE? If a page is visible at any time for 
a given UID, and you have a login under such UID, you can fetch the content 
of the page at any time (ie, ptrace_attach, gdb, ...).   And if you are 
not under a UID login, you'll never get to see that page. ATM not even the 
classical "root can see everything" rule is applied.
I think the focus should be to find a case where under the currently 
implemented policy for MAP_NOZERO, MAP_NOZERO represent a loss of security 
WRT no MAP_NOZERO.   I have not been able to find one yet, although Andy 
found a potential one in the setuid+exec/ptrace race (fixed by a patch 
that should IMO go in in any case).
The more ppl think about breaking it, the better it is.




> The real trick is how to define the "key".  The default, without LSMs, should
> be something like the UID.  SELinux, on the other hand, would probably want to
> use some kind of hash of the label as the "key", (and store the label in each
> pool, as well).  That way SELinux could have a simple access-vector check for
> process:reusepage, as well as an access-vector check and type transition for
> "freereusablepage".  Then a policy could allow most user processes to
> unconditionally reuse pages (which would end up in the access-vector-cache and
> therefore be fast), while security-sensitive processes like ssh-agent could
> neither reuse pages nor have their pages reused, even if they request it.

It is very easy, assuming a simple unsigned long cookie is enough for 
SeLinux, to fit in the current MAP_NOZERO.   Well, we have to change 
something in the current struct page _mapcount reuse, but that doable.
There is one line to change, that is the line where the cookie is assigned 
to the mm_struct.   From there on, it's all handled the same way.
If the hash is any longer than unsigned long, I don't really think is ever 
gonna fly, being it stored inside a struct page.
Also, if you start introducing "keys" whose domain is wider than a single 
user, then you'll run for sure in some sort of problem.   This is why the 
current code does not even try to go into the "group" policies.
IMO all this may have some sense if 1) it is very simple 2) limits code 
and data structures bloat to very little or nothing 3) stays all the way 
to the safe side, at the cost of losing some possible valid pages to be 
recycled.   After all, MAP_NOZERO is an hint and not a requirement.
I think that the current method (either UID or KEY based) is simple, does 
not add extra management pools and, *so far*, is not showing security 
leaks.




- Davide


