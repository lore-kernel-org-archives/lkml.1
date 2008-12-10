Return-Path: <linux-kernel-owner+w=401wt.eu-S1754472AbYLJOG6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754472AbYLJOG6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 09:06:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751657AbYLJOGt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 09:06:49 -0500
Received: from cpsmtpo-eml04.KPNXCHANGE.COM ([213.75.38.153]:16647 "EHLO
	cpsmtpo-eml04.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750928AbYLJOGs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 09:06:48 -0500
From: Frans Pop <elendil@planet.nl>
To: Ingo Molnar <mingo@elte.hu>, lenb@kernel.org
Subject: "APIC error on CPU1: 00(40)" during resume (was: Regression from 2.6.26: Hibernation (possibly suspend) broken on Toshiba R500)
Date: Wed, 10 Dec 2008 15:06:43 +0100
User-Agent: KMail/1.9.9
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Greg KH <greg@kroah.com>,
       jbarnes@virtuousgeek.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, tiwai@suse.de,
       Andrew Morton <akpm@linux-foundation.org>
References: <200812020320.31876.rjw@sisk.pl> <200812041900.27514.elendil@planet.nl> <alpine.LFD.2.00.0812041037250.3543@nehalem.linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.0812041037250.3543@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812101506.45691.elendil@planet.nl>
X-OriginalArrivalTime: 10 Dec 2008 14:06:46.0169 (UTC) FILETIME=[8966E890:01C95AD0]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Anybody interested in persuing this issue?

On Thursday 04 December 2008, Linus Torvalds wrote:
> Ingo, Len, can you check the end of the email about the apparent
> very-early interrupt issue? Can we get into acpi_ec_gpe_handler()
> without interrupts being enabled some way?
>
> HOWEVER. Having now looked through your fuller dmesg output even for
> the _successful_ case, I actually find a few things that are a bit
> worrying.
[...]
> The third thing that worries me is the _very_ early occurrence of
>
> 	ACPI: Waking up from system sleep state S3
> 	APIC error on CPU1: 00(40)
> 	ACPI: EC: non-query interrupt received, switching to interrupt mode
>
> Now, that "APIC error" thing is worrisome. It's worrisome for multiple
> reasons:
>
>  - errors are never good (0x40 means "received illegal vector",
>    whatever caused _that_)
>
>  - more importantly, it seems to imply that interrupts are enabled on
>    CPU1, and they sure as hell shouldn't be enabled at this stage!
>
>    Do we perhaps have a SMP resume bug where we resume the other CPU's
>    with interrupts enabled?
>
>  - the "ACPI: EC: non-query interrupt received, switching to interrupt
>    mode" thing is from ACPI, and _also_ implies that interrupts are on.
>
> Why are interrupts enabled that early? I really don't like seeing
> interrupts enabled before we've even done the basic PCI resume.
>
> I'd really like to resume the other CPU's much later (last in the whole
> sequnce, long after we've set up devices), but the f'ing ACPI rules
> seem to be against that. And maybe some setup actually needs the CPU's
> alive to act as a bridge for IO (eg with HT or CSI).
