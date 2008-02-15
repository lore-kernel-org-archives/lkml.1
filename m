Return-Path: <linux-kernel-owner+w=401wt.eu-S1757954AbYBOFpl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757954AbYBOFpl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 00:45:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753912AbYBOFpa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 00:45:30 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53402 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752288AbYBOFp3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 00:45:29 -0500
Date: Thu, 14 Feb 2008 21:44:57 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Huang, Ying" <ying.huang@intel.com>
cc: Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
       tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix left over EFI cache mapping problems
In-Reply-To: <1203050886.30010.19.camel@caritas-dev.intel.com>
Message-ID: <alpine.LFD.1.00.0802142139260.4255@woody.linux-foundation.org>
References: <20080214131317.GA27769@basil.nowhere.org>  <20080214161218.GA28152@elte.hu> <1203050886.30010.19.camel@caritas-dev.intel.com>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 15 Feb 2008, Huang, Ying wrote:
> 
> I think the patch following may be better, because it is possible that
> the EFI_PAGE_SHIFT and PAGE_SHIFT are different.

If this is a problem in practice, we'd be better off having a helper 
function to do it, to avoid overflows. Right now, doing

> +		unsigned long num_pages;
> +		num_pages = (md->num_pages << EFI_PAGE_SHIFT) >> PAGE_SHIFT;

overflows at 4GB on x86-32. And maybe you never have areas that big, and 
people are moving over to 64-bit anyway, it still sounds like a bug 
waiting to happen.

So *if* we care (I doubt we do, since EFI_PAGE_SHIFT at least right now 
matches PAGE_SHIFT on x86), you'd probably want to do something like

  static inline unsigned long efi_pages_to_native_pages(unsigned long efi_pages)
  {
  #if EFI_PAGE_SHIFT > PAGE_SHIFT
	return efi_pages << (EFI_PAGE_SHIFT - PAGE_SHIFT);
  #else
	return efi_pages >> (PAGE_SHIFT - EFI_PAGE_SHIFT);
  #endif
  }

or whatever.

Otherwise, trying to avoid a bug with different page sizes is actually 
more likely to *introduce* one rather than fix one..

			Linus
