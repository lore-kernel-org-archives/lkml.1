Return-Path: <linux-kernel-owner+w=401wt.eu-S1756355AbYG3BdP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756355AbYG3BdP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 21:33:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753225AbYG3Bc6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 21:32:58 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:32929 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753061AbYG3Bc6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 21:32:58 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: "Yinghai Lu" <yhlu.kernel@gmail.com>, "Mike Travis" <travis@sgi.com>,
       "Dhaval Giani" <dhaval@linux.vnet.ibm.com>,
       "Thomas Gleixner" <tglx@linutronix.de>, "Ingo Molnar" <mingo@elte.hu>,
       lkml <linux-kernel@vger.kernel.org>, "Jack Steiner" <steiner@sgi.com>,
       "Alan Mayer" <ajm@sgi.com>, "Cliff Wickman" <cpw@sgi.com>
References: <20080729160939.GA4484@linux.vnet.ibm.com>
	<86802c440807291135m7f8e2163xdde14545e311649a@mail.gmail.com>
	<86802c440807291220t7813effcwb32ae6c18e3cddfe@mail.gmail.com>
	<m1d4kwbg8f.fsf@frodo.ebiederm.org> <488F96DD.6020505@sgi.com>
	<86802c440807291521k6e6277b5ta05b180d0d1c963a@mail.gmail.com>
	<m17ib48etp.fsf@frodo.ebiederm.org>
	<20080730010044.06e7442b@lxorguk.ukuu.org.uk>
Date: Tue, 29 Jul 2008 18:29:02 -0700
In-Reply-To: <20080730010044.06e7442b@lxorguk.ukuu.org.uk> (Alan Cox's message
	of "Wed, 30 Jul 2008 01:00:44 +0100")
Message-ID: <m17ib42m8x.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Alan Cox <alan@lxorguk.ukuu.org.uk>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.0 BAYES_50 BODY: Bayesian spam probability is 40 to 60%
	*      [score: 0.4134]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: kernel BUG at arch/x86/kernel/io_apic_64.c:357!
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox <alan@lxorguk.ukuu.org.uk> writes:

> On Tue, 29 Jul 2008 16:12:50 -0700
> ebiederm@xmission.com (Eric W. Biederman) wrote:
>
>> "Yinghai Lu" <yhlu.kernel@gmail.com> writes:
>> 
>> >> But this would be a show stopper for SGI being able to ship systems if the
>> >> distros do not want to waste this much memory and won't set NR_CPUS=4096.
>> >
>> > wonder if nr_irqs need to be probed dynamically too.
>> 
>> NR_IRQS simply needs to die.
>
> Agreed - it would also be nice to bite the bullet at the same time and
> stop using dev->irq as an integer in an increasingly fake and imaginary
> numberspace and instead make it an object with a description and other
> properties. That would make "no IRQ" NULL, let us display meaningful IRQ
> strings and the like as well as ensuring nobody tries to abuse NR_IRQ and
> hardcoded similar knowledge for arrays

Unfortunately that is extremely expensive and hard.  Plus with NR_IRQs
going away the irq number space becomes sparse enough that the irq
numbers can become stable between boots, and as meaningful as they
have ever been.  At least for userspace an irq number is part of the
ABI so we will need one for the forseeable future.

We really need to change architecture specific code/generic irq code
first, preserving the number based interface to the drivers.  Then if
it looks useful change the drivers.

I would like nothing better then to change fields from "int irq" to
"struct irq_desc *irq" but unless we want to do a 2.7 we need a migration
path.  So we can change drivers slowly.  Which means providing both
interfaces in parallel for a while.

So it makes most sense to me to change everything beneath interfaces still
taking irq numbers (because that is where we get the performance and the
scalability improvements).  Then push forward with driver level changes.

Eric

