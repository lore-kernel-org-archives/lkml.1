Return-Path: <linux-kernel-owner+w=401wt.eu-S1753621AbYIHQ3W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753621AbYIHQ3W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 12:29:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751783AbYIHQ3O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 12:29:14 -0400
Received: from gw.goop.org ([64.81.55.164]:39948 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750894AbYIHQ3O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 12:29:14 -0400
Message-ID: <48C552D8.3050405@goop.org>
Date: Mon, 08 Sep 2008 09:29:12 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>,
       Xen Devel <xen-devel@lists.xensource.com>
Subject: Re: [PATCH 6 of 7] x86: use early_ioremap in __acpi_map_table
References: <patchbomb.1220826072@localhost> <944fe7ea3da7707eb90f.1220826078@localhost> <20080907234418.GB26079@one.firstfloor.org> <48C46BCB.2060209@goop.org> <20080908142619.GA10580@elte.hu>
In-Reply-To: <20080908142619.GA10580@elte.hu>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> uhm, there's a nasty trap in that route: it can potentially cause a lot 
> of breakage.
>
> It's not robust to assume that the ACPI code is sane wrt. 
> mapping/unmapping, because it currently simply doesnt rely on robust 
> unmapping (in the linear range).
>   

You mean there's code which just assumes that it can keep using a
linear-mapped acpi even after __acpi_map_table() should have implicitly
unmapped it?
> I tried it in the past and i found tons of crappy ACPI code all around 
> that just never unmapped tables. Leaking ACPI maps are hard to find as 
> well, and it can occur anytime during bootup.
>   

__acpi_map_table() is called by acpi_map_table(), which does have a
acpi_unmap_table() counterpart.  But it only calls iounmap() once we're
past the stage of calling early_*().  I could easily make it call
__acpi_unmap_table()->early_iounmap().  But if the concern is that the
early boot callers of acpi_map_table() "know" that they never need to
unmap, then yes, I see the problem.

> As a general principle it might be worth fixing those places, and we've 
> hardened up the early-ioremap code for leaks during the PAT rewrite, 
> still please realize that it can become non-trivial and it might cause a 
> lot of unhappy users.
>
> So i'd suggest a different, more carful approach: keep the new code you 
> wrote, but print a WARN()ing if prev_map is not unmapped yet when the 
> next mapping is acquired. That way the ACPI code can be fixed gradually 
> and without breaking existing functionality.
>   

Yep.

> There's another complication: ACPI might rely on multiple mappings being 
> present at once, so unmapping the previous one might not be safe. But it 
> _should_ be fine most of the time as __acpi_map_table() is only used 
> inearly init code - and we fixed most of these things in the PAT 
> patchset in any case.

And the current behaviour of __acpi_map_table() is to remove the
previous mapping (implicitly, by overwriting the same fixmap slots), so
its only an issue if the callers assume they can keep using
linear-mapped acpi tables after a subsequent call to __acpi_map_table().

    J
