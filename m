Return-Path: <linux-kernel-owner+w=401wt.eu-S1756648AbXIYQJX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756648AbXIYQJX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 12:09:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752677AbXIYQJO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 12:09:14 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54204 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752730AbXIYQJN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 12:09:13 -0400
Date: Tue, 25 Sep 2007 09:08:19 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andi Kleen <ak@suse.de>, Takashi Iwai <tiwai@suse.de>,
       LKML <linux-kernel@vger.kernel.org>, discuss@x86-64.org
Subject: Re: 2.6.23-rc8-mm1, -rc7-mm1 kill audio on HP nx6325
Message-Id: <20070925090819.a7c6c3f3.akpm@linux-foundation.org>
In-Reply-To: <200709251353.52723.rjw@sisk.pl>
References: <200709251353.52723.rjw@sisk.pl>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Sep 2007 13:53:51 +0200 "Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> Hi,
> 
> This patch from Andi:
> 
> x86_64-mm-cpa-einval.patch
> 
> makes the hda_intel audio driver stop working on my HP nx6325.
> 
> The following line appears in dmesg (from 2.6.23-rc7-mm1:
> 
> ALSA /home/rafael/src/mm/linux-2.6.23-rc7-mm1/sound/pci/hda/hda_intel.c:1755: hd
> a-intel: ioremap error
> 
> and the driver doesn't work afterwards.
> 
> Still, I'm not sure if the patch above is wrong or rather it exposes a problem
> in the driver.
> 

Mysterious.

ioremap_nocache() does __ioremap(..., _PAGE_PCD);, then __ioremap() does
ioremap_page_range(..., _PAGE_PCD | other_stuff) That's one.

__ioremap() then does ioremap_change_attr(..., _PAGE_PCD);.  That's two.

So I _think_ we're setting _PAGE_PCD twice on those pte's?  Unclear.  The
implementation is rather different from i386, too.

I dunno why __change_page_attr() failed though.  Perhaps this, in
change_page_attr_addr():

		if (!kernel_map || pte_present(pfn_pte(0, prot))) {

should be &&

Andi's taking a bit of time off, so we may need to park this until he
resurfaces.
