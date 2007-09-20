Return-Path: <linux-kernel-owner+w=401wt.eu-S1755098AbXITWP7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755098AbXITWP7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 18:15:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752316AbXITWPv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 18:15:51 -0400
Received: from mga02.intel.com ([134.134.136.20]:35033 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750987AbXITWPv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 18:15:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.20,280,1186383600"; 
   d="scan'208";a="299662912"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [Celinux-dev] Re: [Announce] Linux-tiny project revival
Date: Thu, 20 Sep 2007 15:15:47 -0700
Message-ID: <5389061B65D50446B1783B97DFDB392D07126574@orsmsx411.amr.corp.intel.com>
In-Reply-To: <200709201702.08126.rob@landley.net>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [Celinux-dev] Re: [Announce] Linux-tiny project revival
thread-index: Acf70CRpmtiukuE5Twu7kdOtwVJx5AAAa97g
References: <46F1645D.9050406@am.sony.com> <200709201538.43093.rob@landley.net><20070920195844.GA1805@martell.zuzino.mipt.ru> <200709201702.08126.rob@landley.net>
From: "Gross, Mark" <mark.gross@intel.com>
To: "Rob Landley" <rob@landley.net>, "Alexey Dobriyan" <adobriyan@gmail.com>
Cc: "Michael Opdenacker" <michael@free-electrons.com>,
       <linux-tiny@selenic.com>,
       "CE Linux Developers List" <celinux-dev@tree.celinuxforum.org>,
       "linux kernel" <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 20 Sep 2007 22:15:48.0816 (UTC) FILETIME=[CC554500:01C7FBD3]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



>-----Original Message-----
>From: celinux-dev-bounces@tree.celinuxforum.org [mailto:celinux-dev-
>bounces@tree.celinuxforum.org] On Behalf Of Rob Landley
>Sent: Thursday, September 20, 2007 3:02 PM
>To: Alexey Dobriyan
>Cc: Michael Opdenacker; linux-tiny@selenic.com; CE Linux Developers
List;
>linux kernel
>Subject: [Celinux-dev] Re: [Announce] Linux-tiny project revival
>
>On Thursday 20 September 2007 2:58:44 pm Alexey Dobriyan wrote:
>> On Thu, Sep 20, 2007 at 03:38:42PM -0500, Rob Landley wrote:
>> > I've been playing with an idea for a while to improve the printk()
>> > situation, but it's a more intrusive change than I've had time to
bang
>> > on.
>> >
>> > Right now, the first argument to printk() is a loglevel, but it's
>handled
>> > via string concatenation.  I'd like to change that to be an
integer,
>and
>> > make it an actual comma-separated first argument.  (Mandatory, not
>> > optional.)
>> >
>> > So instead of:
>> >   printk(KERN_NOTICE "Fruit=%d\n", banana);
>> > It would now be:
>> >   printk(KERN_NOTICE, "Fruit=%d\n", banana);
>> >
>> > Change the header from:
>> >   #define KERN_NOTICE "<5>"
>> > to:
>> >   #define KERN_NOTICE 5
>> >
>> > Then you can change the printk guts to do something vaguely like
>> > (untested): #define printk(arg1, arg2, ...) actual_printk("<" #arg1
">"
>> > arg2, __VA_ARGS__)
>> >
>> > And so far no behavior has changed.  But now the _fun_ part is, you
can
>> > add a config symbol for "what is the minimum loglevel I care
about?"
>>
>> Given that
>> a) there're plenty of printks without any KERN_* bloat,
>
>> b) there're printks that SHOULD NOT have KERN_* bloat,
>
>So define a level 0 that doesn't prepend any level to the string, and
have
>the
>macro filter that out at the same default level it counts as now.
>(KERN_INFO, I think?)  The tests are all on contants which should
resolve
>at
>compile time and the dead code eliminator should zap it, even if the
macro
>gets more complicated it shouldn't result in a bigger binary.
>
>> c) debugging-by-printk method is widely used and this will force
>>    additional typing, head-scratching  and swear words
>
>Because we never change kernel internal APIs.  Oh yeah.  Never happens.
>
>> d) time wasted on pointless discussions whether some particular
>>    printk ALERT or CRIT
>
>Let me get this straight: you're objecting to actually making the
printk
>levels useful enough that developers start to care what they're set to,
>because then they might be motivated to want some of them changed?
>
>Make it useful, people might care, thus they might talk about it...
>
>Sorry, I'm still missing the downside here.
>
>> e) flag day for printk,
>
>That's the main reason I haven't played with it so far, although it
would
>be
>easy to define a new symbol (dprintk or some such, although I note
several
>drivers are already using that) and transition gradually.
>
>> I think that this idea is not worth it.
>
>*Shrug*.
>
>My problem is that switching off printk is the single biggest bloat
cutter
>in
>the kernel, yet it makes the resulting system very hard to support.  It
>combines a big upside with a big downside, and I'd like something in
>between.

What about getting even more hard core? 

Use compiler tricks to remove ALL the static printk string from the
kernel and replace the printk with something that outputs an decimal
index followed by tuples, of zero to N, hex-strings on a single line.
Then have the syslogd or some other utility take this cryptic output and
convolve it with a table (created at compile time) to re-create what
would have been dumped to the sys-log ring buffer.  This way you strip
out most of the static text from the kernel and yet can still re-create
the kernlog output.

At least as a post processing operation....

Is this an old idea?  I'm guessing this has been at least proposed
before....

--mgross

the 
>
>> > #define printk(level, str, ...) \
>> >   do { \
>> >     if (level < CONFIG_PRINTK_DOICARE) \
>> >       actual_printk("<" #level ">" str, __VA_ARGS__); \
>> >   } while(0);
>> >
>> > Opinions?
>>
>> Ick.
>>
>> 	Alexey "ignore_loglevel" Dobriyan
>
>But ignore_loglevel doesn't decrease the size of the _binary_.  That's
what
>we're talking about here with the -tiny tree.  Embedded developers want
to
>squeeze more code onto smaller flash/rom chips.  Setting
ignore_loglevel
>does
>prevent these messages from ever being emitted, but they're still in
the
>kernel image as dead weight.  It saves noise but doesn't save _space_.
>
>I'm proposing allowing an ignore_loglevel to remove the unused messages
at
>compile time so they don't take up space.  Doing that requires the
levels
>to
>be integers so they can be compared with < or >, and the remaining
changes
>follow logically.  (To me, anyway...)
>
>Rob
>--
>"One of my most productive days was throwing away 1000 lines of code."
>  - Ken Thompson.
>_______________________________________________
>Celinux-dev mailing list
>Celinux-dev@tree.celinuxforum.org
>http://tree.celinuxforum.org/mailman/listinfo/celinux-dev
