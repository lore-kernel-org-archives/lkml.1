Return-Path: <linux-kernel-owner+w=401wt.eu-S1754538AbYKDLZZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754538AbYKDLZZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 06:25:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753267AbYKDLZM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 06:25:12 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:35074 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752739AbYKDLZK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 06:25:10 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Avi Kivity <avi@redhat.com>
Cc: Eduardo Habkost <ehabkost@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Andrey Borzenkov <arvidjaar@mail.ru>, mingo@redhat.com,
       Andrew Morton <akpm@osdl.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <200810312118.45368.arvidjaar@mail.ru>
	<20081103090843.GI11730@elte.hu> <490ECC4D.9090704@redhat.com>
	<20081103133306.GZ23893@blackpad> <490F0DA3.4090108@redhat.com>
	<m1myggdbzg.fsf@frodo.ebiederm.org> <4910283B.4070501@redhat.com>
Date: Tue, 04 Nov 2008 03:22:30 -0800
In-Reply-To: <4910283B.4070501@redhat.com> (Avi Kivity's message of "Tue, 04
	Nov 2008 12:47:23 +0200")
Message-ID: <m163n3burt.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=mx04.mta.xmission.com;;;ip=24.130.11.59;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Rcpt-To: too long (recipient list exceeded maximum allowed size of 128 bytes)
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Avi Kivity <avi@redhat.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -1.1 BAYES_05 BODY: Bayesian spam probability is 1 to 5%
	*      [score: 0.0493]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [PATCH] Use BIOS reboot on Toshiba Portege 4000
X-SA-Exim-Version: 4.2.1 (built Thu, 07 Dec 2006 04:40:56 +0000)
X-SA-Exim-Scanned: Yes (on mx04.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity <avi@redhat.com> writes:

> Eric W. Biederman wrote:
>> I think we are confusing two issues here.
>>
>> - Ordinary machine_restart which happens to call emergency_restart.
>>   And is proceeded by machine_shutdown.
>>
>> - And emergency_restart itself.
>>
>> To some extent I would be a lot happier if Alt-sysrq-r did what
>> was necessary to get into a context where it can call machine_restart
>> or even better kernel_restart().
>> emergency_restart() is a nice idea but is broken by design.
>>
>>
>
> Isn't emergency_restart() equivalent to kexec()?  Both start from indeterminite
> conditions.

Good point.  That is a reasonable direction to evolve it on x86.
Similar to and sharing some of the same code as the kexec on panic path.

We may need to separate out emergency_restart from the normal clean
restart to make that happen.  It would be pointless and silly to be
sending NMI at other cpus for example if we have cleanly shut them
down already.

>> That said.  If we can turn off vmx on that one processor.
>> That should be enough for the cpu to triple fault and let
>> the BIOS do what it needs to do on that cpu i.e. outb(magic, 0x92)
>> and toggle a motherboard level reset?
>>
>>
>
> If triple fault is wired to INIT (as it is at least on some systems; for example
> one of mine) then the cpu will reset, but why will the bios proceed to issue a
> motherboard reset?  Won't it happily POST it's way to boot (leaving the other
> cpus dead)?

I'm not certain.  But when I was writing BIOS's it was much easier to
just toggle the reset line than to try and cope with the weird state
the machine was in.  I'm pretty certain why we don't see more problems
with reboot when we leave the machine in a weird state.   It is certainly
legal for a BIOS to just run the POST code though.


>> If I read the earlier comments correctly the deep issue is
>> that going through ACPI to reset systems is less reliable than
>> doing it the classic way.
>>
>
> It depends on the system; both are unreliable.  But if we use the same trick as
> with kdump (NMI SIPI + vmxoff) the choice will be orthogonal to whether vmx is
> in use or not.


Yes.

Eric
