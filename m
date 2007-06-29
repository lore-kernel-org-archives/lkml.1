Return-Path: <linux-kernel-owner+w=401wt.eu-S933026AbXF2FVA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933026AbXF2FVA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 01:21:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751764AbXF2FUv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 01:20:51 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:3745 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751689AbXF2FUv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 01:20:51 -0400
X-AuthUser: davidel@xmailserver.org
Date: Thu, 28 Jun 2007 22:20:34 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Kyle Moffett <mrmacman_g4@mac.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Rik van Riel <riel@redhat.com>, Andy Isaacson <adi@hexapodia.org>
Subject: Re: [patch 0/4] MAP_NOZERO v2 - VM_NOZERO/MAP_NOZERO early summer
 madness
In-Reply-To: <EC4CE052-5514-465E-92D2-9D50DA970DDC@mac.com>
Message-ID: <Pine.LNX.4.64.0706282215050.22076@alien.or.mcafeemobile.com>
References: <send-serie.davidel@xmailserver.org.5792.1183056564.0>
 <EC4CE052-5514-465E-92D2-9D50DA970DDC@mac.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Jun 2007, Kyle Moffett wrote:

> On Jun 28, 2007, at 14:49:24, Davide Libenzi wrote:
> > I was using oprofile to sample some userspace code I am working on, and I
> > was continuosly noticing  clear_page  in the top three entries of the
> > oprofile logs.
> > 
> > Also, a simple kernel build, in my Dual Opteron with 8GB of RAM, shows
> > clear_page  as the first kernel entry, second only to the userspace the  cc1
> > and  as. Most of the userspace code uses malloc() (and anonymous  mappings)
> > in such a way that the memory returned via kernel->glibc is immediately
> > written soon after. The POSIX malloc() definition itself also, does not
> > require the returned memory to be zeroed (as calloc() does).
> > 
> > So I implemented a rather quick hack that introduces a new mmap() flag
> > MAP_NOZERO (only valid for anonymous mappings) and the  vma  counter-part
> > VM_NOZERO. Also, a new sys_brk2() has been introduced to accept a new flags
> > parameter. A brief description of the patches follows in the next emails.
> 
> Hmm, sounds like this would also need a "MAP_NOREUSE" flag of some kind for
> security sensitive applications.  Basically, I wouldn't want my ssh-agent
> pages holding private SSH keys to be reused by my web browser which then gets
> exploited :-D

Well, if your web browser and your ssh session are running under the same 
user, and your web browser gets hacked, someone is basically logged in in 
your system under your user. It can ptrace-attach your ssh-agent and take 
it from there. It can also read your .ssh directory for what it matter and 
more simply ;)



> It would also be a massive information leak under SELinux.  To
> fix it properly according to the SELinux model you would need to tag each page
> with a label immediately after it's freed and then do an access-vector-check
> against the old page and the new process before allowing reuse.  On the other
> hand, that would probably be at least as expensive as zeroing the page.

SeLinux could use a simple hook and disable the feature per-task and 
globally. Just assign an invalid UID to mm->owner_uid and pages will never 
be used. It could also hook mmap and clear off MAP_NOZERO.



- Davide


