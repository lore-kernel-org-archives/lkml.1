Return-Path: <linux-kernel-owner+w=401wt.eu-S932117AbYBNSir@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932117AbYBNSir (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 13:38:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764421AbYBNSig
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 13:38:36 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:58548 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764350AbYBNSif (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 13:38:35 -0500
Date: Thu, 14 Feb 2008 19:38:19 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <andi@firstfloor.org>
Cc: torvalds@osdl.org, tglx@linutronix.de, linux-kernel@vger.kernel.org,
       ying.huang@intel.com
Subject: Re: [PATCH] Fix left over EFI cache mapping problems
Message-ID: <20080214183819.GA19846@elte.hu>
References: <20080214131317.GA27769@basil.nowhere.org> <20080214161218.GA28152@elte.hu> <20080214171603.GC16255@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080214171603.GC16255@one.firstfloor.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <andi@firstfloor.org> wrote:

> > this is indeed a bug (we change the attributes for a larger area 
> > than needed), but your fix is unclean. Find below a cleaner 
> > solution.
> 
> You're still ignoring the other problem of set_memory_uc() not 
> handling fixmap and ioremap correctly. [...]

No, we did not ignore it, and yes, you are wrong.

One thing that you miss is that the 64-bit EFI runtime has to be marked 
uncacheable only if it the EFI image attribute signals an uncacheable 
area:

                if (!(md->attribute & EFI_MEMORY_WB))
                        set_memory_uc(md->virt_addr, md->num_pages);

and Linux EFI does not support device EFI runtimes. So your observation, 
while correct for non-RAM 64-bit EFI images, is theoretical at the 
moment and has no practical relevance.

Of course, as we've stated it numerous times, we want this all fixed up, 
and we _have_ fixed it up already, but we wanted to do it properly. 
Right now we've got the fixes lined up and we are waiting for a test 
report and an Ack from Ying Huang. (he reported that current -git worked 
just fine for him)

Also note that 64-bit EFI runtime support (the ability to execute EFI 
code) is completely new - it got introduced 14 days ago. We only use 
fixmaps on 64-bit EFI.

32-bit EFI is more common (but still not very common, compared to other 
x86 platforms) and that is totally unaffected by secondary aliases. 
(which is a complication of the 64-bit kernel)

Thanks,

	Ingo
