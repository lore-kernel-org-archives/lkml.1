Return-Path: <linux-kernel-owner+w=401wt.eu-S1765608AbXLOHo2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765608AbXLOHo2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2007 02:44:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752335AbXLOHoV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Dec 2007 02:44:21 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:48357 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751941AbXLOHoU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2007 02:44:20 -0500
Date: Sat, 15 Dec 2007 08:43:58 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "David P. Reed" <dpreed@reed.com>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
       Rene Herman <rene.herman@keyaccess.nl>, Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH] x86_64: fix problems due to use of "outb" to port 80
	on some AMD64x2 laptops, etc.
Message-ID: <20071215074358.GD12110@elte.hu>
References: <469578CD.3080609@reed.com> <1184216528.12353.203.camel@chaos> <1184218962.12353.209.camel@chaos> <46964352.7040301@reed.com> <1184253339.12353.223.camel@chaos> <469697C6.50903@reed.com> <1184274754.12353.254.camel@chaos> <4761F193.7090400@reed.com> <20071214131502.GA14359@elte.hu> <4762C551.5070003@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4762C551.5070003@zytor.com>
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


* H. Peter Anvin <hpa@zytor.com> wrote:

> I believe this will suffer from the issue that was raised: this will 
> use udelay() long before loop calibration (and no, we can't just "be 
> conservative" since there is no "conservative" value we can use.)
>
> Worse, I suspect that at least the PIT, which may need to be used for 
> udelay calibration, is one of the devices that may be affected.  I 
> have seen the Verilog for a contemporary chipset, and it can only 
> access the PIT once per microsecond -- this actually has to do with 
> the definition of the PIT; some of the PIT operations are ill-defined 
> if allowed at a higher frequency than the PIT clock.

i think the native_io_delay() in quirks.c signals the obvious solution: 
a DMI (or otherwise) driven quirk that activates a port 0x80 based delay 
on such boards. Combined with an iodelay=port80 boot option as well 
perhaps, just in case someone hits a system that is not blacklisted yet. 
This way such crazy broken hardware can be mapped correctly - like we 
map such quirks in every other case. Perhaps even do this workaround on 
the PIT driver level. Instead of perpetuating the superstition of port 
80 forever.

	Ingo
