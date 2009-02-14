Return-Path: <linux-kernel-owner+w=401wt.eu-S1753837AbZBNWOx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753837AbZBNWOx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Feb 2009 17:14:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751417AbZBNWOo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Feb 2009 17:14:44 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:56490 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752145AbZBNWOo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Feb 2009 17:14:44 -0500
Date: Sat, 14 Feb 2009 23:14:29 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andres Salomon <dilinger@queued.net>
Cc: Chris Ball <cjb@laptop.org>, Harvey Harrison <harvey.harrison@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] olpc: fix model detection without OFW
Message-ID: <20090214221429.GB5200@elte.hu>
References: <1222208409.16003.25.camel@brick> <m3mycpye65.fsf@pullcord.laptop.org> <20090213231900.4f22008a@ephemeral> <20090214214312.GB31928@elte.hu> <20090214165311.5cf5b8bf@ephemeral>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090214165311.5cf5b8bf@ephemeral>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Andres Salomon <dilinger@queued.net> wrote:

> On Sat, 14 Feb 2009 22:43:12 +0100
> Ingo Molnar <mingo@elte.hu> wrote:
> [...]
> > 
> > Applied to tip:x86/urgent [for v2.6.29], thanks guys!
> > 
> > Did i get the impact-line below right?
> > 
> > 	Ingo
> > 
> 
> More like -
> 
> Impact: garbled display, laptop is unusable
> 
> ;)

ah, okay :-) Serious regression that warrants urgent upstream routing.

> The DCON detection code determines whether there's a DCON attached
> based upon the model (any XO model >= B2 is assumed to have a DCON).
> The LXFB driver determines which mode to use based upon whether or not
> it thinks there's a DCON attached, and the DCON/LXFB can't deal w/
> standard modes.
> 
> So, the result is that LXFB attempts to use some random standard mode
> rather than the DCON-required 1200x900, and the display is unusable.

Where did my git grepping skills go wrong?

I git-grepped the code and this is the scope i found:

olpc_platform_info.boardrev is used for:

 - a printk
 - olpc_board_at_least() which is used in:
    - drivers/input/mouse/hgpk.c:                mouse driver quirk
    - sound/pci/cs5535audio/cs5535audio_olpc.c:  audio quirk

aha. I missed this roundabout impact:

    - arch/x86/kernel/olpc.c:                    OLPC_F_DCON flag
      - which is used in olpc_has_dcon(), which is used in:
        - drivers/video/geode/gxfb_core.c:       GX modes db
                                                 [ouch if this goes wrong!]
        - drivers/video/geode/lxfb_core.c:       ditto

So i guess the mouse and audio quirk point was correct too, but the
major impact is the graphics mode array mismatch and the resulting
nonsensical mode setting, right?

	Ingo
