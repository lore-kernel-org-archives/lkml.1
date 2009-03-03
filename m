Return-Path: <linux-kernel-owner+w=401wt.eu-S1755438AbZCCSwu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755438AbZCCSwu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 13:52:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753367AbZCCSwm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 13:52:42 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:58495 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753341AbZCCSwl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 13:52:41 -0500
Date: Tue, 3 Mar 2009 19:52:25 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Dimitri Sivanich <sivanich@sgi.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       john stultz <johnstul@us.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6 v6] SGI RTC: add generic system interrupt
Message-ID: <20090303185225.GA5057@elte.hu>
References: <20090303151044.GA20016@sgi.com> <20090303151357.GA20120@sgi.com> <20090303153433.GA29454@elte.hu> <20090303173943.GA30012@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090303173943.GA30012@sgi.com>
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


* Dimitri Sivanich <sivanich@sgi.com> wrote:

> On Tue, Mar 03, 2009 at 04:34:33PM +0100, Ingo Molnar wrote:
> > 
> > * Dimitri Sivanich <sivanich@sgi.com> wrote:
> > 
> > > This patch allocates a system interrupt vector for various 
> > > platform specific uses.
> > 
> > this is really ugly.
> > 
> > Also, why are all these symbols exported? There's no need to 
> > build the UV RTC driver as a module. It's either built-in or not 
> > built-in - it's small enough.
> 
> OK.
> 
> > 
> > this stuff:
> > 
> > > +/* Function pointer for generic interrupt vector handling */
> > > +static void (*generic_interrupt_extension)(void);
> > > +static char generic_show_string[28];
> > > +static char generic_show_prefix[6];
> > > +
> > > +int is_generic_interrupt_registered()
> > > +{
> > > +	if (generic_interrupt_extension)
> > > +		return 1;
> > > +	else
> > > +		return 0;
> > > +}
> > > +
> > > +char *generic_interrupt_string(void)
> > > +{
> > > +	return generic_show_string;
> > > +}
> > > +
> > > +char *generic_interrupt_prefix(void)
> > > +{
> > > +	return generic_show_prefix;
> > > +}
> > 
> > is SMP unsafe, etc. etc. - not something we should ever call 
> > from a module. We just shouldnt do it in this form. What 
> > necessiates it?
> 
> I wanted a way to show specific strings when displaying irq statistics.  We could show these in a more generic way I suppose.
> 
> Any given platform should just be changing these once, hence the lack of need for locking.
> 
> > 
> > All we need is:
> > 
> > > +	/* generic IPI for platform specific use */
> > > +	alloc_intr_gate(GENERIC_INTERRUPT_VECTOR, generic_interrupt);
> > 
> > plus one trivial callback function - and then the UV platform 
> > uses it for its own purpose. It's not like two platforms will be 
> > running at once so there's no locking needed, etc.
> 
> Right.  But still register the callback function as I have it 
> now?

i'd suggest to just override that global function pointer from 
the UV detection routines.

this way we have it in a minimalistically generic fashion, but 
with a minimum amount of fuss around it.

	Ingo
