Return-Path: <linux-kernel-owner+w=401wt.eu-S1764640AbXHFKte@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764640AbXHFKte (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 06:49:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764720AbXHFKsk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 06:48:40 -0400
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:34344
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764534AbXHFKsj convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 06:48:39 -0400
Message-Id: <46B718DB.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Mon, 06 Aug 2007 11:49:31 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: "Andi Kleen" <ak@suse.de>
Cc: <linux-kernel@vger.kernel.org>, <patches@x86-64.org>
Subject: Re: [patches] [PATCH] [1/58] x86: Always flush pages in
	change_page_attr
References: <200707191154.642492000@suse.de>
 <20070719095444.CFAB114E04@wotan.suse.de>
 <46B710C5.76E4.0078.0@novell.com> <200708061236.59195.ak@suse.de>
In-Reply-To: <200708061236.59195.ak@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Andi Kleen <ak@suse.de> 06.08.07 12:36 >>>
>On Monday 06 August 2007 12:15:01 Jan Beulich wrote:
>> But that is still wrong - you're again flushing the page table page rather than
>> the data one. Fixing this was the purpose of the patch I had sent, plus the
>> broken reference counting used by the reversion logic. Jan
>
>True. The problem is that we can't necessarily use the LRU list_head of the data
>pages though; e.g. when the page is mapped to user space.
>
>I guess we might need to go back to wbinvd again.

That was what my patch did, plus an attempt to avoid the wbinvd if all accumulated
pages that have pending modifications are contiguous.

>What was the remaining problem of the reference counting? 

The counter gets adjusted regardless of the current attribute in effect, e.g. if you
change a page to PAGE_KERNEL that already happens to be PAGE_KERNEL, the
counter still gets decremented, which in turn may result in reverting the containing
2M/4M page prematurely. Likewise if a not-PAGE_KERNEL gets changed to another
non-PAGE_KERNEL attribute, the counter would get incremented, likely preventing
reverting the large page forever.

Jan

