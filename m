Return-Path: <linux-kernel-owner+w=401wt.eu-S1759212AbYFKE5D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759212AbYFKE5D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 00:57:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751196AbYFKE4t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 00:56:49 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:45840
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751332AbYFKE4P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 00:56:15 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: Adrian Bunk <bunk@kernel.org>
Subject: Re: mainlining min-configs...
Date: Tue, 10 Jun 2008 22:48:15 -0500
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Tim Bird <tim.bird@am.sony.com>, linux-tiny <Linux-tiny@selenic.com>,
       linux-embedded <linux-embedded@vger.kernel.org>,
       linux kernel <linux-kernel@vger.kernel.org>
References: <48447615.5050806@am.sony.com> <484DDAD9.2000306@am.sony.com> <20080610083610.GC1987@cs181133002.pp.htv.fi>
In-Reply-To: <20080610083610.GC1987@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806102248.16595.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 10 June 2008 03:36:10 Adrian Bunk wrote:
> On Mon, Jun 09, 2008 at 06:37:29PM -0700, Tim Bird wrote:
> > Rob Landley wrote:
> > > On Friday 06 June 2008 18:47:47 Tim Bird wrote:
> > >> At a minimum, it would be nice to have a few nice examples
> > >> of really, really small configs for things like qemus for different
> > >> architectures (just to give embedded developers who are working
> > >> on size a starting point).
> > >
> > > That's more or less what I'm trying to do with my Firmware Linux
> > > project: creating cross compilers and minimal native build environments
> > > for every qemu target.
> >
> > Any chance of getting your minimal configs from Firmware Linux mainlined?
>
> It could help finding compile errors in some more "exotic" configurations
> early (but I'd question whether the Rob's current configs are really
> both minimal and typical for embedded usage - e.g the i686 one having
> both ext2 and ext3 enabled but no JFFS2; and enabling all IO schedulers
> in the kernel as well as ACPI is also not a typical embedded setup).

No argument there.  I just offered them as a starting point for supporting 
each qemu target.

I'm emulating a native build environment, meaning I need an emulated hard 
drive with gibabytes of writable space; lots of embedded devices use 
initramfs and nothing else.  I'm using distcc so I need a working network 
card and network stack, which lots of devices won't need.  Also, some of them 
(mips comes to mind) need to be stripped down some more.

(The ext2 plus ext3 thing is because ext2 isn't happy about writable mounts 
where the emulator gets killed out from under it and then needs fsck, but 
ext3 isn't really happy with small read-only mounts ala initrd.  I keep 
meaning to teach ext3 to work without a #*%&# journal, at least on read only 
mounts, but it's about 150 entries down on my todo list...)

I keep meaning to refactor the configs into two files, so "just enough to boot 
this with a serial console" is a separate file from things like filesystems 
and network stack that are common to all of 'em.  (Then concatenate the two 
to get a miniconfig.)  I'm not _quite_ convinced the extra build complexity's 
worth it...

> But if you want to discover size change with minimal configs early you
> anyway have to both:
> - constantly keep your configs in shape so that they are both minimal
>   for some set of hardware support and features and

I find miniconfig helps here.

> - investigate for any size changes what caused them
>   (experience has shown that putting information on a webpage doesn't
>    fix problems - even for compile errors).
>
> You need both, and ideally constantly done by the same person against
> Linus' tree, -next and -mm.

Speaking from experience, this is a huge #*%&# pain.  (I'm trying to track 
this sort of changes for less than a dozen qemu configs.  There are hundreds 
of defconfigs in the tree, most of which I can't boot test...)

However, qemu can be automated and scripted.  (Especially when /dev/console 
attaches to qemu's stdin and stdout.  That's why I need each platform to know 
how to shut _down_, and exit the emulator.  Currently, powerpc -M prep 
doesn't do this. :P)

> Where to get your minimal configs from at the start is just a small
> thing at the beginning - don't underestimate the required manual work
> that will have to be done each week.

Eh, I'd suggest every -pre release.

And starting with tracking the size regressions in just _one_ platform is 
probably best.  I'd suggest either x86 (32 bit, matches arm) or x86_64 
(largest userbase at this point, even Via's finally switched over).

> > Does anyone else think this would be valuable?  If not in mainline, it
> > would be nice to collect them somewhere, to compare what options
> > different developers decide turn on or off.
>
> You already have this when you look at e.g. the ARM defconfigs in the
> kernel

I've got a script running to convert all the 2.6.25 defconfigs into 
miniconfigs, which I find makes 'em easier to read.  I'll post the results 
when it finishes...

Rob
-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
