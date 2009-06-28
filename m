Return-Path: <linux-kernel-owner+w=401wt.eu-S1753065AbZF1Vfp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753065AbZF1Vfp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 17:35:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751589AbZF1Vfh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 17:35:37 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:42043 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751018AbZF1Vfg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 17:35:36 -0400
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, Neil Horman <nhorman@tuxdriver.com>,
       linux-kernel@vger.kernel.org, earl_chew@agilent.com,
       Oleg Nesterov <oleg@redhat.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>
References: <20090622172818.GB14673@hmsreliant.think-freely.org>
	<20090625163050.d6a71a13.akpm@linux-foundation.org>
	<20090626104804.GA7337@hmsreliant.think-freely.org>
	<20090626092001.32e35e17.akpm@linux-foundation.org>
	<20090628193112.GA6760@one.firstfloor.org>
	<20090628135235.10f9b153.akpm@linux-foundation.org>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Sun, 28 Jun 2009 14:35:31 -0700
In-Reply-To: <20090628135235.10f9b153.akpm@linux-foundation.org> (Andrew Morton's message of "Sun\, 28 Jun 2009 13\:52\:35 -0700")
Message-ID: <m163egt524.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, oleg@redhat.com, earl_chew@agilent.com, linux-kernel@vger.kernel.org, nhorman@tuxdriver.com, andi@firstfloor.org
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Andrew Morton <akpm@linux-foundation.org>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.5 XM_Body_Dirty_Words Contains a dirty word
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [PATCH] exec: Make do_coredump more robust and safer when using pipes in core_pattern
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:

> On Sun, 28 Jun 2009 21:31:12 +0200 Andi Kleen <andi@firstfloor.org> wrote:
>
>> > One way would be to add a new sysctl-externs.h and then put all the
>> > declarations in there.  That file gets included by sysctl.c and by each
>> > file which shares a global with sysctl.c
>> 
>> Long ago I had a experimental patch to put sysctls into a new ELF section. The 
>> you could simply put a DEFINE_SYSCTL(....) into the appropiate source file
>> which defined the variable and most of the tables went.
>> 
>> No externs, no mess, no patch collisions, everything much nicer.
>> 
>> The only problem was that it didn't support the numerical sysctl
>> space, so that would need to be removed first.
>> 
>> It's deprecated for quite some time now:
>> 
>>   if (msg_count < 5) {
>>                 msg_count++;
>>                 printk(KERN_INFO
>>                         "warning: process `%s' used the deprecated sysctl "
>>                         "system call with ", current->comm);
>> 
>> Should it finally go now? If yes I could polish up the old patch again.
>> 
>
> I suspect that it will be a long time before we can actually remove the
> numerical sysctl support, if ever.  In _theory_ we should support it
> for ever.  But in practice, we could probably remove it with a minimum
> of disruption a few years hence, but it's hard to work this out.
>
> When was the last time we saw a "warning: process `%s' used the
> obsolete bdflush system call" warning?  A quick google here says 2004. 
> Is that data?  A bit, I guess.
>
> Maybe Eric has thought about this issue?

I have a patchset.  That I intend to dust off now and repost now that the
merge window has closed that converts all of the binary sysctl handling
into compatibility code that calls read/write on the ascii sysctls.

The bulk of the patchset is removing all of the binary sysctl support code
from all of the susbystems that it makes no longer needed.

At which point the maintenance pain is of all of the binary sysctls is
essentially removed.

At which point the technical decisions on dumping binary become much
easier.  They are reduced to one big file that we can keep or compile
out at our leisure.  I still figure September 2010 as documented in
feature-removal.txt sounds like a good date for the final ripping all of
the binary sysctl code out.

It is certainly time to remove the internal ABIs.  The current system
is still too error prone, for users adding new sysctls.  It was only
a week or two ago that I had to nack a patch for adding a binary sysctl.

Once we have purged the binary parts it should be much easier to simplify
the sysctl code.

So my big question:

Andrew should I toss all 100 or so patches over the wall to you
and your -mm tree?  Or should I maintain a public git tree based
at 2.6.31-rc1?  Get it into linux-next and ask Linus to pull it when
the merge window comes?

Eric

