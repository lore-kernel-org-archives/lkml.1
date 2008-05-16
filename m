Return-Path: <linux-kernel-owner+w=401wt.eu-S1755381AbYEPCa2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755381AbYEPCa2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 22:30:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751569AbYEPCaR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 22:30:17 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:44238 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751424AbYEPCaP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 22:30:15 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Huang, Ying" <ying.huang@intel.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, Pavel Machek <pavel@ucw.cz>,
       nigel@nigel.suspend2.net, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Kexec Mailing List <kexec@lists.infradead.org>
References: <1210574441.30365.8.camel@caritas-dev.intel.com>
	<20080513053408.GA5870@redhat.com>
	<1210730266.23707.50.camel@caritas-dev.intel.com>
	<20080514025607.GA19944@redhat.com>
	<1210736275.23707.62.camel@caritas-dev.intel.com>
	<m1lk2c4l4i.fsf@frodo.ebiederm.org>
	<1210827473.23707.133.camel@caritas-dev.intel.com>
	<m1lk2bs970.fsf@frodo.ebiederm.org>
	<1210902114.23707.156.camel@caritas-dev.intel.com>
Date: Thu, 15 May 2008 19:25:00 -0700
In-Reply-To: <1210902114.23707.156.camel@caritas-dev.intel.com> (Ying Huang's
	message of "Fri, 16 May 2008 09:41:54 +0800")
Message-ID: <m14p8zgf43.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;"Huang, Ying" <ying.huang@intel.com>
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -1.1 BAYES_05 BODY: Bayesian spam probability is 1 to 5%
	*      [score: 0.0217]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [PATCH] kexec based hibernation: a prototype of kexec multi-stage load
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Huang, Ying" <ying.huang@intel.com> writes:

> On Thu, 2008-05-15 at 11:39 -0700, Eric W. Biederman wrote:
> [...]
>> 2) After we figure out our address read the stack pointer from
>>    a fixed location and simply set it.  (This is my preference)
>
> Just for confirmation (My English is poor).
>
> Do you mean that kernel A just read the stack top as re-entry point,
> regardless of whether it is return address or argument 1?

What I was thinking was:

In kernel A()

relocate_new_kernel:

        ...

        call	*%eax

kexec_jump_back_entry:
        /* This code should be PIC so figure out where we are */
        call	1f
1:
        popl	%edi
        subl	$(1b - relocate_kernel), %edi

        /* Setup a safe stack */
        leal    PAGE_SIZE(%edi), %esp
        ...


Then in purgatory we can read the address of kexec_jump_back_entry
by examining 0(%esp) and export it in whatever fashion is sane.

However we reach kexec_jump_back_entry we should be fine.

Eric
