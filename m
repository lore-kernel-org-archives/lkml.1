Return-Path: <linux-kernel-owner+w=401wt.eu-S1754697AbYIHTpT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754697AbYIHTpT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 15:45:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753021AbYIHTpG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 15:45:06 -0400
Received: from gw.goop.org ([64.81.55.164]:50652 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750820AbYIHTpF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 15:45:05 -0400
Message-ID: <48C580BE.8060207@goop.org>
Date: Mon, 08 Sep 2008 12:45:02 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Hugh Dickins <hugh@veritas.com>
CC: Ingo Molnar <mingo@elte.hu>, Rafa? Mi?ecki <zajec5@gmail.com>,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC] x86: check for and defend against BIOS memory corruption
References: <48B701FB.2020905@goop.org> <Pine.LNX.4.64.0808290817190.21494@blonde.site> <48B80C26.2080002@goop.org> <Pine.LNX.4.64.0809081157020.14401@blonde.site> <48C55E07.5000406@goop.org> <Pine.LNX.4.64.0809081956390.23187@blonde.site>
In-Reply-To: <Pine.LNX.4.64.0809081956390.23187@blonde.site>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh Dickins wrote:
> On Mon, 8 Sep 2008, Jeremy Fitzhardinge wrote:
>   
>> Well, if we never want the direct map to be non-executable (which I
>>     
>
> One too many negatives?
>   

Yes.  I over-corrected in my pre-send proofread.

>> think would be OK, since all the code is either core kernel or modules
>> which are mapped elsewhere),
>>     
>
> I had thought so until just before replying.
>
>   
>> then we can set NX on the level4 for the
>> linear mapping which will make everything below non-executable.
>>     
>
> That would be much the neatest answer: I hadn't realized
> that inheritance (perhaps I'm still living in early-i386 days,
> when IIRC there was a bug in inheriting WP from higher levels).
>   

In PAE mode the top-level doesn't let you set inheritable permissions
flags.  On i386 it only works on levels 2 and 1, but 64-bit fixes it to
work on all levels.

> But then I stumbled across static_protections() in pageattr.c
> (takes both addr and pfn, latter seems weird),

Well, it wants to set the mappings for some physical memory in the case
of BIOS and RO data, but only affect the kernel mappings in a particular
virtual range (so the linear mapping of the kernel is still NX).   (No
need for it to be inline though.)

But it does seem it wants the BIOS to be executable when you're using it
for PCI space.  A possible fix in that case is to create a separate
executable mapping of BIOS space.

That said, PCI_GOBIOS is only used on 32-bit anyway, so it's moot (its
only use is to define CONFIG_PCI_BIOS, and it depends on X86_32).

> A simple answer might be to go the way you suggest, but remove
> the special casing from pageattr.c and ioremap.c; but I fear
> that will slow something down, or introduce further bugs.
>   

It looks to me like it won't matter either way.

    J
