Return-Path: <linux-kernel-owner+w=401wt.eu-S1756195AbYGIVMP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756195AbYGIVMP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 17:12:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751967AbYGIVL7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 17:11:59 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:46629 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751049AbYGIVL5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 17:11:57 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Mike Travis <travis@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>
References: <20080709165129.292635000@polaris-admin.engr.sgi.com>
	<m1abgqzv3g.fsf@frodo.ebiederm.org> <20080709200757.GD14009@elte.hu>
	<48751B57.8030605@goop.org> <48751CF9.4020901@linux-foundation.org>
	<4875209D.8010603@goop.org> <487522A8.60906@zytor.com>
	<48752409.1030201@goop.org>
Date: Wed, 09 Jul 2008 14:06:27 -0700
In-Reply-To: <48752409.1030201@goop.org> (Jeremy Fitzhardinge's message of
	"Wed, 09 Jul 2008 13:48:09 -0700")
Message-ID: <m1abgqu5rg.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Jeremy Fitzhardinge <jeremy@goop.org>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.7 BAYES_20 BODY: Bayesian spam probability is 5 to 20%
	*      [score: 0.0971]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [RFC 00/15] x86_64: Optimize percpu accesses
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge <jeremy@goop.org> writes:

> H. Peter Anvin wrote:
>> Thinking about this some more, I don't know if it would make sense to put the
>> x86-64 stack canary at the *end* of the percpu area, and otherwise use
>> negative offsets.  That would make sure they were readily reachable from
>> %rip-based references from within the kernel text area.
>
> If we can move the canary then a whole pile of options open up.  But the problem
> is that we can't.

But we can pick an arbitrary point where %gs points at.

Hmm.  This whole thing is even sillier then I thought.
Why can't we access per cpu vars as:
%gs:(per_cpu__var - __per_cpu_start) ?

If we can subtract constants and allow the linker to perform that resolution
at link.  A zero based per cpu segment becomes a moot issue.

We may need to change the definition of PERCPU in vmlinux.lds.h to
#define PERCPU(align)							\
	. = ALIGN(align);						\
-	__per_cpu_start = .;					\
	.data.percpu  : AT(ADDR(.data.percpu) - LOAD_OFFSET) {		\
+		__per_cpu_start = .;					\
		*(.data.percpu)						\
		*(.data.percpu.shared_aligned)				\
+		__per_cpu_end = .;					\
+	}
-	}								\
-	__per_cpu_end = .;


So that the linker knows  __per_cpu_start and __per_cpu_end are in the same section
but otherwise it sounds entirely reasonable.  Just slightly trickier math at link
time.

Eric
