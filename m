Return-Path: <linux-kernel-owner+w=401wt.eu-S1759373AbYJIEWW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759373AbYJIEWW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 00:22:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759523AbYJIETI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 00:19:08 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:35858 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760161AbYJIETH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 00:19:07 -0400
Date: Wed, 8 Oct 2008 22:19:05 -0600
From: Alex Chiang <achiang@hp.com>
To: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Cc: jbarnes@virtuousgeek.org, kristen.c.accardi@intel.com, matthew@wil.cx,
       linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 00/15] PCI: let the core manage slot names
Message-ID: <20081009041905.GE4668@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>,
	Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
	jbarnes@virtuousgeek.org, kristen.c.accardi@intel.com,
	matthew@wil.cx, linux-pci@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <20081003230125.9989.31145.stgit@bob.kio> <48EC53D3.9020203@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48EC53D3.9020203@jp.fujitsu.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>:
> Hi Alex-san,
>
> I have some ideas and made some patches for comments I sent about
> your [PATCH v4 02/15] and [PATCH v4 03/15]. Please take a look.
> There are three patches.

Hi Kenji-san,

Thanks for doing this work.

I tested your patches, but found a problem with refcounting in
your 02/03, and the slot directories in sysfs remained, even
after rmmod of all drivers.

I decided that things are getting too complicated with all these
new interfaces, so I got rid of them and updated the
pci_create_slot API instead, to take a 'rename' parameter. That
way, creating a slot and overriding its name can become an atomic
operation.

That should make the race conditions go away, and the code is
much easier to understand as well.

>  - [01/03] Sample patch for [PATCH v4 02/15]

This is a good patch by itself. I think you should submit it to
Jesse. I did not need it after reworking to my new design.

>  - [02/03] Sample patch for [PATCH v4 03/15]
>    NOTE:This doesn't target the comment about changing exported
>         symbol name.

I had to stare at this patch for a long time to understand it,
and finally saw that you were changing the rename logic to detect
if we were trying to rename an existing slot.

Unfortunately, it had some problem with the refcounting, and in
this scenario:

	- pci_slot loaded
	- fakephp dup_slots=1 loaded
	- pci_slot unloaded

The slots claimed by pci_slot (but _not_ by fakephp) were never
released.

By the time I got this far, I was already thinking about a
redesign, so I did not try and debug further...

>  - [03/03] Sample patch for [PATCH v4 14/15]
>    This is needed because above two patches make your [PATCH v4
>    14/15] can not be applied.

Not needed, since I re-designed the approach.

> Note: I made those patches as replacement of your corresponding
> ones. So those patches are NOT for applying on top your original
> patches.

Again, thank you very much for all the review and hard work, and
sorry for causing so much churn. :-/

I'll be sending out the new patch series shortly.

/ac

