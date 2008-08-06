Return-Path: <linux-kernel-owner+w=401wt.eu-S1760829AbYHFTXl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760829AbYHFTXl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 15:23:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754188AbYHFTXd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 15:23:33 -0400
Received: from aun.it.uu.se ([130.238.12.36]:53818 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752963AbYHFTXc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 15:23:32 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18585.64037.521673.362547@alkaid.it.uu.se>
Date: Wed, 6 Aug 2008 21:23:17 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: Arkadiusz Miskiewicz <arekm@maven.pl>
Cc: "Wahlig, Elsie" <elsie.wahlig@amd.com>, mikpe@it.uu.se,
       linux-kernel@vger.kernel.org
Subject: Re: Opteron Rev E has a bug ... a locked instruction doesn't act as a read-acquire barrier (confirmed)
In-Reply-To: <200808061913.34874.arekm@maven.pl>
References: <CB2417C2B1152C41919D5B9DE58840FA72D828@sausexmb5.amd.com>
	<200808061913.34874.arekm@maven.pl>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Aug 2008 19:13:34 +0200, Arkadiusz Miskiewicz wrote:
>On Wednesday 06 August 2008, Wahlig, Elsie wrote:
>> Your issue may be one that has been seen on 1st generation
>> AMD Opteron processor's with cpuid family 0Fh, cpuid model's
>> < 40h with the code sequence that performs a read-modify write
>> operation after acquiring a semaphore.
>
>Matches my hardware
>
>cpu family      : 15
>model           : 33
>
>>
>> The memory read ordering between a semaphore operation and a
>> subsequent read-modify-write instruction (an instruction which
>> uses the same memory location as both a source and destination)
>> may allow the read-modify-write instruction to operate on the
>> memory location ahead of the completion of the semaphore
>> operation and an erratum may occur.

Thanks for the detailed erratum description.

>I wonder why there was no official errata about this?

Indeed.

>> If you think your software is encountering this code sequence,
>> a work-around should be implemented by adding an LFENCE
>> instruction right after the semaphore, after a cpuid check.
>> The workaround's applied to OpenSolaris at
>> http://mail.opensolaris.org/pipermail/onnv-notify/2006-October/009080.ht
>> ml
>> and Google performance tools tool at
>> http://google-perftools.googlecode.com/svn-history/r48/trunk/src/base/at
>> omicops-internals-x86.cc
>> are suitable examples.
>> A list of the model numbers this issue may occur on is at
>> http://products.amd.com/en-us/downloads/AMD_Opteron_First_Generation_Ref
>> erence_101607.pdf.
>
>Would be better to fix the bug on kernel level if this is possible. Just=20
>someone with the knowledge needs to do this. Anyone interested?

In principle it's easy. We append a 3-byte nop to the lock-taking
instructions. We invent an AMD_MUTEX_BUG synthetic cpuid feature
bit and add boot-time code to detect it. We use the alternatives()
infrastructure to replace that nop with lfence at boot-time if
AMD_MUTEX_BUG is present.

I think the hardest part is locating all lock-taking code sequences.

Also I think I'll start by writing a user-space test program that
does a stress-test of the plain lock;rmw;unlobk sequence to see if
it can break it. (Locks/mutexes are also used in user-space.)

/Mikael
