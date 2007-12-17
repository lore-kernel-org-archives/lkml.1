Return-Path: <linux-kernel-owner+w=401wt.eu-S1760575AbXLQP2N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760575AbXLQP2N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 10:28:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753498AbXLQP17
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 10:27:59 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:37062 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752991AbXLQP16 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 10:27:58 -0500
Date: Mon, 17 Dec 2007 16:27:16 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Robert Hancock <hancockr@shaw.ca>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Pavel Machek <pavel@ucw.cz>,
       "David P. Reed" <dpreed@reed.com>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
       Rene Herman <rene.herman@keyaccess.nl>
Subject: Re: [PATCH] x86_64: fix problems due to use of "outb" to port 80
	on some AMD64x2 laptops, etc.
Message-ID: <20071217152716.GA27223@elte.hu>
References: <fa.F/CPALGk5eBe3QDRN7pjalMH5m4@ifi.uio.no> <fa.56LRmmk2ZdofP2s+juNK5l0iREQ@ifi.uio.no> <fa.FRcgZwrZusfLF5d88S6yPr2bvYo@ifi.uio.no> <fa.eZe9IlwlTeEF/5eA+8kKfNUncS4@ifi.uio.no> <fa.EBJleK5JYl+P/h3+2m6zPq3PzDc@ifi.uio.no> <fa.jU9nntHcOIpTOJuwui+u+/gya4Y@ifi.uio.no> <4765C97B.3000305@shaw.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4765C97B.3000305@shaw.ca>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Robert Hancock <hancockr@shaw.ca> wrote:

>> unfortunately this hack's side-effects are mis-used by an unknown 
>> number of drivers to mask PCI posting bugs. We want to figure out 
>> those bugs (safely and carefully) and we want to remove this hack 
>> from modern machines that dont need it. Doing anything else would be 
>> superstition.
>
> Are there any such examples known of such drivers? It doesn't seem to 
> make much sense.. PCI IO writes are not posted on any known system 
> (the spec allows them to be posted in the host bus bridge, but if they 
> were they could only be flushed by a read, not a write) and PCI MMIO 
> writes are only guaranteed to flush by doing a read from that device, 
> not by other random port accesses. I suppose using the _p versions of 
> port accesses might happen to mask such problems on certain machines..

yeah, that's the fear - that timing sensitivities or outright races are 
hidden via _p() uses. It's a bit like the BKL - nobody really knows why 
it's still needed in some places but there's "fear" that "stuff might 
break" so removal is very slow. So we should get rid of all _p() uses, 
by either removing them (concluding that the _p() was not needed), or by 
adding in an udelay(2) (documenting that the device indeed relies on the 
delay from the host side) or by adding whatever posting/flushing is 
needed. That will gradually reduce the amount of code that uses _p() 
methods, and will improve the quality of the kernel.

	Ingo
