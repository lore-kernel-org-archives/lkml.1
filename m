Return-Path: <linux-kernel-owner+w=401wt.eu-S1755932AbZGJQNB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755932AbZGJQNB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 12:13:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753725AbZGJQMx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 12:12:53 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41134 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752073AbZGJQMw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 12:12:52 -0400
Message-ID: <4A575735.9050208@zytor.com>
Date: Fri, 10 Jul 2009 07:59:01 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Matthew Garrett <mjg59@srcf.ucam.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@infradead.org>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Yinghai Lu <yinghai@kernel.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alexey Fisher <bug-track@fisher-privat.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Richard A. Holden III" <aciddeath@gmail.com>
Subject: Re: Intel BIOS - Corrupted low memory at ffff880000004200
References: <4A5210A2.2080301@fisher-privat.net> <4A52254F.8080103@fisher-privat.net> <20090708113949.GA8960@srcf.ucam.org> <20090710115238.GA8812@elte.hu>
In-Reply-To: <20090710115238.GA8812@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> 
> So i'd really like to know what is happening there, instead of just 
> zapping support for 64K of RAM on the majority of Linux systems.
> 
> We might end up doing the same thing in the end (i.e. disable that 
> 64k of RAM) - but it should be an informed decision, not a wild stab 
> in the dark.
> 

Speaking as a boot loader author, I can let you know that these kinds of
problems are in no wise limited to suspend/resume.

Pretty much any time you're executing BIOS code you're going to have
*some* platform which has severe memory corruption somewhere.  This is
particularly painful for boot loaders, obviously, because the BIOS
corrupts the boot loader as it is running.  In most cases, there simply
isn't any way to prevent the corruption, and it's simply dumb luck that
you will boot most of the time.

And no, I don't think EFI is going to magically solve anything.  EFI
will just spread the same class of corruption problems over the entire
memory map.  It will reduce the density of such bugs -- in particular it
will eliminiate the "right offset, wrong segment" as well as "idiot
coding assembly" class of problems -- but it will not confine the ones
that can and will happen; it's still fundamentally a super-privileged
flat memory space.

The root cause seems to be a lack of verification practices in the BIOS
industry in the post-DOS era.  Back when DOS was still a commercially
significant system, the BIOS didn't just support the running OS, it also
directly supported running applications.  That put a relatively high bar
on how broken your BIOS could be and still have a viable platform.
These days, it doesn't look like neither the BIOS vendors nor the OEMs
necessarily even know how to QA, and since the BIOS industry is
relatively small and highly consolidated, if there isn't sufficient OEM
pressure it simply won't happen since there is no money in it.

The HDMI case is a good example -- that probably involved SMI being
triggered and the SMI code then clobbering a wild pointer.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

