Return-Path: <linux-kernel-owner+w=401wt.eu-S1759578AbZCCAdW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759578AbZCCAdW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 19:33:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753425AbZCCAdN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 19:33:13 -0500
Received: from smtp120.sbc.mail.sp1.yahoo.com ([69.147.64.93]:32616 "HELO
	smtp120.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751374AbZCCAdM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 19:33:12 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=pBD9gB8LrPlix2NTj3AObFR02P6Gk6BlY8dqJEZ6KI/Yba3Jifv/swwSF/JXd30nDGzsnz2g5r2d1buPz4D7ssSb7bQR/QTaeKWA0RMpC+62i4BkyIfSSrVKOyShoSZKWTV29uxKJlqeOP0vO8VTiL5zo93Uoo3rZAjPKKX7E9Y=  ;
X-YMail-OSG: j9xeuF4VM1mg.JR0c2I2Hw_gouOVA3mx0F2B3IeuXH8gA4vPg3.WLEfIKQD6v_OkjAwfvGIGgCGD.uHwkAoW.p_WbFptvAiEdx1ZociG5O79.5PBDdIGNZ0qgz27kbaEw3Za2Q6sX7WzxpUYk_gg2f5pe6yK5eLYMQ99pJ7ZhzSVCFq4PrYkm7j2zBes
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: lockdep and threaded IRQs (was: ...)
Date: Mon, 2 Mar 2009 16:33:08 -0800
User-Agent: KMail/1.9.10
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>, me@felipebalbi.com,
       linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
       felipe.balbi@nokia.com, dmitry.torokhov@gmail.com, sameo@openedhand.com,
       tglx@linutronix.de
References: <1235762883-20870-1-git-send-email-me@felipebalbi.com> <200903021542.25153.david-b@pacbell.net> <20090302235327.GB19084@elte.hu>
In-Reply-To: <20090302235327.GB19084@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200903021633.08736.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 02 March 2009, Ingo Molnar wrote:
> > 
> > The significant omission is lack of support for chaining
> > such threads.  Example, an I2C device that exposes
> > several dozen IRQs with mask/ack/... operations that
> > require I2C access.
> 
> Well, those are rarely used, embedded-only constructs - the main 
> focus of IRQ threading patches are the more common patterns.

Yes, mostly for embedded, where "system bus" more likely
means I2C than PCI.


> Since you care about them - could you please send patches on top 
> of the IRQ threading patches to add support for them?

I'll look at that, and try to prepare something on top
of the version of the threading patches that gets into
the -next tree.  I got the impression there was going
to be a v3 of those patches soonish...

I expect there will be two basic parts of that work:

 - One to cope with the upcoming change to handle_irq(),
   insisting that it live in hardirq context instead of
   just an irqs-off context (and thereby preventing use
   of standard chaining calls in irq threads, sigh).

 - Another to set up a chaining thread, since chain
   setup bypasses setup_irq() and friends.

That latter might touch what the v2 patches added,
since I'd want it to share code.

- Dave

p.s. Note that those changes would still leave the
     lockdep bug around ... it will still be breaking
     various drivers that use normal IRQs, by forcibly
     enabling IRQF_DISABLED.

