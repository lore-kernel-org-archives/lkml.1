Return-Path: <linux-kernel-owner+w=401wt.eu-S1763949AbZE3VU5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763949AbZE3VU5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 May 2009 17:20:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760670AbZE3VUr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 May 2009 17:20:47 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:43407 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756663AbZE3VUq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 May 2009 17:20:46 -0400
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Cornelia Huck <cornelia.huck@de.ibm.com>, linux-fsdevel@vger.kernel.org,
       Kay Sievers <kay.sievers@vrfy.org>, Greg KH <greg@kroah.com>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
References: <m1zlcwltri.fsf_-_@fess.ebiederm.org>
	<1243551665-23596-4-git-send-email-ebiederm@xmission.com>
	<4A1FA777.3040200@kernel.org> <m1zlcvdf7j.fsf@fess.ebiederm.org>
	<4A210DEF.2030203@kernel.org> <m1d49qoi1o.fsf@fess.ebiederm.org>
	<1243693199.5223.5.camel@mulgrave.int.hansenpartnership.com>
	<m1bppaei52.fsf@fess.ebiederm.org>
	<1243698667.5223.12.camel@mulgrave.int.hansenpartnership.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Sat, 30 May 2009 14:20:35 -0700
In-Reply-To: <1243698667.5223.12.camel@mulgrave.int.hansenpartnership.com> (James Bottomley's message of "Sat\, 30 May 2009 15\:51\:07 +0000")
Message-ID: <m17hzyb84c.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: James.Bottomley@HansenPartnership.com, ebiederm@aristanetworks.com, greg@kroah.com, kay.sievers@vrfy.org, linux-fsdevel@vger.kernel.org, cornelia.huck@de.ibm.com, linux-kernel@vger.kernel.org, gregkh@suse.de, akpm@linux-foundation.org, tj@kernel.org
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;James Bottomley <James.Bottomley@HansenPartnership.com>
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
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Bottomley <James.Bottomley@HansenPartnership.com> writes:

>> >> My take is simply that a correct user has to wait until no one else
>> >> can find the kobject before calling kobject_del.  At which point
>> >> races are impossible, and it doesn't matter if sysfs_mutex is held
>> >> across the entire operation.
>> >
>> > I'm afraid this one isn't a valid assumption.  If you look in SCSI,
>> > you'll see we do get objects after they've been removed from visibility.
>> > We use it as part of the state model for how our objects work (objects
>> > removed from visibility are dying, but we still need them to be findable
>> > (and gettable).
>> 
>> I was not precise enough.  It appears I overlooked the fact that
>> kobject_del is not always called from kobject_put by way of
>> kobject_release.
>
> OK ... just so you understand, I'm thinking about the device model
> rather than kobjects.  device_del() can't be called from release methods
> because they're often called from interrupt context and the mutex
> requirements in device_del() mean it needs user context.

Makes sense.

>> Strictly the requirement is that after kobject_del we don't add,
>> remove or otherwise manipulate sysfs attributes.  That is we don't
>> call any of:
>> 
>> sysfs_add_file
>> sysfs_create_file
>> sysfs_create_bin_file
>> sysfs_remove_file
>> sysfs_remove_bin_file
>> sysfs_create_link
>> sysfs_remove_link
>> sysfs_create_group
>> sysfs_remove_group
>> sysfs_create_subdir
>> sysfs_remove_subdir
>> 
>> 
>> Those all either oops or BUG today if you try it.  So I can't see how
>> a subsystem could depend on those working.
>
> It doesn't; you've altered your requirement.  We can fully buy into this
> new relaxed one.

My apologies for misstating it earlier.  Sometimes translating what
is happening in sysfs up to the device model can be a bit of a challenge.

At the sysfs layer the requirement is all the same.  Don't mess with a
directory as or after you have deleted it.


To recap, my change that Tejun has a problem with is simply that I have
refactored sysfs_remove_dir so that if there are directory entries
present.  A very fast observer in the kernel or in user space can see
each directory entry being deleted individually.  Before I delete the
directory itself.

This is because I now drop and reacquire the sysfs_mutex in between
each delete.

As the upper layers must already avoid messing with the attributes
of a sysfs directory from the time we call kobject_del I don't
see that this makes any difference to them.

>> Also there is sysfs_remove_dir (on a subdirectory) aka kobject_del on
>> a child object after kobject_del on the parent object.
>> 
>> As best I can tell that only works by fluke today.
>
> Yes, that's an artifact of the fact that the reference counted lifecycle
> is on release ... del just happens at a certain point in it.  We don't
> hold any counters that tell us what the visibility of our children are,
> so it's possible to make a parent invisible by calling del simply
> because you don't know.

Strictly speaking my changes don't affect this part either except to
issue a warning that something unexpected is going on.

Eric
