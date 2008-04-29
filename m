Return-Path: <linux-kernel-owner+w=401wt.eu-S1762261AbYD2TJr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762261AbYD2TJr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 15:09:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753739AbYD2TJi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 15:09:38 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:55388 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753641AbYD2TJh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 15:09:37 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: yhlu.kernel@gmail.com
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Gabriel C <nix.or.die@googlemail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Mika Fischer <mika.fischer@zoopnet.de>
References: <200804272337.40130.yhlu.kernel@gmail.com>
	<200804281244.56938.yhlu.kernel@gmail.com>
	<200804281316.14168.yhlu.kernel@gmail.com>
	<200804281505.05764.yhlu.kernel@gmail.com>
Date: Tue, 29 Apr 2008 12:00:51 -0700
In-Reply-To: <200804281505.05764.yhlu.kernel@gmail.com> (Yinghai Lu's message
	of "Mon, 28 Apr 2008 15:05:05 -0700")
Message-ID: <m1wsmg32qk.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [PATCH] x86: mtrr cleanup for converting continuous to discrete layout v5
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu <yhlu.kernel.send@gmail.com> writes:

> some BIOS like to use continus MTRR layout, and may X driver can not add
> WB entries for graphical cards when 4g or more RAM installed.
>
> the patch will change MTRR to discrete.
>
> mtrr_chunk_size= could be used to have smaller continuous block to hold holes.
> default is 256m, could be set according to size of graphics card memory.
>
> v2: fix -1 for UC checking
> v3: default to disable, and need use enable_mtrr_cleanup to enable this feature
>     skip the var state change warning.
>     remove next_basek in range_to_mtrr()
> v4: correct warning mask.
> v5: CONFIG_MTRR_SANITIZER
>
> Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

Skimming through the code it looks fairly sane.

I do think it would be good to split this patch into two pieces.
1) The mtrr rewriter/sanitizer/normalize.
   All it does it should do is rewrite the MTRRs with a
   semantically equivalent value.  This code should always be
   safe and work on any system with MTRRs.

   This works around otherwise sane bios's that simply prefer
   to have contiguous MTRRs.

   I don't see a reason why this code should be configurable.

   This approach avoids earlier concerns because it starts
   with the existing MTRR layout and not with the e820 map.

2) The mtrr_chunk_size code that rounds things off and allows
   us to use discrete MTRRs by reducing some RAM to uncacheable.
   Because it makes things uncacheable it has potentially bad
   side effects on performance and thus potentially bad side
   effects on functionality.  For areas like the SMM and ACPI
   especially as they usually occur at the end of RAM just
   below 4G.

   The chunk size code should be configurable and default to off
   because it has potential side effects.  A KConfig option may
   also be appropriate.  It asks an interesting trade off question
   do you want your BIOS to be fast or X.


Eric
