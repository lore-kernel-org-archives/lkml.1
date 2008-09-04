Return-Path: <linux-kernel-owner+w=401wt.eu-S1756802AbYIDUul@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756802AbYIDUul (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 16:50:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754157AbYIDUub
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 16:50:31 -0400
Received: from one.firstfloor.org ([213.235.205.2]:38598 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753979AbYIDUub (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 16:50:31 -0400
Date: Thu, 4 Sep 2008 22:53:45 +0200
From: Andi Kleen <andi@firstfloor.org>
To: "Mingarelli, Thomas" <Thomas.Mingarelli@hp.com>
Cc: Andi Kleen <andi@firstfloor.org>, Vivek Goyal <vgoyal@redhat.com>,
       Don Zickus <dzickus@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Prarit Bhargava <prarit@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "arozansk@redhat.com" <arozansk@redhat.com>,
       "ak@linux.intel.com" <ak@linux.intel.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       "Maciej W. Rozycki" <macro@linux-mips.org>
Subject: Re: [PATCH RFC] NMI Re-introduce un[set]_nmi_callback
Message-ID: <20080904205345.GO18288@one.firstfloor.org>
References: <20080904145617.GB28095@elte.hu> <87y727vrgu.fsf@basil.nowhere.org> <20080904172052.GN3400@redhat.com> <20080904175231.GH18288@one.firstfloor.org> <20080904182637.GP3400@redhat.com> <20080904190816.GB4349@redhat.com> <20080904200032.GM18288@one.firstfloor.org> <183C1D5A376DE343AA8F94FC2A1EC14938D3E74841@GVW1091EXB.americas.hpqcorp.net> <20080904201926.GN18288@one.firstfloor.org> <183C1D5A376DE343AA8F94FC2A1EC14938D3E7486E@GVW1091EXB.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <183C1D5A376DE343AA8F94FC2A1EC14938D3E7486E@GVW1091EXB.americas.hpqcorp.net>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 04, 2008 at 08:21:40PM +0000, Mingarelli, Thomas wrote:
> The BIOS does the actual logging of the cause of the NMI. What kind of NMI:
> 
> PCI Bus Parity error
> Double bit memory error
> .
> .
> .
> And so on.
> 
> The watchdog is a separate part of the driver. It can be enabled or not; most of our customers will want the NMI sourcing capability of the driver.
> With Prarit's patch we no longer need to worry about the watchdog timer firing. However, yes that was troublesome before his patch. We could not distinguish between a REAL NMI and a watchdog timer tick.
> 
> The BIOS does not come into play until the hpwdt nmi handler gets called.

If you use the die chain (as you should) you'll get notified 
of the NMis, but your handler has to decide if the NMI is for
you or not. The way the chain works is that it asks everyone
(in priority order) and the first one who says "it's for me"
will get it.

So if your handler can decide "This is an NMI that came from
a source i know about" it can be a proper[1] NMI cititzen.

Otherwise it will be hard to make it coexist nicely.

Then if the BIOS tells you the real cause you should also take
over the final handler anyways because as it was pointed out earlier
the Linux default fallback handler is crap (it made sense on a 
IBM PC-AT but not today). If you can ask the BIOS for the real
reason you could printk that instead and everyone will be more
happy. That would be one of those "NMI chipset drivers" I talked
about earlier.

That probably should be a separate driver because it's orthogonal to 
the watchdog. 

 But it should only take 
the default handler when kdump is not active. 

-Andi

[1] proper defined as in "it's still racy, but on low volume
NMIs it will hopefully DTRT"

