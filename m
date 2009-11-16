Return-Path: <linux-kernel-owner+w=401wt.eu-S1753978AbZKPUfr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753978AbZKPUfr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 15:35:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753513AbZKPUfr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 15:35:47 -0500
Received: from smtp-noauth7.primus.ca ([216.254.180.38]:45041 "EHLO
	mail-01.primus.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752210AbZKPUfq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 15:35:46 -0500
Date: Mon, 16 Nov 2009 15:35:45 -0500
From: Nick Bowler <nbowler@elliptictech.com>
To: Andreas Mohr <andi@lisas.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] FIX IT
Message-ID: <20091116203545.GA2028@emergent.ellipticsemi.com>
Mail-Followup-To: Andreas Mohr <andi@lisas.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org
References: <20091116194015.GA13820@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091116194015.GA13820@rhlx01.hs-esslingen.de>
Organization: Elliptic Technologies Inc.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20:40 Mon 16 Nov     , Andreas Mohr wrote:
> ChangeLog: Partially fix B0RKEN kernel usability

Improving error messages is a good idea, but I'm not sure how much this
patch actually helps.

> --- linux-2.6/init/main.c.orig	2009-11-16 20:13:08.000000000 +0100
> +++ linux-2.6/init/main.c	2009-11-16 20:14:51.000000000 +0100
> @@ -846,7 +846,8 @@ static noinline int init_post(void)
>  	run_init_process("/bin/init");
>  	run_init_process("/bin/sh");
>  
> -	panic("No init found.  Try passing init= option to kernel.");
> +	panic("No init found.  Try passing init= option to kernel. "
> +	      "See Linux Documentation/init.txt for guidance.");

I think that the people who know where to look after reading this are
mainly the people who don't need to read that file, with one exception -
point (C) later on.

> +OK, so you've got this pretty unintuitive message (currently located
> +in init/main.c) and are wondering what the H*** went wrong.
> +Some high-level reasons for failure (listed roughly in order of execution)
> +to load the init binary are:
> +A) Unable to mount root FS

Whenever the root FS has been unable to mount, I've always received an
error message that included the string "VFS: Unable to mount root fs".
Has this changed recently?  What sort of setup causes one to receive "No
init found" instead?

> +B) init binary doesn't exist on rootfs
> +C) other requirements not met

The introduction to this list already stated that it is not exhaustive,
so this entry adds no new information.  After reading the detailed
explanation, "broken console device" seems more appropriate here.

> +D) binary exists but dependencies not available
> +E) binary cannot be loaded

To me, (B), (D) and (E) are the same thing, and could just be "binary
cannot be loaded".  The details can be expanded upon in the next
section.

> +Detailed explanations:
<snip>
> +C) Possibly a conflict in console= setup --> initial console unavailable.
> +E.g. some serial consoles are unreliable due to serial IRQ issues (e.g. missing
> +interrupt-based configuration).
> +Try using a different console= device or e.g. netconsole=.

This appears to be by far the most interesting point in this file, since
it clarifies that "No init found." might be caused by a configuration
problem which seems completely unrelated to loading init.

> +D) e.g. crucial library dependencies of the init binary such as
> +/lib/ld-linux.so.2 missing or broken. Use readelf -d <INIT>|grep NEEDED
> +to find out which libraries are required.
> +E) make sure the binary's architecture matches your hardware.
> +E.g. i386 vs. x86_64 mismatch, or trying to load x86 on ARM hardware.
> +Or did you try loading a non-binary file here!?! (shell script?)

Linux is perfectly happy to load a shell script as init, so this comment
is very misleading.

-- 
Nick Bowler, Elliptic Technologies (http://www.elliptictech.com/)

