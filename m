Return-Path: <linux-kernel-owner+w=401wt.eu-S1756480AbYGIUmO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756480AbYGIUmO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 16:42:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752845AbYGIUl5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 16:41:57 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:59400 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752774AbYGIUl4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 16:41:56 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Arjan van de Ven <arjan@infradead.org>
Cc: Mike Travis <travis@sgi.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org
References: <20080709165129.292635000@polaris-admin.engr.sgi.com>
	<m1abgqzv3g.fsf@frodo.ebiederm.org>
	<20080709131405.54f9d49b@infradead.org>
Date: Wed, 09 Jul 2008 13:33:21 -0700
In-Reply-To: <20080709131405.54f9d49b@infradead.org> (Arjan van de Ven's
	message of "Wed, 9 Jul 2008 13:14:05 -0700")
Message-ID: <m1y74ax0fi.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Arjan van de Ven <arjan@infradead.org>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.0 BAYES_50 BODY: Bayesian spam probability is 40 to 60%
	*      [score: 0.4192]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [RFC 00/15] x86_64: Optimize percpu accesses
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven <arjan@infradead.org> writes:

> On Wed, 09 Jul 2008 13:00:19 -0700
> ebiederm@xmission.com (Eric W. Biederman) wrote:
>
>> 
>> I just took a quick look at how stack_protector works on x86_64.
>> Unless there is some deep kernel magic that changes the segment
>> register to %gs from the ABI specified %fs CC_STACKPROTECTOR is
>> totally broken on x86_64.  We access our pda through %gs.
>
> and so does gcc in kernel mode.

Some gcc's in kernel mode.  The one I tested with doesn't.

>> Further -fstack-protector-all only seems to detect against buffer
>> overflows and thus corruption of the stack.  Not stack overflows.  So
>> it doesn't appear especially useful.
>
> stopping buffer overflows and other return address corruption is not
> useful? Excuse me?

Stopping buffer overflows and return address corruption is useful.  Simply
catching and panic'ing the machine when the occur is less useful.  We aren't
perfect but we have a pretty good track record of handling this with
old fashioned methods.

>> So we don't we kill the broken CONFIG_CC_STACKPROTECTOR.  Stop trying
>> to figure out how to use a zero based percpu area.
>
> So why don't we NOT do that and fix instead what you're trying to do?

So our choices are.
fix -fstack-protector to not use a hard coded offset.
fix gcc/ld to not miscompile the kernel at random times that prevents us from
booting when we add a segement with an address at 0.

-fstack-protector does not use the TLS ABI and instead uses nasty hard coded magic
and that is why it is a problem.  Otherwise we could easily support it.

>> That should allow us to make the current pda a per cpu variable, and
>> use %gs with a large offset to access the per cpu area. 
>
> and what does that gain us?

A faster more maintainable kernel.

Eric
