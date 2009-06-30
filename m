Return-Path: <linux-kernel-owner+w=401wt.eu-S1754976AbZF3TgR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754976AbZF3TgR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 15:36:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753385AbZF3TgD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 15:36:03 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:49803 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752939AbZF3TgC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 15:36:02 -0400
To: Avi Kivity <avi@redhat.com>
Cc: Gleb Natapov <gleb@redhat.com>,
       "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Sheng Yang <sheng@linux.intel.com>,
       "kvm\@vger.kernel.org" <kvm@vger.kernel.org>
References: <20090629132926.GB20289@redhat.com>
	<m1ocs6axca.fsf@fess.ebiederm.org> <20090630092623.GI20289@redhat.com>
	<m1eit1acxl.fsf@fess.ebiederm.org> <4A4A476C.2070305@redhat.com>
	<m1ljn94k16.fsf@fess.ebiederm.org> <4A4A6499.9000406@redhat.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Tue, 30 Jun 2009 12:36:01 -0700
In-Reply-To: <4A4A6499.9000406@redhat.com> (Avi Kivity's message of "Tue\, 30 Jun 2009 22\:16\:41 +0300")
Message-ID: <m1k52t1plq.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: avi@redhat.com, kvm@vger.kernel.org, sheng@linux.intel.com, suresh.b.siddha@intel.com, linux-kernel@vger.kernel.org, gleb@redhat.com
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Avi Kivity <avi@redhat.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0003]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [PATCH v3] enable x2APIC without interrupt remapping under KVM
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity <avi@redhat.com> writes:

> On 06/30/2009 10:08 PM, Eric W. Biederman wrote:
>>> Can you elaborate?  For kvm guests, the hardware is reasonably will implemented
>>> and if not we will fix it.  We need not cripple a feature just because some
>>> hardware is broken.
>>>      
>>
>> The short version is I don't know what work arounds we will ultimately
>> decide to deploy to work with real hardware.
>>
>> I have been seriously contemplating causing a cpu hot-unplug request
>> to fail if we are in ioapic mode and we have irqs routed to the cpu
>> that is being unplugged.
>>    
>
> Well, obviously we need to disassociate any irqs from such a cpu.  Could be done
> from the kernel or only enforced by the kernel.

Using the normal irq migration path we can move irqs off of a cpu reliably
there just aren't any progress guarantees.

>> Even with perfectly working hardware it is not possible in the general
>> case to migrate an ioapic irq from one cpu to another outside of an
>> interrupt handler without without risking dropping an interrupt.
>>    
>
> Can't you generate a spurious interrupt immediately after the migration?  An
> extra interrupt shouldn't hurt.

Nope.  The ioapics can't be told to send an interrupt.

>> There is no general way to know you have seen the last interrupt
>> floating around your system.  PCI ordering rules don't help because
>> the ioapics can potentially take an out of band channel.
>>    
>
> Can you describe the problem scenario? an ioapic->lapic message delivered to a
> dead cpu?

Dropped irqs..  Driver hangs because it is waiting for an irq.  Hardware
hangs because it is waiting for the cpu to process the irq.

Potentially we get a level triggered irq that is never acked by
the cpu that won't arm until the cpu send an ack, and we can't
send an ack from another cpu.

Eric
