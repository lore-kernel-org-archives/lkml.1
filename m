Return-Path: <linux-kernel-owner+w=401wt.eu-S1756548AbZCCRj5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756548AbZCCRj5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 12:39:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752995AbZCCRjs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 12:39:48 -0500
Received: from relay1.sgi.com ([192.48.179.29]:48133 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752404AbZCCRjr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 12:39:47 -0500
Date: Tue, 3 Mar 2009 11:39:43 -0600
From: Dimitri Sivanich <sivanich@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       john stultz <johnstul@us.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6 v6] SGI RTC: add generic system interrupt
Message-ID: <20090303173943.GA30012@sgi.com>
References: <20090303151044.GA20016@sgi.com> <20090303151357.GA20120@sgi.com> <20090303153433.GA29454@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090303153433.GA29454@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 03, 2009 at 04:34:33PM +0100, Ingo Molnar wrote:
> 
> * Dimitri Sivanich <sivanich@sgi.com> wrote:
> 
> > This patch allocates a system interrupt vector for various 
> > platform specific uses.
> 
> this is really ugly.
> 
> Also, why are all these symbols exported? There's no need to 
> build the UV RTC driver as a module. It's either built-in or not 
> built-in - it's small enough.

OK.

> 
> this stuff:
> 
> > +/* Function pointer for generic interrupt vector handling */
> > +static void (*generic_interrupt_extension)(void);
> > +static char generic_show_string[28];
> > +static char generic_show_prefix[6];
> > +
> > +int is_generic_interrupt_registered()
> > +{
> > +	if (generic_interrupt_extension)
> > +		return 1;
> > +	else
> > +		return 0;
> > +}
> > +
> > +char *generic_interrupt_string(void)
> > +{
> > +	return generic_show_string;
> > +}
> > +
> > +char *generic_interrupt_prefix(void)
> > +{
> > +	return generic_show_prefix;
> > +}
> 
> is SMP unsafe, etc. etc. - not something we should ever call 
> from a module. We just shouldnt do it in this form. What 
> necessiates it?

I wanted a way to show specific strings when displaying irq statistics.  We could show these in a more generic way I suppose.

Any given platform should just be changing these once, hence the lack of need for locking.

> 
> All we need is:
> 
> > +	/* generic IPI for platform specific use */
> > +	alloc_intr_gate(GENERIC_INTERRUPT_VECTOR, generic_interrupt);
> 
> plus one trivial callback function - and then the UV platform 
> uses it for its own purpose. It's not like two platforms will be 
> running at once so there's no locking needed, etc.

Right.  But still register the callback function as I have it now?

> 
> > +#ifdef CONFIG_X86_64
> > +extern void generic_interrupt(void);
> > +#endif
> 
> in any case please make it symmetric across 32-bit and 64-bit - 
> even though UV is 64-bit only.

OK.

> 
> 	Ingo
