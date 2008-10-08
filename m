Return-Path: <linux-kernel-owner+w=401wt.eu-S1757879AbYJHAqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757879AbYJHAqT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 20:46:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753934AbYJHAqE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 20:46:04 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:36824 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753459AbYJHAqC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 20:46:02 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Greg KH <greg@kroah.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
       Benjamin Thery <benjamin.thery@bull.net>, linux-kernel@vger.kernel.org,
       "Serge E. Hallyn" <serue@us.ibm.com>, Al Viro <viro@ftp.linux.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Tejun Heo <tj@kernel.org>
References: <48D7AC44.6050208@bull.net> <20080922153455.GA6238@kroah.com>
	<48D8FC1E.6000601@bull.net> <m1k5d2oh4y.fsf@frodo.ebiederm.org>
	<20081003101331.GH28946@ZenIV.linux.org.uk>
	<20081005053236.GA9472@kroah.com> <m1bpxwajyy.fsf@frodo.ebiederm.org>
	<20081007222726.GA9465@kroah.com>
Date: Tue, 07 Oct 2008 17:39:05 -0700
In-Reply-To: <20081007222726.GA9465@kroah.com> (Greg KH's message of "Tue, 7
	Oct 2008 15:27:26 -0700")
Message-ID: <m1hc7nj4ye.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=mx04.mta.xmission.com;;;ip=24.130.11.59;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Rcpt-To: too long (recipient list exceeded maximum allowed size of 128 bytes)
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Greg KH <greg@kroah.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.0 BAYES_50 BODY: Bayesian spam probability is 40 to 60%
	*      [score: 0.4701]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: sysfs: tagged directories not merged completely yet
X-SA-Exim-Version: 4.2.1 (built Thu, 07 Dec 2006 04:40:56 +0000)
X-SA-Exim-Scanned: Yes (on mx04.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH <greg@kroah.com> writes:

> On Tue, Oct 07, 2008 at 01:27:17AM -0700, Eric W. Biederman wrote:
>> Unless someone will give an example of how having multiple superblocks
>> sharing inodes is a problem in practice for sysfs and call it good
>> for 2.6.28.  Certainly it shouldn't be an issue if the network namespace
>> code is compiled out.  And it should greatly improve testing of the
>> network namespace to at least have access to sysfs.
>
> But if the network namespace code is in?  THen we have problems, right?

Possibly.  Tejun and I looked at it a while ago and could not see any
problems that you could trigger by having multiple superblocks share
the same inodes but there might be some.  I don't like that aspect
of it any more than Al does, I just haven't found an alternative
that works, nor have I seen a suggestion that is better.

> And that's the whole point here.

And my point is that compared to the other bugs Al found in sysfs
my contribution is miniscule and minor, and pretty much fixed
at this point.

Do I have to rewrite all of sysfs to the point where Al can not find
bugs in it before I can merge my changes?

If that is the standard while it seems ridiculous I can work with
it.  I need something i can work with.

> The fact that you are trying to limit userspace view of in-kernel data
> structures, based on that specific user, is, in my opinion, crazy.
>
> Why not just keep all users from seeing sysfs, and then have a user
> daemon doing something on top of FUSE if you really want to see this
> kind of stuff.

As Serge said.  The problem is very simply that with the network
namespaces we create devices in different namespaces that have
the same name.  lo being the first one we hit.  It wasn't my
idea to export them to sysfs but it has happened.

We need a way to put those devices in sysfs that doesn't break
sysfs and is in some form backwards compatible with code that
is running today.

Given that there is at least one directory per physical NIC
in sysfs that I need to handle, the easiest approach I have
found is simply to have a way of having entries with the
same name in the same directory and have a filter on the superblock
of sysfs so different ones are shown.

> The "leakage" just seems too hard to stop.

The goal is not to hide the fact you are in anamespace.  So
information "leakage" isn't a problem.  I simply need a configuration
where something works.

If I could do what I am trying to do with FUSE I would be happy to
do it that way, and for more esoteric things I have actively suggested
it.

> I know how the whole "we'll go back later and fix it up" stuff works,
> I've used that excuse too many times in the past myself.  Never happens
> :)

Sometimes.  That has to be balanced against the it is pointless to
submit patches effect.  Which I am feeling pretty strongly right now.

A lot of false criticism and what feels like over reaction mixed in
with the few real bugs.

>> Greg I agree with Al that sysfs isn't perfect but we sure aren't going
>> to fix it if you keep dropping or taking years to merge every patch
>> from the people working on it, and then dropping those patches because
>> someone frowns at them.
>
> "years"?  Come on, these did take a while due to travel and other stuff.

Yes.  "years".  This last round hasn't been too bad in comparison
3-4 months.  Just before the start of the previous merge window to now.

> These are core kernel changes, and need time to ensure that they work
> properly, and get the proper review from people who understand this kind
> of stuff.

I totally agree.  And for that I have no problem if they are not merged
into the stable release.  At the same time if they are not at least in
a tree that merges into linux-next no one takes them seriously and the
code is just ignored.

> And to call Al a generic "someone", is just rude and disrespectful.  I
> trust his opinion in this area far more than I do yours, to be honest.

> This whole series is dropped, if you want to resubmit them, feel free
> to, _after_ adressing his issues.

His issues are that sysfs has problems.

Except for one I have already addressed Al's issues that were in my code.

Greg do you understand sysfs well enough to know if I have addressed Al's issues?

> bah,

Eric
