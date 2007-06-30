Return-Path: <linux-kernel-owner+w=401wt.eu-S1755434AbXF3X53@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755434AbXF3X53 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2007 19:57:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753097AbXF3X5V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jun 2007 19:57:21 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:1492 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753597AbXF3X5U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2007 19:57:20 -0400
X-AuthUser: davidel@xmailserver.org
Date: Sat, 30 Jun 2007 16:57:18 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Kyle Moffett <mrmacman_g4@mac.com>
cc: Andy Isaacson <adi@hexapodia.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Rik van Riel <riel@redhat.com>
Subject: Re: [patch 0/4] MAP_NOZERO v2 - VM_NOZERO/MAP_NOZERO early summer
 madness
In-Reply-To: <8F40BE4A-BD38-4C3F-B77D-35661E84C553@mac.com>
Message-ID: <Pine.LNX.4.64.0706301652050.2957@alien.or.mcafeemobile.com>
References: <send-serie.davidel@xmailserver.org.5792.1183056564.0>
 <EC4CE052-5514-465E-92D2-9D50DA970DDC@mac.com> <20070629193954.GL9157@hexapodia.org>
 <Pine.LNX.4.64.0706291306220.31176@alien.or.mcafeemobile.com>
 <D65DCB84-F812-4C3B-8E68-EACA0CA8A0C0@mac.com>
 <Pine.LNX.4.64.0706291711320.31176@alien.or.mcafeemobile.com>
 <8F40BE4A-BD38-4C3F-B77D-35661E84C553@mac.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 30 Jun 2007, Kyle Moffett wrote:

> On Jun 30, 2007, at 15:03:07, Davide Libenzi wrote:
> > Hmm, why would you need MAP_REUSABLE? If a page is visible at any time for a
> > given UID, and you have a login under such UID, you can fetch the content of
> > the page at any time (ie, ptrace_attach, gdb, ...).
> 
> Not under SELinux or other LSMs.  I suppose those could live without a 15%
> performance improvement in some workloads, but it would be nice if we could
> avoid it.  Essentially, UID is a really poor way to define
> process-security-equivalence classes in some systems.  If you really want to
> define such classes then you need to add LSM hooks to manage the equivalence
> classes.
> 
> > I think the focus should be to find a case where under the currently
> > implemented policy for MAP_NOZERO, MAP_NOZERO represent a loss of security
> > WRT no MAP_NOZERO.
> 
> Very simple case:
> SELinux is turned on, an s9 (IE: TOP_SECRET) process calls free(), and an s3
> (IE: UNCLASSIFIED) process calls malloc(), getting the data from the
> TOP_SECRET process.

Note that you use *s3* and *s9*. Those will be two different context cookies. 
SeLinux will have its own way to set the cookie in the mm_struct, to *s3* 
in one case, and to *s9* in the other case. This will make things so that 
they'll never see each other pages.




> > It is very easy, assuming a simple unsigned long cookie is enough for
> > SeLinux, to fit in the current MAP_NOZERO.   Well, we have to change
> > something in the current struct page _mapcount reuse, but that doable. There
> > is one line to change, that is the line where the cookie is assigned  to the
> > mm_struct.
> 
> I think if you create the concept of a "process equivalence class" and add an
> LSM hook for it, then the unsigned long could just store which equivalence
> class the page is in.  The default without LSMs would be to use
> mutual-ptraceability as the equivalence class (IE: the UID with a proviso for
> SUID binaries).  LSMs should be able to create a process_equivalence_class
> hook which when called returns an unsigned long identifying the "equivalence
> class" (IE: pool) into which the page is placed when freed (or ((unsigned
> long)-1) to forcibly zero the page).  When a process requests a
> maybe-not-zeroed page, the LSM hook would be called again to determine what
> equivalence class should be used, (or ((unsigned long)-1) for
> dont-use-any-class).

I'd rather prefer to not create anything, and to not add anything. SeLinux 
can set the cookie as it likes, and it can also disable the feature. Since 
SeLinux is definitely not the common case, I'd prefer to keep the simple 
unsigned long cookie abstraction, and let them handle however they like it.



- Davide


