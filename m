Return-Path: <linux-kernel-owner+w=401wt.eu-S1752890AbYGDSnW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752890AbYGDSnW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 14:43:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751164AbYGDSnO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 14:43:14 -0400
Received: from mail164.messagelabs.com ([216.82.253.131]:63646 "EHLO
	mail164.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751107AbYGDSnN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 14:43:13 -0400
X-VirusChecked: Checked
X-Env-Sender: Uwe.Kleine-Koenig@digi.com
X-Msg-Ref: server-7.tower-164.messagelabs.com!1215196991!3165169!1
X-StarScan-Version: 5.5.12.14.2; banners=-,-,-
X-Originating-IP: [66.77.174.13]
Date: Fri, 4 Jul 2008 20:43:07 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <Uwe.Kleine-Koenig@digi.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH v2] handle failure of irqchip->set_type in setup_irq
Message-ID: <20080704184307.GA8076@digi.com>
References: <20080625131101.GA6205@digi.com> <20080704104634.GA31634@digi.com> <20080704101717.28f6a771.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080704101717.28f6a771.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 04 Jul 2008 18:43:08.0575 (UTC) FILETIME=[CD9B02F0:01C8DE05]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Andrew Morton wrote:
> On Fri, 4 Jul 2008 12:46:34 +0200 Uwe Kleine-K__nig <Uwe.Kleine-Koenig@digi.com> wrote:
> 
> > set_type returns an int indicating success or failure, but up to now
> > setup_irq ignores that.
> >
> > In my case this resulted in a machine hang:
> > gpio-keys requested IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING, but
> > arm/ns9xxx can only trigger on one direction so set_type didn't touch
> > the configuration which happens do default to a level sensitiveness and
> > returned -EINVAL.  setup_irq ignored that and unmasked the irq.  This
> > resulted in an endless triggering of the gpio-key interrupt service
> > routine which effectively killed the machine.
> >
> > With this patch applied setup_irq propagates the error to the caller.
> >
> > Note that before in the case
> >
> >       chip && !chip->set_type && !chip->name
> >
> > a NULL pointer was feed to printk.  This is fixed, too.
> >
> 
> hm, OK.  Do I recall there being some urgency to this?
No, I didn't mention this before.  (Fixing NULL-Pointers feed to printk
is a bit of a reflex for me as I used to program for Solaris and if you
feed a NULL-Pointer to printf there your program segfaults.)  I didn't
check that recently, but IIRC it's no problem here.

> 
> > +     if (ret) {
> > +             char buf[100];
> > +
> > +             snprintf(buf, sizeof(buf), KERN_ERR
> > +                             "setting flow type for irq %u failed (%%s)\n",
> > +                             irq);
> > +             print_fn_descriptor_symbol(buf, chip->set_type);
> > +     }
> 
> eww.  We really mucked up that interface. 
That's what I thought, too. ;-)  This was the nicest way I found to
print the whole line in one go.

>                                            I wonder if we can do better.
> Let me think about that.
I was about to suggest something like:

	/* WARNING: this returns a static pointer, so you cannot use the
	 * returned value after another call to creative_function_name
	 */
	char *creative_function_name(void *addr)
	{
		static char buf[SOME_LENGTH];

		... format symbol name into buf ...

		return buf;
	}

Then I could have used

	pr_err("setting flow type for irq %u failed (%s)\n",
			irq, creative_function_name(chip->set_type));

which looks definitely nicer.

Thanks for taking the patch.

Best regards
Uwe

-- 
Uwe Kleine-König, Software Engineer
Digi International GmbH Branch Breisach, Küferstrasse 8, 79206 Breisach, Germany
Tax: 315/5781/0242 / VAT: DE153662976 / Reg. Amtsgericht Dortmund HRB 13962
