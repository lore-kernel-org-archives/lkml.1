Return-Path: <linux-kernel-owner+w=401wt.eu-S1755370AbYA1T4T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755370AbYA1T4T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 14:56:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752035AbYA1T4J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 14:56:09 -0500
Received: from terminus.zytor.com ([198.137.202.10]:37737 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752009AbYA1T4I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 14:56:08 -0500
Message-ID: <479E3248.40409@zytor.com>
Date: Mon, 28 Jan 2008 11:51:36 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, Ingo Molnar <mingo@elte.hu>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Ian Campbell <ijc@hellion.org.uk>,
       =?ISO-8859-1?Q?Mika_Penttil=E4?= <mika.penttila@kolumbus.fi>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Ian Campbell <ijc@hellion.org.uk>
Subject: Re: [PATCH] x86: Construct 32 bit boot time page tables in native
 format.
References: <1201167544.30671.64.camel@cthulhu.hellion.org.uk> <200801252302.52164.rjw@sisk.pl> <20080128150022.GE27928@elte.hu> <200801281625.45165.rjw@sisk.pl> <20080128194017.GA4481@ucw.cz>
In-Reply-To: <20080128194017.GA4481@ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> Hi!
> 
>>>>  /*
>>>>   * Swap suspend & friends need this for resume because things like the intel-agp
>>>>   * driver might have split up a kernel 4MB mapping.
>>>>   */
>>>> -char __nosavedata swsusp_pg_dir[PAGE_SIZE]
>>>> +char swsusp_pg_dir[PAGE_SIZE]
>>> thanks, applied.
> 
> Sorry, this is subtle and I've overlooked it before.
> 
> (I thought you were only changing ifdef).
> 
> Now you memcpy() over pg_dir when that pgdir is in use during swsusp
> resume. Granted, you memcpy() with same data that already are there,
> but it may still do some funny effects.
> 
> Hmm, but same argument applies to lower levels of paging in 64-bit and
> PAE cases, and we still do that memcpy-over-active-pagetables there...
> :-(.
> 

This really comes down to the concept that we should keep an 
identity-mapped page table set around and keep it maintained. 
Maintenance should be relatively cheap -- we don't care about the 
vmalloc area (but if it's easier to have it, it won't cause any harm), 
and we already have to have code to synchronize the PGDs on !PAE and the 
PMDs on Xen (although that was supposedly getting fixed).  This is 
nothing very different than synchronizing yet another PGD[*] offset.

This obviously relates to (and needs to be on top of) the 
always-native-pagetables work.

[*] = Almost.  There is one exception: for 3 GB kernel:1 GB userspace, 
we must ensure that only 1 GB of the kernel area is synced.

	-hpa


