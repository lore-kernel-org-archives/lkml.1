Return-Path: <linux-kernel-owner+w=401wt.eu-S933284AbZDAS22@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933284AbZDAS22 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 14:28:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757132AbZDAS2S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 14:28:18 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40523 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753590AbZDAS2S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 14:28:18 -0400
Date: Wed, 1 Apr 2009 11:24:10 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: "H. Peter Anvin" <hpa@zytor.com>
cc: "Michael K. Johnson" <johnsonm@rpath.com>,
       Justin Forbes <jmforbes@linuxtx.org>,
       Jordan Hargrave <Jordan_Hargrave@dell.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] x86 setup BIOS workarounds
In-Reply-To: <200904011640.n31GeD0m008691@voreg.hos.anvin.org>
Message-ID: <alpine.LFD.2.00.0904011115210.4130@localhost.localdomain>
References: <200904011640.n31GeD0m008691@voreg.hos.anvin.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 1 Apr 2009, H. Peter Anvin wrote:
> 
> implements handling for the backwards-incompatible(!) E820 handling in 
> ACPI 3.

I am _extremely_ nervous about this one.

You do

	size = sizeof buf;	/* ACPI-3 size */
	asm(.. "+c" (size)	/* size might change */
	..
	if (size > 20 && !(buf.ext_flags & 1))
		continue;

ie you are expecting that _all_ old pre-ACPI-3 BIOSES will always set size 
to 20, or always write a low-bit-set value to that extended flag field 
that doesn't even exist previously.

I don't think that's likely true. Quite frankly, I'd expect a number of 
BIOSen to entirely ignore %ecx, since it's irrelevant (it _has_ to be 
bigger than 20 anyway on entry, and I doubt anybody really ever bothered 
to test that it's 20 on exit).

So at a _minimum_, I'd suggest that we set bug.ext_flags to 1 before the 
call - so that if some random BIOS just leaves %ecx unchanged, it won't 
mean that the area just gets ignored as a ACPI-3 entry.

And if it really _is_ a new ACPI-3 BIOS, it will overwrite ext_flags with 
its own value.

I've pulled you changes, but I really don't like how they seem to be 
designed to be very fragile, and designed to expect BIOSes to actually 
implement documented interfaces without bugs. So please look at it.

		Linus
