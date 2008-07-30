Return-Path: <linux-kernel-owner+w=401wt.eu-S1756330AbYG3ADF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756330AbYG3ADF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 20:03:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752533AbYG3ACy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 20:02:54 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:40781 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752330AbYG3ACx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 20:02:53 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Mike Travis <travis@sgi.com>, Yinghai Lu <yhlu.kernel@gmail.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       lkml <linux-kernel@vger.kernel.org>, Jack Steiner <steiner@sgi.com>,
       Alan Mayer <ajm@sgi.com>, Cliff Wickman <cpw@sgi.com>
References: <20080729160939.GA4484@linux.vnet.ibm.com>
	<86802c440807291135m7f8e2163xdde14545e311649a@mail.gmail.com>
	<86802c440807291220t7813effcwb32ae6c18e3cddfe@mail.gmail.com>
	<m1d4kwbg8f.fsf@frodo.ebiederm.org> <488F96DD.6020505@sgi.com>
	<m1bq0g8euy.fsf@frodo.ebiederm.org> <488FAAD9.4090907@goop.org>
Date: Tue, 29 Jul 2008 17:01:35 -0700
In-Reply-To: <488FAAD9.4090907@goop.org> (Jeremy Fitzhardinge's message of
	"Tue, 29 Jul 2008 16:42:17 -0700")
Message-ID: <m1vdyo44v4.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Jeremy Fitzhardinge <jeremy@goop.org>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.2 SARE_LWSHORTT BODY: SARE_LWSHORTT
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.0 BAYES_50 BODY: Bayesian spam probability is 40 to 60%
	*      [score: 0.5000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: kernel BUG at arch/x86/kernel/io_apic_64.c:357!
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge <jeremy@goop.org> writes:

> I'm still interested in making Xen's event channel-based interrupts fit better
> into the rest of the interrupt handling scheme.  In particular, event channels
> map very closely to the x86-64 notion of a vector.  There's 1024 of them per
> domain, and each is bound to a cpu.  At the moment, I map them to irqs, which
> means that I need to allocate around 5-6 irqs per cpu, which makes everything
> very cluttered.  I'd like to map event channels to vectors, and then map vectors
> to (irq,cpu) tuples.

Uh....  I'm not certain this applies.

> From what I've seen this is exactly how x86-64 currently has things set up, and
> I'm interested in making sure that 32-bit does the same thing.

Yes. x86_32 needs work to get cleaned up.

The architecture on x86_64 is as follows.

We have interrupt sources:  GSIs in the case of acpi.
We have linux interupts:  something with an irq number.

Vectors are an internal implementation detail.

I don't know if your event channels more closely resemble interrupt sources or internal
implementation details.  If they are an implementation detail that interrupt sources
just flow through we should hide them like we do vectors.  If event channels actually are
the sources of interrupts we should do something different.

> I'm also interested in having vectors being sourced from multiple interrupt
> controllers.  So, some vectors would be sourced from APICs, and other are
> sourced from event channels.  This would be useful for Xen domains which have
> direct access to hardware (ie, the dom0 control domain in the short term, and
> disaggregated driver domains later on), and fully emulated domains which have
> paravirtual drivers.

Generally easy except for the disparate methods of catching interrupts.

> I haven't studied the current code to see if this notion already exists or not.
>
> While the APIC interrupt model is the most architecturally important for the x86
> platform, I'd like to make sure we don't build in the assumption that it's the
> *only* interrupt model.

Well with iommus starting to show up in our irq paths it looks we are going to get
a lot of diversity.

Eric

