Return-Path: <linux-kernel-owner+w=401wt.eu-S1753921AbYAQASf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753921AbYAQASf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 19:18:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751275AbYAQAS0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 19:18:26 -0500
Received: from mga03.intel.com ([143.182.124.21]:6439 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750998AbYAQASZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 19:18:25 -0500
X-ExtLoop1: 1
Date: Wed, 16 Jan 2008 16:18:24 -0800
From: Venki Pallipadi <venkatesh.pallipadi@intel.com>
To: Mika =?iso-8859-1?Q?Penttil=E4?= <mika.penttila@kolumbus.fi>
Cc: venkatesh.pallipadi@intel.com, ak@muc.de, ebiederm@xmission.com,
       rdreier@cisco.com, torvalds@linux-foundation.org, gregkh@suse.de,
       airlied@skynet.ie, davej@redhat.com, mingo@elte.hu, tglx@linutronix.de,
       hpa@zytor.com, akpm@linux-foundation.org, arjan@infradead.org,
       jesse.barnes@intel.com, davem@davemloft.net,
       linux-kernel@vger.kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [patch 2/4] x86: PAT followup - Remove KERNPG_TABLE from pte entry
Message-ID: <20080117001823.GA20383@linux-os.sc.intel.com>
References: <20080116023955.597433000@intel.com> <20080116024111.825025000@intel.com> <478DBCC8.10404@kolumbus.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <478DBCC8.10404@kolumbus.fi>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 16, 2008 at 10:14:00AM +0200, Mika Penttilä wrote:
> venkatesh.pallipadi@intel.com kirjoitti:
> >KERNPG_TABLE was a bug in earlier patch. Remove it from pte.
> >pte_val() check is redundant as this routine is called immediately after a
> >ptepage is allocated afresh.
> >
> >Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
> >Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
> >
> >Index: linux-2.6.git/arch/x86/mm/init_64.c
> >===================================================================
> >--- linux-2.6.git.orig/arch/x86/mm/init_64.c	2008-01-15 
> >11:02:23.000000000 -0800
> >+++ linux-2.6.git/arch/x86/mm/init_64.c	2008-01-15 
> >11:06:37.000000000 -0800
> >@@ -541,9 +541,6 @@
> > 		if (address >= end)
> > 			break;
> > 
> >-		if (pte_val(*pte))
> >-			continue;
> >-
> > 		/* Nothing to map. Map the null page */
> > 		if (!(address & (~PAGE_MASK)) &&
> > 		    (address + PAGE_SIZE <= end) &&
> >@@ -561,9 +558,9 @@
> > 		}
> > 
> > 		if (exec)
> >-			entry = _PAGE_NX|_KERNPG_TABLE|_PAGE_GLOBAL|address;
> >+			entry = _PAGE_NX|_PAGE_GLOBAL|address;
> > 		else
> >-			entry = _KERNPG_TABLE|_PAGE_GLOBAL|address;
> >+			entry = _PAGE_GLOBAL|address;
> > 		entry &= __supported_pte_mask;
> > 		set_pte(pte, __pte(entry));
> > 	}
> >
> >  
> 
> Hmm then what's the point of mapping not present 4k pages for valid mem 
> here?
> 

Ingo,

Below incremental patch fixes this pte entry setting correctly. Thanks to
Mika for catching this.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>

Index: linux-2.6.git/arch/x86/mm/init_64.c
===================================================================
--- linux-2.6.git.orig/arch/x86/mm/init_64.c	2008-01-16 03:38:32.000000000 -0800
+++ linux-2.6.git/arch/x86/mm/init_64.c	2008-01-16 03:51:34.000000000 -0800
@@ -515,9 +515,9 @@
 		}
 
 		if (exec)
-			entry = _PAGE_NX|_PAGE_GLOBAL|address;
+			entry = __PAGE_KERNEL_EXEC | _PAGE_GLOBAL | address;
 		else
-			entry = _PAGE_GLOBAL|address;
+			entry = __PAGE_KERNEL | _PAGE_GLOBAL | address;
 		entry &= __supported_pte_mask;
 		set_pte(pte, __pte(entry));
 	}

