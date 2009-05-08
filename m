Return-Path: <linux-kernel-owner+w=401wt.eu-S1753845AbZEHGzY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753845AbZEHGzY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 02:55:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751517AbZEHGzK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 02:55:10 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:57116 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751154AbZEHGzH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 02:55:07 -0400
To: "H. Peter Anvin" <h.peter.anvin@intel.com>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>, linux-kernel@vger.kernel.org,
       vgoyal@redhat.com, hbabu@us.ibm.com, kexec@lists.infradead.org,
       ying.huang@intel.com, mingo@elte.hu, tglx@linutronix.de,
       sam@ravnborg.org
References: <1241735222-6640-1-git-send-email-hpa@linux.intel.com>
	<m14ovwz8ua.fsf@fess.ebiederm.org> <4A03C3BB.3070401@intel.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Thu, 07 May 2009 23:54:52 -0700
In-Reply-To: <4A03C3BB.3070401@intel.com> (H. Peter Anvin's message of "Thu\, 07 May 2009 22\:31\:39 -0700")
Message-ID: <m1tz3wgk3n.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=67.169.126.145;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.169.126.145
X-SA-Exim-Rcpt-To: h.peter.anvin@intel.com, sam@ravnborg.org, tglx@linutronix.de, mingo@elte.hu, ying.huang@intel.com, kexec@lists.infradead.org, hbabu@us.ibm.com, vgoyal@redhat.com, linux-kernel@vger.kernel.org, hpa@linux.intel.com
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;"H. Peter Anvin" <h.peter.anvin@intel.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.0 BAYES_50 BODY: Bayesian spam probability is 40 to 60%
	*      [score: 0.5000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.1 XMSolicitRefs_0 Weightloss drug
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [PATCH 00/14] RFC: x86: relocatable kernel changes
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"H. Peter Anvin" <h.peter.anvin@intel.com> writes:

> Eric W. Biederman wrote:
>> Peter do you plan to update pxelinux or other bootloaders to use the
>> relocatable kernel feature?
>
> Yes.
>
>> The direction of this patch seems reasonable.  The details are broken.
>> The common case for relocatable kernels today is kdump.  A situation
>> with very minimal memory.  In that situation the kernel needs to run
>> where we put it, modifying the kernel to not run where it gets put
>> is a problem.
>
> I thought in the kdump case you typically loaded it pretty high?  Either
> which way, kdump is always loaded by kexec, so it should just be a
> matter of updating kexec to zero the runtime_start field, no?

Yes.  In practice it doesn't matter. I just don't want to get into a
contest with the kernel about who knows better how to put the kernel
in memory the bootloader or the kernel decompressor.

> Basically
> this is the bootloader saying "do what I say, dammit."  Since the
> existing protocol doesn't have a way to unambiguously communicate one
> direction versus another (see below), it seems like a relatively small
> issue involving only one tool.  Suboptimal, yes.

The existing protocol doesn't have the option of anything else.

Physical start has always been <= the alignment for x86 and x86_64,
in any real world configuration.

Something goofy may have happened during unification, I thought I had
removed physical start as totally unnecessary from x86_64.

Hmmm....

In the non-kdump case this is interesting.  I know of instances where
kexec is burned in firmware.  So I am strongly reluctant to make anything
that feels like a true backwards incompatible change.

Those systems also don't have the stupid 15MB hole either.

>> With the code as it is today you can get the exact same behavior
>> by simply bumping up the minimum alignment to 16MB, and a lot less code
>> and no changes needed to any bootloaders.
>> 
>> Is your goal to setup a scenario where on small memory systems a bootloader
>> like pxelinux can support a relocatable kernel and load it a lower
>> address?  If so that seems reasonable.
>
> Yes.
>
>> With that said how about we change the logic to:
>> 
>> if (load_addr == legacy_load_addr) /* 0x100000 */
>> 	use config_physical_start
>> else if aligned
>> 	noop
>> else
>>         /* Crap this is bad, align the kernel and hope something works. */
>> 
>> That gets the desired behavior we override bootloaders that are not
>> smart and taking relocation into account.  I am really not comfortable
>> with having code that will override a bootloader doing something
>> reasonable.
>
> I'm not sure that is quite right either, because if alignment is
> configured to be 1 MB or less then 1 MB is a perfectly legitimate
> address for a relocating bootloader to want to use, even if it is not
> configured in.  It would be more than a bit odd to not have that be
> permitted.

On the 64bit kernel 2MB really is required.  We run at a fixed virtual
address and use 2MB pages. So anything less that 2MB really won't work.

So I think it would be a bad idea if we had bootloaders ignoring the
alignment.

With the suggested start address, it probably make sense to only
export our true alignment requirement.

>> I expect we will still want to update kexec to be able to take
>> advantage of loadtime_size (runtime_size seems like the wrong name).
>
> Well, it is the amount of memory the kernel needs during runtime (as
> opposed to during loading.)  I admit it's not an ideal name, though.  On
> the other hand, simply calling it kernel_start and kernel_size seemed
> ambiguous.

It is the amount of memory we need before a true memory allocator is
initialized.  Essentially text+data+bss.  How about we call it init_size?

Perhaps we should have:
init_size
best start (As a 64bit field please)
optimum align  (Or we flip it around)

Eric
