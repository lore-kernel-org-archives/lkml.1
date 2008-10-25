Return-Path: <linux-kernel-owner+w=401wt.eu-S1755502AbYJYDfN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755502AbYJYDfN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 23:35:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753195AbYJYDe1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 23:34:27 -0400
Received: from waste.org ([66.93.16.53]:41970 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754967AbYJYDeZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 23:34:25 -0400
Subject: Re: Bloatwatch 2.6.28-rc1: i8042 DMI lookup tables
From: Matt Mackall <mpm@selenic.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Jiri Kosina <jkosina@suse.cz>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       David Woodhouse <dwmw2@infradead.org>, Ingo Molnar <mingo@redhat.com>
In-Reply-To: <200810242046.02743.dmitry.torokhov@gmail.com>
References: <1224879959.3248.32.camel@calx>
	 <alpine.LNX.1.10.0810250001530.27479@jikos.suse.cz>
	 <1224890002.3248.71.camel@calx>
	 <200810242046.02743.dmitry.torokhov@gmail.com>
Content-Type: text/plain
Date: Fri, 24 Oct 2008 22:31:19 -0500
Message-Id: <1224905479.3248.126.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-10-24 at 20:46 -0400, Dmitry Torokhov wrote:
> On Friday 24 October 2008, Matt Mackall wrote:
> > On Sat, 2008-10-25 at 00:15 +0200, Jiri Kosina wrote:
> > > On Fri, 24 Oct 2008, Matt Mackall wrote:
> > > 
> > > > We've added 12k of new initdata to allnoconfig builds for i8042 DMI
> > > > lookup tables:
> > > > 
> > > > http://www.selenic.com/bloatwatch/?cmd=compare;v1=2.6.27;v2=2.6.28-rc1;part=/built-in/drivers
> > > > 
> > > > It looks like each table entry is > 320 bytes as we reserve four 80-byte
> > > > slots in each for DMI match strings. 
> > > 
> > > Umm, and what is the actual problem with that, really?
> > 
> > The actual problem is that if the kernel grows by 12k every time a
> > developer says "what's the big deal?" the kernel will become very large
> > indeed.
> > 
> > > OK, we can remove it from .init, but then it will be rotting in memory 
> > > forever, which is quite sub-optimal, when this kind of DMI information is 
> > > needed only during initialization.
> > 
> > I wasn't complaining that they were in init, but rather that they were
> > 12k. For something like 37 entries. The entry size is ridiculous and
> > looks to have grown by a factor of 10 since 2.6.27. What, as they say,
> > is up with that?
> > 
> > It looks like David Woodhouse is to blame:
> > 
> > commit d945b697d0eea5a811ec299c5f1a25889bb0242b
> > Automatic MODULE_ALIAS() for DMI match tables.
> > 
> > This is probably also responsible for most of the growth in x86 I
> > mentioned elsewhere, so it's about 25-30k damage in total. David?
> > 
> 
> I think that the net effect of this change is positive.

Sure. But it's still suddenly one of the biggest data structures in the
kernel image. And I expect we'll keep accumulating these sorts of
tables.

>  While it is
> true that the size of the kernel image grew we do discard more memory
> (most of DMI tables are marked __initdata) than we were able to do
> before DMI strings were embedded into dmi_strmatch so the footprint of
> the running kernel now should be smaller. Having said this I wonder if
> we could reduce the length of these strings form 79 to let's say 39. 

The sad thing is that we've gone from using len(x) + 4 bytes to 79
bytes, where the average x appears to have been... 4 (counting the fact
that most match slots are empty!). If we used strstr rather than strcmp,
we could probably get by with < 8 bytes per id (and maybe roll some
entries together).

Also, painfully, we end the lists with 320+ byte empty entries.

Ideally, we'd find a way to (a) store variable-length string constants
in init sections and (b) teach modpost about following pointers.

Something like this would work inside code but sadly not inside
declarations:

#define ISTR(s) ({static char c[] __attribute__ ((section("__initdata__"))) = s;c;})

> I would like to get rid of .ident strings in cases when drivers don't
> use them for anything, this should free some more memory.

Interestingly, those still live in the kernel image after init as
they're pointers to string constants. And most of them are purely
redundant.

-- 
Mathematics is the supreme nostalgia of our time.

