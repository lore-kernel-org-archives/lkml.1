Return-Path: <linux-kernel-owner+w=401wt.eu-S1754259AbZFBUce@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754259AbZFBUce (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 16:32:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751302AbZFBUc0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 16:32:26 -0400
Received: from oblivion.subreption.com ([66.240.236.22]:47976 "EHLO
	mail.subreption.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750776AbZFBUc0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 16:32:26 -0400
Date: Tue, 2 Jun 2009 13:34:05 -0700
From: "Larry H." <research@subreption.com>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Rik van Riel <riel@redhat.com>,
       linux-kernel@vger.kernel.org, pageexec@freemail.hu
Subject: Re: [PATCH] Change ZERO_SIZE_PTR to point at unmapped space
Message-ID: <20090602203405.GC6701@oblivion.subreption.com>
References: <20090530192829.GK6535@oblivion.subreption.com> <alpine.LFD.2.01.0905301528540.3435@localhost.localdomain> <20090530230022.GO6535@oblivion.subreption.com> <alpine.LFD.2.01.0905301902010.3435@localhost.localdomain> <20090531022158.GA9033@oblivion.subreption.com> <alpine.DEB.1.10.0906021130410.23962@gentwo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0906021130410.23962@gentwo.org>
Organization: Subreption LLC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11:37 Tue 02 Jun     , Christoph Lameter wrote:
> On Sat, 30 May 2009, Larry H. wrote:
> 
> > Let me provide you with a realistic scenario:
> >
> > 	1. foo.c network protocol implementation takes a sockopt which
> > 	sets some ACME_OPTLEN value taken from userland.
> >
> > 	2. the length is not validated properly: it can be zero or an
> > 	integer overflow / signedness issue allows it to wrap to zero.
> >
> > 	3. kmalloc(0) ensues, and data is copied to the pointer
> > 	returned. if this is the default ZERO_SIZE_PTR*, a malicious user
> > 	can mmap a page at NULL, and read data leaked from kernel memory
> > 	everytime that setsockopt is issued.
> > 	(*: kmalloc of zero returns ZERO_SIZE_PTR)
> 
> Cannot happen. The page at 0L is not mapped. This will cause a fault.

Why would mmap_min_addr have been created in first place, if NULL can't
be mapped to force the kernel into accessing userland memory? This is
the way a long list of public and private kernel exploits have worked to
elevate privileges, and disable SELinux/LSMs atomically, too.

Take a look at these:
http://www.grsecurity.net/~spender/exploit.tgz (disables LSMs)
http://milw0rm.com/exploits/4172
http://milw0rm.com/exploits/3587

I would like to know what makes you think I can't mmap(0) from within
the same process that triggers your 'not so exploitable NULL page
fault', which instead of generating the oops will lead to 100% reliable,
cross-arch exploitation to get root privileges (again, after disabling
SELinux and anything else that would supposedly prevent this situation).
Or leaked memory, like a kmalloc(0) situation will most likely lead to,
given the current circumstances.

> You are assuming the system has already been breached. Then of course all
> bets are off.

No, your system has been breached and they have access as a
not-yet-privileged user. The bets are off when nothing protects your
kernel from letting them escalate privileges and disable your fancy
SELinux MLS policy, AppArmor, or any other LSM useless in this scenario.

> > The performance impact, if any, is completely negligible. The security
> > benefits of this utterly simple change well surpass the downsides.
> 
> Dont see any security benefit. If there is a way to breach security
> of the kernel via mmap then please tell us and then lets fix
> the problem and not engage in dealing with secondary issues.

Your first concern has been addressed above. Regarding the second, well,
this is called proactive defense. Instead of taking a reactive approach
when your security has been already breached, you try to lock down
potential venues of attack to deter unknown threats.

Instead of the definitive tone and so forth, you could try something more
reasonable like 'I do not understand what this is all about, could you
please explain it?', which might help.

> Semantics of mmap(NULL, ...) is that the kernel selects a valid address
> for you. How are you mapping something at 0L?

http://www.opengroup.org/onlinepubs/000095399/functions/mmap.html

Please proceed to re-read the part about anonymous mappings and
MAP_FIXED|MAP_PRIVATE. And refer to the exploits mentioned in the
previous paragraphs ;)

Once mmap semantics are clear, we can continue discussing any other
possible objections to this patch, if you don't mind.

	Larry

(Please keep pageexec/PaX team in CC)

