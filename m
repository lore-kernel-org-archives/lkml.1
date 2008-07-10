Return-Path: <linux-kernel-owner+w=401wt.eu-S932124AbYGJSwV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932124AbYGJSwV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 14:52:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754150AbYGJSwK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 14:52:10 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:41717 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753163AbYGJSwJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 14:52:09 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Mike Travis <travis@sgi.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Arjan van de Ven <arjan@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org,
       Rusty Russell <rusty@rustcorp.com.au>
References: <20080709165129.292635000@polaris-admin.engr.sgi.com>
	<m1abgqzv3g.fsf@frodo.ebiederm.org> <20080709200757.GD14009@elte.hu>
	<48751B57.8030605@goop.org> <20080709133958.612635f0@infradead.org>
	<4875231F.1020506@zytor.com> <487524A0.6020304@goop.org>
	<487529AE.3060505@zytor.com> <m1r6a2r9nj.fsf@frodo.ebiederm.org>
	<48753A71.2030006@zytor.com> <m18wwahauq.fsf@frodo.ebiederm.org>
	<48763732.7020805@sgi.com>
Date: Thu, 10 Jul 2008 11:48:39 -0700
In-Reply-To: <48763732.7020805@sgi.com> (Mike Travis's message of "Thu, 10 Jul
	2008 09:22:10 -0700")
Message-ID: <m1lk091soo.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Mike Travis <travis@sgi.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.0 BAYES_50 BODY: Bayesian spam probability is 40 to 60%
	*      [score: 0.4637]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [RFC 00/15] x86_64: Optimize percpu accesses
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Travis <travis@sgi.com> writes:

> Eric W. Biederman wrote:
> ...
>> Another alternative that almost fares better then a segment with
>> a base of zero is a base of -32K or so.  Only trouble that would get us
>> manually managing the per cpu area size again.
>
> One thing to remember is the eventual goal is implementing the cpu_alloc
> functions which I think we've agreed has to be "growable".  This means that
> the addresses will need to be virtual to allow the same offsets for all cpus.
> The patchset I have uses 2Mb pages.  This "little" twist might figure into the
> implementation issues that are being discussed.

I had not heard that.

However if you are going to use 2MB pages you might was well just use a
physical address at the start of a node.    2MB is so much larger then
the size of the per cpu memory we need today it isn't even funny.

To get 32K I had to round up on my current system, and honestly it is
important that per cpu data stay relatively small as otherwise the system
won't have memory to use for anything interesting.

I just took a quick look at our alloc_percpu calls. At a first glance
they all appear to be for relatively small data structures.  So we can
just about get away with doing what we do today for modules for everything.
The question is what to do when we fill up our preallocated size for percpu
data.

I think we can get away with just simply realloc'ing the percpu area
on each cpu.  No fancy table manipulations required.  Just update
the base pointer in %gs and in someplace global.

If you do use virtual addresses really requires using 4K pages, so we
can benefit from non-contiguous allocations.  I just can't imagine
the per cpu area getting up to 2MB in size, where you would need
multiple 2MB pages.  That is a huge jump from the 32KB I see today.


For the rest mostly I have been making a list of things that we can do
that could work.  A zero based percpu area is great if you can
eliminate it from suspicion of your weird random failures.

Eric
