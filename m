Return-Path: <linux-kernel-owner+w=401wt.eu-S1753563AbZHFCsF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753563AbZHFCsF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 22:48:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751234AbZHFCsD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 22:48:03 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:54775 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750799AbZHFCsB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 22:48:01 -0400
To: Amerigo Wang <amwang@redhat.com>
Cc: Neil Horman <nhorman@redhat.com>, linux-kernel@vger.kernel.org,
       tony.luck@intel.com, linux-ia64@vger.kernel.org,
       akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       Anton Vorontsov <avorontsov@ru.mvista.com>
References: <20090805112123.6552.73574.sendpatchset@localhost.localdomain>
	<m1eirqtmey.fsf@fess.ebiederm.org>
	<20090805140408.GJ7259@hmsreliant.think-freely.org>
	<m1skg5vpgg.fsf@fess.ebiederm.org> <4A7A3A78.7080200@redhat.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Wed, 05 Aug 2009 19:47:56 -0700
In-Reply-To: <4A7A3A78.7080200@redhat.com> (Amerigo Wang's message of "Thu\, 06 Aug 2009 10\:05\:44 +0800")
Message-ID: <m1y6pxr737.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: amwang@redhat.com, avorontsov@ru.mvista.com, mingo@elte.hu, akpm@linux-foundation.org, linux-ia64@vger.kernel.org, tony.luck@intel.com, linux-kernel@vger.kernel.org, nhorman@redhat.com
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Amerigo Wang <amwang@redhat.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0005]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [Patch 0/7] Implement crashkernel=auto
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Amerigo Wang <amwang@redhat.com> writes:

> Eric W. Biederman wrote:
>> Neil Horman <nhorman@redhat.com> writes:
>>   
>>> You could of
>>> course boot the installer kernel with a crashkernel line pre-selected  suppose,
>>> but then you have to go to the trouble of figuring that allocation size out each
>>> time.  This gives you a nice convienent way to get a reasonable block of memory
>>> without the need to do all that extra work.
>>>     
>>
>> My big concern is that you are moving policy into the kernel, when it isn't at
>> all clear that policy is the right thing to do, and the existing mechanisms give
>> you enough rope to do this all in userspace.
>>   
>
>
> How? This doesn't remove the existing mechanism, just provides a new choice for
> user like me who doesn't know how much memory should be reserved, or who simply
> doesn't want to concern this since he/she has very enough memory.

Having end users not caring is fine.  My problem with this patch is that it
appears that no one is stepping up and taking responsibility for the crahsdump
mechanism, ensuring it will work, ensuring it will work for users.  I see
us solving problems in the wrong place because people are not stepping
up and solving them in the proper place.

To actually use it there are much bigger problems then supplying the size
of the crashdump area.

My personal experience is that to make this work I had to list every kernel
module I needed in the order that they must be loaded, in /etc/kdump.conf
for my filesystem.  I had to modify mkdumprd so that it actually generated
a dump ramdisk, and I think I am forgetting some other manual hack that
I had to use as well.

So if you have to do something manually I think the problem is user space,
and not the kernel.

In general I figure that whoever builds the kernel and initrd should be
responsible for testing and figuring out the amount of memory needed.
The primary kernel has no idea what is going to loaded in there and
as such no real idea how much memory is needed.

>> You also have to build (or at least load) the whole kdump image after
>> the system boots, and configure someplace for this to be saved.
>>
>> What class of problems do you expect to catch with this?
>>   
>
> Again, try to save the user from choosing numbers for "crashkernel=".

The user being kernel developers?  Whoever builds the kernel and initrd
should be responsible for testing and figuring this out.

In a distro context installers etc should be able to setup good defaults
so end users don't have to worry about this.

>> What has me puzzled is that the mkdumprd that ships with fedora isn't
>> usable without patching, and it seems to be steadily getting worse.  
>
> Please explain why it is not usable? The patch won't break the userspace, since
> it modifies the "crashkernel=" command line dynamically.

No the crashdump mechanism is useless because user space is already
broken and unusable.  At least on fedora and I assume by extension
redhat.

Eric
