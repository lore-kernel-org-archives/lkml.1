Return-Path: <linux-kernel-owner+w=401wt.eu-S932629AbZACTqV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932629AbZACTqV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 14:46:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753131AbZACTqI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 14:46:08 -0500
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:59555
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751571AbZACTqH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 14:46:07 -0500
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: Matthieu CASTET <matthieu.castet@parrot.com>
Subject: Re: PATCH [0/3]: Simplify the kernel build by removing perl.
Date: Sat, 3 Jan 2009 13:46:00 -0600
User-Agent: KMail/1.10.1 (Linux/2.6.27-7-generic; KDE/4.1.2; x86_64; ; )
Cc: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>,
       linux-kernel@vger.kernel.org,
       Embedded Linux mailing list <linux-embedded@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Sam Ravnborg <sam@ravnborg.org>
References: <200901020207.30359.rob@landley.net> <200901020513.19593.rob@landley.net> <495E3AF8.6000006@parrot.com>
In-Reply-To: <495E3AF8.6000006@parrot.com>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <200901031346.01325.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 02 January 2009 10:04:08 Matthieu CASTET wrote:
> Rob Landley a écrit :
> > On Friday 02 January 2009 03:26:37 Arkadiusz Miskiewicz wrote:
> >> On Friday 02 of January 2009, Rob Landley wrote:
> >>
> >> Heh,
> >
> > I believe all three scripts run under dash and busybox ash.  (The
> > timeconst.sh one needs 64 bit math which dash only provides on 64 bit
> > hosts, which is a regression from Red Hat 9 in 2003 by the way.
>
> With dash 0.5.4-12 (from debian sid), I seems I got the 64 bit math for
> 32 bit hosts :
> $ uname -m
> i686
> $ dash -c 'echo $((1<<32))'
> 4294967296

Cool.

The "relatively recent" 32 bit image I have lying around for testing purposes 
is xubuntu 7.10, and when dash was first introduced into ubuntu it had 
_buckets_ of bugs.  (If you backgrounded a task with & and then hit ctrl-z on 
the command line, it would suspend the backgrounded task.  It was Not Ready 
for Prime Time in a big way.)  Lack of 64 bit math could easily be one more.  
(It _is_ a regression vs Red Hat 9.)

The dash in ubuntu 8.10 seems to have a lot of the more obvious problems 
worked out.  Good to know. :)

That said, while testing the new round of patches against various shells and 
making it reproduce the full set of time constants that the old perl script 
kept cached values for (24, 32, 48, 64, 100, 122, 128, 200, 250, 256, 300, 
512, 1000, 1024, and 1200 hz), I found a bug.

The first patch is  miscalculating USEC_TO_HZ_ADJ32 for 24 HZ and 122 HZ.  All 
the other values are fine.)  It's an integer overflow.  The GCD of 24 and 
1000000 is 8, so that's 17 significant bits with a shift of 47... which is 
exactly 64 bits, but the math is _signed_, so it goes boing.

For the record, the reason I can't just pregenerate all these suckers on a 
system that's got an arbitrary precision calculator (ala dc) and then just 
ship the resulting header files (more or less the what the first version of 
that first patch did) is that some architectures (arm omap and and arm at91) 
allow you to enter arbitrary HZ values in kconfig.  (Their help text says that 
in many cases values that aren't powers of two won't work, but nothing 
enforces this.)  So if we didn't have the capability to dynamically generate 
these, you could enter a .config value that would break the build.

I'd be willing to use dc in the script if A) it was mentioned in SUSv3 (it's 
not, although bc is), B) the version of dc in busybox wasn't crap (it's 
floating point rather than arbitrary precision, and doesn't implement the left 
shift operator).  The reason I'm not looking more closely at what SUSv3 has to 
say about bc is that A) it claims to be an entire programming language, which 
is definitely overkill for this B) busybox hasn't bothered to implement it so 
it can't be all that widely used anymore.

I'll fix this and resubmit, it just wasn't ready last night.  (If the merge 
window is closing soon I could resubmit the other two with Sam's suggestions 
and resubmit this one next time 'round, but it was only a couple days to write 
in the first place, once I finally figured out what the perl version was 
trying to _do_...)

I believe ADJ32 is the only operation with any potential to overflow.  The 
pathological case for SHIFT is HZ 1, which for USEC conversions would give a 
shift around 52 (32 significant bits plus 20 bits to divide by 1000000), but 
MUL32 still wouldn't overflow because the shift loop stops when it finds 32 
significant bits, and any larger HZ value would produce a smaller shift.  The 
problem with ADJ32 is it uses the MUL32 shift value, so a small $TO (24 HZ) 
with a big $FROM (1000000 USEC, 19 signficant bits) and a small Greatest 
Common Denominator (in this case 8) can overflow 64 bits.  Pathological case 
is still HZ 1.  (Or any other smallish prime number.)  If I make that work, 
everything else has to.

So anyway, it's not _arbitrary_ precision math.  It's more like 32+20+20=72 
bits, and I can probably fake that pretty easily by breaking a couple of 
operations into two stages...

Fallen a bit behind on the thread since I noticed this and went off to code, 
I'll try to catch up later today.

Rob
