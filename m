Return-Path: <linux-kernel-owner+w=401wt.eu-S1752917AbZGBASS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752917AbZGBASS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 20:18:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752003AbZGBASE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 20:18:04 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:38912 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750969AbZGBASB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 20:18:01 -0400
To: suresh.b.siddha@intel.com
Cc: Avi Kivity <avi@redhat.com>, Gleb Natapov <gleb@redhat.com>,
       "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Sheng Yang <sheng@linux.intel.com>,
       "kvm\@vger.kernel.org" <kvm@vger.kernel.org>, garyhade@us.ibm.com
References: <20090629132926.GB20289@redhat.com>
	<m1ocs6axca.fsf@fess.ebiederm.org> <20090630092623.GI20289@redhat.com>
	<m1eit1acxl.fsf@fess.ebiederm.org> <4A4A476C.2070305@redhat.com>
	<m1ljn94k16.fsf@fess.ebiederm.org> <4A4A6499.9000406@redhat.com>
	<m1k52t1plq.fsf@fess.ebiederm.org>
	<1246488808.27006.10691.camel@localhost.localdomain>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Wed, 01 Jul 2009 17:17:57 -0700
In-Reply-To: <1246488808.27006.10691.camel@localhost.localdomain> (Suresh Siddha's message of "Wed\, 01 Jul 2009 15\:53\:28 -0700")
Message-ID: <m1d48kndje.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: suresh.b.siddha@intel.com, garyhade@us.ibm.com, kvm@vger.kernel.org, sheng@linux.intel.com, linux-kernel@vger.kernel.org, gleb@redhat.com, avi@redhat.com
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;suresh.b.siddha@intel.com
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
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

Suresh Siddha <suresh.b.siddha@intel.com> writes:

> On Tue, 2009-06-30 at 12:36 -0700, Eric W. Biederman wrote:
>> Dropped irqs..  Driver hangs because it is waiting for an irq.  Hardware
>> hangs because it is waiting for the cpu to process the irq.
>> 
>> Potentially we get a level triggered irq that is never acked by
>> the cpu that won't arm until the cpu send an ack, and we can't
>> send an ack from another cpu.
>
> Eric,
>
> Among number of experiments you have tried in the past to fix this, have
> you tried the experiment of explicitly clearing the remoteIRR by
> changing the trigger mode to edge and then back to level.
>
> Is there a problem with this?

The problem I had wasn't remoteIRR getting stuck, but the symptoms
were largely the same.  I did try changing the trigger mode to edge
and back and that did not unstick the ioapic in all cases.

> We can send a spurious IPI (after the RTE migration) with the new vector
> to another cpu and handler which services the level interrupt will check
> if we saw the edge mode for a level interrupt and then the handler can
> explicitly restore the level trigger and reset the remote IRR by mask
> +edge and unmask+level.
>
> We might have to work with some rough edges but do you recollect any
> major issue with this approach..

This is coming up enough recently I expect it is time to cook up
a patch that does the ioapic migration in process context plus
some user space code that stress tests things.  Just so people
can repeat my experiments and see what I am trying to avoid.

Eric
