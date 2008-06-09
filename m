Return-Path: <linux-kernel-owner+w=401wt.eu-S1757095AbYFIH5S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757095AbYFIH5S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 03:57:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751978AbYFIH5I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 03:57:08 -0400
Received: from mail29.messagelabs.com ([216.82.249.147]:26693 "EHLO
	mail29.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751958AbYFIH5G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 03:57:06 -0400
X-VirusChecked: Checked
X-Env-Sender: Uwe.Kleine-Koenig@digi.com
X-Msg-Ref: server-11.tower-29.messagelabs.com!1212998225!6018729!1
X-StarScan-Version: 5.5.12.14.2; banners=-,-,-
X-Originating-IP: [66.77.174.13]
Date: Mon, 9 Jun 2008 09:57:01 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <Uwe.Kleine-Koenig@digi.com>
To: "Hans J. Koch" <hjk@linutronix.de>
CC: Magnus Damm <magnus.damm@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "gregkh@suse.de" <gregkh@suse.de>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "lethal@linux-sh.org" <lethal@linux-sh.org>,
       "tglx@linutronix.de" <tglx@linutronix.de>
Subject: Re: [PATCH] uio_pdrv: Unique IRQ Mode
Message-ID: <20080609075701.GA20656@digi.com>
References: <20080604060826.17162.46972.sendpatchset@rx1.opensource.se> <20080604101144.GA3207@local> <aec7e5c30806041825o4c6c859fp8380063e9384622@mail.gmail.com> <20080605090916.GA3198@local> <aec7e5c30806050246t248abc39vbc1e71d4475a0a0d@mail.gmail.com> <20080605112744.GB3198@local> <aec7e5c30806080319y7b9b6a89icacbfa67b117fb2b@mail.gmail.com> <20080608205455.GA3191@local>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080608205455.GA3191@local>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 09 Jun 2008 07:57:02.0132 (UTC) FILETIME=[66AD7F40:01C8CA06]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Hans,

> Did you notice that in this thread nobody spoke up to support your
> patch?
Actually I like what the patch tries to achieve.  I'd like to have it a
bit more explicit tough:

- Provide the irq disabling handler in uio_pdrv.c (or even uio.c) with a
  prototype in an adequate header.  Then the platforms that want this
  kind of handling can request it explicitly.

- Don't use this handler automatically.

- Provide the function named uio_pdrv_unique_irqcontrol in Magnus' patch
  in uio_pdrv.c and in an adequate header.

- Either rely on userspace to enable the irq before reading/polling or
  assert that in kernel space.  See also
  http://thread.gmane.org/gmane.linux.kernel/684683/focus=689635
  (I asked tglx about the race condition via irc, but without a response
  so far.)
  Currently the former is done, but if we decide to let it as it is, I'd
  like to have it documented.  (I.e. something like:  "Before
  polling/reading /dev/uioX assert that irqs are enabled.")

The last point is a bit independent from that mode, but applies to
devices that have a irqcontrol function in general.

Apart from the general things above, I'd change a few things in the
implementation:

 - call dev_info->irqcontrol(OFF) in the handler (instead of
   disable_irq()) and demand that calling this is idempotent.
   With this change it isn't uio_pdrv specific any more and could go to
   uio.c.

 - rename "Unique IRQ Mode" to something like "No IRQ Handler Mode".
   I'm not completely lucky with that name, but it's better than the
   former.  Of course the function should be renamed accordingly.

 - s/unsigned long irq_disabled/unsigned int irq_disabled : 1/ in struct
   uio_platdata.

Best regards
Uwe

-- 
Uwe Kleine-König, Software Engineer
Digi International GmbH Branch Breisach, Küferstrasse 8, 79206 Breisach, Germany
Tax: 315/5781/0242 / VAT: DE153662976 / Reg. Amtsgericht Dortmund HRB 13962
