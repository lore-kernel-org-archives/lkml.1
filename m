Return-Path: <linux-kernel-owner+w=401wt.eu-S1756594AbYHUIYg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756594AbYHUIYg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 04:24:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754484AbYHUIYI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 04:24:08 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:57302 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753067AbYHUIYA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 04:24:00 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andi Kleen <andi@firstfloor.org>
Cc: torvalds@osdl.org, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@linux.intel.com>
References: <1218865985-23403-1-git-send-email-andi@firstfloor.org>
	<m1myj63neb.fsf@frodo.ebiederm.org>
	<20080821064009.GB18831@one.firstfloor.org>
Date: Thu, 21 Aug 2008 01:14:18 -0700
In-Reply-To: <20080821064009.GB18831@one.firstfloor.org> (Andi Kleen's message
	of "Thu, 21 Aug 2008 08:40:09 +0200")
Message-ID: <m1abf6vl7p.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Andi Kleen <andi@firstfloor.org>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [PATCH] Move sysctl check into debugging section and don't make it default y
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen <andi@firstfloor.org> writes:

>> What is a feature change like this doing coming in after the
>> merge window?
>
> I considered it a "anti bloat bugfix". Adding 30k of 
> object code to allno was a bit too much. 
>
>> Why doesn't an allnoconfig disable sysctl all together?
>
> Because it depends on EMBEDDED and EMBEDDED is not y. Yes it's not
> intuitive, on the other hand the end result is reasonable.

That makes sense in a silly sort of way.  Making
allnoconfig not a particularly good minimal size check.

>> These are the only checks we have against someone doing something
>> nasty in the sysctl hierarchy.   We have proven that we don't
>> have the discipline to do the right thing with code in the
>> core kernel.  I expect out of tree code will be much worse.
>
> My assumption is that they will be run at least once during
> a release cycle by someone and then the messages will appear
> and be reported. We do the same thing with a lot of other
> debug options (lockdep, slab debug, sleep debug etc.,). There's no 
> need for this one to be special.

But it really isn't a debug option.

> Also I'm not sure the check is all that useful anyways. We
> should just not accept any new binary numbered sysctl, and
> that's nearly the case anyways.

This code is the mechanism by which we do not accept any
new binary numbered sysctl into the kernel.

Andrew used to get them just often enough that I would get a message
ever couple of months.  What and why is our policy with respect to new
binary sysctls?

Since this code has yet to ship in any enterprise kernel to my knowledge
I expect there are going to be another raft load of kernel bugs discovered
in out of tree code when it does.  We have a decade or more of near
total neglect to make up for.

As for what the code does.  There is one big expensive (space wise)
check in there that ensures we don't add new sysctl binary names.
Beyond that the checks that sysctl_check performs are actual sanity
checks with the only expensive one being to ensure we don't register
the same name twice.  Real code hits those checks, and frequently not
in development, but in some weird production scenario.  And the code
only runs when we register a sysctl so it is cheap.

Which is the big difference between this code and debugging checks,
even when enabled it barely ever runs.

Now if you would like to fix the size issue.  The thing to do is to
add a type field or a conversion function onto those tables.  Which is
enough to implement all of our binary sysctls by looking up the ascii
equivalents and calling the proc handling functions.  Then those tables
would be much more then dead weight.

Eric
