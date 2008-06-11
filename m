Return-Path: <linux-kernel-owner+w=401wt.eu-S932456AbYFKS6y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932456AbYFKS6y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 14:58:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765900AbYFKS55
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 14:57:57 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:58909 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1765891AbYFKS5z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 14:57:55 -0400
Date: Wed, 11 Jun 2008 13:57:54 -0500
From: Jack Steiner <steiner@sgi.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
       holt@sgi.com, andrea@qumranet.com
Subject: Re: [patch 01/11] GRU Driver - hardware data structures
Message-ID: <20080611185754.GA14442@sgi.com>
References: <20080609211028.110089743@attica.americas.sgi.com> <20080609211044.992972808@attica.americas.sgi.com> <20080609155217.97806364.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080609155217.97806364.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 09, 2008 at 03:52:17PM -0700, Andrew Morton wrote:
> On Mon, 09 Jun 2008 16:10:29 -0500
> steiner@sgi.com wrote:
> 
> > This patch contains the definitions of the hardware GRU data structures that are used
> > by the driver to manage the GRU.
> > 
> 
> oh goody, more code to review.

Glad to oblige ....    :-)


> 
> >
> > ...
> >
> > +/* Convert resource counts to the number of AU */
> > +#define GRU_DS_BYTES_TO_AU(n)	(((n) + GRU_DSR_AU_BYTES - 1) / \
> > +				 GRU_DSR_AU_BYTES)
> > +#define GRU_CB_COUNT_TO_AU(n)	(((n) + GRU_CBR_AU_SIZE - 1) / 	\
> > +				 GRU_CBR_AU_SIZE)
> 
> These are open-coded ROUND_UP()s

Fixed.


> 
> > +/* UV limits */
> > +#define GRU_CHIPLETS_PER_HUB	2
> > +#define GRU_HUBS_PER_BLADE	1
> > +#define GRU_CHIPLETS_PER_BLADE	(GRU_HUBS_PER_BLADE * GRU_CHIPLETS_PER_HUB)
> > +
> > +/* User GRU Gseg offsets */
> > +#define GRU_CB_BASE		0
> > +#define GRU_CB_LIMIT		(GRU_CB_BASE + GRU_HANDLE_STRIDE * GRU_NUM_CBE)
> > +#define GRU_DS_BASE		0x20000
> > +#define GRU_DS_LIMIT		(GRU_DS_BASE + GRU_NUM_DSR_BYTES)
> > +
> > +/* General addressing macros. b=grubase, c=ctxnum, i=cbnum, cl=cacheline#  */
> > +#define GRU_GSEG(b, c)		((void *)((b) + GRU_GSEG0_BASE +	\
> > +		GRU_GSEG_STRIDE * (c)))
> > +#define GRU_GSEG_CB(b, c, i)	((void *)(GRU_GSEG((b), (c)) +		\
> > +		GRU_CB_BASE + GRU_HANDLE_STRIDE * (i)))
> > +#define GRU_GSEG_DS(b, c, cl)	((void *)(GRU_GSEG((b), (c)) +		\
> > +		GRU_DS_BASE + GRU_CACHE_LINE_BYTES * (cl)))
> > +#define GRU_TFM(b, c)		((struct gru_tlb_fault_map *)		\
> > +		((unsigned long)(b) + GRU_TFM_BASE + (c) * GRU_HANDLE_STRIDE))
> > +#define GRU_TGH(b, c)		((struct gru_tlb_global_handle *)	\
> > +		((unsigned long)(b) + GRU_TGH_BASE + (c) * GRU_HANDLE_STRIDE))
> > +#define GRU_CBE(b, n)		((struct gru_control_block_extended *)	\
> > +		((unsigned long)(b) + GRU_CBE_BASE + (n) * GRU_HANDLE_STRIDE))
> > +#define GRU_TFH(b, n)		((struct gru_tlb_fault_handle *)	\
> > +		((unsigned long)(b) + GRU_TFH_BASE + (n) * GRU_HANDLE_STRIDE))
> > +#define GRU_CCH(b, n)		((struct gru_context_configuration_handle *) \
> > +		((unsigned long)(b) + GRU_CCH_BASE + (n) * GRU_HANDLE_STRIDE))
> > +#define GRU_GSH(b)		((struct gru_global_status_handle *)	\
> > +		((unsigned long)(b) + GRU_GSH_BASE))
> 
> Is there any particular reason why these had to be implemented via macros?

Not particularily. I can switch them to inline functions. The added type checking will help.


> 
> > +/*
> > + * Test if an offset is a valid kernel handle address.
> > + * 	Ex:  TYPE_IS(CBE, chiplet_offset)
> > + */
> > +#define TYPE_IS(hn, h)		((h) >= GRU_##hn##_BASE && (h) < 	\
> > +	GRU_##hn##_BASE + GRU_NUM_##hn * GRU_HANDLE_STRIDE && 		\
> > +				 (((h) & (GRU_HANDLE_STRIDE - 1)) == 0))
> 
> That one will misbehave if passed an `h' whcih hasside-effects.  I
> guess that's hard to fix if you need to retain the pasting thing.

Hmmm. It turns out that this is used exclusively in the hardware simulator. I
will move this definition to the simulator so that it won't be part
of the kernel.


> 
> > +/*
> > + * Test a GRU physical address to determine the type of address range (does
> > + * NOT validate holes)
> > + */
> > +#define IS_MCS_PADDR(h)		(((h) & (GRU_SIZE - 1)) >= GRU_MCS_BASE)
> > +#define IS_CBR_PADDR(h)		(((h) & (GRU_SIZE - 1)) < 		\
> > +		GRU_MCS_BASE && (((h) & (GRU_GSEG_STRIDE - 1)) < GRU_DS_BASE))
> 
> has the same bug, but doesn't do pasting.

Will switch to inline functions.


> 
> > +#define IS_DSR_PADDR(h)		(((h) & (GRU_SIZE - 1)) < GRU_MCS_BASE && \
> > +		(((h) & (GRU_GSEG_STRIDE - 1)) >= GRU_DS_BASE))
> 
> ditto.

Ditto


> 
> > +/* Convert an arbitrary handle address to the beginning of the GRU segment */
> > +#ifndef __PLUGIN__
> > +#define GRUBASE(h)		((void *)((unsigned long)(h) & ~(GRU_SIZE - 1)))
> > +#else
> > +/* Emulator hack */
> > +extern void *gmu_grubase(void *h);
> > +#define GRUBASE(h)		gmu_grubase(h)
> > +#endif
> > +
> > +/* Convert a GRU physical address to the chiplet offset */
> > +#define GSEGPOFF(h) ((h) & (GRU_SIZE - 1))
> > +
> > +/* Convert a GSEG CB address to the relative CB number within the context */
> > +#define CBNUM(cb) ((((unsigned long)(cb) - GRU_CB_BASE) % GRU_GSEG_PAGESIZE) / \
> > +			GRU_HANDLE_STRIDE)
> > +
> > +/* Convert a TFH address to the relative TFH number within the GRU*/
> > +#define TFHNUM(tfh) ((((unsigned long)(tfh) - GRU_TFH_BASE) % GRU_SIZE) / \
> > +			GRU_HANDLE_STRIDE)
> > +
> > +/* Convert a CCH address to the relative context number within the GRU*/
> > +#define CCHNUM(cch) ((((unsigned long)(cch) - GRU_CCH_BASE) % GRU_SIZE) / \
> > +			GRU_HANDLE_STRIDE)
> > +
> > +/* Convert a CBE address to the relative context number within the GRU*/
> > +#define CBENUM(cbe) ((((unsigned long)(cbe) - GRU_CBE_BASE) % GRU_SIZE) / \
> > +			GRU_HANDLE_STRIDE)
> > +
> > +/* Convert a TFM address to the relative context number within the GRU*/
> > +#define TFMNUM(tfm) ((((unsigned long)(tfm) - GRU_TFM_BASE) % GRU_SIZE) / \
> > +			GRU_HANDLE_STRIDE)
> > +
> > +/* byte offset to a specific GRU chiplet. (p=pnode, c=chiplet (0 or 1)*/
> > +#define GRUCHIPOFFSET(p, c) (GRU_SIZE * ((p) * 2 + (c)))
> 
> etc.

Ditto


> 
> > +#ifndef BITS_TO_LONGS
> > +#define BITS_TO_LONGS(bits)     (((bits)+64-1)/64)
> > +#endif
> 
> BITS_TO_LONGS is defined in include/linux/bitops.h.  Is this here just
> for userspace inclusion?  If not, it can go.  If so, don't we have a
> 32-bit problem?  Or does this code have the suitable 64-bit Kconfig
> dependencies?

Yes - the header is also included in user test programs (mostly diagnostics) that
are used to dump the GRU state after an error.  If necessary, I can make these
lines go away from the kernel version of the file.


> 
> 
> > +/*
> > + * GSH - GRU Status Handle
> > + *	Shows status of each CBR/CBR resources
> > + */
> > +struct gru_global_status_handle {
> > +	unsigned long bits[BITS_TO_LONGS(GRU_NUM_CBE) * 2];
> 
> That's an open-coded DECLARE_BITMAP.
> 
> I'm assuming that we're about to see large amounts of code which
> reimplements the functions which the bitmap library offers, so I'll
> just ask: should this code be using the bitmap library?

I think I could use a bitmap here. However, I may still have an issue with
the use of this header in user programs - not sure yet.

However, we don't current use this GRU structure and am not sure if we will.
For now, I think I will just delete the structure. When/if we find a use,
I'll re-address the issue.


> 
> > +	unsigned int opc:1;
> > +	unsigned int fill1:5;
> > +
> > +	unsigned int fill2:8;
> > +
> >
> > ...
> >
> > +#ifdef __KERNEL__
> > +#include "gru_instructions.h"
> > +
> > +/* Extract the status field from a kernel handle */
> > +#define GET_MSEG_HANDLE_STATUS(h)	(((*(unsigned long *)(h)) >> 16) & 3)
> > +
> 
> > +#if defined __ia64__
> > +#elif defined __x86_64__
> > +#endif
> 
> CONFIG_IA64 and CONFIG_X86_64 would be more fashionable.

Agree. Fixed.


> 
> > +static inline void start_instruction(void *h)
> > +static inline int wait_instruction_complete(void *h)
> > +static inline void cch_allocate_set_asids(
> > +static inline void cch_allocate_set_asids(
> > +static inline int cch_allocate(struct gru_context_configuration_handle *cch,
> > +static inline int cch_start(struct gru_context_configuration_handle *cch)
> > +static inline int cch_interrupt(struct gru_context_configuration_handle *cch)
> > +static inline int cch_deallocate(struct gru_context_configuration_handle *cch)
> > +static inline int cch_interrupt_sync(struct gru_context_configuration_handle
> > +static inline int tgh_invalidate(struct gru_tlb_global_handle *tgh,
> > +static inline void tfh_write_only(struct gru_tlb_fault_handle *tfh,
> > +static inline void tfh_write_restart(struct gru_tlb_fault_handle *tfh,
> > +static inline void tfh_restart(struct gru_tlb_fault_handle *tfh)
> > +static inline void tfh_user_polling_mode(struct gru_tlb_fault_handle *tfh)
> > +static inline void tfh_exception(struct gru_tlb_fault_handle *tfh)
> 
> wow.  Most of these are way too large to be inlined.  And inlining is
> so unweildy and namespace-polluty.  How come?

I'll take another look at these. My "todo" list has an item to review the
use of inline functions and make sure they are correctly used.


--- jack

