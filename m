Return-Path: <linux-kernel-owner+w=401wt.eu-S1762892AbZFNTEX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762892AbZFNTEX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 15:04:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757179AbZFNTEQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 15:04:16 -0400
Received: from keetweej.vanheusden.com ([80.126.110.251]:36281 "EHLO
	keetweej.vanheusden.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752975AbZFNTEP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 15:04:15 -0400
Date: Sun, 14 Jun 2009 21:04:17 +0200
From: Folkert van Heusden <folkert@vanheusden.com>
To: Matt Mackall <mpm@selenic.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: issue with /dev/random? gets depleted very quick
Message-ID: <20090614190417.GC7272@vanheusden.com>
References: <20090614125138.GZ7272@vanheusden.com> <1244994669.4496.229.camel@calx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1244994669.4496.229.camel@calx>
Organization: www.unixexpert.nl
X-Chameleon-Return-To: folkert@vanheusden.com
X-Xfmail-Return-To: folkert@vanheusden.com
X-Phonenumber: +31-6-41278122
X-URL: http://www.vanheusden.com/
X-PGP-KeyID: 1F28D8AE
X-GPG-fingerprint: AC89 09CE 41F2 00B4 FCF2  B174 3019 0E8C 1F28 D8AE
X-Key: http://pgp.surfnet.nl:11371/pks/lookup?op=get&search=0x1F28D8AE
Reply-By: Tue Jun  9 20:35:32 CEST 2009
X-Message-Flag: www.vanheusden.com
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> [cc:ed to lkml]

> > On an idle system (no gui, no daemons, nothing) system, /dev/random gets
> > empty in a matter of 20 seconds with a 2.6.26 kernel.
> > My test:
> > add 1000 bits to the device:
> > zolder:/tmp# cat test-RNDADDENTROPY.c 
...
> > }
> > and then check whayt is in it:
> > zolder:/tmp# ./a.out ; while true ; do echo `date` `cat /proc/sys/kernel/random/entropy_avail` ; sleep 1 ; done
> > 0
> > Sun Jun 14 14:50:44 CEST 2009 1117
...
> > Sun Jun 14 14:50:55 CEST 2009 157
> > Is there something wrong with it?
> Does it go below 128? If not, that's the behavior of something depleting
> the pool down to the anti-starvation threshold via either /dev/urandom
> or get_random_bytes.

No, it stays above 128. Sometimes around 13x, sometimes 151, so not
always close to 128.

> On my system, I'm seeing that behavior as well. fuser reports a bunch of
> processes hold /dev/urandom open, but stracing them doesn't reveal a
> culprit. Which means there's now probably something in the kernel
> calling get_random_bytes continuously.

Yes. On the systems I tried, nothing had /dev/*random open, also no
cronjobs that could use it. And still it gets lower.

> Is this a problem? It really shouldn't be. Everyone should be
> using /dev/urandom anyway. And the anti-starvation threshold guarantees

Well, if I understood correctly how /dev/*random works, urandom is fed
by /dev/random. So if there's almost nothing left in the main pool and
urandom demands bits then we have an issue.
Also, if you frequently want to generate keys (thing gpg, ssl), I think
you want bits from /dev/random and not urandom.

> that if there's entropy being collected, readers of /dev/random can
> always make forward progress.

Also if it is used so heavily, you need quit an entropy-source to keep
it filled.


Folkert van Heusden

-- 
www.vanheusden.com/multitail - multitail is tail on steroids. multiple
               windows, filtering, coloring, anything you can think of
----------------------------------------------------------------------
Phone: +31-6-41278122, PGP-key: 1F28D8AE, www.vanheusden.com
