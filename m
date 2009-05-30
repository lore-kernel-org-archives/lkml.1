Return-Path: <linux-kernel-owner+w=401wt.eu-S932110AbZE3O3p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932110AbZE3O3p (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 May 2009 10:29:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759236AbZE3O3g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 May 2009 10:29:36 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:34769 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759012AbZE3O3f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 May 2009 10:29:35 -0400
To: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Cornelia Huck <cornelia.huck@de.ibm.com>, linux-fsdevel@vger.kernel.org,
       Kay Sievers <kay.sievers@vrfy.org>, Greg KH <greg@kroah.com>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
References: <m1zlcwltri.fsf_-_@fess.ebiederm.org>
	<1243551665-23596-4-git-send-email-ebiederm@xmission.com>
	<4A1FA777.3040200@kernel.org> <m1zlcvdf7j.fsf@fess.ebiederm.org>
	<4A210DEF.2030203@kernel.org> <m1d49qoi1o.fsf@fess.ebiederm.org>
	<4A21329A.10202@kernel.org>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Sat, 30 May 2009 07:29:28 -0700
In-Reply-To: <4A21329A.10202@kernel.org> (Tejun Heo's message of "Sat\, 30 May 2009 22\:20\:26 +0900")
Message-ID: <m1zlcuhdfb.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: tj@kernel.org, ebiederm@aristanetworks.com, greg@kroah.com, kay.sievers@vrfy.org, linux-fsdevel@vger.kernel.org, cornelia.huck@de.ibm.com, linux-kernel@vger.kernel.org, gregkh@suse.de, akpm@linux-foundation.org
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Tejun Heo <tj@kernel.org>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.1 XMSolicitRefs_0 Weightloss drug
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [PATCH 04/24] sysfs: Normalize removing sysfs directories.
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo <tj@kernel.org> writes:

> Hello,
>
> Eric W. Biederman wrote:
>> I guess we are going to have to disagree on this one.
>
> Yeap, seems like it.
>
>> My take is simply that a correct user has to wait until no one else
>> can find the kobject before calling kobject_del.  At which point
>> races are impossible, and it doesn't matter if sysfs_mutex is held
>> across the entire operation.
>
> This one also is a matter of degree.  Way back when users could crash
> sysfs reliably from userland, the sysfs code had a lot of assumptions
> about object lifetime and synchronizaion which even the sysfs code
> itself didn't really follow leading to fragility.  My focus while
> restructuring the code was to make the code behave as expected by the
> usual conventions.  It could be that I'm a bit paranoid about this,
> but in general I really don't like when low level code doesn't do its
> due diligence to save several hours of effort to implement clean
> semantics, but again there's nothing wrong with your due and my due
> being different.

Given a history of user space was crashing sysfs I can see where you
would be nervous.

I come from the perspective of sysfs still having bugs (although not
easily triggered), but the code is so complicated that people can't
see them because there is just so much code.  So I value every little
bit of extra simplicity I can.

>> For the long term I still intend to kill __sysfs_remove_dir.  Just
>> not in this patch series.
>
> Yeah, sysfs code is in the middle of two sane ways.  sysfs either has
> to deal with children creation/removal including atomicity of the
> operations or it should force its users to do so.  I prefer the former
> but any would be better than the current situation.

What user space cares about is that we perform the additions in
the following order:

kobject_add()
sysfs_add_file()
kobject_uevent()

So that when user space receives the event it can consult sysfs and
be safe in assuming all of the attributes for the device are present.

Since device_add calls kobject_uevent we must have all of the
attributes setup in a manner that device_add can add them to sysfs,
before device_add calls kobject_uevent.


So for most of the kernel today, the right solution is to setup attribute
groups and set them on the device before device_add is called.  For
most of the code that really isn't too hard.

Making that also to get all of the attributes removed in device_del
before sysfs_remove_dir is called.

So for the common case all of the complexity is handled at the device
layer today.

There are a few more cases but that just takes time.


When I add that to the fact that there are cases where sysfs simply
gets it wrong by deleting things like /sys/dev/char and
/sys/dev/block.  I can't see keeping __sysfs_remove_dir indefinitely.


Just adding my warning has turned up an issue in the scsi target vs
host lifetime rules that does the wrong thing in sysfs, and that isn't
something I can see sysfs making any easier by trying to be helpful.

Eric
