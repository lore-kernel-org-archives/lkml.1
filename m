Return-Path: <linux-kernel-owner+w=401wt.eu-S1757503AbXLTTZI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757503AbXLTTZI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 14:25:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753343AbXLTTY5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 14:24:57 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33450 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753216AbXLTTY4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 14:24:56 -0500
Date: Thu, 20 Dec 2007 11:24:01 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jan Kara <jack@suse.cz>
cc: Bj?rn Steinbrink <B.Steinbrink@gmx.de>, Krzysztof Oledzki <olel@ans.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Peter Zijlstra <peterz@infradead.org>,
       Thomas Osterried <osterried@jesse.de>, protasnb@gmail.com,
       bugme-daemon@bugzilla.kernel.org
Subject: Re: [Bug 9182] Critical memory leak (dirty pages)
In-Reply-To: <20071220172551.GE764@atrey.karlin.mff.cuni.cz>
Message-ID: <alpine.LFD.0.9999.0712201116510.21557@woody.linux-foundation.org>
References: <20071215221935.306A5108068@picon.linux-foundation.org> <Pine.LNX.4.64.0712152358240.14491@bizon.gios.gov.pl> <20071215203539.d6f71e96.akpm@linux-foundation.org> <Pine.LNX.4.64.0712161016290.25065@bizon.gios.gov.pl> <20071216015112.d0ab08a1.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0712161440030.25065@bizon.gios.gov.pl> <alpine.LFD.0.9999.0712190903350.21557@woody.linux-foundation.org> <20071220141217.GA4745@atjola.homenet> <alpine.LFD.0.9999.0712200753040.21557@woody.linux-foundation.org>
 <20071220172551.GE764@atrey.karlin.mff.cuni.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 20 Dec 2007, Jan Kara wrote:
>
>   As I wrote in my previous email, this solution works but hides the
> fact that the page really *has* dirty data in it and *is* pinned in memory
> until the commit code gets to writing it. So in theory it could disturb
> the writeout logic by having more dirty data in memory than vm thinks it
> has. Not that I'd have a better fix now but I wanted to point out this
> problem.

Well, I worry more about the VM being sane - and by the time we actually 
hit this case, as far as VM sanity is concerned, the page no longer really 
exists. It's been removed from the page cache, and it only really exists 
as any other random kernel allocation.

The fact that low-level filesystems (in this case ext3 journaling) do 
their own insane things is not something the VM even _should_ care about. 
It's just an internal FS allocation, and the FS can do whatever the hell 
it wants with it, including doing IO etc.

The kernel doesn't consider any other random IO pages to be "dirty" either 
(eg if you do direct-IO writes using low-level SCSI commands, the VM 
doesn't consider that to be any special dirty stuff, it's just random page 
allocations again). This is really no different.

In other words: the Linux "VM" subsystem is really two differnt parts: the 
low-level page allocator (which obviously knows that the page is still in 
*use*, since it hasn't been free'd), and the higher-level file mapping and 
caching stuff that knows about things like page "dirtyiness". And once 
you've done a "remove_from_page_cache()", the higher levels are no longer 
involved, and dirty accounting simply doesn't get into the picture.

			Linus
