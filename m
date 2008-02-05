Return-Path: <linux-kernel-owner+w=401wt.eu-S1754693AbYBEHF7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754693AbYBEHF7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 02:05:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752955AbYBEHFu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 02:05:50 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:38659 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752925AbYBEHFt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 02:05:49 -0500
Date: Tue, 5 Feb 2008 08:05:35 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Subject: Re: issue with patch "x86: no CPA on iounmap"
Message-ID: <20080205070535.GA10695@elte.hu>
References: <20080205011357.GA14712@linux-os.sc.intel.com> <47A7EA88.3020404@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47A7EA88.3020404@linux.intel.com>
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


* Arjan van de Ven <arjan@linux.intel.com> wrote:

> Siddha, Suresh B wrote:
>> This is wrt to x86 git commit f56d005d30342a45d8af2b75ecccc82200f09600
>> 	"x86: no CPA on iounmap"
>>
>> This can use performance issue. When a GART driver unmaps a RAM page,
>
> thinking about this some more...
>
> afaik the gart driver doesn't use ioremap....
>
> (and it does caching control explicitly, and sets its pages back to 
> cached)

there are many GART drivers, and the method used depends on the GART 
driver. The following GART drivers still use ioremap in one way or 
another:

 drivers/char/agp/amd-k7-agp.c
 drivers/char/agp/ati-agp.c
 drivers/char/agp/generic.c
 drivers/char/agp/sworks-agp.c
 drivers/char/drm/radeon_cp.c

the method use is in all cases the same: they use __get_free_page() to 
pick up a general RAM page, they do SetPageReserved() and then they use 
ioremap_nocache() to map it non-cached, and then they also program the 
GART to access those pages.

when the GART code deinits, it does an iounmap() on those pages, unmaps 
it from the GART hardware itself, does a ClearPageReserved() and does 
__free_page() to put the page into the general page pool again. So 
Suresh is right: these pages are currently marked UC at this point and 
we need to mark them cacheable.

we could do this automatically in iounmap() upon seeing a page_is_ram() 
that has PageReserved set. Or we could stick in a set_memory_wb() into 
the deinit [and ioremap_nocache()-failure] sequence.

Since we treat PageReserved pages specially in ioremap() already [we 
allow them, despite them being listed in the e820 map], i think the more 
robust solution is to recognize them in iounmap() as well - this way it 
cannot be forgotten accidentally. (and UC pages in the buddy are _hard_ 
to notice after the fact) There is no aliasing danger i believe: IO bars 
should never be marked as general RAM in the e820.

	Ingo
