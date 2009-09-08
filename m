Return-Path: <linux-kernel-owner+w=401wt.eu-S1752243AbZIHUts@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752243AbZIHUts (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 16:49:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751941AbZIHUtr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 16:49:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56821 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751708AbZIHUtr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 16:49:47 -0400
Date: Tue, 8 Sep 2009 16:48:54 -0400
From: Jason Baron <jbaron@redhat.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: linux-kernel@vger.kernel.org, roland@redhat.com, rth@redhat.com,
       mingo@elte.hu
Subject: Re: [PATCH 0/4] RFC: jump label - (tracepoint optimizations)
Message-ID: <20090908204853.GC2641@redhat.com>
References: <cover.1252007851.git.jbaron@redhat.com> <20090907154824.GA1085@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090907154824.GA1085@Krystal>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 07, 2009 at 11:48:24AM -0400, Mathieu Desnoyers wrote:
> >                ".pushsection __jump_table,  \"a\" \n\t"                \
> >                _ASM_PTR "1b, %l[" #label "], %c0 \n\t"                 \
> >                ".popsection \n\t"                                      \
> >                : :  "i" (__sjstrtab_##tag) :  : label)
> > 
> 
> Supporting multiple labels to create a real jump table would be a
> nice-to-have as future enhancement too. This could be called
> STATIC_JUMP_TABLE(). Actually, the STATIC_JUMP_IF could probably be
> implemented in terms of STATIC_JUMP_TABLE.
> 
> > #else
> > 
> > #define STATIC_JUMP_IF(tag, label, cond)        \
> >         if (unlikely(cond))                     \
> >                 goto label;
> > 
> 
> Hrm, however, it's not clear to me how the STATIC_JUMP_TABLE() fallback
> would look like. In the case of STATIC_JUMP_IF, it's a simple if (),
> which makes support of compilers lacking static jump support easy. We
> could probably use a switch statement to replace the STATIC_JUMP_TABLE
> though.
> 

right - if we have more labels passed into STATIC_JUMP_TABLE(), we can
probably do a case statement with a 'goto' to the correct label.

> > #endif /* !HAVE_STATIC_JUMP */
> > 
> > 
> > which can be used as:
> > 
> >         STATIC_JUMP_IF(trace, trace_label, jump_enabled);
> >         printk("not doing tracing\n");
> > if (0) {
> > trace_label:
> >         printk("doing tracing: %d\n", file);
> > }
> > 
> 
> Hrm. Is there any way to make this a bit prettier ? Given modifications
> are made to gcc anyway...
> 
> Maybe:
> 
> static_jump_if (trace, jump_enabled) {
>  ...
> 
> } else {
>  ...
> }
> 
> And for the jump table:
> 
> static_jump_table (trace, jump_select) {
>   case 0: ...
>           break;
>   case 1: ...
>           break;
>   default:
>           ...
> }
> 

hmmm...yes, I agree it would be nice if the code looked a little prettier.
However, short of additional gcc changes i'm not sure how to do that.
perhaps, somebody has some better ideas? Note also, that the
'STATIC_JUMP_IF()' as defined implements both:

if () { }

and:

if () { } else { }

I'm not sure the code is that hideous as proposed. However, I definitely
would be interested it other opinions? Also, in this case note that the
STATIC_JUMP_IF() is only added to 1 place in the code, and doesn't
affect any of the normal tracepoint API.

> 
> > ---------------------------------------
> > 
> > Thus, if 'HAVE_STATIC_JUMP' is defined (which will depend ultimately on the
> > existence of 'asm goto' in the compiler version), we simply have a no-op
> > followed by a jump around the dormant (disabled) tracing code.
> 
> Hrm, why don't we collapse that into a single 5-bytes jump instruction
> instead ?

that might be nice, but would require more complex compiler support. I'm
not sure if the extra complexity is worth the 2-byte i-cache savings?
That is, I think we're getting the majority of the savings with the
proposed solution.

thanks,

-Jason

