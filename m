Return-Path: <linux-kernel-owner+w=401wt.eu-S1762445AbXFJGs6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762445AbXFJGs6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2007 02:48:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759496AbXFJGsj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jun 2007 02:48:39 -0400
Received: from ozlabs.org ([203.10.76.45]:45643 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759205AbXFJGsh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2007 02:48:37 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18027.40637.672203.14305@cargo.ozlabs.ibm.com>
Date: Sun, 10 Jun 2007 16:48:29 +1000
From: Paul Mackerras <paulus@samba.org>
To: Kyle Moffett <mrmacman_g4@mac.com>
Cc: Davide Libenzi <davidel@xmailserver.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Theodore Tso <tytso@mit.edu>,
       Ulrich Drepper <drepper@redhat.com>, Eric Dumazet <dada1@cosmosbay.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 7/8] fdmap v2 - implement sys_socket2
In-Reply-To: <463C79D8-88CB-492A-96FD-10C10D16C4B6@mac.com>
References: <466741BD.20106@redhat.com>
	<20070607110432.73be7960@the-village.bc.nu>
	<B8B9EC80-2E36-433E-87EB-5B31FF42FBCF@mac.com>
	<20070607151243.22caab9e.dada1@cosmosbay.com>
	<Pine.LNX.4.64.0706071243090.6445@alien.or.mcafeemobile.com>
	<466864F8.2050903@cosmosbay.com>
	<46686810.6030805@redhat.com>
	<Pine.LNX.4.64.0706071438020.6445@alien.or.mcafeemobile.com>
	<466880A4.3090908@redhat.com>
	<Pine.LNX.4.64.0706071534280.6445@alien.or.mcafeemobile.com>
	<20070608120746.GD12687@thunk.org>
	<20070608140150.6f31672f@the-village.bc.nu>
	<Pine.LNX.4.64.0706081108130.5519@alien.or.mcafeemobile.com>
	<18026.15766.574693.200636@cargo.ozlabs.ibm.com>
	<463C79D8-88CB-492A-96FD-10C10D16C4B6@mac.com>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kyle Moffett writes:

> 1)  Linear FD allocation makes it IMPOSSIBLE for libraries to  
> reliably use persistent FDs behind an application's back.  For  

That's not completely true; for example, openlog() opens a file
descriptor for the library's own use, as does sethostent().  I agree
that it creates difficulties if the library implementor wants to use a
file descriptor in a set of functions that didn't previously use one,
but with a bit of assistance from the kernel, that can be solved
without breaking the ABI.

> for (i = 0; i < NR_OPEN; i++)
> 	if (!fd_is_special_to_us(i))
> 		close(i);
> 
> Note that this is conceptually buggy, but occurs in several major C  
> programming books, most of the major shells, and a lot of other  
> software to boot.

Buggy in what way?  In the use of the NR_OPEN constant?

> 3) In order to allocate new FDs, the kernel has to scan over a  
> (potentially very large) bitmap.  A process with 100,000 fds (not  
> terribly uncommon) would have 12.5kbyte of FD bitmap and would trash  
> the cache every time it tried to allocate an FD.

For specialized programs like that we can offer alternative fd
allocation strategies if necessary (although I expect that with
100,000 fds other things will limit performance more than
allocation).

None of those things is an excuse for breaking the ABI, however.
As I said to Davide, I was really protesting about the attitude that
we can just break the ABI however and whenever we like and force
programs to adapt.

Paul.
