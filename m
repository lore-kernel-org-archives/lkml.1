Return-Path: <linux-kernel-owner+w=401wt.eu-S1757303AbYGPMZm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757303AbYGPMZm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 08:25:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753141AbYGPMZe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 08:25:34 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:54645 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750971AbYGPMZd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 08:25:33 -0400
Message-ID: <487DE8BB.5070407@sgi.com>
Date: Wed, 16 Jul 2008 05:25:31 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Bert Wesarg <bert.wesarg@googlemail.com>
CC: Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org,
       Paul Jackson <pj@sgi.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 7/8] cpumask: Provide a generic set of CPUMASK_ALLOC macros
References: <20080715211429.454823000@polaris-admin.engr.sgi.com>	 <20080715211430.448714000@polaris-admin.engr.sgi.com> <36ca99e90807152341h28ec137do76fbf85bd50a3abe@mail.gmail.com>
In-Reply-To: <36ca99e90807152341h28ec137do76fbf85bd50a3abe@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bert Wesarg wrote:
> On Tue, Jul 15, 2008 at 23:14, Mike Travis <travis@sgi.com> wrote:
>>  * Provide a generic set of CPUMASK_ALLOC macros patterned after the
>>    SCHED_CPUMASK_ALLOC macros.  This is used where multiple cpumask_t
>>    variables are declared on the stack to reduce the amount of stack
>>    space required.
>>
>> Based on linux-2.6.tip/master at the following commit:
>>
>>    commit 0a91813e16ebd5c2d9b5c2acd5b7c91742112c4f
>>    Merge: 9a635fa... 724dce0...
>>    Author: Ingo Molnar <mingo@elte.hu>
>>    Date:   Tue Jul 15 14:55:17 2008 +0200
>>
>> Signed-off-by: Mike Travis <travis@sgi.com>
>> Cc: Paul Jackson <pj@sgi.com>
>> ---
>>  include/linux/cpumask.h |   21 +++++++++++++++++++++
>>  1 file changed, 21 insertions(+)
>>
>> --- linux-2.6.tip.orig/include/linux/cpumask.h
>> +++ linux-2.6.tip/include/linux/cpumask.h
>> @@ -75,6 +75,17 @@
>>  * CPU_MASK_NONE                       Initializer - no bits set
>>  * unsigned long *cpus_addr(mask)      Array of unsigned long's in mask
>>  *
>> + *if NR_CPUS > BITS_PER_LONG
>> + *   CPUMASK_ALLOC(m)                  Declares and allocates struct m *m =
>> + *                                        (struct m *)kmalloc(sizeof(*m), ...)
> Shouldn't you mention the GFP_KERNEL flag? And the cast should not
> necessarily be mentioned in a comment.

Hmm, yes.  I encountered the checkpatch warning about casting kmalloc and
changed the macro but not the comment.  (And now there's room for adding
GFP_KERNEL to the comment! ;-)
> 
>> + *   CPUMASK_FREE(m)                   Macro for kfree(v)
>                                                     kfree(m)
> 
>> + *else
>> + *   CPUMASK_ALLOC(m)                  Declares struct m _m, *m = &_m
>> + *   CPUMASK_FREE(m)                   Nop
>> + *endif
>> + *   CPUMASK_VAR(v, m)                 Declares cpumask_t *v =
>> + *                                             m + offset(struct m, v)
>                                                       offsetof
> and why can't you use a &(m->v)?

I thought about this but what if kmalloc fails?  It's ok to add the
offset to a NULL pointer, but dereferencing a null pointer (even though
it's just to get the address) may introduce a fault, yes?

I'll look into this further.  There was one other remnant from the
copy/paste that needed to be fixed:

-#define        CPUMASK_ALLOC(m)        struct allmasks _m, *m = &_m
+#define        CPUMASK_ALLOC(m)        struct m _m, *m = &_m

Thanks!
Mike
