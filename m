Return-Path: <linux-kernel-owner+w=401wt.eu-S1753381AbYE1JlB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753381AbYE1JlB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 05:41:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751455AbYE1Jkw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 05:40:52 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:58604 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751414AbYE1Jkv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 05:40:51 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>, Avi Kivity <avi@qumranet.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Keir Fraser <Keir.Fraser@eu.citrix.com>
References: <483B34CA.8000600@goop.org> <20080527083729.GF29246@elte.hu>
	<483BD843.5080009@goop.org> <20080527145606.GB24457@elte.hu>
	<483C35AA.5060102@goop.org>
Date: Wed, 28 May 2008 02:35:08 -0700
In-Reply-To: <483C35AA.5060102@goop.org> (Jeremy Fitzhardinge's message of
	"Tue, 27 May 2008 17:24:10 +0100")
Message-ID: <m1ve0yai0j.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Jeremy Fitzhardinge <jeremy@goop.org>
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -1.1 BAYES_05 BODY: Bayesian spam probability is 1 to 5%
	*      [score: 0.0128]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.5 XM_Body_Dirty_Words Contains a dirty word
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: Question about interrupt routing and irq allocation
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge <jeremy@goop.org> writes:

> Ingo Molnar wrote:
>>> I'm initially targeting 32-bit, though obviously I'd like something that
>>> works for both 32 and 64 bit.  irq_cfg[] is missing in io_apic_32.c; would I
>>> achieve the same effect by setting irq_vector[irq] = 0xff or something?
>>>
>>
>> ok, here comes the next phase of a rather cunning plan: please unify these
>> vector allocators first! ;-)
>>
>
> Somehow I knew you were going to say that...
>
>> it's nontrivial but would result in rather nice code. I dont know whether we
>> want to extend per-CPU vectors to 32-bit as well ... but might be worth an
>> attempt and we could give any exploratory patches a try in -tip. Eric, what do
>> you think about the general approach?
>>
>> this would also pave the way towards unified APIC code. Hm
>
> All of that sounds very appealing, particularly as the work on xen-dom0
> continues.  But in the meantime I'm just using create_irq(), and I'll wear the
> wasted vector (after all, it will only happen when booting under Xen-hvm).

- I think using create_irq is a good step.
- I think all vectors are wasted in the case of Xen.
- I think we want a individual irq for each xen irq source.
  Sparc already does a demux in similar circumstances with
  a queue of received MSI messages an a single cpu irq
  that these get demuxed from.
  If we don't have individual irqs per drivers it will be hard
  to share a source base with native drivers.
- I think it would be very nice if we could get irqs allocated
  in request_irq instead of create_irq (and equivalents).
  
- I think ultimately it makes sense to port the per vector
  code to 32bit linux.  On single cpu systems the cost should
  be just a hair more code, but no extra data structures.  We
  can easily restrict the irq allocation to allocating the same
  vector on all cpus for any old machines that prove flaky with
  irq migration.

  The code between the two architectures we kept fairly close
  in sync when I worked on it so a merge should not be a big deal.

  Trouble is I'm not finding a lot of time to work on any of this
  stuff lately :(

Eric
