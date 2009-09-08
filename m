Return-Path: <linux-kernel-owner+w=401wt.eu-S1752546AbZIHXdy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752546AbZIHXdy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 19:33:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752175AbZIHXdy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 19:33:54 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:42736 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752093AbZIHXdx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 19:33:53 -0400
Date: Tue, 8 Sep 2009 20:33:23 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Kay Sievers <kay.sievers@vrfy.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@linux.intel.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH RFC] char/tty_io: fix legacy pty name when more than 256
 pty devices are requested
Message-ID: <20090908203323.486c129c@caramujo.chehab.org>
In-Reply-To: <4AA6DF50.3030603@zytor.com>
References: <20090908144942.76ddf0e7@caramujo.chehab.org>
	<4AA6DF50.3030603@zytor.com>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, 08 Sep 2009 15:48:48 -0700
"H. Peter Anvin" <hpa@zytor.com> escreveu:

> On 09/08/2009 10:49 AM, Mauro Carvalho Chehab wrote:
> > 
> > It is important to preserve the old nomenclature for tty/pty devices for the
> > first 256 devices, to avoid breakage on existing applications and with udev.
> > 
> > So, in order to allow more pty devices, the nomenclature were extended for
> > the devices with minor 256 or above. For those, the nomenclature will be:
> > 	ttyf0000-ttfpffff	(pty slave)
> > 	ptyf0000-ttyfffff	(pty master)
> > 
> 
> This would seem to be a somewhat silly way to extend it, especially
> given the arbitrary artificial limit of just over 2^16 entries.

> If you're going to do this, I would suggest using the following
> namespace, as such:
> 
> 	[pt]ty[p-za-e][0-9a-f]+

To be backward compatible, the format should be, at least:

 	[pt]ty[p-za-e][0-9a-f].+

otherwise, it can potentially break backward compatibility, as the first 10 devices will be like:
	/dev/ttyp0
	/dev/ttyp1
	...

instead of:

	/dev/ttyp00
	/dev/ttyp01

> 
> 	sprintf(name, "%cty%c%x", slave ? 't' : 'p',
> 		"pqrstuvwxyzabcde"[(index >> 4) & 15],
> 		((index >> 4) & ~15) | (index & 15));

We may use this, instead:

 	sprintf(name, "%cty%c%02x", slave ? 't' : 'p',
 		"pqrstuvwxyzabcde"[(index >> 4) & 15],
 		((index >> 4) & ~15) | (index & 15));

> No arbitrary limits, and it still extends the existing namespace with
> some reasonable continuity.  It means bits [7:4] are weirdly encoded,
> but we get straightforward backwards compatibility as a result.

But it will also be a little more weird.
> 




Cheers,
Mauro
