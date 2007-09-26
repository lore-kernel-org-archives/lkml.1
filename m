Return-Path: <linux-kernel-owner+w=401wt.eu-S1755836AbXIZHcB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755836AbXIZHcB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 03:32:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751856AbXIZHbx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 03:31:53 -0400
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:4586
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751293AbXIZHbx convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 03:31:53 -0400
Message-Id: <46FA274B.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Wed, 26 Sep 2007 08:32:59 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: "Andrew Morton" <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: "Andi Kleen" <ak@suse.de>, "Takashi Iwai" <tiwai@suse.de>,
       "LKML" <linux-kernel@vger.kernel.org>, <discuss@x86-64.org>
Subject: Re: [discuss] 2.6.23-rc8-mm1, -rc7-mm1 kill audio on HP nx6325
References: <200709251353.52723.rjw@sisk.pl>
 <20070925090819.a7c6c3f3.akpm@linux-foundation.org>
In-Reply-To: <20070925090819.a7c6c3f3.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Andrew Morton <akpm@linux-foundation.org> 25.09.07 18:08 >>>
>On Tue, 25 Sep 2007 13:53:51 +0200 "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
>
>> Hi,
>> 
>> This patch from Andi:
>> 
>> x86_64-mm-cpa-einval.patch
>> 
>> makes the hda_intel audio driver stop working on my HP nx6325.
>> 
>> The following line appears in dmesg (from 2.6.23-rc7-mm1:
>> 
>> ALSA /home/rafael/src/mm/linux-2.6.23-rc7-mm1/sound/pci/hda/hda_intel.c:1755: hd
>> a-intel: ioremap error
>> 
>> and the driver doesn't work afterwards.
>> 
>> Still, I'm not sure if the patch above is wrong or rather it exposes a problem
>> in the driver.
>> 
>
>Mysterious.
>
>ioremap_nocache() does __ioremap(..., _PAGE_PCD);, then __ioremap() does
>ioremap_page_range(..., _PAGE_PCD | other_stuff) That's one.
>
>__ioremap() then does ioremap_change_attr(..., _PAGE_PCD);.  That's two.
>
>So I _think_ we're setting _PAGE_PCD twice on those pte's?  Unclear.  The
>implementation is rather different from i386, too.
>
>I dunno why __change_page_attr() failed though.  Perhaps this, in
>change_page_attr_addr():
>
>		if (!kernel_map || pte_present(pfn_pte(0, prot))) {
>
>should be &&

Definitely not, and this code has been that way for a while.

I rather suspect this change

-	if (!kpte) return 0;
+	if (!kpte)
+		return -EINVAL;

to be the reason for the failure (and I had already sent a comment to this
respect to Andi upon his review request).

Jan

