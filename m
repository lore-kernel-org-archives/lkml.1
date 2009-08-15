Return-Path: <linux-kernel-owner+w=401wt.eu-S1752010AbZHOGBf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752010AbZHOGBf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Aug 2009 02:01:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751296AbZHOGBf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Aug 2009 02:01:35 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:40922 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751351AbZHOGBd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Aug 2009 02:01:33 -0400
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: "David P. Quigley" <dpquigl@tycho.nsa.gov>, jmorris@namei.org,
       Stephen Smalley <sds@tycho.nsa.gov>, gregkh@suse.de,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       selinux@tycho.nsa.gov
References: <1247665721-2619-1-git-send-email-dpquigl@tycho.nsa.gov>
	<4A84EF1D.8060408@schaufler-ca.com> <m1my62xde6.fsf@fess.ebiederm.org>
	<4A861291.1030404@schaufler-ca.com> <m1tz09j00q.fsf@fess.ebiederm.org>
	<4A864008.50907@schaufler-ca.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Fri, 14 Aug 2009 23:01:29 -0700
In-Reply-To: <4A864008.50907@schaufler-ca.com> (Casey Schaufler's message of "Fri\, 14 Aug 2009 21\:56\:40 -0700")
Message-ID: <m1my61sjie.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: casey@schaufler-ca.com, selinux@tycho.nsa.gov, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, gregkh@suse.de, sds@tycho.nsa.gov, jmorris@namei.org, dpquigl@tycho.nsa.gov
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Casey Schaufler <casey@schaufler-ca.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [PATCH] Security/sysfs: Enable security xattrs to be set on sysfs files, directories, and symlinks.
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Casey Schaufler <casey@schaufler-ca.com> writes:

> Eric W. Biederman wrote:
>> Casey Schaufler <casey@schaufler-ca.com> writes:
>>
>>   
>>> Actually, I see that as a justification for the special purpose
>>> scheme rather than a real issue. The real attribute data is going
>>> to take up the same amount of space regardless of how it gets
>>> managed. And Stephen is correct in thinking that is most cases
>>> where there are xattrs there will be only one. I don't see that
>>> a mechanism more elaborate than a list is going to gain much in
>>> real life. On the other hand, if you wanted to take the ball and
>>> run with it, I have a window manager to deal with.
>>>     
>>
>> If you look at things from the point of view of a single inode I would
>> have to agree that the storage costs are roughly the same however they
>> get managed.
>>
>> My understanding is that in most inodes all get a label from
>> a very small set of possible labels.
>>   
>
> Actually, my point is that most files that get xattrs get one xattr.
> The set of labels will be small for a Smack system or a real world
> MLS system. This is not true for SELinux, where the number of labels
> in flight at any given time can be .... large.

In the case of sysfs I don't think that is true enough to defeat the
optimization I am suggesting.  Right now selinux gets away with a
single label on sysfs (magically applied), and it is desired to have
one label per virtual machine.  The feature request that started this.

>> If that is true.  It makes sense to store the set of used labels
>> separately from the inodes.  Then on the inode just store a pointer
>> to the label.
>>   
>
> You have been reading the Smack code, haven't you?

No in this case.  Just trying to keep the sysfs data structures small
without giving up generality.  If I can pick some small static limits
and some simple optimizations for now that keep the size small.  The
entire reason we have sysfs_dirent is because people with lots of
hardware had enough problems with sysfs that they did the work.  So
someone cares (or at least cared) about the memory footprint.

Things like static limits are easy to work with.  If they are too
small we can always raise them later.

After seeing how much of a challenge the magic sysctl selinux handling
is I really would like to keep from having additional special cases
for kernel virtual filesystems.

>> Saying this in lisp parlance we should be able to use atoms instead of
>> strings.
>>   
>
> Sorry, but you're not old enough to be slinging lisp at me. (smiley)
> But yes, that is an apt comparison.
>
>> At which point we have (I believe) an implementation that is as practically
>> as efficient as what was originally proposed but as general and as maintainable
>> as your version.
>>
>> What I don't know is if the set of labels applied to a filesystem is actually
>> small, despite having a large number of labels applied.
>>   
>
> The question is whether you're more concerned with the xattr behavior
> or the LSM behavior. This is where the difference shows itself. If you
> look at the LSM, there is one value. If you look at xattrs, there may
> be many.

The xattr view is the general interface and what I would prefer to support.

> I personally think that the Right Thing(tm) is the xattr view. My
> experience is the LSM view. I hope that we don't shut off the Right
> Thing in preference to the issue of the day. I have been on both sides
> on this one.

Sure. That has been what was agreed to as a common abstraction to
filesystems.  Sysfs probably has special magic in SELinux for a
default label on all files but nothing else.  I don't see this
changing that.

If it is a valid optimization to inter atoms as the labels and just
hold a couple.  I think the implementation is roughly comparable in
size/complexity with what you have now, and likely to be a nicer in
the common case for the people who want to do play with labels and
sysfs.

If nothing else the footprint looks nicer.  Even if we use just as
much memory ;)

Eric

