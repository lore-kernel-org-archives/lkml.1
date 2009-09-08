Return-Path: <linux-kernel-owner+w=401wt.eu-S1752587AbZIHWxQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752587AbZIHWxQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 18:53:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751284AbZIHWxP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 18:53:15 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41364 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751089AbZIHWxP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 18:53:15 -0400
Message-ID: <4AA6DF50.3030603@zytor.com>
Date: Tue, 08 Sep 2009 15:48:48 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>
CC: LKML <linux-kernel@vger.kernel.org>, Kay Sievers <kay.sievers@vrfy.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@linux.intel.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH RFC] char/tty_io: fix legacy pty name when more than 256
 pty devices are requested
References: <20090908144942.76ddf0e7@caramujo.chehab.org>
In-Reply-To: <20090908144942.76ddf0e7@caramujo.chehab.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/08/2009 10:49 AM, Mauro Carvalho Chehab wrote:
> 
> It is important to preserve the old nomenclature for tty/pty devices for the
> first 256 devices, to avoid breakage on existing applications and with udev.
> 
> So, in order to allow more pty devices, the nomenclature were extended for
> the devices with minor 256 or above. For those, the nomenclature will be:
> 	ttyf0000-ttfpffff	(pty slave)
> 	ptyf0000-ttyfffff	(pty master)
> 

This would seem to be a somewhat silly way to extend it, especially
given the arbitrary artificial limit of just over 2^16 entries.

If you're going to do this, I would suggest using the following
namespace, as such:

	[pt]ty[p-za-e][0-9a-f]+

	sprintf(name, "%cty%c%x", slave ? 't' : 'p',
		"pqrstuvwxyzabcde"[(index >> 4) & 15],
		((index >> 4) & ~15) | (index & 15));

No arbitrary limits, and it still extends the existing namespace with
some reasonable continuity.  It means bits [7:4] are weirdly encoded,
but we get straightforward backwards compatibility as a result.

	-hpa
