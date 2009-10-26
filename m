Return-Path: <linux-kernel-owner+w=401wt.eu-S1753078AbZJZPQn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753078AbZJZPQn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 11:16:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752889AbZJZPQn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 11:16:43 -0400
Received: from smtp.nokia.com ([192.100.122.233]:49196 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753002AbZJZPQk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 11:16:40 -0400
Subject: Re: [PATCH v11 4/5] core: Add kernel message dumper to call on
	oopses and panics
From: "Shargorodsky Atal (EXT-Teleca/Helsinki)" 
	<ext-atal.shargorodsky@nokia.com>
To: ext Simon Kagstrom <simon.kagstrom@netinsight.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Artem Bityutskiy <dedekind1@gmail.com>,
       linux-mtd <linux-mtd@lists.infradead.org>,
       David Woodhouse <dwmw2@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Koskinen Aaro (Nokia-D/Helsinki)" <aaro.koskinen@nokia.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <20091026125316.0283e322@marrow.netinsight.se>
References: <20091015093133.GF10546@elte.hu>
	 <20091015161052.0752208e@marrow.netinsight.se>
	 <20091015154640.GA11408@elte.hu>
	 <20091016094601.4e2c2d3e@marrow.netinsight.se>
	 <20091016080935.GA3895@elte.hu>	<1255681467.32489.360.camel@localhost>
	 <20091016112556.6902b2dc@marrow.netinsight.se>
	 <20091016101045.GA3263@elte.hu>
	 <20091016140918.3981cfa2@marrow.netinsight.se>
	 <1255952922.32489.505.camel@localhost>	<20091019125017.GA9030@elte.hu>
	 <alpine.LFD.2.00.0910220832580.9771@eeepc.linux-foundation.org>
	 <20091022082500.602f9a7d@marrow.netinsight.se>
	 <1256313202.5824.60.camel@atal-desktop>
	 <20091026084158.0644ea85@marrow.netinsight.se>
	 <1256553393.5822.24.camel@atal-desktop>
	 <20091026125316.0283e322@marrow.netinsight.se>
Content-Type: text/plain
Date: Mon, 26 Oct 2009 17:13:27 +0200
Message-Id: <1256570007.5822.58.camel@atal-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 26 Oct 2009 15:15:06.0626 (UTC) FILETIME=[19A6FE20:01CA564F]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-10-26 at 12:53 +0100, ext Simon Kagstrom wrote:
> On Mon, 26 Oct 2009 12:36:33 +0200
> "Shargorodsky Atal (EXT-Teleca/Helsinki)" <ext-atal.shargorodsky@nokia.com> wrote:
> 
> > > > I can think of a couple of way to figure it out in the module
> > > > itself, but I could not think of any clean way to do it.
> > > 
> > > This is correct, and the mtdoops driver has some provisions to handle
> > > this. First, there is a parameter to the module to specify whether
> > > oopses should be dumped at all - I added this for the particular case
> > > that someone has panic_on_oops set.
> > 
> > It takes care of most of the situations, but panic_on_oops
> > can be changed any time, even after the module is loaded.
> 
> Yes, but this parameter is settable at runtime as well by writing
> to /sys/module/mtdoops/parameters/dump_oops.
> 
> > > Second, it does not dump oopses directly anyway, but puts it in a work
> > > queue. That way, if panic_on_oops is set, it will store the panic but
> > > the oops (called from the workqueue) will not get written anyway.
> > > 
> > 
> > AFAIK, mtdoops does not put oopses in a work queue. And if by any chance
> > it does, then I think it's wrong and might lead to missed oopses, as
> > the oops might be because of the work queues themselves, or it might
> > look to the kernel like some non-fatal fault, but actually it's a
> > sign of a much more catastrophic failure - IOMMU device garbaging
> > memory, for instance.
> 
> I was referring to my patches to it, sorry. It's in the patch "[PATCH v7 5/5]:
> mtdoops: refactor as a kmsg_dumper" (as well as the parameter to dump
> oopses at all).
> 
> There are other situations which will make dumping problematic as well,
> e.g., crashes in the mtd code, so there are certainly some cases which
> will be difficult to catch. But in the panic_on_oops case or
> oops-in-interrupt, the oops won't be missed and won't be outputted
> twice for mtdoops.
> 
> 
> Anyway, I understand your problem and agree that it would be good to
> fix. Moving up crash_kexec() and the notifiers will at least fix your
> second issue. For the double-output-of-oopses, I don't see a good way
> to fix it unless relying on the module to correct it like above.
> 

How about adding KMSG_DUMP_LAST_OOPS_BEFORE_PANIC or something to the
kmsg_dump_reason enum, and making the kmsg_dump look like
kmsg_dump(panic_on_oops ? KMSG_DUMP_LAST_OOPS_BEFORE_PANIC : KMSG_DUMP_OOPS);
in oops_exit. Then let the dumpers decide what they want to do about it.
Just a thought.

And since you have no objections about moving notifiers up, it looks
like the second issue will be resolved, I believe Artem
will take care of it. :)

Thanks a lot,
Atal.

> // Simon

