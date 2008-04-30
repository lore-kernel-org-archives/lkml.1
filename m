Return-Path: <linux-kernel-owner+w=401wt.eu-S1759988AbYD3IOt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759988AbYD3IOt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 04:14:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755007AbYD3IOb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 04:14:31 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:51655 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754280AbYD3IO3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 04:14:29 -0400
Date: Wed, 30 Apr 2008 10:13:45 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Miller <davem@davemloft.net>
Cc: mchehab@infradead.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, linux-dvb-maintainer@linuxtv.org,
       video4linux-list@redhat.com, linux-kernel@vger.kernel.org,
       sfr@canb.auug.org.au, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [patch, -git] drivers/media build fix for modular builds
Message-ID: <20080430081345.GA16519@elte.hu>
References: <20080429185009.716c3284@gaivota> <20080430074807.GA11224@elte.hu> <20080430.005212.46815036.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080430.005212.46815036.davem@davemloft.net>
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


* David Miller <davem@davemloft.net> wrote:

> From: Ingo Molnar <mingo@elte.hu>
> Date: Wed, 30 Apr 2008 09:48:07 +0200
> 
> > 
> > fix allmodconfig build bug introduced in latest -git by commit 
> > 7c91f0624a9 ("V4L/DVB(7767): Move tuners to common/tuners"):
> > 
> >   LD      kernel/built-in.o
> >   LD      drivers/built-in.o
> >   ld: drivers/media/built-in.o: No such file: No such file or directory
> > 
> > which happens if all media drivers are modular:
> 
> I was seeing this too, as I think was Stephen Rothwell.

i think any build which has the media drivers only as modules will 
trigger it, so it's rather widespread. My fix has held up fine for 10 
randconfigs so far so it should do the trick.

i'm wondering though why similar problems are not more common. A quick 
look at drivers/Makefile suggests that there are many obj-y rules there 
for driver sub-trees that can be all-modular, not just video:

 obj-y                           += video/
 obj-y                           += char/
 obj-y                           += serial/
 obj-y                           += base/ block/ misc/ mfd/ net/ media/
 obj-y                           += macintosh/
 obj-y                           += ieee1394/
 obj-y                           += cdrom/
 obj-y                           += auxdisplay/
 obj-y                           += i2c/
 obj-y                           += lguest/
 obj-y                           += firmware/

drivers/net/ obj-y is kept alive by the "obj-y wireless/" rule i think, 
but what makes other sub-trees link, like drivers/macintosh/ ?

so kbuild apparently has smarts to handle this case - but somehow it 
still failed for drivers/media/.

Sam Cc:-ed - am i missing some detail in this analysis?

hm, one weird rule is drivers/video/matrox/Makefile's my-obj- rule.

	Ingo
