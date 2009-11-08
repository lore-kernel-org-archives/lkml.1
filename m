Return-Path: <linux-kernel-owner+w=401wt.eu-S1755268AbZKHUjO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755268AbZKHUjO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 15:39:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755120AbZKHUjN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 15:39:13 -0500
Received: from casper.infradead.org ([85.118.1.10]:56000 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755087AbZKHUjM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 15:39:12 -0500
Date: Sun, 8 Nov 2009 12:40:35 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Corrado Zoccolo <czoccolo@gmail.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       lenb@kernel.org, mingo@elte.hu, yanmin_zhang@linux.intel.com,
       jens.axboe@oracle.com, Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Subject: Re: [PATCH v2] cpuidle: Fix the menu governor to boost IO
 performance
Message-ID: <20091108124035.23d53197@infradead.org>
In-Reply-To: <4e5e476b0911040139h1f471627la4262a5fa66abab0@mail.gmail.com>
References: <20090915054259.5282e5ba@infradead.org>
	<4e5e476b0911040139h1f471627la4262a5fa66abab0@mail.gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Nov 2009 10:39:13 +0100
Corrado Zoccolo <czoccolo@gmail.com> wrote:

> Hi Arjan,
> On Tue, Sep 15, 2009 at 4:42 AM, Arjan van de Ven
> <arjan@infradead.org> wrote:
> > From: Arjan van de Ven <arjan@linux.intel.com>
> > Subject: cpuidle: Fix the menu governor to boost IO performance
> >
> > Fix the menu idle governor which balances power savings, energy
> > efficiency and performance impact.
> 
> I've tested this patch on an Atom based netbook with SSD, and I see
> 10% improvement in latencies for reading a single 4k block from disk.

great!

> 
> During this test, while looking at powertop, I found that my CPU was
> sitting in polling mode for milliseconds (percentage was however
> negligible).
> I never recalled seeing a non-zero time spent polling, so I looked at
> the patch and found:
> > +       /*
> > +        * We want to default to C1 (hlt), not to busy polling
> > +        * unless the timer is happening really really soon.
> > +        */
> > +       if (data->expected_us > 5)
> > +               data->last_state_idx = CPUIDLE_DRIVER_STATE_START;
> Commenting the if, (the previous behaviour), I no longer see the
> polling, while I still get the performance improvement.
> 
> I wonder if that '5' is a bit too much. According to my BIOS ACPI
> table, the Atom latency for C1 is ~ 1us, so there is very little
> payback in polling on such processors. Should the check use the ACPI
> declared C1 latency to decide whether we should poll or go to C1?

the exit latency is +/- 1 us, the entry latency is similar, and then
you're pretty close to 5 already (esp if you keep in mind that to break
even on energy you also need to be in the C state for a little bit)...

> 
> An other consideration is that sometimes, even if we expect to idle
> for a short time, we end up idling for more (otherwise I would never
> have seen ms polling, when expecting at most 5us). Should we set up a
> timer, that would fire when switching to an higher C state would
> conserve more energy?

this check is supposed to catch the known timer cases; those
are rather accurate in prediction


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
