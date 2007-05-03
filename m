Return-Path: <linux-kernel-owner+w=401wt.eu-S1753559AbXECLQp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753559AbXECLQp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 07:16:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753532AbXECLQp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 07:16:45 -0400
Received: from charybdis-ext.suse.de ([195.135.221.2]:59269 "EHLO
	emea5-mh.id5.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753388AbXECLQm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 07:16:42 -0400
Date: Thu, 3 May 2007 13:16:25 +0200 (CEST)
From: Bernhard Kaindl <bk@suse.de>
To: randy.dunlap@oracle.com, Andi Kleen <ak@suse.de>
cc: patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [16/34] i386: fix mtrr sections
In-Reply-To: <Pine.LNX.4.64.0705021559160.32650@jbgna.fhfr.qr>
Message-ID: <Pine.LNX.4.64.0705031229300.27730@jbgna.fhfr.qr>
References: <20070430549.617098000@suse.de> <20070430154948.B6DDF151CA@wotan.suse.de>
 <Pine.LNX.4.64.0705021559160.32650@jbgna.fhfr.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I noticed that I can just use call graphs to make more clear what I want to say.

There is otherwise nothing new in this mail and I'll submit a new patch
which reverts this patch if my review came too late, if in doubt, just
ignore this mail, I may just refer to it later then.

> NACK - obsolete, replaced by:
> Jeremy Fitzhardinge - "x86: clean up identify_cpu"
> http://lkml.org/lkml/2007/4/7/113 [it's also patch 11/26 in this thread]
>
> It's a leftover of "__init to __cpuinit in mtrr code" (Prarit Bhargava):
> http://lkml.org/lkml/2007/2/28/198 - (acked by Bhavana Nagendra) which
> itself is rejected from Andrews tree already.
>
> Description:
> ------------
>
> This function tree (as of 2.6.21) here explains it all:
>
> __cpuinit       identify_cpu()
>     -> if BSP is inited, so only at __init time, these functions are called:
>          __init     mtrr_bp_init()
>             __init      get_mtrr_state()
>                __initdata   show_mtrr;
>                __init       print_fixed()

That was around 2.6.15 till 2.6.21.

Prarit Bhargava's patch "__init to __cpuinit in mtrr code" did this:

  __cpuinit       identify_cpu()
      -> if BSP is inited, so only at __init time, these functions are called:
-          __init        mtrr_bp_init()
-               __init        get_mtrr_state()
+          __cpuinit     mtrr_bp_init()
+               __cpuinit     get_mtrr_state()
                             (plus half a dozen other functions)
                 __initdata   show_mtrr;
                 __init       print_fixed()

and Randy's patch (on top of Prarit Bhargava's, which is removed now) does:

-                __initdata   show_mtrr;
+                             show_mtrr;
-                __init       print_fixed()
+                __cpuinit    print_fixed()

While Jeremy Fitzhardinge - "x86: clean up identify_cpu" cleans it up:

-  __cpuinit   identify_cpu()
+  __init      identify_boot_cpu()      (only does the boot-only calls)
           __init     mtrr_bp_init()
              __init      get_mtrr_state()
              (and half a dozen other functions also keep __init)
                 __initdata   show_mtrr;
                 __init       print_fixed()

which is best and Randy's patch "fix mtrr sections" is also obsolete then,
show_mtrr and print_fixed() can keep the __init/__initdata prefix.

As Andy already submitted it to Linus with http://lkml.org/lkml/2007/5/2/346
we may have to create a patch which reverts this patch.

I'm also planning to add some function headers to the MTRR functions
and also fix the existing and upcoming function headers to be complant
to kernel-doc.

Bernhard
