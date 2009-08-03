Return-Path: <linux-kernel-owner+w=401wt.eu-S1754229AbZHCBot@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754229AbZHCBot (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 21:44:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754190AbZHCBos
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 21:44:48 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:47533 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754188AbZHCBop (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 21:44:45 -0400
To: Oleg Nesterov <oleg@redhat.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Sukadev Bhattiprolu <sukadev@us.ibm.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>
References: <b0943d9e0907081433y599e6d51j285c390f18d7b32c@mail.gmail.com>
	<20090729170315.f62066c0.akpm@linux-foundation.org>
	<20090730212956.GA26863@redhat.com>
	<1249035398.29967.8.camel@pc1117.cambridge.arm.com>
	<20090802213528.GA18795@redhat.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Sun, 02 Aug 2009 18:44:37 -0700
In-Reply-To: <20090802213528.GA18795@redhat.com> (Oleg Nesterov's message of "Sun\, 2 Aug 2009 23\:35\:28 +0200")
Message-ID: <m1ws5lekmy.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: oleg@redhat.com, serue@us.ibm.com, sukadev@us.ibm.com, linux-kernel@vger.kernel.org, akpm@linux-foundation.org, catalin.marinas@arm.com
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Oleg Nesterov <oleg@redhat.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0004]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: Possible memory leak via alloc_pid()
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@redhat.com> writes:

> On 07/31, Catalin Marinas wrote:
>>
>> On Thu, 2009-07-30 at 23:29 +0200, Oleg Nesterov wrote:
>> >
>> > Since you can reproduce the problem easily, perhaps you can use the
>> > hack above to track get/put ?
>> >
>> > 	$ echo pid_of_Xorg > /proc/sys/kernel/xxx
>>
>> Below is the minicom capture. By the time Xorg dies, the count is 2.
>
> Thanks a lot Catalin.
>
>> When logging out, there are two counter incrementing events via
>> sys_wait4 and sys_ioctl, thoush I'm not sure whether they are
>> unbalanced.
>
> wait4() is right, ioctl() looks fine too.
>
>> pgrep Xorg
>> 1519
>> 10:~# pgrep Xorg > /proc/sys/kernel/xxx 
>> XXXXX(1519) ==22
>
> Unfortunately there is nothing which looks like a leak. I gueess it is
> too late to start the tracking.
>
> I'm afraid this won't really help too, but since nobody has a better
> idea for now, perhaps you can do another test?
>
> Pleas rename Xorg to Xorg.origin, and make a simple Xorg script which
> does something like
>
> 	#!/bin/sh
>
> 	echo $$ >> /proc/sys/kernel/xxx
> 	exec /path/to/Xorg.origin $*
>
> perhaps even this is too late, gdm can do a lot before execing.
>
> Please avoid pgrep/ps/etc, proc adds a lot of noise. Better yet, it
> would be nice to start/stop Xorg with /proc unmounted, but I don't
> know is this can work without /proc.

Hmm.  I'm starting to wonder if kmemleak is right.  I don't know how
it works but something about the way pids are used might be confusing it.

Eric
