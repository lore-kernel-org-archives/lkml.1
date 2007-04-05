Return-Path: <linux-kernel-owner+w=401wt.eu-S965052AbXDEIyM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965052AbXDEIyM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 04:54:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965084AbXDEIyL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 04:54:11 -0400
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:54412
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965052AbXDEIyK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 04:54:10 -0400
Message-Id: <4614D580.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.1 
Date: Thu, 05 Apr 2007 09:54:56 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: "Jeremy Fitzhardinge" <jeremy@goop.org>
Cc: "Ingo Molnar" <mingo@elte.hu>, "Andrew Morton" <akpm@linux-foundation.org>,
       <virtualization@lists.osdl.org>, "Roland McGrath" <roland@redhat.com>,
       "Andi Kleen" <ak@suse.de>, "lkml" <linux-kernel@vger.kernel.org>,
       "Zachary Amsden" <zach@vmware.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [patch 1/2] Relocate VDSO ELF headers to match
	mapped	location with COMPAT_VDSO
References: <20070405081415.E59E6180055@magilla.sf.frob.com>
 <4614B0DB.7040003@goop.org>
In-Reply-To: <4614B0DB.7040003@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>+	for(; dyn->d_tag != DT_NULL; dyn++)
>+		switch(dyn->d_tag) {
>+		case DT_PLTGOT:
>+		case DT_HASH:
>+		case DT_STRTAB:
>+		case DT_SYMTAB:
>+		case DT_RELA:
>+		case DT_INIT:
>+		case DT_FINI:
>+		case DT_REL:
>+		case DT_DEBUG:
>+		case DT_JMPREL:
>+		case DT_VERSYM:
>+		case DT_VERDEF:
>+		case DT_VERNEED:
>+		case DT_ENCODING ... DT_HIOS:
>+			/* tags above DT_ENCODING are even if they're
>+			   a pointer, so skip odd ones */
>+			if (dyn->d_tag >= DT_ENCODING &&
>+			    (dyn->d_tag & 1) == 1)
>+				break;
>+
>+			dyn->d_un.d_ptr += VDSO_HIGH_BASE;
>+		}

I'm pretty certain the range OLD_DT_LOOS ... DT_LOOS must be excluded
here (the document version I'm looking at is inconsistent in itself here, saying
in one place to stop at DT_LOOS, in a second to stop at DT_HIOS, and in a
third to include DT_LOOS ... ST_HIOS - the inconsistency goes away if
assuming that the stop at DT_LOOS really means stop at OLD_DT_LOOS,
and the stop at DT_HIOS misses to special-case the OLD_DT_LOOS ...
DT_LOOS range.
Additionally I'm a little worried about excluding DT_ADDRRNGLO ...
DT_ADDRRNGHI in case future binutils ever start defaulting to generate
any of these (namely DT_GNU_HASH).

>+#define DT_ENCODING	32

Hmm, I was about to say this ought to be 31 when I realized the discrepancy
between document and binutils. I'll have to ask about this...

Jan
