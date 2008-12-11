Return-Path: <linux-kernel-owner+w=401wt.eu-S1758683AbYLKWAd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758683AbYLKWAd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 17:00:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757502AbYLKWAZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 17:00:25 -0500
Received: from electric-eye.fr.zoreil.com ([213.41.134.224]:50305 "EHLO
	electric-eye.fr.zoreil.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757115AbYLKWAY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 17:00:24 -0500
Date: Thu, 11 Dec 2008 23:00:28 +0100
From: Francois Romieu <romieu@fr.zoreil.com>
To: Giangiacomo Mariotti <giangiacomo.mariotti@gmail.com>
Cc: Shaya Potter <spotter@yucs.org>, linux-kernel@vger.kernel.org
Subject: Re: weird realtek gigabit ethernet issue
Message-ID: <20081211220028.GB25911@electric-eye.fr.zoreil.com>
References: <2aac3c260812072334v5d85ca2cke6cd33d7c912b8ea@mail.gmail.com> <493D360D.5030203@yucs.org> <20081208224023.GA8492@electric-eye.fr.zoreil.com> <2aac3c260812081519j4739af7cve93606a46c07b218@mail.gmail.com> <20081208232425.GA8174@electric-eye.fr.zoreil.com> <2aac3c260812091816n41afa4aex101569cdfab130ce@mail.gmail.com> <20081210201818.GA30146@electric-eye.fr.zoreil.com> <2aac3c260812102029p3da46d44h91eebcdbb4f1c5c0@mail.gmail.com> <20081211082805.GA14963@electric-eye.fr.zoreil.com> <2aac3c260812110128s10c71271nf497124bd3d05de0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2aac3c260812110128s10c71271nf497124bd3d05de0@mail.gmail.com>
X-Organisation: Land of Sunshine Inc.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Ccing l-k as it may be of wider interest)

Giangiacomo Mariotti <giangiacomo.mariotti@gmail.com> :
> 2008/12/11 Francois Romieu <romieu@fr.zoreil.com>:
> > Giangiacomo Mariotti <giangiacomo.mariotti@gmail.com> :
> > [...]
> >> Dec  7 10:13:56 debian-hell kernel: [    4.064402] eth0: RTL8169 at
> >> 0xffffc2000062a000, 00:1f:d0:ae:41:0e, XID 281000c0 IRQ 1270
> >> Dec  7 10:13:56 debian-hell kernel: [    5.325793] eth1: RTL8169 at
> >> 0xffffc20000630000, 00:1f:d0:ae:41:10, XID 281000c0 IRQ 1269
> >> Dec  8 06:09:31 debian-hell kernel: [    6.253241] eth0:
> >> RTL8168d/8111d at 0xffffc2000064e000, 00:1f:d0:ae:41:0e, XID 281000c0
> >> IRQ 1270
> >> Dec  8 06:09:31 debian-hell kernel: [    6.258123] eth1:
> >> RTL8168d/8111d at 0xffffc20000652000, 00:1f:d0:ae:41:10, XID 281000c0
> >> IRQ 1269
[...]
> On Dec 8, at 06, I booted 2.6.28-rc7, while on Dec 7, at 10, I booted
> 2.6.26-1-amd64(debian, based on 2.6.26.8). I can't find any log for
> 2.6.27.8.

Ok. Looking at your logs and at the r8169.c code, here is the story.

1. On December 7, the r8169.c driver identifies your network card as an
   (old) "RTL8169" i.e. RTL_GIGA_MAC_VER_01 in r8169.c. This is the default
   choice when there is no specific match for the XID. You can check this
   in r8169.c::rtl8169_get_mac_version. Below RTL_GIGA_MAC_VER_06, the
   driver assumes that the device includes a "RxMissed" register (see
   r8169.c::rtl8169_rx_missed). This assumption is false for your device
   - as it is on nearly all new 816x flavors nowadays - and you will
   experience a broken rx missed counter in ifconfig's output.

2. On December 8, the r8169 driver identifies your network card as a more
   modern "RTL8168d/8111d" i.e. RTL_GIGA_MAC_VER_25. As far as I know, it
   should be the adequate choice given the XID. r8169.c::rtl8169_rx_missed
   will not try to access the non-existant RxMissed register and your
   stats should be fine.

While the fix for the RxMissed register access is in the stable branch,
it is useless if the adapter is (mis-)detected as an old RTL8169.

So, currently, your rx missed counters should be broken on anything
older than 2.6.28-rc1. If they were vanilla kernel (I have not checked
the content of Debian's kernel), Dec 7 should be broken and Dec 8 should
be ok.

Does the explanation above match your observations ?

Btw I should probably push new RTL_GIGA_MAC_VER_XX into -stable.
   
-- 
Ueimor
