Return-Path: <linux-kernel-owner+w=401wt.eu-S1754539AbZJKXMJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754539AbZJKXMJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Oct 2009 19:12:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753761AbZJKXMG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Oct 2009 19:12:06 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40001 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753748AbZJKXMG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Oct 2009 19:12:06 -0400
Date: Sun, 11 Oct 2009 16:07:50 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: "Rafael J. Wysocki" <rjw@sisk.pl>,
       David Woodhouse <David.Woodhouse@intel.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>
Subject: Re: 2.6.32-rc4: Reported regressions from 2.6.31
In-Reply-To: <zJ_pXHNwoHC.A.akB.Aal0KB@chimera>
Message-ID: <alpine.LFD.2.01.0910111554400.3438@localhost.localdomain>
References: <zJ_pXHNwoHC.A.akB.Aal0KB@chimera>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 12 Oct 2009, Rafael J. Wysocki wrote:
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14374
> Subject		: MCEs caused by commit db8be50c4307dac2b37305fc59c8dc0f978d09ea
> Submitter	: Nick Piggin <npiggin@suse.de>
> Date		: 2009-10-02 7:34 (10 days old)
> First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=db8be50c4307dac2b37305fc59c8dc0f978d09ea
> References	: http://marc.info/?l=linux-kernel&m=125446885705223&w=4

I think we're going to have to just revert that commit. It's wrong.

It would be nice to do USB handoff earlier, but

 - the correct fix is to make the damn IOMMU code to do it's thing later

 - the USB handoff cannot be done with just PCI config cycles, and will 
   need to do ioremap's etc, which in turn will need the resources to be 
   allocated, which in turn is not possible at FIXUP_HEADER time.

so however much we migth _wish_ to do what that commit does, the commit is 
obvious crap in retrospect.

The IOMMU should not be reprogrammed until _after_ we have handled and 
re-initialized all the devices, so I really think the problem is the IOMMU 
code, not the USB code.

(Of course, the underlying problem is that USB legacy mode handling by 
BIOS with SMM is some seriously insane crap, no question about that. At 
the same time, the IOMMU code is just clearly wrong in removing the legacy 
mappings before we have initialized all devices, so the revert is simply 
the right thing to do)

		Linus
