Return-Path: <linux-kernel-owner+w=401wt.eu-S1753990AbZGAL64@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753990AbZGAL64 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 07:58:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751193AbZGAL6s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 07:58:48 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:45449 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750862AbZGAL6r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 07:58:47 -0400
Date: Wed, 1 Jul 2009 13:00:18 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Scott Branden" <sbranden@broadcom.com>
Cc: "Jean-Christophe PLAGNIOL-VILLARD" <plagnioj@jcrosoft.com>,
       "Leo (Hao) Chen" <leochen@broadcom.com>,
       "linux-arm-kernel@lists.arm.linux.org.uk" 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1 6/6][ARM]  new ARM SoC support: BCMRing
Message-ID: <20090701130018.115ce0ea@lxorguk.ukuu.org.uk>
In-Reply-To: <9383297B60843144AC17878B479520F1109EEFC25D@SJEXCHCCR01.corp.ad.broadcom.com>
References: <20090701002054.44e6f688@lxorguk.ukuu.org.uk>
	<9383297B60843144AC17878B479520F1109EEFC25D@SJEXCHCCR01.corp.ad.broadcom.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> We would really like to know what needs to change in our patchset.  We have a large codebase of drivers for multiple chipsets already written that we have been maintaining internally and releasing for customer development.  For code that patches existing linux code we follow the style dictated in those files.  But for our new code we do not.
> 
> For our new code we have many developers who have written the code and thus a few "linux standard" coding styles have not been followed.  Much driver code is split into an os-less portion and a linux wrapper portion.  People have written following ISO/IEC 9899:1999 coding which allows such things as // comments.  Also using tabs in our code is not a requirement.  
> 
> My question is do we need to change our entire codebase over to match linux coding standards for comments and whitespace so it can pass a checkpatch script?  I'm sure there is a standard linux kernel community response to this but I need to forward that answer (whatever it is) to our many developers so we know what it is required to get our existing code integrated into the standard linux kernel.
> 

There isn't a general rule because there isn't a general case.

If you look at existing kernel code we have various drivers which have
components shared with other OS systems (usually header files). Some of
those are even generated from firmware builds and/or vhdl tools. (obvious
example drivers/scsi/dpt_i2o.c and drivers/scsi/dpt/*h - the driver is
Linux format completely, the Linux header bits are likewise but various
structures and layout shared across all of the board uses are not)

For stuff that never needs editing its not really too important unless
its horribly obfuscated. Some people run their shared stuff through some
quick formatting scripts so the Linux submission of the header looks a
bit more Linuxy - and if its a header and the reformatting is automated
it avoids creating work maintaining two copies.

Anything which is kernel code to be maintained/edited in the kernel
really needs to be in the kernel style. A lot of that is pretty easy to
automate: indent will fix the formatting, and a simple search and
replace script can turn comments of the form 

	// foo

into
	/* foo */


Taking the submission itself there are some obvious stylist things I'd
sat to fix first (beyond trivia like spaces and comments)

Use of gSysCtlfoo and similar for globals. That's asking for collisions
if everyone does it so the kernel preference is for names of the form

	myplatform_xxx

eg

	bcmring_arch_warm_reboot

(and generally preferring low case names for variables)

The code uses a lot of sempahores as mutexes which is something we've
been working hard to stamp out (to make pre-emptible real time merging
in the future easier)

There are various oddities in the code that are weird (eg defining MIN
when the kernel has min and min_t anyway)


Some people unfortunately like jumping up and down about spaces but not
code. The basic code is readable if oddly styled (from a kernel viewpoint)
and its possible to understand what it is doing on a first pass. I'd
rather read good poetry written in very bad hand writing than bad poetry
written in beautiful handwriting, and I think the same is true of code.

So my suggestions for a first pass would be

Bang the Linux specific bits through indent, some scripts to clean up the
non shared bits of the codebase. Fix up the little niggly things like MIN
v min and the global names. That should be mostly automatable and pretty
quick to do. Checkpatch is a handy guide but don't treat it as some kind
of dictat, at times it makes very bad suggestions for readability.

At that point we can concentrate on the underlying code, which I think is
sound, and some case by case discussion for the shared platform code
depending upon what it is and how it is used.

The kernel is an awful lot of code from an awful lot of people and to
some extent you do have to impose a style so anyone can work on it
sensibly. There are however cases where you've got shared code and want
different answers.

