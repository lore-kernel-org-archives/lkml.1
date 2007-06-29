Return-Path: <linux-kernel-owner+w=401wt.eu-S1753907AbXF2TkF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753907AbXF2TkF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 15:40:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752464AbXF2Tjz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 15:39:55 -0400
Received: from straum.hexapodia.org ([64.81.70.185]:13041 "EHLO
	straum.hexapodia.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752437AbXF2Tjz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 15:39:55 -0400
Date: Fri, 29 Jun 2007 12:39:54 -0700
From: Andy Isaacson <adi@hexapodia.org>
To: Kyle Moffett <mrmacman_g4@mac.com>
Cc: Davide Libenzi <davidel@xmailserver.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Rik van Riel <riel@redhat.com>
Subject: Re: [patch 0/4] MAP_NOZERO v2 - VM_NOZERO/MAP_NOZERO early summer madness
Message-ID: <20070629193954.GL9157@hexapodia.org>
References: <send-serie.davidel@xmailserver.org.5792.1183056564.0> <EC4CE052-5514-465E-92D2-9D50DA970DDC@mac.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <EC4CE052-5514-465E-92D2-9D50DA970DDC@mac.com>
User-Agent: Mutt/1.4.2.2i
X-PGP-Fingerprint: 1914 0645 FD53 C18E EEEF C402 4A69 B1F3 68D2 A63F
X-PGP-Key-URL: http://web.hexapodia.org/~adi/gpg.txt
X-Domestic-Surveillance: money launder bomb tax evasion
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 28, 2007 at 10:57:00PM -0400, Kyle Moffett wrote:
> On Jun 28, 2007, at 14:49:24, Davide Libenzi wrote:
> >So I implemented a rather quick hack that introduces a new mmap()  
> >flag MAP_NOZERO (only valid for anonymous mappings) and the  vma   
> >counter-part VM_NOZERO. Also, a new sys_brk2() has been introduced  
> >to accept a new flags  parameter. A brief description of the  
> >patches follows in the next emails.
> 
> Hmm, sounds like this would also need a "MAP_NOREUSE" flag of some  
> kind for security sensitive applications.  Basically, I wouldn't want  
> my ssh-agent pages holding private SSH keys to be reused by my web  
> browser which then gets exploited :-D.

PGP at least (and I think GPG still) did overwrite keys before calling
free(), and attempted to use mlock().  Looks like ssh-agent doesn't use
mlock -- at least it hasn't in this case:
% grep Lck /proc/`pidof ssh-agent`/status
VmLck:         0 kB
% ulimit -a | grep lock
file size (blocks)         unlimited
core file size (blocks)    0
locked-in-memory size (kb) 32
file locks                 unlimited

Requiring security-sensitive apps to use a new flag to get safe behavior
is dangerous.  Better to be safe by default and turn on the
less-safe-but-faster behavior for the cases that benefit from it.

> It would also be a massive  
> information leak under SELinux.  To fix it properly according to the  
> SELinux model you would need to tag each page with a label  
> immediately after it's freed and then do an access-vector-check  
> against the old page and the new process before allowing reuse.  On  
> the other hand, that would probably be at least as expensive as  
> zeroing the page.

I still think that using uid in mm_struct is wrong, and some kind of
abstraction is required.  I called this "free pool" in
<20070628061911.GA16986@hexapodia.org>, but I think that name is
misleading -- I am not proposing that this should be part of the
management of free pages, but should be a label which abstracts "safe to
share freed pages among" groups.  Then different SELinux protection
domains would simply have different labels.

-andy
