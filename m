Return-Path: <linux-kernel-owner+w=401wt.eu-S1760718AbZE3NIH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760718AbZE3NIH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 May 2009 09:08:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757956AbZE3NHz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 May 2009 09:07:55 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:53373 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757873AbZE3NHy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 May 2009 09:07:54 -0400
To: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Cornelia Huck <cornelia.huck@de.ibm.com>, linux-fsdevel@vger.kernel.org,
       Kay Sievers <kay.sievers@vrfy.org>, Greg KH <greg@kroah.com>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
References: <m1zlcwltri.fsf_-_@fess.ebiederm.org>
	<1243551665-23596-4-git-send-email-ebiederm@xmission.com>
	<4A1FA777.3040200@kernel.org> <m1zlcvdf7j.fsf@fess.ebiederm.org>
	<4A210DEF.2030203@kernel.org>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Sat, 30 May 2009 06:07:47 -0700
In-Reply-To: <4A210DEF.2030203@kernel.org> (Tejun Heo's message of "Sat\, 30 May 2009 19\:43\:59 +0900")
Message-ID: <m1d49qoi1o.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: tj@kernel.org, ebiederm@aristanetworks.com, greg@kroah.com, kay.sievers@vrfy.org, linux-fsdevel@vger.kernel.org, cornelia.huck@de.ibm.com, linux-kernel@vger.kernel.org, gregkh@suse.de, akpm@linux-foundation.org
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Tejun Heo <tj@kernel.org>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
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

> Eric W. Biederman wrote:
>>   Also, I'm quite uncomfortable with these things
>>> being done in non-atomic manner.  It can be made to work but things
>>> like this can lead to subtle race conditions and with the kind of
>>> layering we put on top of sysfs (kobject, driver model, driver
>>> midlayers and so on), it isn't all that easy to verify what's going
>>> on, so NACK for this one.
>> 
>> Total nonsense.
>> 
>> Mucking about with sysfs after we start deleting a directory is a bug.
>> At worst my change makes a buggy race slightly less deterministic.
>> 
>> I am not ready to consider keeping the current unnecessary atomic
>> removal step.  That unnecessary atomicity makes the following patches
>> more difficult, and requires a lot of unnecessary retesting.
>> 
>> What do you think the extra unnecessary atomicity helps protect?
>
> It's just not a clean API.  When people are trying to code things way
> up in the stack, they aren't likely to look up the code to see what
> assumptions are being made especially when the stack is deep and
> complex and sysfs is near the bottom of the tall stack.  IMHO
> implementing the usually expected semantics at this depth is worth
> every effort.  It's just good implementation style which might look
> like wasted effort but will harden the stack in the long run.  Plus,
> it's not like making it atomic is difficult or anything.

I guess we are going to have to disagree on this one.

My take is simply that a correct user has to wait until no one else
can find the kobject before calling kobject_del.  At which point
races are impossible, and it doesn't matter if sysfs_mutex is held
across the entire operation.


For the long term I still intend to kill __sysfs_remove_dir.  Just
not in this patch series.

Eric
