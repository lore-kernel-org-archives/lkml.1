Return-Path: <linux-kernel-owner+w=401wt.eu-S1756974AbXGVPbV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756974AbXGVPbV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 11:31:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752317AbXGVPbO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 11:31:14 -0400
Received: from py-out-1112.google.com ([64.233.166.177]:60953 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750950AbXGVPbN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 11:31:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Ahr/pcfaASdjGRdrNvd6d1R3ymQx00QHpU28wxj7mjc7lBgJrNwvvV9VcZPPlELwK5sRUCTT1WLUMnhJ7tkLqvqh2rNeWf9+EXv2zBAXdeHoOGqYIqz5fJxQeA/zGZ7lWfARfCeongYZHpxh53YzKBSGH9+bIPoUsIqqEpnyz08=
Message-ID: <a781481a0707220831y67bcd64k34d52c3150c27dc1@mail.gmail.com>
Date: Sun, 22 Jul 2007 21:01:12 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Lars Ellenberg" <lars.ellenberg@linbit.com>
Subject: Re: [DRIVER SUBMISSION] DRBD wants to go mainline
Cc: "Jens Axboe" <jens.axboe@oracle.com>, "Andi Kleen" <andi@firstfloor.org>,
       "Andrew Morton" <akpm@osdl.org>, lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <20070722135814.GA32371@mail.linbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070721203819.GA10706@mail.linbit.com>
	 <p73hcnxuxji.fsf@bingen.suse.de> <20070722055235.GQ11657@kernel.dk>
	 <20070722135814.GA32371@mail.linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/22/07, Lars Ellenberg <lars.ellenberg@linbit.com> wrote:
> On Sun, Jul 22, 2007 at 07:52:36AM +0200, Jens Axboe wrote:
> > [...]
> > Yep, cleanup the style issues (that make sense) from checkpatch and then
> > psot as a series of patches that can be reviewed. Linking to a git tree
> > wont get you very far.
>
> it got me far enough, for the first try, anyways :-)
> I did not spam the lkml with patches, and still got some very useful
> advice (no idea how I could overlook the checkpatch.pl complaints).
>
> If each patch of a series needs to compile and work,
> there will probably only one 17kB patch...
> it is difficult to split one module into a series of patches.
> Or am I missing something?

If not too much bother, you could even present the patchset in a way
that reflects how the driver code evolved to its present state in v8.0.4.

> may I bother you again to comment on this, please:
>
> I am now down to
>  5 CHECK: memory barrier without comment
>     these are directly connected with our homegrown kernel thread stuff.
>     will vanish as soon as we convert to kthread.h API.
>
>  4 CHECK: spinlock_t definition without comment
>  3 CHECK: Use #include <linux/uaccess.h> instead of <asm/uaccess.h>
>  3 CHECK: if this code is redundant consider removing it
>  2 CHECK: Use #include <linux/types.h> instead of <asm/types.h>
>     need to check those, still.
>
> 72 ERROR: braces {} are not necessary for single statement blocks
>     one branch needs them, the othe does not.
>     what now? CodingStyle and checkpatch.pl disagree.

Submit a patch to checkpatch.pl (or preferably CodingStyle, I dislike
with the way it blatantly disregards K&R convention in this matter :-)

> 13 ERROR: no space between function name and open parenthesis '('
>     this is about our ERR_IF() macro...
>     suggestions, anyone?

There shouldn't be any space between function/macro name and open
parenthesis. However, there *must* be a space between C language
keyword (if, while, for) and open parenthesis.

>     do need I to explicitly write these out?

Yup, do consider that. Also consider making them functions. Macros
are _generally_ evil and *always* horrible.

>  8 ERROR: Macros with multiple statements should be enclosed in a do - while loop

You don't want to break if-else constructs.

>  1 ERROR: Macros with complex values should be enclosed in parenthesis

I'm not sure know when / why checkpatch.pl reports this. I don't want to
pull your tree so can't check for myself, but note some obvious rules:

1. Macro definition must always include parenthesis around the entire
definition (unless it's a do { somehting; } while (0) kind of macro).
2. Use parenthesis around wherever it uses the passed argument(s).

>     these are "netlink packet definition language" in drbd_nl.h,
>     which is sort of clean, and preprocessor magic in drbd_nl.c.
>     suggestions how to handle this cleanly,
>     without making it more ugly?
>     autogenerate code by other means?
>     write it out by hand, and lose the nice and clean drbd_nl.h?

1. Open-code it if it is trivial enough and there's no point
obfuscating anything.
2. Consider making the macro a function. Probably inline, most probably not.
3. Macros must NOT evaluate the passed argument twice -- consider the
possible damages of someone who doesn't know it's a macro and therefore
passing in an expression that has side-effects (*boom, crash*).

>  1 ERROR: Don't use kernel_thread(): see Documentation/feature-removal-schedule.txt
>     yes. working on that.
>     will take some days, though.
>
>  1 ERROR: Missing Signed-off-by: line(s)

Patches submitted to LKML should conform to guidelines in:

* Documentation/SubmittingPatches in kernel sources
* http://www.zipworld.com.au/~akpm/linux/patches/stuff/tpp.txt

> 94 WARNING: declaring multiple variables together should be avoided
>     int snr, enr;
>     does this really need to become two lines?

No, if these are some unimportant temporary/automatic variables in
some function.

Yes, if they are members of some struct (also comment them in
this case -- in fact give full kernel-doc style comments).

> 33 WARNING: line over 80 characters
>     hmmm. get more ugly...
>     probably need some helper functions and temp variables?

Yes, do consider breaking functions that go significantly beyond
80 lines into smaller ones. If it's just 4-5 columns beyond 80, and
breaking the line would actually hurt readability, don't bother.

>  4 WARNING: multiple assignments should be avoided
>     x = y = 0;
>     is sometimes a convenient initialization.
>     you don't like it?

Yes, we don't appreciate such usage at all. Please fix this.

Satyam
