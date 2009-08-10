Return-Path: <linux-kernel-owner+w=401wt.eu-S1751968AbZHJTVx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751968AbZHJTVx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 15:21:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751857AbZHJTVx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 15:21:53 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:60348 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751822AbZHJTVw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 15:21:52 -0400
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Sukadev Bhattiprolu <sukadev@us.ibm.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>
References: <b0943d9e0907081433y599e6d51j285c390f18d7b32c@mail.gmail.com>
	<20090729170315.f62066c0.akpm@linux-foundation.org>
	<20090730212956.GA26863@redhat.com>
	<1249035398.29967.8.camel@pc1117.cambridge.arm.com>
	<20090802213528.GA18795@redhat.com> <m1ws5lekmy.fsf@fess.ebiederm.org>
	<1249923358.10848.75.camel@pc1117.cambridge.arm.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Mon, 10 Aug 2009 12:21:44 -0700
In-Reply-To: <1249923358.10848.75.camel@pc1117.cambridge.arm.com> (Catalin Marinas's message of "Mon\, 10 Aug 2009 17\:55\:58 +0100")
Message-ID: <m1bpmncw53.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: catalin.marinas@arm.com, serue@us.ibm.com, sukadev@us.ibm.com, linux-kernel@vger.kernel.org, akpm@linux-foundation.org, oleg@redhat.com
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Catalin Marinas <catalin.marinas@arm.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: Possible memory leak via alloc_pid()
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Catalin Marinas <catalin.marinas@arm.com> writes:

> On Sun, 2009-08-02 at 18:44 -0700, Eric W. Biederman wrote:
>> Hmm.  I'm starting to wonder if kmemleak is right.  I don't know how
>> it works but something about the way pids are used might be confusing it.
>
> It could as well be a false positive but I can't find its source.
>
> Basically, the pid structure for the dead Xorg is still allocated
> minutes after Xorg died with a pid->count of 2. Kmemleak scans the data
> and bss sections, task stacks and most of the allocated objects (which
> are not reported as leaks) but cannot find a pointer to this pid
> structure (or anywhere inside it like pid->number.pid_chain).
>
> The supposedly leaked pid structure also have pid_chain.pprev ==
> LIST_POISON2 which means that it was already removed from the pid_hash
> (this block of memory is scanned by kmemleak anyway).
>
> The free_pid() function was also called on this object according to the
> pid->rcu values but put_pid() couldn't free it because of pid->count.
>
> If this structure in not on pid_hash, is there any other place where its
> pointer may be stored for a long time? Otherwise it looks like a real
> leak (though not a big one).

It depends on how it is used. Pids not on the pid_hash are perfectly
fine.  We use these kinds of long standing pid references to prevent
any chance that pid rollover would be a problem.   There are corner
cases in the SIGIO path and a few other places where we have
these kind of long standing pid references.

Perhaps it comes from the tty switching code?

> I'll do more tests in the next few days as suggested by Oleg.

Thanks, and thanks for spotting into and looking into this.

Eric
