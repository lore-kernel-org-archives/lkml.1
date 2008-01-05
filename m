Return-Path: <linux-kernel-owner+w=401wt.eu-S1757234AbYAEUIX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757234AbYAEUIX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2008 15:08:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756189AbYAEUIP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jan 2008 15:08:15 -0500
Received: from smtp-out.google.com ([216.239.33.17]:1778 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756180AbYAEUIO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2008 15:08:14 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=o44fcM7PE1vqcHwzW0ldO2RzkjotoV7m7vy+I0k9/Uhm2IT6leCvxznTl6nKIk1rg
	PTN18gTgxtSilraYLkhLA==
Message-ID: <3f1a065b0801051208y7e832e8ctda61f28e6328dec3@mail.gmail.com>
Date: Sat, 5 Jan 2008 12:08:07 -0800
From: "Russell Leidich" <rml@google.com>
To: "Andi Kleen" <andi@firstfloor.org>
Subject: Re: [PATCH] AMD Thermal Interrupt Support
Cc: "Torsten Kaiser" <just.for.lkml@googlemail.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, "Thomas Gleixner" <tglx@linutronix.de>,
       "Ingo Molnar" <mingo@elte.hu>, valdis.kletnieks@vt.edu,
       thockin@google.com
In-Reply-To: <20080105132402.GA705@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <p731w9410yc.fsf@bingen.suse.de>
	 <20080102200039.GA13784@one.firstfloor.org>
	 <3f1a065b0801021312w6f823cbeh9ea6b73d2b0c46c8@mail.gmail.com>
	 <64bb37e0801021333g3cccff81k68df75463e4a21d0@mail.gmail.com>
	 <3f1a065b0801021350x7fd065fbj9680ce1a4f3c6538@mail.gmail.com>
	 <20080102215433.GB13784@one.firstfloor.org>
	 <3f1a065b0801041333x579d0a8fs9c5535f95dd56015@mail.gmail.com>
	 <20080104222637.GA19248@one.firstfloor.org>
	 <3f1a065b0801041653y77c27a8cvce703cb7d13e10a0@mail.gmail.com>
	 <20080105132402.GA705@one.firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 5, 2008 5:24 AM, Andi Kleen <andi@firstfloor.org> wrote:
> >
> > But if PCI locks are spinlocks, then how can one access config space
> > in an interrupt handler, as it might be locked by the foreground?  (No
>
> They disable interrupts

Got it.

>
> > locks would be required at all, if everyone just saved 0xCF8 and
> > 0xCFC, but I digress.)
>
> Not sure what you mean? Since it is two non atomic accesses even
> saving restoring the registers would not make the accesses safe for lockless.
> If someone changes 0xcf8 before you can access 0xcfc you always have
> a problem.

No, it would be safe, because the interrupting process doesn't
actually need to save 0xCFC (since it's a function of 0xCF8).  SMI
handlers use this technique to ensure they don't destroy OS config
space accesses.  Anyway, it doesn't matter.  As long as everyone CLIs
across the whole business, there is no possibility of races.

>
> In fact we had (or still have) races with some older user land accessing these
> ports directly.

Yuck.  I'm going to assume that I can ignore this fact, as they're
already broken with respect to lots of other kernel code.

>
> The only access method that is lockless is mmconfig, which will work
> on most (but not all) Fam10h systems.
>
> > And it's one thing to be "likely" already in a
> > thread, and another to be sure.  If you can address these issues, I'll
> > change or remove the comment.  I just want to prevent a
> > reasonable-looking but bad coding change from happening in the future.
>
> Well at least as written the comment is not quite correct.

OK, I buy that now.  I'll fix the comment and resend.

> >
> >
> > Agreed.  I had it at the top of the function, but now I've worked it
> > into both places.
> >
> > >
> > > Anyways I'm unsure about the blacklist here -- white list would
> > > probably have been better. k8_northbridges[] will certainly include
> > > Griffin northtbridges and who knows if TT will work there or not.
> > > [sorry for mentioning that not earlier]
> >
> > Ideally, every ID in the k8_northbridges[] whitelist would have
>
> k8_northbridges[] is used by various subsystems, most of them
> do not care at all about thermal throttling.
>
> > functional thermal throttling.  If more IDs than 0x1103 turn out to
> > have this feature broken, then we may need to add a blacklist as well.
>
> ? you already got a blacklist ?

Yes, technically.  It's a single "if" statement which tests for 0x1103
:).  What I was saying was that if lots more thermally-broken CPUs
show up in the wild, then we can expand this into a blacklist array.

>
> >  But I expect that most future IDs will function correctly, hence my
> > reliance on the whitelist.
>
> ? but you don't have a whitelist, you have a black list.

I'm using k8_northbridges[] as my de-facto whitelist, because I
believe that future CPUs will probably function properly.  (It's hard
to imagine AMD removing or breaking a perfectly functional system,
apart from maybe adding new features.  Worst case, as I said, we  can
create a blacklist.  But right now, that's unnecessary.)

Any other concerns?

-- 
Russell Leidich
