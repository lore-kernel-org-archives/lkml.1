Return-Path: <linux-kernel-owner+w=401wt.eu-S1761577AbXLTVCu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761577AbXLTVCu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 16:02:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752730AbXLTVCk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 16:02:40 -0500
Received: from gw.goop.org ([64.81.55.164]:33510 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761372AbXLTVCi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 16:02:38 -0500
Message-ID: <476AD86B.8000901@goop.org>
Date: Thu, 20 Dec 2007 13:02:35 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Eduardo Habkost <ehabkost@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@suse.de>, Thomas Gleixner <tglx@linutronix.de>,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       Jan Beulich <jbeulich@novell.com>,
       Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>
Subject: Re: [PATCH 2/5] x86: unify pgtable*.h
References: <20071219223534.129042140@goop.org> <20071219223604.519474386@goop.org> <20071220121954.GY5322@blackpad.ctb.virtua.com.br>
In-Reply-To: <20071220121954.GY5322@blackpad.ctb.virtua.com.br>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eduardo Habkost wrote:
> On Wed, Dec 19, 2007 at 02:35:36PM -0800, Jeremy Fitzhardinge wrote:
>   
>> +static inline pte_t pte_mkclean(pte_t pte)	{ set_pte(&pte, __pte(pte_val(pte) & ~_PAGE_DIRTY)); return pte; }
>> +static inline pte_t pte_mkold(pte_t pte)	{ set_pte(&pte, __pte(pte_val(pte) & ~_PAGE_ACCESSED)); return pte; }
>> +static inline pte_t pte_wrprotect(pte_t pte)	{ set_pte(&pte, __pte(pte_val(pte) & ~_PAGE_RW)); return pte; }
>> +static inline pte_t pte_mkexec(pte_t pte)	{ set_pte(&pte, __pte(pte_val(pte) & ~_PAGE_NX)); return pte; }
>> +static inline pte_t pte_mkdirty(pte_t pte)	{ set_pte(&pte, __pte(pte_val(pte) | _PAGE_DIRTY)); return pte; }
>> +static inline pte_t pte_mkyoung(pte_t pte)	{ set_pte(&pte, __pte(pte_val(pte) | _PAGE_ACCESSED)); return pte; }
>> +static inline pte_t pte_mkwrite(pte_t pte)	{ set_pte(&pte, __pte(pte_val(pte) | _PAGE_RW)); return pte; }
>> +static inline pte_t pte_mkhuge(pte_t pte)	{ set_pte(&pte, __pte(pte_val(pte) | _PAGE_PSE)); return pte; }
>> +static inline pte_t pte_clrhuge(pte_t pte)	{ set_pte(&pte, __pte(pte_val(pte) & ~_PAGE_PSE)); return pte; }
>>     
>
>
> Is set_pte() really supposed to be used here? pte_val() and __pte()
> are already hooked by paravirt_ops if needed, and it looks like we
> don't want to call paravirt_ops set_pte() here.
>   

No, you're right.  That looks pretty stupid.  It will work, but it's
clearly sub-optimal.


> I don't know if I understood fully the semantics of set_pte(), but
> it seems that the paravirt_ops implementations expect set_pte() to be
> called for PTEs that are actually inside existing pagetables (and not
> for short-lived stack variables, like on this case).
>
> Was this tested under Xen and/or VMI?
>   
Yes, Xen.  It's always OK to use set_pte on something that isn't
actually part of a pagetable, since it can be used on pagetables which
are under construction.  But it may end up doing too much work.

    J
