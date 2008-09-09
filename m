Return-Path: <linux-kernel-owner+w=401wt.eu-S1756226AbYIITZM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756226AbYIITZM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 15:25:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753607AbYIITY7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 15:24:59 -0400
Received: from one.firstfloor.org ([213.235.205.2]:40015 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751742AbYIITY7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 15:24:59 -0400
To: "Keith A. Prickett" <keithp@marvell.com>
Cc: Adrian Bunk <bunk@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: Building Kernel with -O0
From: Andi Kleen <andi@firstfloor.org>
References: <1220550653.15123.6.camel@CV-LAB2>
	<20080909160452.GB30160@cs181140183.pp.htv.fi>
	<1220980240.17292.15.camel@CV-LAB2>
Date: Tue, 09 Sep 2008 21:24:58 +0200
In-Reply-To: <1220980240.17292.15.camel@CV-LAB2> (Keith A. Prickett's message of "Tue, 09 Sep 2008 10:10:40 -0700")
Message-ID: <87vdx5ruk5.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Keith A. Prickett" <keithp@marvell.com> writes:
>
> All of this could, potentially be changed by a configuration parameter
> and added into the kernel release.  Does someone have a primer on why
> this kind of behavior is not desired or "possible"?

Traditionally it was not allowed because -O0 didn't inline and
the kernel relied on inlining in some cases. But with always_inline
that is obsolete -- all functions that rely on inlining should be 
marked __always_inline.

I think a few more cases crept in where it was common to write
build time asserts as

      if (some condition the compiler evaluates at runtime)
         __error_condition_xyz_is_false(); 
 
and this obviously relies on the optimizer to build. But these
are all slowly moving over the BUILD_BUG_ON() which also doesn't
rely on the optimizer, so it's also obsolete.

Then there's the issue that some of the kernel macros will
generate absolutely terrible code without optimizer
(good examples are the macros in asm-x86/uaccess.h). But I guess
that could be tolerated too.

Then another reason was that traditionally no source level
debugger was included and if you do assembly level debugging
optimized code is typically easier to read and debug because
the unoptimized gcc code is so terrible.

And with kgdb now being a standard option that has also changed.
And I agree with you that sometimes stepping through code
is very educational. And gdb tends to be a lot happier 
with -O0 code indeed.

So if you can make it all work cleanly, ideally tested on
other architectures too and a bit broader (e.g. with allyesconfig) 
and track down whatever the mm/* issue 
is correctly I don't see any real reason to not submit
a mainline patch that enables this as a CONFIG. Of course
it has to be very clean and not contain hacks.

If you're not familiar with submitting kernel patches
please read Documentation/{SubmittingPatches,SubmitChecklist} 
first.

Hope this helps,

-Andi

-- 
ak@linux.intel.com
