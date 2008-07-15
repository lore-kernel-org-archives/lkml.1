Return-Path: <linux-kernel-owner+w=401wt.eu-S1761877AbYGODGz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761877AbYGODGz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 23:06:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754098AbYGODGq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 23:06:46 -0400
Received: from rv-out-0506.google.com ([209.85.198.227]:43922 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753995AbYGODGp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 23:06:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=YAKhig1tRzI5ypUCfRGsMcgok+di27OSUvKZ8fQ8Owo2gjiGfUUfz/1DBYUwql1kuh
         46NbeF2ylJgPrDHQIniope3DNT1nACzauFCUqeM4LSI+HfQnea5Bf0PoZi4tvj5b96us
         TIWKBons9q82FZzQSWAyHyI0Cg3hkLq/ef50Y=
Date: Tue, 15 Jul 2008 12:06:39 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "Michael H. Warfield" <mhw@wittsend.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] ip2: avoid add_timer() with pending timer
Message-ID: <20080715030639.GA3123@localhost.localdomain>
References: <20080714024955.GB30952@sssvn.sssvn> <20080714100402.b72e2b1e.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080714100402.b72e2b1e.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 14, 2008 at 10:04:02AM -0700, Andrew Morton wrote:
> On Mon, 14 Jul 2008 11:49:55 +0900 Akinobu Mita <akinobu.mita@gmail.com> wrote:
> 
> > @@ -746,10 +742,8 @@ ip2_loadmain(int *iop, int *irqp)
> >  			}
> >  			if ( ip2config.irq[i] == CIR_POLL ) {
> >  retry:
> > -				if (!TimerOn) {
> > -					PollTimer.expires = POLL_TIMEOUT;
> > -					add_timer ( &PollTimer );
> > -					TimerOn = 1;
> > +				if (!timer_pending(&PollTimer)) {
> > +					mod_timer(&PollTimer, POLL_TIMEOUT);
> >  					printk( KERN_INFO "IP2: polling\n");
> 
> This change to ip2_loadmain() might be racy if it actually did
> anything.  But afaict timer_pending() can never be true here (we're
> only called from module_init()) so it can and should be removed.

Yes, ip2_loadmain() is only called from module_init(). But this add_timer()
is in the loop for each device. So it may be called more than once.

And yes, I can remove timer_pending() here because I switched to use
mod_timer() instead of add_timer(). But this PollTimer works as periodic
timer and it's global timer. So it will not cause a problem.

