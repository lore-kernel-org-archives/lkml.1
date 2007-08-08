Return-Path: <linux-kernel-owner+w=401wt.eu-S1762399AbXHHN6T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762399AbXHHN6T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 09:58:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751612AbXHHN6J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 09:58:09 -0400
Received: from mu-out-0910.google.com ([209.85.134.186]:50024 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751122AbXHHN6I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 09:58:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=c9eKkbrDgOXlbFUCb/O1JMaw02/kpyJ+u++WjQOGcTcrS6nBsAdfgLRDpB/3hozAdFkRzSY7+X0cM9w4kboqUS2QzYzewb9qotkX32h50i18l88aJ9/JMGstpQC5Rf+Rzp/xY5/OVnYQLMtPCowYRRZGDZIVZdB07HIRMc+yxgQ=
Message-ID: <5d6222a80708080658j780667c4o52e924f8690f2a85@mail.gmail.com>
Date: Wed, 8 Aug 2007 10:58:06 -0300
From: "Glauber de Oliveira Costa" <glommer@gmail.com>
To: "Andi Kleen" <ak@suse.de>
Subject: Re: [PATCH 18/25] [PATCH] turn priviled operations into macros in entry.S
Cc: "Glauber de Oliveira Costa" <gcosta@redhat.com>, lguest@ozlabs.org,
       linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
       chrisw@sous-sol.org, anthony@codemonkey.ws, akpm@linux-foundation.org,
       mingo@elte.hu
In-Reply-To: <200708081138.23018.ak@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <11865467522495-git-send-email-gcosta@redhat.com>
	 <1186546820708-git-send-email-gcosta@redhat.com>
	 <11865468243612-git-send-email-gcosta@redhat.com>
	 <200708081138.23018.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thank you for the attention, andi

let's go:

On 8/8/07, Andi Kleen <ak@suse.de> wrote:
>
> > +#define SYSRETQ                                              \
> > +                     movq    %gs:pda_oldrsp,%rsp;    \
> > +                     swapgs;                         \
> > +                     sysretq;
>
> When the macro does more than sysret it should have a different
> name
That's fair. Again, suggestions are welcome. Maybe SYSCALL_RETURN ?

> >   */
> >       .globl int_ret_from_sys_call
> >  int_ret_from_sys_call:
> > -     cli
> > +     DISABLE_INTERRUPTS(CLBR_ANY)
>
> ANY? There are certainly some registers alive at this point like rax
yes, this one is wrong. Thanks for the catch

> >  retint_restore_args:
> > -     cli
> > +     DISABLE_INTERRUPTS(CLBR_ANY)
>
> Similar.
I don't think so. They are live here, but restore_args follows, so we
can safely clobber anything here. Right?

>
> >       /*
> >        * The iretq could re-enable interrupts:
> >        */
> > @@ -566,10 +587,14 @@ retint_restore_args:
> >  restore_args:
> >       RESTORE_ARGS 0,8,0
> >  iret_label:
> > -     iretq
> > +#ifdef CONFIG_PARAVIRT
> > +     INTERRUPT_RETURN
> > +ENTRY(native_iret)
>
> ENTRY adds alignment. Why do you need that export anyways?
Just went on the flow. Will change.

> > +#endif
> > +1:   iretq
> >
> >       .section __ex_table,"a"
> > -     .quad iret_label,bad_iret
> > +     .quad 1b, bad_iret
>
> iret_label seems more expressive to me than 1

fair.

> > +     ENABLE_INTERRUPTS(CLBR_NONE)
>
> In many of the CLBR_NONEs there are actually some registers free;
> but it might be safer to keep it this way. But if some client can get
> significantly better code with one or two free registers it might
> be worthwhile to investigate.
That's exactly what I had in mind. I'd highly prefer to keep it this
way until it is merged, and we are sure all the rest is stable

> > -     swapgs
> > +     SWAPGS_NOSTACK
>
> There's still stack here

Yes, but it is not safe to use. I think Roasted addressed it later on.

> >  paranoid_restore\trace:
> >       RESTORE_ALL 8
> > -     iretq
> > +     INTERRUPT_RETURN
>
> I suspect Xen will need much more changes anyways because of its
> ring 3 guest. Are these changes sufficient for lguest?

Yes, they are sufficient for lguest.
Does any xen folks have any comment?

-- 
Glauber de Oliveira Costa.
"Free as in Freedom"
http://glommer.net

"The less confident you are, the more serious you have to act."
