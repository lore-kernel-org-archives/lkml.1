Return-Path: <linux-kernel-owner+w=401wt.eu-S1756119AbYDOGmQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756119AbYDOGmQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 02:42:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752423AbYDOGmB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 02:42:01 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:37245 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751441AbYDOGmA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 02:42:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=qoO8D2Spf/mXC9PiMvcn03Zj57nlQYQQ5TGPuGR3lxnW+dcldLKOjWXEricK+3LlLTTk9D1rf5Dipq0HgLtgzpKLlUCAvqKXhkf+d1KU/v2OtOFfK6RUi8BTcHgI9Rp/cQHwpNmcR0sRH0Anfoyb99lQa/6szNq9/St1HVecTCs=
Message-ID: <84144f020804142341ic4621c9o6de06d68eee74871@mail.gmail.com>
Date: Tue, 15 Apr 2008 09:41:59 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [bug] SLUB + mm/slab.c boot crash in -rc9
Cc: linux-kernel@vger.kernel.org, "Christoph Lameter" <clameter@sgi.com>,
       "Mel Gorman" <mel@csn.ul.ie>, "Nick Piggin" <npiggin@suse.de>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Yinghai.Lu@sun.com
In-Reply-To: <20080415062534.GA9172@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080411074145.GA4944@elte.hu>
	 <84144f020804110121l8444aafl4631071b34c458fe@mail.gmail.com>
	 <84144f020804110150q367260f6k473380a1309db878@mail.gmail.com>
	 <20080411085411.GA10181@elte.hu>
	 <84144f020804110205u3d073e76lbcdd36ec293a169b@mail.gmail.com>
	 <84144f020804110208m41414c0h2ed71b85efbb426c@mail.gmail.com>
	 <84144f020804110211w4ae41414od24cf2de72453e13@mail.gmail.com>
	 <20080415062534.GA9172@elte.hu>
X-Google-Sender-Auth: bfd49be06bf12c9f
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 15, 2008 at 9:25 AM, Ingo Molnar <mingo@elte.hu> wrote:
>  so it's probably the first few page allocations (setup_cpu_cache())
>  going wrong already - suggesting a some fundamental borkage in SLAB?

I think it's still pointing to the page allocator and/or setting up
the zonelists...

>  note, when i change SLAB to SLUB (and keep the config unchanged
>  otherwise), i get a similar early crash:

...especially considering you have similar crash with SLUB as well.

Now this:

[    0.000999] ------------[ cut here ]------------
[    0.000999] WARNING: at mm/slab.c:1685 cache_alloc_refill+0x2a6/0x4a3()
[    0.000999] Pid: 0, comm: swapper Not tainted 2.6.25-rc9 #924
[    0.000999]  [<c0121b6f>] warn_on_slowpath+0x3c/0x4c
[    0.000999]  [<c0781873>] ? _spin_unlock_irqrestore+0xf/0x13
[    0.000999]  [<c02941ad>] ? delay_tsc+0x2e/0x4e
[    0.000999]  [<c029414d>] ? __delay+0x9/0xb
[    0.000999]  [<c0353db3>] ? serial8250_console_putchar+0x80/0x86
[    0.000999]  [<c0148822>] ? get_page_from_freelist+0x230/0x345
[    0.000999]  [<c0121eb1>] ? __call_console_drivers+0x56/0x63
[    0.000999]  [<c01489bb>] ? __alloc_pages+0x6e/0x2be
[    0.000999]  [<c015bd2e>] cache_alloc_refill+0x2a6/0x4a3
[    0.000999]  [<c015ba3f>] kmem_cache_alloc+0x5b/0xa4

Says that alloc_pages_node() returned NULL early on in the boot.
However, GFP_THISNODE is ruled out as this:

Index: linux/mm/page_alloc.c
===================================================================
--- linux.orig/mm/page_alloc.c
+++ linux/mm/page_alloc.c
@@ -1485,6 +1485,7 @@ restart:
                * Happens if we have an empty zonelist as a result of
                * GFP_THISNODE being used on a memoryless node
                */
+               WARN_ON(1);
               return NULL;
       }

does not trigger. Hmm...
