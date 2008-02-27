Return-Path: <linux-kernel-owner+w=401wt.eu-S1763498AbYB0AXa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763498AbYB0AXa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 19:23:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753135AbYB0AXV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 19:23:21 -0500
Received: from el-out-1112.google.com ([209.85.162.176]:63157 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750834AbYB0AXU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 19:23:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=T7uarEv5DyLQ/ecoxy0x/KVHiCJAbHZRzzJaneAC2h1GX2/dDAiGv5r3ykv5qOx8OM/Cg3pS7boWyKhTBqYTN3gu+mvd53+exWemqNulw4nS6ROTmugvPyuiUBoVYCDuFc4R1m6GmSjIgiRuIr3jGH+t+8HvAt8r8d0X+xFALu0=
Message-ID: <f19298770802261623j1a3429dcmcf855ec6781ffcbb@mail.gmail.com>
Date: Wed, 27 Feb 2008 03:23:17 +0300
From: "Alexey Zaytsev" <alexey.zaytsev@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: bcm43xx regression in 2.6.24 (with patch)
Cc: "Michael Buesch" <mb@bu3sch.de>, "Ingo Molnar" <mingo@elte.hu>,
       "Alexey Zaytsev" <zaytsev.a@protei.ru>, "Greg KH" <greg@kroah.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080226224757.GB3100@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47BEAF3B.3080809@protei.ru> <20080226202044.GE3013@tuxdriver.com>
	 <f19298770802261338r40e3f252j2249c1325b725614@mail.gmail.com>
	 <200802262304.39882.mb@bu3sch.de>
	 <f19298770802261412j7a3fec4bv1754db8123796d54@mail.gmail.com>
	 <20080226224757.GB3100@tuxdriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 27, 2008 at 1:47 AM, John W. Linville
<linville@tuxdriver.com> wrote:
> On Wed, Feb 27, 2008 at 01:12:32AM +0300, Alexey Zaytsev wrote:
>  > On Wed, Feb 27, 2008 at 1:04 AM, Michael Buesch <mb@bu3sch.de> wrote:
>
>
> > >  Besides that the bcm43xx driver is not broken. That's the whole reason
>  > >  this damn thread started at all. So it can't be broken.
>  > >
>  > Can't agree here. The bcm43xx driver used to work with 2.6.23 without requiring
>  > any module magic.
>
>  At the risk of prolonging things... :-(
>
>  Isn't the fundamental problem here that the ssb driver claims the same
>  PCI IDs as the bcm43xx driver?  He have hit this same issue a number
>  of times: 8139too vs.  8139cp, eepro vs. e100, sk98lin vs. skge,
>  and I'm sure there are more.  I admit that this situation is a bit
>  more confusing, since the user is less likely to predict a conflict
>  between bcm43xx and the ssb driver.  This is especially true since
>  the user isn't even selecting ssb directly, but is instead selecting
>  the apparently unrelated b44.
>
>  Still, the bcm43xx driver is not fundamentally damaged.  This is
>  fundamentally a "two drivers claiming the same PCI ID" issue, not a
>  "you broke my driver" one.

Is there any reason the ssb driver should claim the bcm43xx pci ids in
the first place? I have very little understanding what the Sonic Silicon
Backplane really is, but I see that the b44 driver claims its PCI ids
directly. I also think I understand why the b43/b43legacy drivers can't
claim the ids directly: because the driver-device matching is done not
with the pci bus methods, but with the ssb bus methods, and it would
be impossible to automatically choose the right driver for the right
device (with same ssb ids), as the first of the two drivers loaded would
succeed in probe()'ing the pci "ssb bridge" device, and not letting the
other to take control, even after moments later the ssb probe for the
non-supported ssb device would fail. (Or am I completely wrong?)

That said, I still think that the ssb driver claims the wrong pci ids,
which is especially wrong if the the b43/b43legacy drivers are not
even built. And my patch fixes exactly this problem - the ssb driver
no more claims the broadcom pci ids, when the b43/b43legacy drivers
are not built.

One better solution I think might be to move the b43_pci_bridge.c
code to a separate module, and let the b43/b43legacy drivers
depend on it, but as I said, I have little knowledge in the
ssb stuff, so I did it the easy way.

Btw, at least in the 8139cp/8139too case the right driver is
chosen automatically, because they both can detect
the problem at the pci probe() time and tell the device
is not supported early.

>
>  John
>  --
>
>
> John W. Linville
>  linville@tuxdriver.com
>
