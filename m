Return-Path: <linux-kernel-owner+w=401wt.eu-S1760867AbXLTMVi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760867AbXLTMVi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 07:21:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758229AbXLTMV3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 07:21:29 -0500
Received: from mx1.redhat.com ([66.187.233.31]:56554 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758893AbXLTMV2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 07:21:28 -0500
Date: Thu, 20 Dec 2007 10:19:55 -0200
From: Eduardo Habkost <ehabkost@redhat.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@suse.de>, Thomas Gleixner <tglx@linutronix.de>,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       Jan Beulich <jbeulich@novell.com>,
       Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>
Subject: Re: [PATCH 2/5] x86: unify pgtable*.h
Message-ID: <20071220121954.GY5322@blackpad.ctb.virtua.com.br>
References: <20071219223534.129042140@goop.org> <20071219223604.519474386@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071219223604.519474386@goop.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 19, 2007 at 02:35:36PM -0800, Jeremy Fitzhardinge wrote:
> +static inline pte_t pte_mkclean(pte_t pte)	{ set_pte(&pte, __pte(pte_val(pte) & ~_PAGE_DIRTY)); return pte; }
> +static inline pte_t pte_mkold(pte_t pte)	{ set_pte(&pte, __pte(pte_val(pte) & ~_PAGE_ACCESSED)); return pte; }
> +static inline pte_t pte_wrprotect(pte_t pte)	{ set_pte(&pte, __pte(pte_val(pte) & ~_PAGE_RW)); return pte; }
> +static inline pte_t pte_mkexec(pte_t pte)	{ set_pte(&pte, __pte(pte_val(pte) & ~_PAGE_NX)); return pte; }
> +static inline pte_t pte_mkdirty(pte_t pte)	{ set_pte(&pte, __pte(pte_val(pte) | _PAGE_DIRTY)); return pte; }
> +static inline pte_t pte_mkyoung(pte_t pte)	{ set_pte(&pte, __pte(pte_val(pte) | _PAGE_ACCESSED)); return pte; }
> +static inline pte_t pte_mkwrite(pte_t pte)	{ set_pte(&pte, __pte(pte_val(pte) | _PAGE_RW)); return pte; }
> +static inline pte_t pte_mkhuge(pte_t pte)	{ set_pte(&pte, __pte(pte_val(pte) | _PAGE_PSE)); return pte; }
> +static inline pte_t pte_clrhuge(pte_t pte)	{ set_pte(&pte, __pte(pte_val(pte) & ~_PAGE_PSE)); return pte; }


Is set_pte() really supposed to be used here? pte_val() and __pte()
are already hooked by paravirt_ops if needed, and it looks like we
don't want to call paravirt_ops set_pte() here.

I don't know if I understood fully the semantics of set_pte(), but
it seems that the paravirt_ops implementations expect set_pte() to be
called for PTEs that are actually inside existing pagetables (and not
for short-lived stack variables, like on this case).

Was this tested under Xen and/or VMI?

-- 
Eduardo
