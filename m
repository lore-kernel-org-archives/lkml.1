Return-Path: <linux-kernel-owner+w=401wt.eu-S1754520AbZHFIfk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754520AbZHFIfk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 04:35:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754357AbZHFIfi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 04:35:38 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:41364 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752859AbZHFIff (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 04:35:35 -0400
To: Amerigo Wang <amwang@redhat.com>
Cc: Neil Horman <nhorman@redhat.com>, linux-kernel@vger.kernel.org,
       tony.luck@intel.com, linux-ia64@vger.kernel.org,
       akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       Anton Vorontsov <avorontsov@ru.mvista.com>,
       Andi Kleen <andi@firstfloor.org>
References: <20090805112123.6552.73574.sendpatchset@localhost.localdomain>
	<m1eirqtmey.fsf@fess.ebiederm.org>
	<20090805140408.GJ7259@hmsreliant.think-freely.org>
	<m1skg5vpgg.fsf@fess.ebiederm.org> <4A7A3A78.7080200@redhat.com>
	<m1y6pxr737.fsf@fess.ebiederm.org> <4A7A506B.2060008@redhat.com>
	<m1ljlxsiox.fsf@fess.ebiederm.org> <4A7A70E5.2010204@redhat.com>
	<m1bpmtqxjh.fsf@fess.ebiederm.org> <4A7A7A0F.6070906@redhat.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Thu, 06 Aug 2009 01:35:28 -0700
In-Reply-To: <4A7A7A0F.6070906@redhat.com> (Amerigo Wang's message of "Thu\, 06 Aug 2009 14\:37\:03 +0800")
Message-ID: <m1iqh1nxv3.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: amwang@redhat.com, andi@firstfloor.org, avorontsov@ru.mvista.com, mingo@elte.hu, akpm@linux-foundation.org, linux-ia64@vger.kernel.org, tony.luck@intel.com, linux-kernel@vger.kernel.org, nhorman@redhat.com
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Amerigo Wang <amwang@redhat.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
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


> The kernel doesn't have to reserve the exact amount of memory that a kexec
> kernel will use, it just finds a big enough size for all cases which already
> assumes the physical memory is large enough.


>> I think if what you were proposing was part of some coherent story for
>> a complete implementation I would consider it more.  Instead this just
>> appears to be a reaction to how frustrating the user space
>> implementation is, and fixing things in the kernel instead of in user
>> space.
>>   
>
> Yes, exactly, in fact I am doing another part which will allow us to take back
> of the reserved memory at run-time.

Alright. Let's look at that.

I would make the restriction you can't resize the area while a kexec
on panic image is loaded, and growing the area would not be a
realistic option.

If crash_kernel=auto happens in the context of being able to shrink
the area from user space the definition is simple.  We reserve as much
memory as we think we can without affecting performance, stability,
reliability.

We can use an initial approximation of perhaps 1/32nd of low memory
(aka directly mapped memory), and I don't see a point in making the
code arch dependent at all.  We should run the size approximation past
the folks on linux-mm as they are more likely to know how much memory
reduction we can tolerate without problems.

We can then plan on user space saying hey that is more than I need:
shrink that, and load the kexec on panic kernel.

Eric
