Return-Path: <linux-kernel-owner+w=401wt.eu-S1754054AbYGBEB4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754054AbYGBEB4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 00:01:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750706AbYGBEBp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 00:01:45 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:45233 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750701AbYGBEBn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 00:01:43 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Tejun Heo <htejun@gmail.com>
Cc: Benjamin Thery <benjamin.thery@bull.net>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Daniel Lezcano <dlezcano@fr.ibm.com>, Serge Hallyn <serue@us.ibm.com>,
       linux-kernel@vger.kernel.org, Al Viro <viro@ftp.linux.org.uk>,
       Linux Containers <containers@lists.osdl.org>
References: <20080618170729.808539948@theryb.frec.bull.fr>
	<20080618170731.002784342@theryb.frec.bull.fr>
	<485F04E1.70204@gmail.com> <m1y74svtff.fsf@frodo.ebiederm.org>
	<486706C9.9040303@gmail.com> <m18wwmsqdv.fsf@frodo.ebiederm.org>
	<4869D314.5030403@gmail.com> <m1ej6enep7.fsf@frodo.ebiederm.org>
	<486A0751.9080602@gmail.com> <m1wsk5hjm0.fsf@frodo.ebiederm.org>
	<486AF4FA.8020805@gmail.com>
Date: Tue, 01 Jul 2008 20:53:00 -0700
In-Reply-To: <486AF4FA.8020805@gmail.com> (Tejun Heo's message of "Wed, 02 Jul
	2008 12:24:42 +0900")
Message-ID: <m1ej6d9c2r.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Tejun Heo <htejun@gmail.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0007]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [PATCH 06/11] sysfs: Implement sysfs tagged directory support.
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo <htejun@gmail.com> writes:

> Hello,
>
> Eric W. Biederman wrote:
>> What we are implementing is not, a sb with a set of tags that are displayed,
>> but directories with a single tag that is displayed.  The sb just happens
>> to hold the state for the directories.
>> 
>> A directory displaying only a single tag is an necessary constraint for
>> a large number of reasons.
>
> Okay, that isn't exactly the impression I get but... well.  Let's see.

Well one of those reasons is not having duplicate entries in your directory listing.
That is much harder otherwise.

> A few things...
>
> 1. The lookup is currently done linearly and is fast enough for now.
> Also, most lookup ops are cached by vfs layer.  I'm not sure how
> probable it is that we're gonna need hash or tree based sd lookup.

I don't know how bad sysfs is.  On the sysctl side I have people complaining
because I am doing a lookup during insert and that lookup is linear.  Sysfs
appears to have the same complexity as sysctl but just smaller constants.

>> That is just one important aspect of it.   We need a way to describe
>> which tag a sb,directory pair displays.  It is a fundamental concept.
>
> For netns, yes.  I just think it would be better if the sysfs mechanism
> to support that concept is more generic especially because it doesn't
> seem too difficult to make it that way.

Well the envisioned use is for other namespaces and they all are similar
to the network namespace in that way.

>>>> Cause you to view an the tags as dynamic?
>>> The thing is that I don't really see why there's tagged_dir_ops at all.
>> 
>> We need callbacks for interfacing with the kobject layer, and for
>> selecting our set of tags at mount time.  Not tagged_dir_ops so much
>> as tagged_type_ops.
>
> The kobject op seems a bit strange way to interface to me.  For mount,
> yeah, we'll need a hook somewhere or pass it via mount option maybe.

I will look how if there is a place in the kobject layer to put it.  With
a second but noticeably different user I can compare and see how hard that will be.

>>> 3. enable / disable tag on a sb
>>      Disagree that is too flexible.  Tags on a sb need to be
>>      unchanging or else we get vfs layer issues.
>
> Yeah, this really should be something which can't change once it's mounted.
The VFS chokes otherwise because it can't cache things properly.

>>     Further the abstraction is logically exactly one tag on a
>>     (sb,directory) pair.
>
> I'm not so sure here.  As a policy, maybe but I don't really see a
> fundamental reason that the mechanism should enforce this.

Well in the first implementation.

>> 4. Interface with the kobject layer.
>>    kobject_add calls sysfs_create_dir
>>    kboject_rename calls sysfs_rename_dir 
>>    kobject_del calls sysfs_remove_dir
>> 
>>    For the first two operations we need a helper function to go from a
>>    kobject to a tag.
>
> Why not just add a parameter to sysfs_create_dir()?  It's just twisted.

I added it where it was easiest.  Adding a parameter to sysfs_create_dir
simply means I have to add the function to the kobject layer.  It is certainly
worth a second look though.

>> We need helper functions for interfacing with the rest of the kernel. 
>
> Yes, that's why I view it as strange.  These can be done in forward way
> (by passing in mount options and/or arguments) but it's done by first
> going into the sysfs and then calling back out to outer layer.

Well in the case of mount the default parameter at least is current, and
there are good reasons for that.

On the other side I can't pass a tag through from the device layer to
the kobject layer.  It isn't a concept the kobject layer supports.

At least though the conversation is in relative agreement.  I will refresh
the patches shortly and see where we are at.

Eric

