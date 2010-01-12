Return-Path: <linux-kernel-owner+w=401wt.eu-S1754235Ab0ALXRB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754235Ab0ALXRB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 18:17:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753879Ab0ALXRA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 18:17:00 -0500
Received: from terminus.zytor.com ([198.137.202.10]:52129 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752866Ab0ALXRA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 18:17:00 -0500
Message-ID: <4B4D02B8.5020801@zytor.com>
Date: Tue, 12 Jan 2010 15:16:08 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Jason Baron <jbaron@redhat.com>
CC: linux-kernel@vger.kernel.org, mingo@elte.hu, mathieu.desnoyers@polymtl.ca,
       tglx@linutronix.de, rostedt@goodmis.org, andi@firstfloor.org,
       roland@redhat.com, rth@redhat.com, mhiramat@redhat.com
Subject: Re: [RFC PATCH 2/8] jump label v4 - x86: Introduce generic jump patching
 without stop_machine
References: <cover.1263247113.git.jbaron@redhat.com> <a4aa5bbcf5e62eaa5dd156d318a370236f28be09.1263247114.git.jbaron@redhat.com>
In-Reply-To: <a4aa5bbcf5e62eaa5dd156d318a370236f28be09.1263247114.git.jbaron@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/12/2010 08:26 AM, Jason Baron wrote:
> Add text_poke_fixup() which takes a fixup address to where a processor
> jumps if it hits the modifying address while code modifying.
> text_poke_fixup() does following steps for this purpose.
> 
>  1. Setup int3 handler for fixup.
>  2. Put a breakpoint (int3) on the first byte of modifying region,
>     and synchronize code on all CPUs.
>  3. Modify other bytes of modifying region, and synchronize code on all CPUs.
>  4. Modify the first byte of modifying region, and synchronize code
>     on all CPUs.
>  5. Clear int3 handler.
> 

We (Intel OTC) have been able to get an *unofficial* answer as to the
validity of this procedure; specifically as it applies to Intel hardware
(obviously).  We are working on getting an officially approved answer,
but as far as we currently know, the procedure as outlined above should
work on all Intel hardware.  In fact, we believe the synchronization in
step 3 is in fact unnecessary (as the synchronization in step 4 provides
sufficient guard.)

In fact, if a suitable int3 handler is left permanently in place then
step 5 is unnecessary as well.  This would slow down other uses of int3
slightly, but might be a worthwhile tradeoff.

Such a permanent int3 handler would need to keep track of two
potentially-spurious breakpoints: the current and the previous.  The
reason for needing two is that one could get a #BP from either the
current or the previous modification site between the insertion of int3
and the synchronization in step 2.  This, of course, assumes that the
actual code poking is forcibly single-threaded (running under a spinlock
or other mutex) -- if modifications are allowed to run in parallel you
need to consider all possible current or stale #BP sites.

	-hpa
