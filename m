Return-Path: <linux-kernel-owner+w=401wt.eu-S1754047AbZCKXxj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754047AbZCKXxj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 19:53:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750897AbZCKXx3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 19:53:29 -0400
Received: from gw.goop.org ([64.81.55.164]:36616 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750752AbZCKXx3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 19:53:29 -0400
Message-ID: <49B84EF5.3090705@goop.org>
Date: Wed, 11 Mar 2009 16:53:25 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       the arch/x86 maintainers <x86@kernel.org>,
       Yinghai Lu <yinghai@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] x86: add brk allocator for very early allocations
References: <49B7EDF4.7060904@goop.org> <m1mybrzx1x.fsf@fess.ebiederm.org>
In-Reply-To: <m1mybrzx1x.fsf@fess.ebiederm.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> extend_brk is the wrong way to go.  We already have a better mechanism.
> find_e820_early paired with reserve_early.
>   

No doubt that's a better option when available.  But I want to allocate 
earlier than that.

> Allocating the early page tables are a very special case.   There is
> a case for cleaning up that mechanism and making more comprehensible.
> We should not be generalizing it, and making the kernel more fragile.
>   

More fragile?  I don't see that extend_brk() is a particularly fragile 
mechanism.  I guess a user could start over-using it and running out of 
the initial space.  That would fail in a fairly unambiguous way (there's 
a BUG_ON checking for an attempt to extend beyond __brk_limit), and 
would definitely be an abuse of the call.

My motivation for this patch is to dynamically allocate things very 
early, before the e820 map is available.  Specifically, I want to 
dynamically allocate various Xen datastructures which would otherwise 
statically waste space in the bss (in the case where you're running a 
Xen-enabled kernel on a non-Xen system).  It also allows me to scale 
them according to the memory size, etc.  I need to do this before e820 
is available; indeed, I need to do it to synthesize an appropriate e820 
map for the kernel to consume.

It is also nice that it generalizes head_32.S's pagetable construction, 
and mops up the bespoke DMI allocator.  There may well be some other 
potential users.  I think any static data in bss is fair game, 
particularly if it is only used conditionally.

    J
