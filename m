Return-Path: <linux-kernel-owner+w=401wt.eu-S1762237AbYD2Rm5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762237AbYD2Rm5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 13:42:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756364AbYD2Rjp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 13:39:45 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:41164 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761383AbYD2Rjm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 13:39:42 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Ingo Molnar <mingo@elte.hu>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, Gabriel C <nix.or.die@googlemail.com>,
       Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jesse.barnes@intel.com>,
       Mika Fischer <mika.fischer@zoopnet.de>, balajirrao@gmail.com
References: <200801192045.17291.yinghai.lu@sun.com>
	<200801202256.48365.yinghai.lu@sun.com>
	<20080122165125.GA17992@elte.hu>
	<200801221623.20861.yinghai.lu@sun.com>
	<20080426035614.a30afb17.akpm@linux-foundation.org>
	<48132665.8050202@googlemail.com>
	<86802c440804261805rc739f9as519213fecdc0cdff@mail.gmail.com>
	<m17ieh4zuo.fsf@frodo.ebiederm.org> <20080429103150.GJ23198@elte.hu>
Date: Tue, 29 Apr 2008 10:29:44 -0700
In-Reply-To: <20080429103150.GJ23198@elte.hu> (Ingo Molnar's message of "Tue,
	29 Apr 2008 12:31:50 +0200")
Message-ID: <m1ej8o4liv.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0001]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [PATCH] x86_32: trim memory by updating e820 v3
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@elte.hu> writes:

> * Eric W. Biederman <ebiederm@xmission.com> wrote:
>
>> So lets concentrate on PAT to solve contiguous MTRR region problems.
>> 
>> We can upgrade UC to WC with pat.  As well as demote WB to UC or WC. 
>> So for those regions we know about we should be in good shape.
>
> sure, but whatever we do now in the sysfs API space, it will hit distros 
> only in a year, relistically, because Xorg also has to adopt to it. The 
> workaround from Yinghai looks reasonably configurable - if we mess up 
> (say an SMM comes in while we fiddle with the MTRRs) we'll likely get a 
> lockup right then, during bootup, so it wont be hard to realize what 
> went wrong. In that sense it's in fact safer to do it during early init 
> than let the user do it via some script, because the window is smaller, 
> etc.
>
> we still default to the safe mode of course and dont touch MTRRs, but 
> for note the various configuration options that are available to distros 
> and users.

The potential problem isn't while we reprogram the MTRRs, the potential
problem is mapping the SMM area uncachable.  In which case we will
make each SMM interrupt drastically slower.  Which can have all kinds of
unpleasant side effects.

If we really can mess up SMM mode that way we have a really nasty
interaction that is horrible to debug, or recognize.

Further the opportunity for this kind of fixup is small.
Newer AMD systems don't need it as they have an extra
way of specifying memory about 4G as WB.  Systems with just
the MTRRs can only use this when they have right around 4GB
because with more memory there are not enough MTRRs to leave them
non-overlapping and still mark all of memory WB.

Eric
