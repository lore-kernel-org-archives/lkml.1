Return-Path: <linux-kernel-owner+w=401wt.eu-S934409AbZJMV3q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934409AbZJMV3q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 17:29:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934399AbZJMV3p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 17:29:45 -0400
Received: from fmmailgate03.web.de ([217.72.192.234]:34577 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934400AbZJMV3n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 17:29:43 -0400
From: Thomas Schlichter <thomas.schlichter@web.de>
To: "Jan Beulich" <JBeulich@novell.com>
Subject: Re: [RFC Patch] use MTRR for write combining if PAT is not available
Date: Tue, 13 Oct 2009 23:29:05 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.28.10-modified-ioremap; KDE/4.3.2; i686; ; )
Cc: "Jeremy Fitzhardinge" <jeremy.fitzhardinge@citrix.com>,
       "Robert Hancock" <hancockrwd@gmail.com>,
       "Henrique de Moraes Holschuh" <hmh@hmh.eng.br>,
       "Suresh Siddha" <suresh.b.siddha@intel.com>,
       "Venkatesh Pallipadi" <venkatesh.pallipadi@intel.com>,
       "Tejun Heo" <tj@kernel.org>, x86@kernel.org,
       "Yinghai Lu" <yinghai@kernel.org>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Arjan van de Ven" <arjan@linux.intel.com>,
       dri-devel@lists.sourceforge.net, "Ingo Molnar" <mingo@redhat.com>,
       linux-kernel@vger.kernel.org, jbarnes@virtuousgeek.org,
       "Thomas Hellstrom" <thellstrom@vmware.com>,
       "H. Peter Anvin" <hpa@zytor.com>
References: <4AD449A702000078000197EE@vpn.id2.novell.com>
In-Reply-To: <4AD449A702000078000197EE@vpn.id2.novell.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200910132329.05152.thomas.schlichter@web.de>
X-Provags-ID: V01U2FsdGVkX1+PM0xSwz96zQGuAQsv2QDn+CBBfvJmddcR/txc
	APrptynF1uXO+97pg/zMuGcDHcq6igVoZgMnB4QxJQ+mtEt7Aw
	S9v/nEm7tw/15K/GYb2A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Beulich wrote:
> >>> Thomas Schlichter <thomas.schlichter@web.de> 12.10.09 20:32 >>>
> >+	if (!pat_enabled) {
> >+		void __iomem *ret = ioremap_nocache(phys_addr, size);
> >+		if (ret)
> >+			mtrr_add(phys_addr, size, MTRR_TYPE_WRCOMB, false);
> 
> This won't work if phys_addr or size aren't page aligned, or if size isn't
> a power of two.

No, at least the comments in mtrr_add and mtrr_check state that it is just 
required that phys_addr and size are multiple of PAGE_SIZE. And I'm not sure 
if it is always safe to round these up/down to the next PAGE boundary. If it 
is not, maybe it is better to fail...

> >+	if (!pat_enabled) {
> >+		ret = set_memory_uc(addr, numpages);
> >+		if (!ret)
> >+			mtrr_add(__pa(addr), numpages * PAGE_SIZE,
> >+				 MTRR_TYPE_WRCOMB, false);
> 
> Similarly, this requires numpages to be a power of two.

Same as above.

> I think user mode code handles this by splitting the request and trying to
> establish as many entries as possible (and those as big as possible).

Seems not required here...

> Also, in all cases you pass 'false' for the 'increment' parameter, in order
> to avoid having to tear down the established entries. While this may be
> reasonable for kernel initiated mappings, I don't think that's acceptable
> for such originating from user mode.

Well, therefore I would have to remember which mmap successfully set up which 
MTRR entries. And it must be ensured that for each mmap there always is a 
munmap. If this is indeed always ensured, and if it's worth to maintain the 
required data, I'd be happy to add a corresponding mtrr_del there.

Kind regards,
  Thomas
