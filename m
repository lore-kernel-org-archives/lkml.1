Return-Path: <linux-kernel-owner+w=401wt.eu-S1755940AbZBIRH2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755940AbZBIRH2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 12:07:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753611AbZBIRHQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 12:07:16 -0500
Received: from mx2.redhat.com ([66.187.237.31]:60956 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752285AbZBIRHO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 12:07:14 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1232919337-21434-1-git-send-email-righi.andrea@gmail.com>
References: <1232919337-21434-1-git-send-email-righi.andrea@gmail.com>
To: Andrea Righi <righi.andrea@gmail.com>
Cc: dhowells@redhat.com, akpm@linux-foundation.org, linux-mm@kvack.org,
       linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mmotm] mm: unify some pmd_*() functions
Date: Mon, 09 Feb 2009 17:06:35 +0000
Message-ID: <16182.1234199195@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrea Righi <righi.andrea@gmail.com> wrote:

> Unify all the identical implementations of pmd_free(), __pmd_free_tlb(),
> pmd_alloc_one(), pmd_addr_end() in include/asm-generic/pgtable-nopmd.h

NAK for FRV on two fronts:

 (1) The definition of pud_t in pgtable-nopud.h:

	typedef struct { pgd_t pgd; } pud_t;

     is not consistent with the one in FRV's page.h:

	typedef struct { unsigned long	ste[64];} pmd_t;
	typedef struct { pmd_t		pue[1]; } pud_t;
	typedef struct { pud_t		pge[1];	} pgd_t;

     The upper intermediate page table is contained within the page directory
     entry, not the other way around.  Having a pgd_t inside a pud_t is
     upside-down, illogical and makes things harder to follow IMNSHO.

 (2) It produces the following errors:

mm/memory.c: In function 'free_pmd_range':
mm/memory.c:176: error: implicit declaration of function '__pmd_free_tlb'
  CC      fs/seq_file.o
mm/memory.c: In function '__pmd_alloc':
mm/memory.c:2896: error: implicit declaration of function 'pmd_alloc_one_bug'
mm/memory.c:2896: warning: initialization makes pointer from integer without a cast
mm/memory.c:2905: error: implicit declaration of function 'pmd_free'

David
