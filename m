Return-Path: <linux-kernel-owner+w=401wt.eu-S1756798AbXJYDbn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756798AbXJYDbn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 23:31:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760090AbXJYDbc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 23:31:32 -0400
Received: from smtp101.mail.mud.yahoo.com ([209.191.85.211]:34104 "HELO
	smtp101.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756300AbXJYDbb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 23:31:31 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=jgtXTyZ0P2cIQ6MhtH9HYctUbmlDk4GyEUpGDuj6+EYr0ichW9J4NeXh5/ENTnu7U8jP5KLaUZSc6vuI7cDZKZPU2dlE7oU573telyJbxmtk1Sag2aciSEC1e543BLRSEcuTWm4fxgcSKAfIFtjliHGsgbnN2CY6TBbrZh6hbD0=  ;
X-YMail-OSG: ffieki4VM1nUKwxBDuUShx88dfuuBSFdAwz4R3XtjMi1LWpeidtR.LcJOvnwdyPa7LB5OfpUnC_A1J8FgsO7UEqs51MCZ_1yaGzs38F94E6c6W9b6g1S1ZR3V5z3FA--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Kleen, Andi" <ak@suse.de>
Subject: Is gcc thread-unsafe?
Date: Thu, 25 Oct 2007 13:24:49 +1000
User-Agent: KMail/1.9.5
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710251324.49888.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Andi spotted this exchange on the gcc list. I don't think he's
brought it up here yet, but it worries me enough that I'd like
to discuss it.

Starts here
http://gcc.gnu.org/ml/gcc/2007-10/msg00266.html

Concrete example here
http://gcc.gnu.org/ml/gcc/2007-10/msg00275.html

Basically, what the gcc developers are saying is that gcc is
free to load and store to any memory location, so long as it
behaves as if the instructions were executed in sequence.

I guess that dynamically allocated memory and computed pointers
are more difficult for gcc to do anything unsafe with, because
it is harder to tell if a given function has deallocated the
memory. However even that could theoretically happen in future
if the compiler can work out the address comes from a global
variable or is not changed intermediately.

Linux makes extensive use of both trylocks and interruptible
locks (ie. which automatically result in divergant code paths,
one of which holds the lock, the other doesn't). However there
are also other code paths which will either hold a particular
lock or will not hold it, depending on context or some flags
etc. barrier() doesn't help.

For x86, obviously the example above shows it can be miscompiled,
but it is probably relatively hard to make it happen for a non
trivial sequence. For an ISA with lots of predicated instructions
like ia64, it would seem to be much more likely. But of course
we don't want even the possibility of failures.

The gcc guys seem to be saying to mark everything volatile that
could be touched in a critical section. This is insane for Linux.

Any thoughts?
