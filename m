Return-Path: <linux-kernel-owner+w=401wt.eu-S932934AbXHVUr5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932934AbXHVUr5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 16:47:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759911AbXHVUrt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 16:47:49 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:49379 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758654AbXHVUrs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 16:47:48 -0400
Date: Thu, 23 Aug 2007 02:30:33 +0530 (IST)
From: Satyam Sharma <satyam@infradead.org>
X-X-Sender: satyam@enigma.security.iitk.ac.in
To: Andrew Morton <akpm@linux-foundation.org>
cc: Sam Ravnborg <sam@ravnborg.org>, Randy Dunlap <randy.dunlap@oracle.com>,
       wbrana@gmail.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][bugzilla #8679] therm_throt.c: Fix section mismatch
In-Reply-To: <20070820220328.438e8a4d.akpm@linux-foundation.org>
Message-ID: <alpine.LFD.0.999.0708211103090.2774@enigma.security.iitk.ac.in>
References: <alpine.LFD.0.999.0708211003390.2774@enigma.security.iitk.ac.in>
 <20070820220328.438e8a4d.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 20 Aug 2007, Andrew Morton wrote:

> On Tue, 21 Aug 2007 10:07:31 +0530 (IST) Satyam Sharma <satyam@infradead.org> wrote:
> > 
> > WARNING: arch/i386/kernel/built-in.o(.data+0x2148): Section mismatch: reference
> > to .init.text: (between 'thermal_throttle_cpu_notifier' and 'mtrr_mutex')
> > 
> > comes because struct notifier_block thermal_throttle_cpu_notifier in
> > arch/i386/kernel/cpu/mcheck/therm_throt.c goes in .data section but
> > the notifier callback function itself has been marked __cpuinit which
> > becomes __init == .init.text when HOTPLUG_CPU=n. The warning is bogus
> > because the callback will never be called out if HOTPLUG_CPU=n in the
> > first place (as one can see from kernel/cpu.c, the cpu_chain itself
> > is __cpuinitdata :-)
> > 
> > So, let's mark thermal_throttle_cpu_notifier as __cpuinitdata to fix
> > the section mismatch warning.
> > [...]
> 
> okay...  However we're not being very consistent here.
> 
> register_hotcpu_notifier() is cunning.  If CONFIG_HOTPLUG_CPU=y, we need
> the notifier block and the function to which it points to be in .data and
> in .text.  If CONFIG_HOTPLUG_CPU=n, we don't need them to be present at all.
> 
> So what we can do is to just leave the notifier block in .data and the
> function in .text and then the compiler/linker will notice that nothing
> references them and they will be omitted at build time.
> 
> So basically, the register_hotcpu_notifier() implementation (in league with
> the compiler) is taking the place of the manual notations.

Ok, I can see where you're getting at. When CONFIG_HOTPLUG_CPU=n,
the compiler will just optimize away the reference to (void)(nb);
and with it, the reference to the callback function too, entirely.

[ BTW I wonder if we should make the HOTPLUG_CPU=y implementation of
  register_cpu_notifier as void-returning (notifier_chain_register()
  never fails anyway) to preserve symmetry with the HOTPLUG_CPU=n stub.
  Because of the do {} while, no callsite out there can ever check the
  return from register_hotcpu_notifier() without breaking builds when
  HOTPLUG_CPU=n. But that goes against the taste of register_foo()
  functions in the kernel. So probably it is the HOTPLUG_CPU=n stub
  that should be made "static inline int {return 0;}" instead? However,
  on doing that, the compiler may fail to optimize away the callback
  function, at least that's what the testcase I wrote to experiment
  with all this proved:
			http://www.cse.iitk.ac.in/users/ssatyam/xyz.c ]

  Curiously, notifier_chain_unregister() _can_ return errors, but I bet
  *none* of the unregister_foo_notifer()'s out there ever check its
  return anyway. All the unregister_foo() and exit_foo() functions in the
  kernel tend to be void-returning for good reason, so I wonder if we
  should make notifier_chain_unregister() void-returning as well, and go
  BUG() there (instead of returning -ENOENT which noone checks) when asked
  to unregister a notifier block that didn't even exist. That does sound
  BUG-worthy to me, and in all probability, we would've oopsed when trying
  to call out the callback of said non-existent notifier_block already.
  In fact, making notifier_chain_unregister() go BUG() on that error will
  even catch certain bugs (such as somebody annotating the notifier_block
  incorrectly with __init when he should not have) early, irrespective of
  whether or not that notifier was actually ever even called out on! ]


> Note that because this works at compile time, it is also effective within
> modules.

I must say, this is an amazingly cunning idea. Only things I can think of
against this would be: the dropping of unneeded code is not guaranteed,
but depends on compiler. And we saw from the "static inline {return 0;}"
testcase that gcc can sometimes be not-so-smart.


> I'm not sure that we discard the unneeded sections from within
> modules? (I forget).

Didn't quite get this, but yes, __cpu{init,exit} can only become __init
or __exit at most, neither of which can be dropped from a module.


> So...  what to do?  I guess for consistency one could hunt down all the
> register_hotcpu_notifier() sites and remove all the __initfoo tags from all of
> them.  But that makes register_hotcpu_notifier() inconsistent from
> everything else, so there's an argument that we should make all these
> things __cpuinit and __cpuinitdata for consistency rather than relying upon
> register_hotcpu_notifier()'s magical properties as a special case.  Dunno.

I also like the above idea because it eliminates the need for authors
to have to mark their functions appropriately -- nobody gets that right
anyway, as we see from the zillions of section mismatch warnings every
-rc cycle. But the __cpuinit and __cpuinitdata consistency argument does
sound "safe". Sigh.
