Return-Path: <linux-kernel-owner+w=401wt.eu-S1755796AbYGFJbz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755796AbYGFJbz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 05:31:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751960AbYGFJbr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 05:31:47 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:36267 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752126AbYGFJbp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 05:31:45 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Marcin Slusarz <marcin.slusarz@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, Frans Pop <elendil@planet.nl>
References: <20080705131924.GA2083@joi>
	<20080705235148.GW28946@ZenIV.linux.org.uk>
	<20080706001148.GX28946@ZenIV.linux.org.uk>
	<20080706040519.GZ28946@ZenIV.linux.org.uk>
	<m1hcb31p8p.fsf@frodo.ebiederm.org>
	<20080706081126.GA28946@ZenIV.linux.org.uk>
Date: Sun, 06 Jul 2008 02:25:30 -0700
In-Reply-To: <20080706081126.GA28946@ZenIV.linux.org.uk> (Al Viro's message of
	"Sun, 6 Jul 2008 09:11:26 +0100")
Message-ID: <m1tzf3z7n9.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Al Viro <viro@ZenIV.linux.org.uk>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.2 BAYES_40 BODY: Bayesian spam probability is 20 to 40%
	*      [score: 0.2126]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.5 XM_Body_Dirty_Words Contains a dirty word
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [PATCH] parport/ppdev: fix registration of sysctl entries
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro <viro@ZenIV.linux.org.uk> writes:

> On Sat, Jul 05, 2008 at 11:49:26PM -0700, Eric W. Biederman wrote:
>> So our choices appear to be.
>> - Change the name in sysctl so each parport device always has a unique name.
>> - Only allow one opener of ppdev for a given port.
>
> Can't do - it's a legitimate use of ppdev (several userland programs
> multiplexing the sucker).

Yep. And if didn't happen we wouldn't have the bug report.
>
>> - Take the approach of the initial patch and export to sysctl when we claim
>>   the port and unexport when we release the port.
>
> You do realize that we need exclusion around that lazy registration in
> any case?  sysctl is not the only problem there...

Totally.  I was giving credit to the general idea rather then refering
to specific implementation details.

>> - Give up and simply don't register with sysctl for ppdev.
>> 
>> I did a quick google search and I could not find any hits (except for
>> this bug report on devices/ppdev) so I am inclined just to special
>> case ppdev and not even bother registering with sysctl.  I did not
>> see any other fields that would have problems with a duplicate name.
>> 
>> The only other backwards compatible and viable approach appears
>> to be registering ppdev parport devices when they are claimed.
>> 
>> The only reason we would be able to change the name without breakage
>> is if no one uses the /proc interface in which case I don't see a
>> point in continuing to provide it for ppdev.
>
> Not quite.  /proc/sys/.../timeslice is a generically documented way to
> tune the damn thing when we have several things on the same port.  Note
> that while one of those might be in userland, the rest might be in kernel
> and very different.  In this case the parameter is both relevant *and*
> currently usable.

Yes.  I was only thinking about killing it off for ppdev.   You do have a point
something that is tuning this based on all openers could be looking at it
generically.

> Frankly, I'd go for IDR and rename in cases when we have additional openers.
It looks like we can walk port->physport->devices to see if we are the
first ppdev to register.  So that should not be too hard.

That will provide maximum compatibility.  Right now the first ppdev on
a minor shows up in sysctl and the rest error out sysctl wise.  Having
the others show up at a different name is exactly equivalent except
that they show up.

The unfortunate thing is that we won't have a good way to tie those
additional sysctl entries back to whoever opened them.  Oh well.

> _And_ add a mutex around delayed allocation - that's a separate problem.

Yes.  We need locking so that only one process can set or clear PP_CLAIMED.

Eric
