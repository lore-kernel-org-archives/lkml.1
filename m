Return-Path: <linux-kernel-owner+w=401wt.eu-S1764059AbXJZRH2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764059AbXJZRH2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 13:07:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754671AbXJZRHT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 13:07:19 -0400
Received: from nf-out-0910.google.com ([64.233.182.188]:28107 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757718AbXJZRHQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 13:07:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=JE6c4YXeGYk3XRNMW4i+kzKR7V5HKp66iNEa2B8uMuE6c8SLaXr8Wm6oRk9o1SZ/wrIyiWL8IFoZ1TB2DHE1IL4vPix4URDlqiK0BXBGdxOcoeZXaOhsYm23YXQPJ3jHbRvjYyLckFiUXdyutTqLoVW3OAVzsMDG1LIu7L/Kt6I=
Message-ID: <e2e108260710261007n118186b5geb3a48094638497f@mail.gmail.com>
Date: Fri, 26 Oct 2007 19:07:14 +0200
From: "Bart Van Assche" <bart.vanassche@gmail.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: Is gcc thread-unsafe?
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Andrew Haley" <aph@redhat.com>
In-Reply-To: <alpine.LFD.0.999.0710260917500.30120@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <e2e108260710260729x4603211cgb68d7434ce1e54e9@mail.gmail.com>
	 <e2e108260710260740k27210c4fu2f75d5fb31ccdccc@mail.gmail.com>
	 <alpine.LFD.0.999.0710260814570.30120@woody.linux-foundation.org>
	 <alpine.LFD.0.999.0710260917500.30120@woody.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/26/07, Linus Torvalds <torvalds@linux-foundation.org> wrote:
>
> On Fri, 26 Oct 2007, Linus Torvalds wrote:
> >
> > On Fri, 26 Oct 2007, Bart Van Assche wrote:
> > >
> > > You can find my proposal to improve gcc here:
> > > http://gcc.gnu.org/ml/gcc/2007-10/msg00465.html
> >
> > Btw, I think this is fine per se, but putting "__attribute__((acquire))"
> > on the functions that acquire a lock does seem to be problematic, in that
> > quite often you might well want to inline those things. How would you
> > handle that?
>
> Thinking some more about this, you really have two cases:
>  - full functions taking/releasing locks (possibly conditionally, ie
>   with something like trylock and/or based on argument values).
>
>   You simply *cannot* require these to be marked, because the locking may
>   have been done indirectly. Yes, you can mark things like
>   "pthread_mutex_trylock()" as being an acquire-function, but the fact
>   is, users will then wrap these things in *other* functions, and return
>   their return values.
>
>   Ergo: a compiler *must* assume that a function call that it
>   didn't inline involves locking. There's no point in adding some
>   gcc-specific attributes to system header files, because it's not going
>   to fix anything in any portable program.

You have a point here.

>  - inline assembly (together with, potentially, compiler primitives).
>    That's the only other way to reliably do locking from C.
>
>    This one gcc could certainly extend on. But would there really be any
>    upside? It would be easier/better to say that inline assembly (at least
>    if it clobbers memory or is volatile) has the same serialization issues
>    as a function call.

A problem is that the serialization properties defined for functions
in the C standard only apply to volatile variables, not to
non-volatile variables. But for asm statements this can be solved by
adding memory to the list of clobbered registers -- this will prevent
any reordering of manipulations of non-volatile variables and asm
statements.

Andrew, do you know whether gcc currently contains any optimization
that interchanges the order of accesses to non-volatile variables and
function calls ?

> So the fact is, any compiler that turns
>
>         if (conditional)
>                 x++;
>
> into an unconditional write to x (where 'x' is potentially visible to the
> outside - global visibility or has had its address taken) is just broken.
>
> No ifs, buts or maybes about it. You simply cannot do that optimization,
> because there is no way for the compiler to know whether the conditional
> implies that you hold a lock or not.

I agree with the above, but I see this as a different issue -- it
wasn't my intention to solve this with my proposal for acquire and
release attributes.

Bart Van Assche.
