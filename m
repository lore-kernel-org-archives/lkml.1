Return-Path: <linux-kernel-owner+w=401wt.eu-S1761960AbXKMVsh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761960AbXKMVsh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 16:48:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759598AbXKMVs2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 16:48:28 -0500
Received: from madara.hpl.hp.com ([192.6.19.124]:53320 "EHLO madara.hpl.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759591AbXKMVs1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 16:48:27 -0500
Date: Tue, 13 Nov 2007 13:46:28 -0800
From: Stephane Eranian <eranian@hpl.hp.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: akpm@osdl.org, Robert Richter <robert.richter@amd.com>, gregkh@suse.de,
       linux-kernel@vger.kernel.org, perfmon@napali.hpl.hp.com,
       William Cohen <wcohen@redhat.com>, perfmon2-devel@lists.sourceforge.net
Subject: Re: [perfmon] Re: [perfmon2] perfmon2 merge news
Message-ID: <20071113214628.GE5747@frankl.hpl.hp.com>
Reply-To: eranian@hpl.hp.com
References: <20071107003454.GA13374@kroah.com> <20071109120627.60ec9ab4.akpm@linux-foundation.org> <20071109213829.GC28276@kroah.com> <p73abpl2654.fsf@bingen.suse.de> <20071113151718.GA3804@erda.amd.com> <4739C42F.8030208@redhat.com> <20071113175545.GD4319@frankl.hpl.hp.com> <4739EE13.2090006@redhat.com> <20071113211345.GB5747@frankl.hpl.hp.com> <20071113212902.GA17593@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071113212902.GA17593@one.firstfloor.org>
User-Agent: Mutt/1.4.1i
Organisation: HP Labs Palo Alto
Address: HP Labs, 1U-17, 1501 Page Mill road, Palo Alto, CA 94304, USA.
E-mail: eranian@hpl.hp.com
X-HPL-MailScanner: Found to be clean
X-HPL-MailScanner-From: eranian@hpl.hp.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi.

On Tue, Nov 13, 2007 at 10:29:02PM +0100, Andi Kleen wrote:
> On Tue, Nov 13, 2007 at 01:13:45PM -0800, Stephane Eranian wrote:
> > Oprofile does not setup the PMU interrupt. It builds on top of the NMI watchdog
> > setup.
> 
> Oprofile works without the NMI watchdog too, but it just happens to be another
> NMI user.
> 
I have no doubt it can work with a "regular" interrupt.

> > It uses the register_die() mechanism, 
> 
> Not correct.
> 
I meant the register_die_notifier() mechanism which allow you to
chain a handler on NMI interrupts. At least that's my understanding
reading the code:

static int nmi_setup(void)
{
        int err=0;
        int cpu;

        if (!allocate_msrs())
                return -ENOMEM;

        if ((err = register_die_notifier(&profile_exceptions_nb))){
                free_msrs();
                pfm_release_allcpus();
                return err;
        }
	...


> > if I recall. The low level APIC
> > and gate is setup elsewhere. Perfmon does not use NMI, unless forced to because
> > of the NMI watchdog. 
> 
> It could handle it in the same way as oprofile if it wanted. But given
> NMIs make everything more complicated and it might not be worth it.
> 
Yes, horribly more complicated because of locking issues within perfmon.
As soon as you expose a file descriptor, you need some locking to prevent
multiple user threads (malicious or not) to compete to access the PMU state.
I think the value add of NMI can be as well achieved with advanced PMU features
such as Intel Core 2 PEBS.

-- 
-Stephane
