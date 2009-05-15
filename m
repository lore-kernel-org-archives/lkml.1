Return-Path: <linux-kernel-owner+w=401wt.eu-S1756858AbZEOX02@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756858AbZEOX02 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 19:26:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755198AbZEOX0T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 19:26:19 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:52644 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754687AbZEOX0S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 19:26:18 -0400
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ingo Molnar <mingo@elte.hu>, the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>
References: <1242170864-13560-1-git-send-email-jeremy@goop.org>
	<20090513133021.GA7277@elte.hu> <4A0ADBA2.2020300@goop.org>
	<20090515182757.GA19256@elte.hu> <4A0DCC11.10307@goop.org>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Fri, 15 May 2009 16:26:11 -0700
In-Reply-To: <4A0DCC11.10307@goop.org> (Jeremy Fitzhardinge's message of "Fri\, 15 May 2009 13\:09\:53 -0700")
Message-ID: <m1my9ex818.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=67.169.126.145;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.169.126.145
X-SA-Exim-Rcpt-To: jeremy@goop.org, xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org, x86@kernel.org, mingo@elte.hu
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: **;Jeremy Fitzhardinge <jeremy@goop.org>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.0 BAYES_50 BODY: Bayesian spam probability is 40 to 60%
	*      [score: 0.4437]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  2.2 XMSubMetaSxObfu_03 Obfuscated Sexy Noun-People
	*  1.6 XMSubMetaSx_00 1+ Sexy Words
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [GIT PULL] xen /proc/mtrr implementation
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge <jeremy@goop.org> writes:

> Ingo Molnar wrote:
>> Right now there's no MTRR support under Xen guests and the Xen hypervisor was
>> able to survive, right? Why should we do it under dom0?
>>   
>
> Because dom0 has direct hardware access, and is running real device drivers.
> domU guests don't see physical memory, and so MTRR has no relevance for them.


>> The MTRR code is extremely fragile, we dont really need an added layer
>> there. _Especially_ since /proc/mtrr is an obsolete API.
>>   
>
> There's no added layer there.  I'm just adding another implementation of
> mtrr_ops.
>
> /proc/mtrr is in wide use today.  It may be planned for obsolescence, but
> there's no way you can claim its obsolete today (my completely up-to-date F10 X
> server is using it, for example).  We don't break oldish usermode ABIs in new
> kernels.

Sure it is.  There is a better newer replacement.  It is taking a while to
get userspace transitioned but that is different.  Honestly I am puzzled
why that it but whatever.

> Besides, the MTRR code is also a kernel-internal API, used by DRM and other
> drivers to configure the system MTRR state.  Those drivers will either perform
> badly or outright fail if they can't set the appropriate cachability properties.
> That is not obsolete in any way.

There are about 5 of them so let's fix them.
With PAT we are in a much better position both for portability and for
flexibility.

>> If you want to allow a guest to do MTRR ops, you can do it by catching the
>> native kernel accesses to the MTRR space. There's no guest side support needed
>> for that.
>>   
>
> MTRR can't be virtualized like that.  It can't be meaningfully multiplexed, and
> must be set in a uniform way on all physical CPUs.  Guests run on virtual CPUs,
> and don't have any knowledge of what the mapping of VCPU to PCPU is, or even any
> visibility of all PCPUs.
>
> It is not a piece of per-guest state; it is system-wide property, maintained by
> Xen.  These patches add the mechanism for dom0 (=hardware control domain) to
> tell Xen what state they should be in.

Is it possible to fix PAT and get that working first.   That is very definitely
the preferend API.

Eric
