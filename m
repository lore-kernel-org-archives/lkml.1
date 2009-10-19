Return-Path: <linux-kernel-owner+w=401wt.eu-S1755907AbZJSJPQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755907AbZJSJPQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 05:15:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755643AbZJSJPO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 05:15:14 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:28553 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752739AbZJSJPN convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com;10:1>);
	Mon, 19 Oct 2009 05:15:13 -0400
Message-Id: <4ADC4A76020000780001AA49@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Mon, 19 Oct 2009 10:16:06 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: "Thomas Schlichter" <thomas.schlichter@web.de>
Cc: "Jeremy Fitzhardinge" <jeremy.fitzhardinge@citrix.com>,
       "Robert Hancock" <hancockrwd@gmail.com>,
       "Henrique de Moraes Holschuh" <hmh@hmh.eng.br>,
       "Suresh Siddha" <suresh.b.siddha@intel.com>,
       "Venkatesh Pallipadi" <venkatesh.pallipadi@intel.com>,
       "Tejun Heo" <tj@kernel.org>, <x86@kernel.org>,
       "Yinghai Lu" <yinghai@kernel.org>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Arjan van de Ven" <arjan@linux.intel.com>,
       <dri-devel@lists.sourceforge.net>, "Ingo Molnar" <mingo@redhat.com>,
       <linux-kernel@vger.kernel.org>, <jbarnes@virtuousgeek.org>,
       "Thomas Hellstrom" <thellstrom@vmware.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [RFC Patch] use MTRR for write combining if PAT is not
	 available
References: <4AD449A702000078000197EE@vpn.id2.novell.com>
 <200910142114.12433.thomas.schlichter@web.de>
 <4AD6EFD7020000780001A067@vpn.id2.novell.com>
 <200910172148.36267.thomas.schlichter@web.de>
In-Reply-To: <200910172148.36267.thomas.schlichter@web.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Thomas Schlichter <thomas.schlichter@web.de> 17.10.09 21:48 >>>
>Patches 0001-0003 introduce functionality/changes to the MTRR and sysfs 
>subsystems. Patch 0004 is the main patch which sets up the MTRR entries when 
>pci memory regions are mmapped. The Patches 0005-0006 also change ioremap() 
>and set_mempry_wc() to set up MTRR entries. These two are completely optional, 
>especially and there is currently no way to automatically remove MTRR entries 
>set up with them.
>
>What do you think about these patches?

Functionality-wise this looks fine to me; whether the core sysfs changes
are acceptable I can't judge, though.

However, I would recommend folding the last two arguments of
mtrr_add_unaligned(), i.e. use mtrr_usage != NULL as the increment
argument passed to mtrr_add().

And patches 5 and 6 would apparently not build right now, as they're
failing to pass the new 5th argument to mtrr_add_unaligned().

Also, why do you add x86-specific code to drivers/pci-sysfs.c when the
function called there (pci_mmap_page_range()) already is arch-specific?
Moving your addition there would also allow covering the related
(legacy?) procfs based functionality... pci_release() could also become
arch-specific, with a fall-back definition to NULL.

Additionally, I would suggest making those code portions depend on
CONFIG_X86_MTRR rather than CONFIG_X86, so that you don't
needlessly (try to) allocate the mtrr_usage vector.

Jan

