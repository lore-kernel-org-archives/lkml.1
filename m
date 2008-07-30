Return-Path: <linux-kernel-owner+w=401wt.eu-S1760739AbYG3JNt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760739AbYG3JNt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 05:13:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753164AbYG3JNl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 05:13:41 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:43933 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753870AbYG3JNk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 05:13:40 -0400
Subject: Re: [PATCH] mISDN cleanup user interface
From: David Woodhouse <dwmw2@infradead.org>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Karsten Keil <kkeil@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, isdn4linux@listserv.isdn4linux.de
In-Reply-To: <1217365330.417.8.camel@californication>
References: <20080729195637.GB25929@pingi.kke.suse.de>
	 <1217362946.27925.137.camel@pmac.infradead.org>
	 <1217365330.417.8.camel@californication>
Content-Type: text/plain
Date: Wed, 30 Jul 2008 10:13:31 +0100
Message-Id: <1217409211.27925.177.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-07-29 at 23:02 +0200, Marcel Holtmann wrote:
> Hi Karsten,
> 
> > > Please pull from git://git.kernel.org/pub/scm/linux/kernel/git/kkeil/ISDN-2.6.git master
> > > 
> > > The channelmap should have the same size on 32 and 64 bit
> > > systems. Thanks to David Woodhouse for spotting this.
> > > 
> > > Signed-off-by: Karsten Keil <kkeil@suse.de>
> > 
> > Er, isn't that still broken? Consider 32-bit userspace on 64-bit kernel,
> > big-endian.
> 
> I agree with David here. Please lets not do these horribly things again.
> Almost everybody has done their fair share of brokenness with the compat
> layers. Especially 32-bit userspace on 64-bit kernels. Using __u32 and
> alike is a way better choice and less headache.

Well, he's already switched to a 32-bit type, which is fine in that
respect -- at least the struct is the same _size_ on 32-bit and 64-bit
targets now. (OK, so inventing new types like 'u_int' instead of just
using the ones that the C language provides is a bit silly, but that's
the Linux norm so I wasn't complaining about that.)

But the channelmap field is still broken because it's using set_bit() on
int types, and they're defined to work on unsigned long. So in the
fairly common case where a BRI driver sets bits 1 and 2 (sic) in the
channel map, that will look like this on a 64-bit big-endian kernel:

 00 00 00 00 00 00 00 06   00 00 00 00 00 00 00 00
    (unsigned long #1)       (unsigned long #2)

When 32-bit userspace receives that, it'll see this:

 00 00 00 00   00 00 00 06   00 00 00 00   00 00 00 00
  (word #1)     (word #2)     (word #3)     (word #4)

.. in which it's bits 33 and 34 that are set. So the new version in the
patch to which I replied _still_ needs a compat routine.

You might get away with it if you use set_le_bit() though.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation



