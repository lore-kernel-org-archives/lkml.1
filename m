Return-Path: <linux-kernel-owner+w=401wt.eu-S1754312AbYIWIeR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754312AbYIWIeR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 04:34:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752425AbYIWIeG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 04:34:06 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:49945 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752070AbYIWIeF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 04:34:05 -0400
Date: Tue, 23 Sep 2008 10:33:45 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: x86: fix macro with bad_bios_dmi_table
Message-ID: <20080923083345.GE23031@elte.hu>
References: <1222155333-18247-1-git-send-email-yhlu.kernel@gmail.com> <20080923081650.GA19003@elte.hu> <86802c440809230130n44ce9dechbe6b10ffe4685ee5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440809230130n44ce9dechbe6b10ffe4685ee5@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Yinghai Lu <yinghai@kernel.org> wrote:

> On Tue, Sep 23, 2008 at 1:16 AM, Ingo Molnar <mingo@elte.hu> wrote:
> >
> > * Yinghai Lu <yhlu.kernel@gmail.com> wrote:
> >
> >> need one blank tail.
> >>
> >> fix the crash on ingo's test box.
> >
> > applied to tip/x86/memory-corruption-check, thanks Yinghai!
> >
> >> --- a/arch/x86/kernel/setup.c
> >> +++ b/arch/x86/kernel/setup.c
> >> @@ -760,8 +760,8 @@ static struct dmi_system_id __initdata bad_bios_dmi_table[] = {
> >>                       DMI_MATCH(DMI_BIOS_VENDOR, "Phoenix Technologies, LTD"),
> >>               },
> >>       },
> >> -     {}
> >>  #endif
> >> +     {}
> >>  };
> >
> > i've seen such DMI crashes numerous times, caused by a missing NULL at
> > the end of the table. Is there no sane way to detect or robustly avoid
> > such run-off-the-end bugs?
> >
> > how about changing dmi_check_system(table) to a macro, which does
> > something like:
> >
> >   __dmi_check_system(&(table), sizeof(table))
> 
> ARRAY_SIZE()

yes.

> > and rename dmi_check_system() in drivers/firmware/dmi_scan.c to
> > __dmi_check_system() and add the size parameter? That way we could
> > remove the need for NULL termination and it's even a size optimization:
> > it shrinks those tables a tiny bit.
> 
> # git grep dmi_system_id | grep "\[" | wc -l
> 62

what's the problem? I think in most cases dmi_check_system() is called 
with an actual static table so most of the dmi_check_system() callsites 
should work just fine and need not to be touched. (as we still keep the 
same API - we just redirect it to __dmi_check_system())

	Ingo
