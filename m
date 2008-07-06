Return-Path: <linux-kernel-owner+w=401wt.eu-S1756549AbYGFGwA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756549AbYGFGwA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 02:52:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751803AbYGFGvx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 02:51:53 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:40408 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751544AbYGFGvw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 02:51:52 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Marcin Slusarz <marcin.slusarz@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, Frans Pop <elendil@planet.nl>
In-Reply-To: <20080706040519.GZ28946@ZenIV.linux.org.uk> (Al Viro's message of
	"Sun, 6 Jul 2008 05:05:19 +0100")
References: <20080705131924.GA2083@joi>
	<20080705235148.GW28946@ZenIV.linux.org.uk>
	<20080706001148.GX28946@ZenIV.linux.org.uk>
	<20080706040519.GZ28946@ZenIV.linux.org.uk>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
Date: Sat, 05 Jul 2008 23:49:26 -0700
Message-ID: <m1hcb31p8p.fsf@frodo.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Al Viro <viro@ZenIV.linux.org.uk>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.7 BAYES_20 BODY: Bayesian spam probability is 5 to 20%
	*      [score: 0.1764]
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

> On Sun, Jul 06, 2008 at 01:11:48AM +0100, Al Viro wrote:
>> On Sun, Jul 06, 2008 at 12:51:48AM +0100, Al Viro wrote:
>> 
>> > I don't believe that it's right.  Note that if you *do* race there, you
>> > are fucked regardless of sysctls - ppdev.c::register_device() racing
>> > with itself will do tons of fun things all by itself (starting with two
>> > threads allocating different pdev and both setting pp->pdev).
>> > 
>> > IOW, *if* that's what we are hitting here, you've only papered over the
>> > visible symptom.
>> 
>> BTW, with your patch you'll have 100% reproducible double registration if
>> you do PPCLAIM/PPRELEASE/PPCLAIN on one file descriptor.
>
> FWIW, here's what's going on in ppdev:
> 	a) we *are* allowed to create several pardevice over the same
> port, one per each open().  Each is essentially a parport scheduling
> entity.  So far, so good.
> 	b) creation is actually delayed until an ioclt (PPCLAIM).  That
> appears to be a result of shitty API (another ioctl (PPEXCL) instead of
> just using O_EXCL at open() time, as any normal driver would).  In any
> case, it's badly racy - two tasks doing PPCLAIM on the same struct file
> (e.g. one had opened it, then called fork(), then both child and parent
> had called ioctl(fd, PPCLAIM, 0)) can race, leading to rather nasty
> effects.  Check for delayed registration + register_device() call should
> be atomic.  That's solvable by a mutex.
> 	c) *HOWEVER*, all races aside, we have a genuinely fscked up
> API.  Each of these parport scheduling entities has a parameter - timeslice.
> That parameter is exposed as sysctl.  And we definitely want these per-open,
> not per-port.  And we get everything for the same port mapped to the same
> sysctl.

It isn't quite that bad.  Every other user of parport_register_device uses
a compile time unique name.  Only ppdev allows multiple callers to
reuse the same name.

So our choices appear to be.
- Change the name in sysctl so each parport device always has a unique name.
- Only allow one opener of ppdev for a given port.
- Take the approach of the initial patch and export to sysctl when we claim
  the port and unexport when we release the port.
- Give up and simply don't register with sysctl for ppdev.

I did a quick google search and I could not find any hits (except for
this bug report on devices/ppdev) so I am inclined just to special
case ppdev and not even bother registering with sysctl.  I did not
see any other fields that would have problems with a duplicate name.

The only other backwards compatible and viable approach appears
to be registering ppdev parport devices when they are claimed.

The only reason we would be able to change the name without breakage
is if no one uses the /proc interface in which case I don't see a
point in continuing to provide it for ppdev.

Eric
