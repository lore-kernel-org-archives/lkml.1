Return-Path: <linux-kernel-owner+w=401wt.eu-S1762757AbYD3QEe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762757AbYD3QEe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 12:04:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757768AbYD3QEZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 12:04:25 -0400
Received: from wr-out-0506.google.com ([64.233.184.225]:24597 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755532AbYD3QEY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 12:04:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=P1CcoQheX10Vmmldxi2bZSDV0+bX81WGqBDLGutsPzlMpO+mB8aRpKupveKwaok3gafeXNWsMj33BK+4oJbsRXpgT2ezIqFLAv7M/4q0kKibH4hSs2e53syr/K7R8Nhe00drYXM70ygscySbeCJuUzS8BEPvgj7DJCTo60/EOl8=
Message-ID: <19f34abd0804300904x7000cc6q8d717c3cd524ada4@mail.gmail.com>
Date: Wed, 30 Apr 2008 18:04:23 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Andres Salomon" <dilinger@queued.net>
Subject: Re: [PATCH] x86: ioremap ram check fix
Cc: "Jan Beulich" <jbeulich@novell.com>, "Ingo Molnar" <mingo@elte.hu>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080430113024.43aa3935@ephemeral>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080430113024.43aa3935@ephemeral>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 30, 2008 at 5:30 PM, Andres Salomon <dilinger@queued.net> wrote:
> Hi Ingo,
>
>  bdd3cee2e4b7279457139058615ced6c2b41e7de (x86: ioremap(), extend check
>  to all RAM pages) breaks OLPC's ioremap call.  The ioremap that OLPC uses is:
>
>         romsig = ioremap(0xffffffc0, 16);
>
>  The commit that breaks it is basically:
>
>  -       for (pfn = phys_addr >> PAGE_SHIFT; pfn < max_pfn_mapped &&
>  -            (pfn << PAGE_SHIFT) < last_addr; pfn++) {
>  +       for (pfn = phys_addr >> PAGE_SHIFT;
>  +                               (pfn << PAGE_SHIFT) < last_addr; pfn++) {
>  +
>
>  Previously, the 'pfn < max_pfn_mapped' check would've caused us to not
>  enter the loop.  Removing that check means we loop infinitely.  The
>  reason for that is because pfn is 0xfffff, and last_addr is 0xffffffcf.
>  The remaining check that is used to exit the loop is not sufficient;
>  when pfn<<PAGE_SHIFT is 0xfffff000, that is less than 0xffffffcf; when
>  we increment pfn and it overflows (pfn == 0x100000), pfn<<PAGE_SHIFT
>  ends up being 0.  That, of course, is less than last_addr.  In effect,
>  pfn<<PAGE_SHIFT is never lower than last_addr.
>
>  The simple fix for this is to limit the last_addr check to the PAGE_MASK;
>  a patch is below.
>
>
>
>
>  Signed-off-by: Andres Salomon <dilinger@debian.org>
>  ---
>   arch/x86/mm/ioremap.c |    3 ++-
>   1 files changed, 2 insertions(+), 1 deletions(-)
>
>  diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
>  index 804de18..fb960f5 100644
>  --- a/arch/x86/mm/ioremap.c
>  +++ b/arch/x86/mm/ioremap.c
>  @@ -149,7 +149,8 @@ static void __iomem *__ioremap_caller(resource_size_t phys_addr,
>          * Don't allow anybody to remap normal RAM that we're using..
>          */
>         for (pfn = phys_addr >> PAGE_SHIFT;
>  -                               (pfn << PAGE_SHIFT) < last_addr; pfn++) {
>  +                               (pfn << PAGE_SHIFT) < (last_addr & PAGE_MASK);
>  +                               pfn++) {
>
>                 int is_ram = page_is_ram(pfn);
>

This fixes two 150-second solid freezes during bootup on a P4 I have
as well. Acked!

Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
