Return-Path: <linux-kernel-owner+w=401wt.eu-S1754799AbZDMXmu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754799AbZDMXmu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 19:42:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753519AbZDMXmh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 19:42:37 -0400
Received: from mx2.redhat.com ([66.187.237.31]:45462 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753066AbZDMXmg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 19:42:36 -0400
Date: Mon, 13 Apr 2009 17:41:05 -0600
From: Pete Zaitcev <zaitcev@redhat.com>
To: "John Stoffel" <john@stoffel.org>
Cc: Jarek Poplawski <jarkao2@gmail.com>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, linux-usb@vger.kernel.org, zaitcev@redhat.com
Subject: Re: usb_mon oops Re: tcpdump crashes 2.6.29.1 (and 2.6.29-rc5)
Message-Id: <20090413174105.b03a1f19.zaitcev@redhat.com>
In-Reply-To: <18909.65347.234817.29689@stoffel.org>
References: <18906.49779.243047.207639@stoffel.org>
	<20090407120022.GA6519@ff.dom.local>
	<18907.28788.965069.573489@stoffel.org>
	<20090407130403.e0061a8d.zaitcev@redhat.com>
	<18908.42166.404232.721757@stoffel.org>
	<20090408232344.afed8103.zaitcev@redhat.com>
	<18909.65347.234817.29689@stoffel.org>
Organization: Red Hat, Inc.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 Apr 2009 09:59:31 -0400, "John Stoffel" <john@stoffel.org> wrote:

> Here's a dmesg of bootup:

> [    0.000000] Linux version 2.6.29.1 (john@sail) (gcc version 4.3.3 (Ubuntu 4.3.3-5ubuntu4) ) #24 SMP PREEMPT Tue Apr 7 11:30:52 EDT 2009
> [    0.000999] Checking aperture...
> [    0.000999] No AGP bridge found
> [    0.000999] Node 0: aperture @ 20000000 size 32 MB
> [    0.000999] Aperture pointing to e820 RAM. Ignoring.
> [    0.000999] Your BIOS doesn't leave a aperture memory hole
> [    0.000999] Please enable the IOMMU option in the BIOS setup
> [    0.000999] This costs you 64 MB of RAM
> [    0.000999] Mapping aperture over 65536 KB of RAM @ 20000000

> [ 1396.271782] BUG: unable to handle kernel paging request at ffff880020a15cc0

So 20a15000 is in the aperture. Oh well, I screwed up. I meant to
check for this back in 2006 but forgot, and miraclously it worked
until now.

Here's the problem:

	pg = phys_to_page(dma_addr);
	map = kmap_atomic(pg, KM_IRQ0);
	offset = mon_copy_to_buff(rp, offset, map + page_off, step_len);
	kunmap_atomic(map, KM_IRQ0);

Obviously we don't want the page that's overlayed by the aperture,
but the page where IOMMU is pointing.

-- Pete
