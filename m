Return-Path: <linux-kernel-owner+w=401wt.eu-S1758890AbZEHBXu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758890AbZEHBXu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 21:23:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756815AbZEHBXb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 21:23:31 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:45057 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755891AbZEHBX3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 21:23:29 -0400
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, vgoyal@redhat.com, hbabu@us.ibm.com,
       kexec@lists.infradead.org, ying.huang@intel.com, mingo@elte.hu,
       tglx@linutronix.de, sam@ravnborg.org
References: <1241735222-6640-1-git-send-email-hpa@linux.intel.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Thu, 07 May 2009 18:23:09 -0700
In-Reply-To: <1241735222-6640-1-git-send-email-hpa@linux.intel.com> (H. Peter Anvin's message of "Thu\,  7 May 2009 15\:26\:48 -0700")
Message-ID: <m14ovwz8ua.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=67.169.126.145;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.169.126.145
X-SA-Exim-Rcpt-To: hpa@linux.intel.com, sam@ravnborg.org, tglx@linutronix.de, mingo@elte.hu, ying.huang@intel.com, kexec@lists.infradead.org, hbabu@us.ibm.com, vgoyal@redhat.com, linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;"H. Peter Anvin" <hpa@linux.intel.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.0 BAYES_50 BODY: Bayesian spam probability is 40 to 60%
	*      [score: 0.4934]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [PATCH 00/14] RFC: x86: relocatable kernel changes
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Peter do you plan to update pxelinux or other bootloaders to use the
relocatable kernel feature?

Can we please kill the gosh awful impact lines?  They keep breaking my
concentration whenever I try and review these patches.  They are
horrible.  Something of very minimal significance jumping up and
screaming at me. 

The impact lines also fail to capture any of the significant ways I
can easily think of that this patch could cause problems.  A little
screw up could cause the kernel to fail to boot for a random portion
of our user base, and the patch as constructed will require changes
to existing bootloaders.

The direction of this patch seems reasonable.  The details are broken.
The common case for relocatable kernels today is kdump.  A situation
with very minimal memory.  In that situation the kernel needs to run
where we put it, modifying the kernel to not run where it gets put
is a problem.

With the code as it is today you can get the exact same behavior
by simply bumping up the minimum alignment to 16MB, and a lot less code
and no changes needed to any bootloaders.

Is your goal to setup a scenario where on small memory systems a bootloader
like pxelinux can support a relocatable kernel and load it a lower
address?  If so that seems reasonable.

With that said how about we change the logic to:

if (load_addr == legacy_load_addr) /* 0x100000 */
	use config_physical_start
else if aligned
	noop
else
        /* Crap this is bad align the kernel and hope something works. */

That gets the desired behavior we override bootloaders that are not
smart and taking relocation into account.  I am really not comfortable
with having code that will override a bootloader doing something
reasonable.

I expect we will still want to update kexec to be able to take
advantage of loadtime_size (runtime_size seems like the wrong name).

Eric
