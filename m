Return-Path: <linux-kernel-owner+w=401wt.eu-S1752895Ab0AMFjm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752895Ab0AMFjm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 00:39:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750715Ab0AMFjl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 00:39:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:3444 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932070Ab0AMFjl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 00:39:41 -0500
Message-ID: <4B4D5C6F.6020702@redhat.com>
Date: Wed, 13 Jan 2010 00:38:55 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Jason Baron <jbaron@redhat.com>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, mathieu.desnoyers@polymtl.ca, tglx@linutronix.de,
       rostedt@goodmis.org, andi@firstfloor.org, roland@redhat.com,
       rth@redhat.com
Subject: Re: [RFC PATCH 2/8] jump label v4 - x86: Introduce generic jump patching
 without stop_machine
References: <cover.1263247113.git.jbaron@redhat.com> <a4aa5bbcf5e62eaa5dd156d318a370236f28be09.1263247114.git.jbaron@redhat.com> <4B4D02B8.5020801@zytor.com>
In-Reply-To: <4B4D02B8.5020801@zytor.com>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> On 01/12/2010 08:26 AM, Jason Baron wrote:
>> Add text_poke_fixup() which takes a fixup address to where a processor
>> jumps if it hits the modifying address while code modifying.
>> text_poke_fixup() does following steps for this purpose.
>>
>>  1. Setup int3 handler for fixup.
>>  2. Put a breakpoint (int3) on the first byte of modifying region,
>>     and synchronize code on all CPUs.
>>  3. Modify other bytes of modifying region, and synchronize code on all CPUs.
>>  4. Modify the first byte of modifying region, and synchronize code
>>     on all CPUs.
>>  5. Clear int3 handler.
>>
> 
> We (Intel OTC) have been able to get an *unofficial* answer as to the
> validity of this procedure; specifically as it applies to Intel hardware
> (obviously).  We are working on getting an officially approved answer,
> but as far as we currently know, the procedure as outlined above should
> work on all Intel hardware.  In fact, we believe the synchronization in
> step 3 is in fact unnecessary (as the synchronization in step 4 provides
> sufficient guard.)

Good news! Thank you very much, Peter!

And actually, this patch is a bit older than I previously posted on LKML.

http://lkml.org/lkml/2009/12/18/312

Oops, I've forgotten update comment on patch... anyway, patch implementation
itself is updated and removed second sync_core_all.
I'll post it again with updated comment.

> In fact, if a suitable int3 handler is left permanently in place then
> step 5 is unnecessary as well.  This would slow down other uses of int3
> slightly, but might be a worthwhile tradeoff.

OK.

> Such a permanent int3 handler would need to keep track of two
> potentially-spurious breakpoints: the current and the previous.  The
> reason for needing two is that one could get a #BP from either the
> current or the previous modification site between the insertion of int3
> and the synchronization in step 2.  This, of course, assumes that the
> actual code poking is forcibly single-threaded (running under a spinlock
> or other mutex) -- if modifications are allowed to run in parallel you
> need to consider all possible current or stale #BP sites.

Sure, and since we are using fixmap for poking, we need to do this
under locking text_mutex.

Thank you!


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

