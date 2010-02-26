Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965795Ab0BZTJM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 14:09:12 -0500
Received: from filtteri1.pp.htv.fi ([213.243.153.184]:45150 "EHLO
	filtteri1.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965726Ab0BZTJK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 14:09:10 -0500
X-Greylist: delayed 483 seconds by postgrey-1.27 at vger.kernel.org; Fri, 26 Feb 2010 14:09:10 EST
Date: Fri, 26 Feb 2010 21:01:00 +0200
From: Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <syrjala@sci.fi>
To: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       DRI <dri-devel@lists.sourceforge.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][RFC] time: add wait_interruptible_timeout macro to
 sleep (w. timeout) until wake_up
Message-ID: <20100226190100.GQ10145@sci.fi>
Mail-Followup-To: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	DRI <dri-devel@lists.sourceforge.net>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Ingo Molnar <mingo@elte.hu>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <1266761422-2921-1-git-send-email-zajec5@gmail.com>
 <b170af451002260238p29c7db97nd50154bf7288ef42@mail.gmail.com>
 <20100226081418.5902446f.akpm@linux-foundation.org>
 <b170af451002260933i6a7a5e1el619f8e71c3ae0bc8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b170af451002260933i6a7a5e1el619f8e71c3ae0bc8@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 26, 2010 at 06:33:57PM +0100, Rafał Miłecki wrote:
> W dniu 26 lutego 2010 17:14 użytkownik Andrew Morton
> <akpm@linux-foundation.org> napisał:
> > On Fri, 26 Feb 2010 11:38:59 +0100 Rafa Miecki <zajec5@gmail.com> wrote:
> >
> >> +#define wait_interruptible_timeout(wq, timeout)
> >>     \
> >> +({                                   \
> >> +    long ret = timeout;                      \
> >> +                                    \
> >> +    DEFINE_WAIT(wait);                      \
> >> +    prepare_to_wait(&wq, &wait, TASK_INTERRUPTIBLE);       \
> >> +    if (!signal_pending(current))                  \
> >> +        ret = schedule_timeout(ret);            \
> >> +    finish_wait(&wq, &wait);                   \
> >> +                                    \
> >> +    ret;                             \
> >> +})
> >
> > It's often a mistake to use signals in-kernel.  Signals are more a
> > userspace thing and it's better to use the lower-level kernel-specific
> > messaging tools in-kernel.  Bear in mind that userspace can
> > independently and asynchronously send, accept and block signals.
> 
> Can you point me to something kernel-level please?
> 
> 
> > Can KMS use wait_event_interruptible_timeout()?
> 
> No. Please check definition of this:
> 
> #define wait_event_interruptible_timeout(wq, condition, timeout)	\
> ({									\
> 	long __ret = timeout;						\
> 	if (!(condition))						\
> 		__wait_event_interruptible_timeout(wq, condition, __ret); \
> 	__ret;								\
> })
> 
> It uses condition there, but that's not a big issue. We just need to
> pass 0 (false) there and it will work so far.

Disabling the condition check doesn't make sense.

You could use a completion.

init_completion(vbl_irq);
enable_vbl_irq();
wait_for_completion(vbl_irq);
disable_vbl_irq();
and call complete(vbl_irq) in the interrupt handler.

The same would of course work with just some flag or counter
and a wait queue. Isn't there already a vbl counter that you could
compare in the condition?

-- 
Ville Syrjälä
syrjala@sci.fi
http://www.sci.fi/~syrjala/
