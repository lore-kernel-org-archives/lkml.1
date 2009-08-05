Return-Path: <linux-kernel-owner+w=401wt.eu-S1752953AbZHEW5m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752953AbZHEW5m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 18:57:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752422AbZHEW5l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 18:57:41 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:46473 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751039AbZHEW5k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 18:57:40 -0400
To: Neil Horman <nhorman@redhat.com>
Cc: Amerigo Wang <amwang@redhat.com>, linux-kernel@vger.kernel.org,
       tony.luck@intel.com, linux-ia64@vger.kernel.org,
       akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       Anton Vorontsov <avorontsov@ru.mvista.com>
References: <20090805112123.6552.73574.sendpatchset@localhost.localdomain>
	<m1eirqtmey.fsf@fess.ebiederm.org>
	<20090805140408.GJ7259@hmsreliant.think-freely.org>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Wed, 05 Aug 2009 15:57:35 -0700
In-Reply-To: <20090805140408.GJ7259@hmsreliant.think-freely.org> (Neil Horman's message of "Wed\, 5 Aug 2009 10\:04\:08 -0400")
Message-ID: <m1skg5vpgg.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: nhorman@redhat.com, avorontsov@ru.mvista.com, mingo@elte.hu, akpm@linux-foundation.org, linux-ia64@vger.kernel.org, tony.luck@intel.com, linux-kernel@vger.kernel.org, amwang@redhat.com
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Neil Horman <nhorman@redhat.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.7 BAYES_20 BODY: Bayesian spam probability is 5 to 20%
	*      [score: 0.1379]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.5 XM_Body_Dirty_Words Contains a dirty word
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [Patch 0/7] Implement crashkernel=auto
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Neil Horman <nhorman@redhat.com> writes:

> On Wed, Aug 05, 2009 at 06:33:57AM -0700, Eric W. Biederman wrote:
>> Amerigo Wang <amwang@redhat.com> writes:
>> 
>> > This series of patch implements automatically reserved memory for crashkernel,
>> > by introducing a new boot option "crashkernel=auto". This idea is from Neil.
>> >
>> > In case of breaking user-space applications, it modifies this boot option after
>> > it decides how much memory should be reserved.
>> >
>> > On different arch, the threshold and reserved memory size is different. Please
>> > refer patch 7/7 which contains an update for the documentation.
>> >
>> > Note: This patchset was only tested on x86_64 with differernt memory sizes.
>> 
>> This seems like a silly hard code. Especially for a feature distros don't
>> care enough about to implement a working initrd for.
>> 
>> Has anyone bothered to justify those large amounts of memory?
>> Where does the 128M go?
>> 
>> Please pardon me for being a cynic but I don't see the command line option
>> being the bottleneck for real users to make this work.
>> 
>> Eric
>
> Lots of the impetus behind this results from a desire to have kexec configured
> and setup up during install.  Having the kernel allocate a default size block of
> RAM lets you do that without the need for an interim reboot.

I assume you mean kexec on panic.  kexec should be fine and you can arguably
solve this problem with a little bit of userspace glue and a kexec of yourself
during bootup.

> You could of
> course boot the installer kernel with a crashkernel line pre-selected  suppose,
> but then you have to go to the trouble of figuring that allocation size out each
> time.  This gives you a nice convienent way to get a reasonable block of memory
> without the need to do all that extra work.

My big concern is that you are moving policy into the kernel, when it isn't at
all clear that policy is the right thing to do, and the existing mechanisms give
you enough rope to do this all in userspace.

You also have to build (or at least load) the whole kdump image after
the system boots, and configure someplace for this to be saved.

What class of problems do you expect to catch with this?

What has me puzzled is that the mkdumprd that ships with fedora isn't
usable without patching, and it seems to be steadily getting worse.  If the
concern was about getting better bug reports I would expect getting this
functionality into fedora would be where you would be focusing your efforts.

Am I missing something obvious?

Eric
