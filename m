Return-Path: <linux-kernel-owner+w=401wt.eu-S1755972AbYGIUCQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755972AbYGIUCQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 16:02:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751597AbYGIUCB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 16:02:01 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:42294 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933AbYGIUCA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 16:02:00 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Mike Travis <travis@sgi.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org
References: <20080709165129.292635000@polaris-admin.engr.sgi.com>
Date: Wed, 09 Jul 2008 13:00:19 -0700
In-Reply-To: <20080709165129.292635000@polaris-admin.engr.sgi.com> (Mike
	Travis's message of "Wed, 09 Jul 2008 09:51:29 -0700")
Message-ID: <m1abgqzv3g.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Mike Travis <travis@sgi.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.2 BAYES_40 BODY: Bayesian spam probability is 20 to 40%
	*      [score: 0.2320]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [RFC 00/15] x86_64: Optimize percpu accesses
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I just took a quick look at how stack_protector works on x86_64.  Unless there is
some deep kernel magic that changes the segment register to %gs from the ABI specified
%fs CC_STACKPROTECTOR is totally broken on x86_64.  We access our pda through %gs.

Further -fstack-protector-all only seems to detect against buffer overflows and
thus corruption of the stack.  Not stack overflows.  So it doesn't appear especially
useful.

So we don't we kill the broken CONFIG_CC_STACKPROTECTOR.  Stop trying to figure out
how to use a zero based percpu area.

That should allow us to make the current pda a per cpu variable, and use %gs with
a large offset to access the per cpu area.  And since it is only the per cpu accesses
and the pda accesses that will change we should not need to fight toolchain issues
and other weirdness.  The linked binary can remain the same.

Eric

