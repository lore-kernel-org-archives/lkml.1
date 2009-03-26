Return-Path: <linux-kernel-owner+w=401wt.eu-S1754362AbZCZDFp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754362AbZCZDFp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 23:05:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752844AbZCZDFe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 23:05:34 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:42445 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751591AbZCZDFb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 23:05:31 -0400
To: Tejun Heo <htejun@gmail.com>
Cc: Alex Chiang <achiang@hp.com>, greg@kroah.com, cornelia.huck@de.ibm.com,
       stern@rowland.harvard.edu, kay.sievers@vrfy.org, rusty@rustcorp.com.au,
       linux-kernel@vger.kernel.org
References: <20090325035707.15921.42150.stgit@bob.kio>
	<m13ad2xi46.fsf@fess.ebiederm.org>
	<20090325225414.GA11447@ldl.fc.hp.com>
	<m17i2dunao.fsf@fess.ebiederm.org> <49CADB45.3090501@gmail.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Wed, 25 Mar 2009 20:05:24 -0700
In-Reply-To: <49CADB45.3090501@gmail.com> (Tejun Heo's message of "Thu\, 26 Mar 2009 10\:32\:53 +0900")
Message-ID: <m163hxrnkb.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=67.169.126.145;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.169.126.145
X-SA-Exim-Rcpt-To: htejun@gmail.com, linux-kernel@vger.kernel.org, rusty@rustcorp.com.au, kay.sievers@vrfy.org, stern@rowland.harvard.edu, cornelia.huck@de.ibm.com, greg@kroah.com, achiang@hp.com
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Tejun Heo <htejun@gmail.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  3.0 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.5 XM_Body_Dirty_Words Contains a dirty word
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  1.0 XMSolicitRefs_1 XMSolicitRefs_1
Subject: Re: [RFC PATCH 0/3] sysfs: allow suicide
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo <htejun@gmail.com> writes:

> Thanks for the points.  I do agree that it could be a bit too clever,
> but the thing is that protecting the code area from going underneath
> something is a pretty special thing to begin with and I think it's
> better to apply special solution rather than trying to work around it
> using general mechanisms.  So, I actually think the global inhibit
> thing is one of the better ways to deal with the nasty-in-nature
> problem.

Protecting the data structures from going away is just as important,
and the module_inhibit does not address that.

When I looked at it I could not see any touches of kobj in the sysfs
code after we dropped the reference count in a strange place, but
I haven't been able to convince myself that we will be safe.

>>>> My hypothesis is once we solve this for the general case of
>>>> device hotplug and removal we won't need special support from
>>>> sysfs.  At least not in the suicidal way.
>>> I agree that we have problems in our infrastructure, especially,
>>> as you point out, overlapping device trees, etc.
>
> I don't really see how some grand general solution would solve
> deadlock problem at sysfs layer, care to elaborate a bit?

See below.  I'm really not thinking of doing anything different
just putting the code somewhere different that sysfs.

>>> I see your point about adding extra cruft into sysfs to work
>>> around a special case while leaving the hard problem unsolved.
>>>
>>> Perhaps the status quo is better. I do think that getting
>>> suicidal sysfs attributes off the global workqueue is a band-aid
>>> that actually helps, vs. the proposed patches here which are
>>> questionable in nature.
>> 
>> Sounds like it.    I'm not trying to shoot this down, rather
>> I'm trying to figure out how to solve this cleanly, as I am slowly
>> trying to sort out the pci hotplug and unplug issues.
>
> The problem I see is that there aren't too many users and the solution
> is a bit too narrow focused, but with increasing support for
> hotplug/unplug, I think the problem is becoming more widespread and
> the workqueue solution is quite fragile and cumbersome for each and
> every user, so unless there are other directions we can pursue (the
> general one above maybe?), I think it's better to add a bit of
> complexity to sysfs rather than forcing everyone user of it to do it.

My view is that this is a general hotplug problem and not a sysfs problem.
Further I see inhibiting module reload as only solving have the problem
as dropping the kobject reference opens a window to a use after free on
the kobj.

The problem that I see is that we are missing support from the device
model for hotunplug.  Running the device remove method from process
context is required.  Typically hotplug controllers discover a
device has been removed or will be removed in interrupt context.

Therefore every hotplug driver I have looked at has it's own workqueue
to solve the problem of getting the notification of a hotplug event
from an inappropriate context.

So the general problem that I see is that I need a solution to trigger
a remove from interrupt context and that same solution will happen to
work just fine for sysfs.

Eric
