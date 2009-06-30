Return-Path: <linux-kernel-owner+w=401wt.eu-S1754501AbZF3TZD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754501AbZF3TZD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 15:25:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752804AbZF3TYx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 15:24:53 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:57652 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751818AbZF3TYw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 15:24:52 -0400
To: Avi Kivity <avi@redhat.com>
Cc: Gleb Natapov <gleb@redhat.com>, Yinghai Lu <yhlu.kernel@gmail.com>,
       linux-kernel@vger.kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>,
       Sheng Yang <sheng@linux.intel.com>,
       "kvm\@vger.kernel.org" <kvm@vger.kernel.org>
References: <20090630064515.GG20289@redhat.com>
	<86802c440906300018p8c5156dy3e8d84b8c263797e@mail.gmail.com>
	<20090630155820.GC8122@redhat.com> <m11vp18xmp.fsf@fess.ebiederm.org>
	<4A4A4812.4070804@redhat.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Tue, 30 Jun 2009 12:24:51 -0700
In-Reply-To: <4A4A4812.4070804@redhat.com> (Avi Kivity's message of "Tue\, 30 Jun 2009 20\:14\:58 +0300")
Message-ID: <m1iqid34os.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: avi@redhat.com, kvm@vger.kernel.org, sheng@linux.intel.com, suresh.b.siddha@intel.com, linux-kernel@vger.kernel.org, yhlu.kernel@gmail.com, gleb@redhat.com
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Avi Kivity <avi@redhat.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [PATCH v4] enable x2APIC without interrupt remapping under KVM
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity <avi@redhat.com> writes:

> So the jump-to-vector reset code cannot work on real hardware?  It works in
> qemu, but of course that's easy.

In general yes.  Nothing regularly uses that path so there is little
point adding a new users if we can avoid it.

Heck there are machines with unreliable cmos.

>> You might be able to get a full cpu reset but not a reset of the I/O
>> devices.
>>
>> The premise of kexec is that we are doing things on our own, and don't
>> get a 3rd piece of software involved that has not been heavily tested
>> on the path we want to use.  Occassionally it is a pain to do everything
>> ourselves but at least when we do and we test it we know it is going
>> to work.
>>
>> Cpu designers lately seem fond of adding features that require all
>> kind of coordination to turn on and off.  We handle the hardware
>> virtualization mode features now, and if x2apic has similar problems
>> being turned on and off I am certain we can handle that case in a
>> similar fashion.
>>
>> When we can my preference is to keep code like that out of the
>> kexec on panic path if we can figure out how to write the software
>> to do something reasonable.
>>
>> Once we figure out how to work without putting the interrupt controllers
>> in legacy mode to handle the timer interrupts I expect all kinds of
>> things will become simpler.
>>    
>
> I think it makes sense to add full reset support as a non-default option.
> Leaving hardware running and dmaing left and right has its risks.

It is easy enough to do that in user space in /sbin/kexec if that proves
useful for some reason.

As for the leaving hardware running and dmaing left and right.  You
are talking about the kexec on panic code path.  On a normal reboot
we do our darndest to cleanly shut everything down properly.

We avoid the dmaing left and right problem by reserving a chunk of
memory at boot time and we probably should be reserving a chunk
of the iommus as well for that purpose.

Hardware resets in general don't preserve the contents of memory.

In general the kexec on panic path is about teaching drivers to
initialize in the worst possible scenario and using those drivers
that can to get information out of the system.

At the same time 99% of the code that runs is in user space so
it should be easy to jump through whatever hoops make sense in
the user space component.  While keeping the kexec on panic code
path as slim as possible.

Eric
