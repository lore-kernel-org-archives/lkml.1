Return-Path: <linux-kernel-owner+w=401wt.eu-S1756405AbYKCQPW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756405AbYKCQPW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 11:15:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754439AbYKCQPJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 11:15:09 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:47641 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754382AbYKCQPH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 11:15:07 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Avi Kivity <avi@redhat.com>
Cc: Eduardo Habkost <ehabkost@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Andrey Borzenkov <arvidjaar@mail.ru>, mingo@redhat.com,
       Andrew Morton <akpm@osdl.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <200810312118.45368.arvidjaar@mail.ru>
	<20081103090843.GI11730@elte.hu> <490ECC4D.9090704@redhat.com>
	<20081103133306.GZ23893@blackpad> <490F0DA3.4090108@redhat.com>
Date: Mon, 03 Nov 2008 08:13:07 -0800
In-Reply-To: <490F0DA3.4090108@redhat.com> (Avi Kivity's message of "Mon, 03
	Nov 2008 16:41:39 +0200")
Message-ID: <m1myggdbzg.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=mx04.mta.xmission.com;;;ip=24.130.11.59;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Rcpt-To: too long (recipient list exceeded maximum allowed size of 128 bytes)
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Avi Kivity <avi@redhat.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.2 BAYES_40 BODY: Bayesian spam probability is 20 to 40%
	*      [score: 0.3103]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [PATCH] Use BIOS reboot on Toshiba Portege 4000
X-SA-Exim-Version: 4.2.1 (built Thu, 07 Dec 2006 04:40:56 +0000)
X-SA-Exim-Scanned: Yes (on mx04.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity <avi@redhat.com> writes:

> Eduardo Habkost wrote:
>> We probably need to disable vmx on all CPUs, but emergency reboot skips
>> native_smp_send_stop() (where we could hook a virt_disable call in).
>>
>> As relying on IPIs defeats the whole point of emergency_restart, a proper
>> fix will need to use NMIs like the kdump code does.
>>
>
> They should use the same code; they have a similar environment at entry and
> reliability requirements for e_r are not greater than kdump's.

Just a sec.

I think we are confusing two issues here.

- Ordinary machine_restart which happens to call emergency_restart.
  And is proceeded by machine_shutdown.

- And emergency_restart itself.

To some extent I would be a lot happier if Alt-sysrq-r did what
was necessary to get into a context where it can call machine_restart
or even better kernel_restart().
emergency_restart() is a nice idea but is broken by design.

That said.  If we can turn off vmx on that one processor.
That should be enough for the cpu to triple fault and let
the BIOS do what it needs to do on that cpu i.e. outb(magic, 0x92)
and toggle a motherboard level reset?

If I read the earlier comments correctly the deep issue is
that going through ACPI to reset systems is less reliable than
doing it the classic way.

Eric

