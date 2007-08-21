Return-Path: <linux-kernel-owner+w=401wt.eu-S1756595AbXHUF5N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756595AbXHUF5N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 01:57:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752121AbXHUF5A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 01:57:00 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:51341 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751848AbXHUF47 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 01:56:59 -0400
Subject: Re: [linux-usb-devel] [4/4] 2.6.23-rc3: known regressions
From: Arjan van de Ven <arjan@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Brownell <david-b@pacbell.net>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       linux-usb-devel@lists.sourceforge.net, Greg KH <gregkh@suse.de>,
       LKML <linux-kernel@vger.kernel.org>,
       "Stuart_Hayes@Dell.com" <Stuart_Hayes@dell.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Daniel Exner <dex@dragonslave.de>
In-Reply-To: <alpine.LFD.0.999.0708202201580.30176@woody.linux-foundation.org>
References: <46C098FD.1030601@googlemail.com>
	 <200708202102.58508.david-b@pacbell.net>
	 <alpine.LFD.0.999.0708202106290.30176@woody.linux-foundation.org>
	 <200708202148.45575.david-b@pacbell.net>
	 <alpine.LFD.0.999.0708202201580.30176@woody.linux-foundation.org>
Content-Type: text/plain
Organization: Intel International BV
Date: Mon, 20 Aug 2007 22:51:28 -0700
Message-Id: <1187675488.2676.3.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.11.90 (2.11.90-1.fc8) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> Have we done that? Yes. We actually had a "no-hlt" kernel command line 
> flag that literally disabled halting the CPU, because it apparently caused 
> problems for some floppy disk setups (and yes, the main reasonable 
> explanation was some bad DMA interaction, we never figured it out).
> 
> So it might be much better if we instead re-introduced that kind of "DMA 
> latency requirement", and letting different subsystems react to that as 
> they may.


wait.... we HAVE that infrastructure .. see kernel/latency.c ...


> It really can affect more than just cpufreq - I would not be in the 
> *least* surprised if C3 latencies and other things can cause these things 
> too! But even within cpufreq, it's quite likely to hit certain situations 
> more than others.

and kernel/latency.c was designed EXACTLY for that reason. All the USB
layer has to do is to announce it's latency requirement like this:

/* 
 * Some broadcom chips are buggy and can't take more than 5 usec as DMA
 * latency; inform the rest of kernel of this.
 */
if (weird_broadcom_chip())
	set_acceptable_latency("ehci", 5);


and the C-state code will honor it. CPUFREQ doesn't honor it yet but
that's easy to add.. (this assumes the ACPI BIOS informs us correctly
about the cpu behavior, but that's the best we can do obviously unless
you want a table inside the kernel keyed off vendor/model/stepping)




-- 
if you want to mail me at work (you don't), use arjan (at) linux.intel.com
Test the interaction between Linux and your BIOS via http://www.linuxfirmwarekit.org

