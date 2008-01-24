Return-Path: <linux-kernel-owner+w=401wt.eu-S1758608AbYAXWKl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758608AbYAXWKl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 17:10:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754139AbYAXWKe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 17:10:34 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41753 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753428AbYAXWKd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 17:10:33 -0500
Message-ID: <47990BDC.4070008@zytor.com>
Date: Thu, 24 Jan 2008 14:06:20 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ian Campbell <ijc@hellion.org.uk>
CC: Jeremy Fitzhardinge <jeremy@goop.org>, Ingo Molnar <mingo@elte.hu>,
       =?UTF-8?B?TWlrYSBQZW50dGlsw6Q=?= <mika.penttila@kolumbus.fi>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] x86: Construct 32 bit boot time page tables in native
 format.
References: <1200758937-22386-2-git-send-email-ijc@hellion.org.uk>	 <47939363.8040603@kolumbus.fi>	 <1200950633.15491.21.camel@cthulhu.hellion.org.uk>	 <479510CE.7010706@zytor.com>	 <1200951996.15491.28.camel@cthulhu.hellion.org.uk>	 <479551FD.5040801@zytor.com>	 <1201023401.5643.52.camel@localhost.localdomain>	 <479634A9.1090908@zytor.com>	 <1201031325.15491.66.camel@cthulhu.hellion.org.uk>	 <47964B7B.9000905@zytor.com>  <20080122203611.GA12892@elte.hu>	 <1201121530.30671.15.camel@cthulhu.hellion.org.uk>	 <4797E487.8010108@goop.org> <1201167544.30671.64.camel@cthulhu.hellion.org.uk>
In-Reply-To: <1201167544.30671.64.camel@cthulhu.hellion.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ian Campbell wrote:
> 
> I'm not sure how PSE comes to be used ever though -- an EFI only thing?
> Using the qemu monitor I could see a bunch of NX bits used when NX was
> available.
> 

This is part of the trickiness with re-using the early pagetables 
instead of rebuilding them from scratch - if PSE is available, we have 
two options:

- either we build PSE page tables early (which means detecting PSE, 
which means if there are any chip-specific CPUID workarounds they have 
to be present in the early code), or

- when building the "complete" page tables, coalesce !PSE pagetables 
into PSE entries where appropriate.

For PAT to work right, the first chunk probably should *not* be a PSE 
page table, which complicates things further.  (There is no TLB impact, 
since a PSE page table at offset zero or that otherwise have an MTRR 
conflict will be broken apart in hardware.)  In the former case, it 
means splitting it apart later; in the latter case it just means 
excluding it from coalescing.

In other words, reusing the early page tables isn't all that 
straightforward.  It may easily be that it's better to build a new set 
of page tables from scratch, however, it would *still* be beneficial to 
have the early page tables be in the same format as the later one, since 
it lets us use the fixmap area, and therefore {bt,early}_ioremap() much 
sooner.

	-hpa

