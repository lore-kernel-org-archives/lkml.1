Return-Path: <linux-kernel-owner+w=401wt.eu-S1761605AbZCTXmM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761605AbZCTXmM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 19:42:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764511AbZCTXkU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 19:40:20 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:60325 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764494AbZCTXkS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 19:40:18 -0400
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Jan Beulich <jbeulich@novell.com>,
       tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org
References: <49B91A7E.76E4.0078.0@novell.com>
	<tip-6a09dfa870ba0ed21b1124539968a36b42660661@git.kernel.org>
	<1236934491.5188.209.camel@laptop> <49BA33BE.76E4.0078.0@novell.com>
	<1236937423.22914.3698.camel@twins> <20090313103828.GB31094@elte.hu>
	<m1d4cd9n4k.fsf@fess.ebiederm.org> <20090320085205.GB16021@elte.hu>
	<m14oxo8qis.fsf@fess.ebiederm.org> <20090320182404.GA31629@elte.hu>
	<1237575134.4667.5.camel@laptop>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Fri, 20 Mar 2009 16:40:03 -0700
In-Reply-To: <1237575134.4667.5.camel@laptop> (Peter Zijlstra's message of "Fri\, 20 Mar 2009 19\:52\:14 +0100")
Message-ID: <m1zlff227g.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=67.169.126.145;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.169.126.145
X-SA-Exim-Rcpt-To: peterz@infradead.org, linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com, tglx@linutronix.de, jbeulich@novell.com, mingo@elte.hu
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Peter Zijlstra <peterz@infradead.org>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.0 XMSolicitRefs_1 + 2 solicitation references
Subject: Re: [tip:core/ipi] generic-ipi: eliminate spurious pointlessWARN_ON()s
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra <peterz@infradead.org> writes:

> On Fri, 2009-03-20 at 19:24 +0100, Ingo Molnar wrote:
>> * Eric W. Biederman <ebiederm@xmission.com> wrote:
>> 
>> > Now back to my regularly scheduled hotunplug challenges starting 
>> > with getting lockdep to warn about the dead locks.
>
> http://programming.kicks-ass.net/kernel-patches/cpu-hotplug/
>
> The recursive read code needs more work.. 

Cpu hotunplug isn't quite where I am looking at.

Normal device hotunplug, and in particular the use counts sysctl,
proc, and sysfs that act as reader locks that we eventually wait for
when it comes time to free those structures.

I think they fit the same model as reader/writer locks where the
readers can recurse but the writers can not.  Which seems to be
the model of rcu locks as well.

It doesn't look like read==2 works properly because it does not log any
locks grabbed underneath the reader lock.  Is that deliberate?  It certainly
does not seem to be correct.

The deadlock I am worried about is:
rtnl_lock()                                 inc_use_count();
wait use_count == 0.                        rtnl_lock();

Which you I have seen several people hit in the last couple of weeks.

Eric
