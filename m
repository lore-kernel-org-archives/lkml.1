Return-Path: <linux-kernel-owner+w=401wt.eu-S1755011AbZERE5w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755011AbZERE5w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 00:57:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750779AbZERE5l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 00:57:41 -0400
Received: from claw.goop.org ([74.207.240.146]:58967 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750739AbZERE5k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 00:57:40 -0400
Message-ID: <4A10EAC4.9070701@goop.org>
Date: Sun, 17 May 2009 21:57:40 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>, Ingo Molnar <mingo@elte.hu>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>
Subject: Re: [GIT PULL] xen /proc/mtrr implementation
References: <1242170864-13560-1-git-send-email-jeremy@goop.org>	<20090513133021.GA7277@elte.hu> <4A0ADBA2.2020300@goop.org>	<20090515182757.GA19256@elte.hu> <4A0DCC11.10307@goop.org>	<m1my9ex818.fsf@fess.ebiederm.org> <4A0DFF78.6000501@goop.org>	<20090515202250.0f1218ef@jbarnes-g45> <m1iqk1k708.fsf@fess.ebiederm.org>
In-Reply-To: <m1iqk1k708.fsf@fess.ebiederm.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> There are only 3 states that are interesting.  WB UC and WC.  Since
> Xen controls the page tables anyway.  I expect it can even remap
> it feels like it.
>   

It would be awkward.  A paravirtualized guest has direct access to the 
real pagetables, and so would notice if Xen swizzled around the PAT bits 
when it reads back a pagetable entry.  We don't currently have any 
paravirtualized hooks for adjusting the PTE flags, because there hasn't 
been any need, and it would probably be pretty costly (lots of 
read+bit-tests would turn into a function call).  On the other hand, 
there's probably only a few places (if any) in the kernel which actually 
inspect the PAT status of an established PTE, so we could put in some 
special case mapping there.  It becomes a maintenance burden to 1) track 
down all the right places, and then 2) make sure any new instances get 
handled properly.  So, not a preferred solution, I think.

But our planned approach is to simply make Xen use the same PAT layout 
as Linux, and go from there.  We still need to sort out the details of 
how to handle other Xen guests which use the existing Xen PAT setup, how 
to verify that Xen and the guest kernel are really using the same setup, 
etc.

But since we support the last few year's worth of released versions of 
Xen, we still need to handle the PAT-not-supported case with reasonable 
grace.

> I won't argue that having MTRRs when you can makes sense.  It is a bit
> weird in a vitalized system.

It's not really virtualized.  We're talking about dom0, which is the 
guest domain which has access to the real machine's real hardware; the 
MTRR is part of that.

>   At a practical level there are an
> increasing number of systems for which MTRRs are unusable because the
> BIOS sets up overlapping mtrrs.  With cheap entry level systems
> shipping with 4G I expect it is becoming a majority of systems.
>   

Yes, but that is true irrespective of Xen.

    J
