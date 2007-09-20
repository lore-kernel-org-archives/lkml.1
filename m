Return-Path: <linux-kernel-owner+w=401wt.eu-S1752189AbXITVC1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752189AbXITVC1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 17:02:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750907AbXITVCT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 17:02:19 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:50478
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750797AbXITVCS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 17:02:18 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [Announce] Linux-tiny project revival
Date: Thu, 20 Sep 2007 17:02:07 -0500
User-Agent: KMail/1.9.6
Cc: linux-tiny@selenic.com, Tim Bird <tim.bird@am.sony.com>,
       linux kernel <linux-kernel@vger.kernel.org>,
       CE Linux Developers List <celinux-dev@tree.celinuxforum.org>,
       Michael Opdenacker <michael@free-electrons.com>
References: <46F1645D.9050406@am.sony.com> <200709201538.43093.rob@landley.net> <20070920195844.GA1805@martell.zuzino.mipt.ru>
In-Reply-To: <20070920195844.GA1805@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709201702.08126.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 20 September 2007 2:58:44 pm Alexey Dobriyan wrote:
> On Thu, Sep 20, 2007 at 03:38:42PM -0500, Rob Landley wrote:
> > I've been playing with an idea for a while to improve the printk()
> > situation, but it's a more intrusive change than I've had time to bang
> > on.
> >
> > Right now, the first argument to printk() is a loglevel, but it's handled
> > via string concatenation.  I'd like to change that to be an integer, and
> > make it an actual comma-separated first argument.  (Mandatory, not
> > optional.)
> >
> > So instead of:
> >   printk(KERN_NOTICE "Fruit=%d\n", banana);
> > It would now be:
> >   printk(KERN_NOTICE, "Fruit=%d\n", banana);
> >
> > Change the header from:
> >   #define KERN_NOTICE "<5>"
> > to:
> >   #define KERN_NOTICE 5
> >
> > Then you can change the printk guts to do something vaguely like
> > (untested): #define printk(arg1, arg2, ...) actual_printk("<" #arg1 ">"
> > arg2, __VA_ARGS__)
> >
> > And so far no behavior has changed.  But now the _fun_ part is, you can
> > add a config symbol for "what is the minimum loglevel I care about?"
>
> Given that
> a) there're plenty of printks without any KERN_* bloat,

> b) there're printks that SHOULD NOT have KERN_* bloat,

So define a level 0 that doesn't prepend any level to the string, and have the 
macro filter that out at the same default level it counts as now.  
(KERN_INFO, I think?)  The tests are all on contants which should resolve at 
compile time and the dead code eliminator should zap it, even if the macro 
gets more complicated it shouldn't result in a bigger binary.

> c) debugging-by-printk method is widely used and this will force
>    additional typing, head-scratching  and swear words

Because we never change kernel internal APIs.  Oh yeah.  Never happens.

> d) time wasted on pointless discussions whether some particular
>    printk ALERT or CRIT

Let me get this straight: you're objecting to actually making the printk 
levels useful enough that developers start to care what they're set to, 
because then they might be motivated to want some of them changed?

Make it useful, people might care, thus they might talk about it...

Sorry, I'm still missing the downside here.

> e) flag day for printk,

That's the main reason I haven't played with it so far, although it would be 
easy to define a new symbol (dprintk or some such, although I note several 
drivers are already using that) and transition gradually.

> I think that this idea is not worth it.

*Shrug*.

My problem is that switching off printk is the single biggest bloat cutter in 
the kernel, yet it makes the resulting system very hard to support.  It 
combines a big upside with a big downside, and I'd like something in between.

> > #define printk(level, str, ...) \
> >   do { \
> >     if (level < CONFIG_PRINTK_DOICARE) \
> >       actual_printk("<" #level ">" str, __VA_ARGS__); \
> >   } while(0);
> >
> > Opinions?
>
> Ick.
>
> 	Alexey "ignore_loglevel" Dobriyan

But ignore_loglevel doesn't decrease the size of the _binary_.  That's what 
we're talking about here with the -tiny tree.  Embedded developers want to 
squeeze more code onto smaller flash/rom chips.  Setting ignore_loglevel does 
prevent these messages from ever being emitted, but they're still in the 
kernel image as dead weight.  It saves noise but doesn't save _space_.

I'm proposing allowing an ignore_loglevel to remove the unused messages at 
compile time so they don't take up space.  Doing that requires the levels to 
be integers so they can be compared with < or >, and the remaining changes 
follow logically.  (To me, anyway...)

Rob
-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
