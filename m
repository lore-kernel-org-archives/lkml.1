Return-Path: <linux-kernel-owner+w=401wt.eu-S1755834AbYG3Ciz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755834AbYG3Ciz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 22:38:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752679AbYG3Cir
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 22:38:47 -0400
Received: from g4t0017.houston.hp.com ([15.201.24.20]:22890 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751826AbYG3Ciq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 22:38:46 -0400
Date: Tue, 29 Jul 2008 20:38:42 -0600
From: Alex Chiang <achiang@hp.com>
To: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Cc: Matthew Wilcox <matthew@wil.cx>, Pierre Ossman <drzeus-list@drzeus.cx>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org
Subject: Re: post 2.6.26 requires pciehp_slot_with_bus
Message-ID: <20080730023842.GA4269@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>,
	Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
	Matthew Wilcox <matthew@wil.cx>,
	Pierre Ossman <drzeus-list@drzeus.cx>,
	Jesse Barnes <jbarnes@virtuousgeek.org>,
	LKML <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org
References: <20080724134737.4b91f30d@mjolnir.drzeus.cx> <200807241407.18543.jbarnes@virtuousgeek.org> <20080724235127.40bd0ac9@mjolnir.drzeus.cx> <200807241506.58973.jbarnes@virtuousgeek.org> <20080724222914.GG5307@ldl.fc.hp.com> <20080725004926.5f201c70@mjolnir.drzeus.cx> <20080724230827.GA30302@ldl.fc.hp.com> <20080725012916.06679a6d@mjolnir.drzeus.cx> <20080725032909.GA6701@parisc-linux.org> <48895D3C.7040100@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48895D3C.7040100@jp.fujitsu.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>:
> Matthew Wilcox wrote:
>> So we need a way to find if there's already a slot of this
>> name.  I don't see a kobject routine to do that.  Maybe we can
>> do it internally to the pci slot code.

pci_hp_register already does this with get_slot_from_name().

>> Then we need to pick a new name for the kobject if it does
>> collide.  My suggestion is that the second time we find an
>> object named "2", we call it "2dup1" (the third time "2dup2",
>> etc.)  Other opinions I've seen include "2a", "2b", ... or
>> "2-1", "2-2", ... or "2-brokenfw1", "2-brokenfw2".
>
> That looks quite better than using bus number.

I went with:

	- first slot to register gets "2"
	- second slot to register gets "2-1"
	- Mth slot to register gets "2-M"

At first, I thought it would have been better to put this logic
inside of pci_hp_register, since it knows about the collision,
and could just fix stuff up for the caller.

However, the problem is that each hotplug driver can have a
different length for "name", and it got messy quickly.

So, I just patched the two drivers that are known to be
problematic.

Two patches follow, against 2.6.27-rc1.

Compile tested only -- I don't have hardware to replicate this.

I'd say they're somewhere between RFC and requested for
inclusion. I'm certainly not tied to them, just trying to show
some code to implement the approach described above. If we decide
that looking at _RMV + other bits is the way to go, then I'm fine
with that.

It would be great if Pierre and Kenji-san could try them out.

Thanks.

/ac

