Return-Path: <linux-kernel-owner+w=401wt.eu-S1757065AbYCCRmF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757065AbYCCRmF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 12:42:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756351AbYCCRhf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 12:37:35 -0500
Received: from ug-out-1314.google.com ([66.249.92.175]:50044 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757466AbYCCRhc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 12:37:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=NX9o/TykoLo97WalU+4a6zTO29hr/Bh9Vu66odxbg6gqqnsTSJNqnbcjivMb2gk+VfnBKeDTV1qsNMP2i8gGrsdoJp8n0yjWZEZSTEP8EVZuPgpM1IpvjQuwD693UTWF1g6ca8QO7li+G8MeKJ9+vpfXECPAibr9jmnxqcTpwdc=
Message-ID: <59ad55d30803030937h7e8b6487s134aec2d87e00c62@mail.gmail.com>
Date: Mon, 3 Mar 2008 12:37:29 -0500
From: "=?UTF-8?Q?Kristian_H=C3=B8gsberg?=" <krh@bitplanet.net>
To: "Stefan Richter" <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH 2/5] firewire: fix crash in automatic module unloading
Cc: linux1394-devel@lists.sourceforge.net, "Jarod Wilson" <jwilson@redhat.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <47CC326D.3070604@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
References: <tkrat.5dc141579386d159@s5r6.in-berlin.de>
	 <tkrat.ce9862ad477be41e@s5r6.in-berlin.de>
	 <59ad55d30803030845n419ac813kaa99e5ee7657dc52@mail.gmail.com>
	 <47CC326D.3070604@s5r6.in-berlin.de>
X-Google-Sender-Auth: 2aecaddfa516b8d5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha id m23HhOnq024005

On Mon, Mar 3, 2008 at 12:16 PM, Stefan Richter<stefanr@s5r6.in-berlin.de> wrote:> Kristian HÃ¸gsberg wrote:>  > I would want to use a kref and a completion for tracking this though>  > instead of the atomic.  Just use kref_get() instead of incrementing>  > the atomic and use kref_put() instead of decrementing it.  The release>  > function for kref_put() should complete the completion struct and>  > instead of the busy loop in fw_core_remove_card() we just wait for the>  > completion.>>  Sounds like the way to go.  Since I already passed that patch upwards, I>  will do an incremental rework.  (But perhaps not before spending some>  time on ticket number 9617 at bugzilla.kernel.org's...)>>>  > And I'm not sure I agree that it's a device_count, it>  > really just is a ref-count.  The core should also hold a reference to>  > the card and release it in fw_core_remove_card(), just before waiting>  > on the completion.>>  Right; we just shouldn't mix fw-ohci's refcounting (which isn't really>  needed since the lifetime rules for the card are as simple as they can>  get for fw-ohci) and fw-core's refcounting.
Yup, we should keep the fw-ohci side of things simple.  And they stillare: it calls add_card() to add a new card at which point the corestarts using the card.  On removal, it calls remove_card() and whenthat returns the core no knows or cares about the card and fw-ohci.cis free to tear it down however it wants.  When I mention that thecore should hold a ref-count, it's really just that somebody needs toown the initial ref-count and make sure it's dropped on the removepath.
Kristianÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
