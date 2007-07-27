Return-Path: <linux-kernel-owner+w=401wt.eu-S937372AbXG0Urm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937372AbXG0Urm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 16:47:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763544AbXG0Urc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 16:47:32 -0400
Received: from nz-out-0506.google.com ([64.233.162.224]:43979 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763516AbXG0Ur1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 16:47:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ug6JrYtKi9B9PswrhY5zg5I6ONxQ4cIeNYKqkApRoGLlnBVfzR00jFPLh8mIXgQj5VtL15CN5LKyGbQVskBrR/5g8VtZDCcdhpbsE9aawPIBE30q7/HtPabmGYMas0twTrSlnCegKr27fsW8Sv/qW7o9b9j4wYd6wMyTFgKYXhI=
Message-ID: <a781481a0707271347w53dd9755j87e7762cfe953777@mail.gmail.com>
Date: Sat, 28 Jul 2007 02:17:24 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Rodolfo Giometti" <giometti@enneenne.com>
Subject: Re: LinuxPPS & spinlocks
Cc: "Chris Friesen" <cfriesen@nortel.com>,
       "David Woodhouse" <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <20070727194516.GX9840@enneenne.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070717180550.GA24759@enneenne.com>
	 <20070724080013.GA22171@gundam.enneenne.com>
	 <1185284942.14697.319.camel@pmac.infradead.org>
	 <20070724142050.GD4074@enneenne.com>
	 <1185288769.14697.339.camel@pmac.infradead.org>
	 <20070727184418.GV9840@enneenne.com> <46AA42CA.4060004@nortel.com>
	 <20070727192848.GW9840@enneenne.com> <46AA4A1E.8040302@nortel.com>
	 <20070727194516.GX9840@enneenne.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rodolfo,

On 7/28/07, Rodolfo Giometti <giometti@enneenne.com> wrote:
> On Fri, Jul 27, 2007 at 01:40:14PM -0600, Chris Friesen wrote:
> >
> > My point is that the lock should be used to protect specific data. Thus, it
> > would be more correct to say, "spinlock foo is taken because
> > pps_register_source() accesses variable bar".
> >
> > That way, if someone else wants to access "bar", they know that they need
> > to take lock "foo".
>
> Ah, ok! I see. :)

I only glanced through the code, so could be wrong, but I noticed that
the only global / shared data you have in there is a global "pps_source"
array of pps_s structs. That's accessed / modified from the various
syscalls introduced in the API exported to userspace, as well as the
register/unregister/pps_event API exported to in-kernel client subsystems,
yes? So it looks like you need to introduce proper locking for it, simply
type-qualifying it as "volatile" is not enough.

However, I think you've introduced two locks for it. The syscalls (that
run in process context, obviously) seem to use a pps_mutex and
pps_event() seems to be using the pps_lock spinlock (because that
gets executed from interrupt context) -- and from the looks of it, the
register/unregister functions are using /both/ the mutex and spinlock (!)

This isn't quite right, (in fact there's nothing to protect pps_event from
racing against a syscall), so you should use *only* the spinlock for
synchronization -- the spin_lock_irqsave/restore() variants, in fact.

[ Also, have you considered making pps_source a list and not an array?
It'll help you lose a whole lot of MAX_SOURCES, pps_is_allocated, etc
kind of gymnastics in there, and you _can_ return a pointer to the
corresponding pps source struct from the register() function to the in-kernel
users, so that way you get to retain the O(1) access to the corresponding
source when a client calls into pps_event(), similar to how you're using the
array index presently. ]

I also noticed code like (from pps_event):

+	/* Try to grab the lock, if not we prefere loose the event... */
+	if (!spin_trylock(&pps_lock))
+		return;

which looks worrisome and unnecessary. That spinlock looks to be of
fine enough granularity to me, do you think there'd be any contention
on it? I /think/ you can simply make that a spin_lock().

Overall the code looks simple / straightforward enough to me (except for
the parport / uart stuff that I have no clue about), and I'll also read up on
the relevant RFC for this and would hopefully try and give you a more
meaningful review over the weekend.

Thanks,
Satyam
