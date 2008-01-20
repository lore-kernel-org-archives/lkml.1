Return-Path: <linux-kernel-owner+w=401wt.eu-S1753748AbYATMZk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753748AbYATMZk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2008 07:25:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752656AbYATMZd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jan 2008 07:25:33 -0500
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:49661
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752626AbYATMZc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2008 07:25:32 -0500
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: linux-tiny@selenic.com
Subject: Re: [PATCH] x86: =?iso-8859-1?q?fix=09unconditional=09arch/x86/kernel/pcspeaker=2Ec=3Fcomp?=
 =?iso-8859-1?q?iling?=
Date: Sun, 20 Jan 2008 06:25:28 -0600
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Michael Opdenacker <michael-lists@free-electrons.com>,
       Matt Mackall <mpm@selenic.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
References: <200801171643.49301.michael-lists@free-electrons.com> <1200664214.4001.24.camel@cinder.waste.org> <4790D3E3.4060409@free-electrons.com>
In-Reply-To: <4790D3E3.4060409@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801200625.29511.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 18 January 2008 10:29:23 Michael Opdenacker wrote:
> Sounds fine! Don't hesitate to let us know about the lower-hanging fruit
> you're thinking about. Here are the main things I have so far:
>
>     * Ideas in the existing Linux-Tiny patchset.
>     * Disable support for non-Intel processors in x86 (cyrix.c,
>       centaur.c, transmeta.c, nexgen.c, umc.c in arch/x86/kernel/cpu).
>       As far as I remember, I saved 15 KB when I first experimented with
>       this).
>     * Disable support for readahead, page writeback, pdflush and swap
>       when we have no storage at all (typically booting from an
>       initramfs). This corresponds to 69 KB of source code!
>
> So, more ideas are welcome!

Personally, I'm trying to figure out how to build a "hello world" kernel.

I.E. the minimal set of files I need to compile to get a kernel I can boot 
under qemu that does something visible.  (Printing "hello world" to the 
serial port via the early_serial_write(), perhaps?)

No VFS, no process management, preferably no memory management...  Just get to 
a stub start_kernel() that calls early_serial_write() and then does a HLT.  I 
note that start_kernel() calls 11 things before the first printk(), and that 
without the early_printk stuff that's just going into a buffer.

Preferably, I even want to take this out of the kernel's build process and 
build it from the command line or a small shell script.  (zImage packaging 
and all.)  I.E. some kind of:

  gcc blah blah blah -o vmlinux
  wrap.sh vmlinux zImage

The reason for this is, of course, that I'm trying to build the kernel with my 
tinycc fork, and the whole kernel build is kind of intimidating and 
complicated.  (And I currently need to pregenerate asm-offsets.h until I 
teach tinycc to produce assembly output or come up with an alternative.)

Currently, a "make allnoconfig" build runs for 479 lines, and builds radix 
tree code and /dev/random and sysfs and all sorts of stuff.  
Counter-intuitively, allnoconfig _isn't_ the smallest kernel you can build 
(by a long shot), to do that you have to switch on the embedded menu and then 
switch off everything in it (and all the stuff that shows up right _after_ 
it, which smells like a bug to me), and switch to SLOB and switch off the 
block layer at the top level.  But doing that only gets the build down to 449 
lines, and the resulting x86-64 kernel is over 400k.  That is _not_ a "hello 
world" kernel.  Not even close. :)

Alas, working from the other end and building your way _up_ isn't trivial 
either.  (But has the advantage that I'm starting much closer to my goal than 
the stripping down approach.)

> Thanks for your time,
>
> Michael.

Rob
-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
