Return-Path: <linux-kernel-owner+w=401wt.eu-S1752269AbXC1PBh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752269AbXC1PBh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 11:01:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932195AbXC1PBh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 11:01:37 -0400
Received: from nf-out-0910.google.com ([64.233.182.185]:8437 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752192AbXC1PBf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 11:01:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=bIzaZjtENyKpZBTq20OpX2tjivV26dj84SI1zGG/BYYuey2hjoWwA9KJRthemYj7UoqYnBfiTKFUNdNPmhdQAXRfAtWpEHJclKG99N5qod7lZImQE7A1cgV8WDxCNA5Lwkvt8hqXMTsicAoWgCC3zAMQgZBVEVk/fK54jt1ROEI=
From: Maxim <maximlevitsky@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [3/6] 2.6.21-rc4: known regressions
Date: Wed, 28 Mar 2007 17:01:23 +0200
User-Agent: KMail/1.9.6
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Jeff Chua <jeff.chua.linux@gmail.com>, Adrian Bunk <bunk@stusta.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, pavel@suse.cz,
       linux-pm@lists.osdl.org, gregkh@suse.de,
       linux-pci@atrey.karlin.mff.cuni.cz, Jens Axboe <jens.axboe@oracle.com>,
       Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
       jgarzik@pobox.com, linux-ide@vger.kernel.org,
       "Michael S. Tsirkin" <mst@mellanox.co.il>
References: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org> <200703281543.47049.maximlevitsky@gmail.com> <20070328144148.GA16244@elte.hu>
In-Reply-To: <20070328144148.GA16244@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703281701.23876.maximlevitsky@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 28 March 2007 16:41:48 Ingo Molnar wrote:
> 
> * Maxim <maximlevitsky@gmail.com> wrote:
> 
> > I almost sure I know why this happens,
> 
> cool! Your patch is a definite improvement on my t60 (where 
> suspend/resume never worked with hpet enabled). But it does not fix 
> everything - for example the timings are way off after resume. Thomas?
> 
> 	Ingo
> 

The problem is that HPET  consists of two parts:
	one is a main counter and second is a a timers.

	To enable main counter one must set HPET_CFG_ENABLE.
	It is set only on boot, and not on resume now.

	But on my system I think bios re-enables it.

	Secondary to enable HPET to act as a timer on IRQ0 and to make it replace RTC IRQ8 one must set
	HPET_CFG_LEGACY

	This bit is definitely not set on resume, so on my system I get a hang if I use HPET as clockevents device,
	and on other system where bios doesn't reenable HPET, then even if HPET is used as timing device 
	'date won't advance'

	But I set those bits only in initialization of HPET clockevents device, and I set always, when it is turned on,
	It is not that good,but works.

	Now I don't have a clue how to set those bits if only HPET is used as clock source because now clocksources
	don't have _any_ resume hook.

	The timing problem you mention I think isd connected to the fact that HPET is not enabled instantly after resume, but after some time when clockevents
	core calls HPET to enable event timer.

	Best regards,
		Maxim Levitsky
