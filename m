Return-Path: <linux-kernel-owner+w=401wt.eu-S1758651AbZBXQN4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758651AbZBXQN4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 11:13:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757582AbZBXQNk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 11:13:40 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:45122 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757548AbZBXQNj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 11:13:39 -0500
Date: Tue, 24 Feb 2009 17:13:29 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <andi@firstfloor.org>
Cc: Salman Qazi <sqazi@google.com>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Performance regression in write() syscall
Message-ID: <20090224161329.GA26299@elte.hu>
References: <20090224020304.GA4496@google.com> <20090224100913.GU26292@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090224100913.GU26292@one.firstfloor.org>
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


* Andi Kleen <andi@firstfloor.org> wrote:

> On Mon, Feb 23, 2009 at 06:03:04PM -0800, Salman Qazi wrote:

> > -	return __copy_user_nocache(dst, src, size, 1);
> > +	if (likely(size >= PAGE_SIZE))
> > +		return __copy_user_nocache(dst, src, size, 1);
> > +	else
> > +		return __copy_from_user(dst, src, size);
> 
> I think you disabled it completely, the kernel never really 
> does any copies larger than page size because all its internal 
> objects are page sized only.

No, look again, it's not disabled completely - the check now 
basically special-cases 4K writes _only_, and makes them 
non-temporal. That still covers the big/midsize file case.

And that kind of 4K limit makes a lot of sense. A small file 
write will unlikely to have a perfect 4K sized copy. Big file 
writes (and raw/direct IO related copies, etc.) will be chunked 
down to 4K sized units.

	Ingo
