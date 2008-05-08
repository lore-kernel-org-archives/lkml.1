Return-Path: <linux-kernel-owner+w=401wt.eu-S1759514AbYEHHfR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759514AbYEHHfR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 03:35:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757266AbYEHHfA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 03:35:00 -0400
Received: from mtagate2.de.ibm.com ([195.212.29.151]:12525 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757141AbYEHHe5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 03:34:57 -0400
Date: Thu, 8 May 2008 09:34:21 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: benh@kernel.crashing.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, tony@bakeyournoodle.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Silence 'ignoring return value' warnings in
 drivers/video/aty/radeon_base.c
Message-ID: <20080508093421.31cd735b@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <1210196621.1421.5.camel@pasglop>
References: <20080424043400.GS20457@bakeyournoodle.com>
	<20080506143936.6357e578.akpm@linux-foundation.org>
	<20080506.144301.233784820.davem@davemloft.net>
	<1210121683.21644.194.camel@pasglop>
	<20080506182006.4b4a3968.akpm@linux-foundation.org>
	<1210134804.21644.202.camel@pasglop>
	<20080507102310.57b4ccfb@gondolin.boeblingen.de.ibm.com>
	<1210196621.1421.5.camel@pasglop>
Organization: IBM Deutschland Entwicklung GmbH Vorsitzender des
 Aufsichtsrats: Martin Jetter =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?=
 Herbert Kircher Sitz der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?=
 Registergericht: Amtsgericht Stuttgart, HRB 243294
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 08 May 2008 07:43:41 +1000,
Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:

> You prefer a crippled ABI or a machine that doesn't boot with no console
> at all to see what happened because the console driver refused to
> initialize due to such a sysfs file conflict ?

So it really depends on the driver, doesn't it?

If the file isn't vital, ignore the return code (sysfs will already
complain). If things will break, fail the device registration.

> What I'm saying is basically that rather than have a test & printk in
> every bloody driver, we are better off having it once in the function
> itself (bloat ?)

A centralized printk makes sense, sure (and it is already in place for
duplicate entries).

> 
> In addition, in most cases, failure of initializing the driver is -not-
> the right solution, so the driver should probably just warn, which can
> as well be done by ... having sysfs_create_file() itself do the warning.

sysfs_add_one() does it :)

I was under the impression that failing the initialization was usually
the right thing to do, since we end up with an un-configurable,
un-usable device. But that may be coloured by my experience with s390
devices, where we rely on sysfs attributes extensively. If indeed most
sysfs files are non-vital, removing the __must_check and relying on a
scary warning in the core may be fine. (OTOH, adding checks to the core
has helped us to find some lurking bugs.)

> > Which of the current __must_check functions do you think should have
> > the __must_check removed?
> 
> sysfs_create_file is a good candidate imho :-)

:)

I was thinking more about functions like bus_rescan_devices(). Any
others?
