Return-Path: <linux-kernel-owner+w=401wt.eu-S1753386AbYKQPh7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753386AbYKQPh7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 10:37:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752221AbYKQPhj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 10:37:39 -0500
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:54231 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752150AbYKQPhi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 10:37:38 -0500
Message-Id: <1226936257.32609.1285214311@webmail.messagingengine.com>
X-Sasl-Enc: wNH4XdQZka1DWfo+P4vyp9hRoBqn2MwlZKjgb4z/ww9d 1226936257
From: "Alexander van Heukelum" <heukelum@fastmail.fm>
To: "Andi Kleen" <andi@firstfloor.org>
Cc: "Ingo Molnar" <mingo@elte.hu>, "LKML" <linux-kernel@vger.kernel.org>,
       "Andi Kleen" <andi@firstfloor.org>,
       "Alexander van Heukelum" <heukelum@lusi.uni-sb.de>,
       "Glauber Costa" <gcosta@redhat.com>
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
X-Mailer: MessagingEngine.com Webmail Interface
References: <1226845741-12470-1-git-send-email-heukelum@fastmail.fm>
 <1226845741-12470-2-git-send-email-heukelum@fastmail.fm>
 <20081117125317.GK6703@one.firstfloor.org>
Subject: Re: [RFC] x86: save_args out of line
In-Reply-To: <20081117125317.GK6703@one.firstfloor.org>
Date: Mon, 17 Nov 2008 16:37:37 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Nov 2008 13:53:17 +0100, "Andi Kleen" <andi@firstfloor.org>
said:
> On Sun, Nov 16, 2008 at 03:29:01PM +0100, Alexander van Heukelum wrote:
> > From: Alexander van Heukelum <heukelum@sleipnir.lusi.uni-sb.de>
> > 
> > The macro "interrupt" in entry_64.S generates a lot of code. This
> > patch moves most of its contents into an external function. It
> > saves anywhere between 500 and 2500 bytes of text depending on the
> > configuration.
> 
> The only duplication is in the apicinterrupt entry points which
> have expanded recently (when I wrote all that there weren't as many)
> 
> I think it would be cleaner to just have a common apic_interrupt
> entry point similar to how the exceptions work that try to factor
> out "interrupt" like this. As more and more of them get added
> (I have another new one in recent) patches that will likely
> save more space.
> 
> The only ugly part is that passing the handler to the common
> stub requires the manual pt_regs setup that the exception
> handler currently does. Because that could be factored
> out in a new macro. Or just copied (I have heard complaints
> in the past that the file has too many macros already)

Hi Andi,

I liked this way of calling an external function, because it
circumvents exactly most of this ugly setup. For two bytes
extra per stub, one can make this setup function a completely
normal one (without relocating the return address on the stack).
I intended the stubs to fit in one cache line (32 bytes) as it
does not make much sense to make them smaller than that. A
further advantage is that no indirect call is needed, but maybe
this is not as slow anymore as it used to be? B.t.w., I intended
to change the exception handler stubs in a similar way to get
rid of the indirect call.

> > There is a comment in the original code about saving rbp twice, but
> > I don't understand what the code tries to do. First of all, the
> 
> To be honest I didn't understand this one either when it was added. In 
> standard frame pointer format rbp has to be at the place pointed to by
> the real 
> rbp register with the return address directly on top of it. But pushing
> %rbp below the pt_regs doesn't put it into this format, because
> the return address is at the wrong place.

The second copy of %rbp is indeed placed at the 'correct' position
inside the pt_regs struct. However, at this point only a partial
stack frame is saved: the C argument registers and the scratch
registers. r12-r15,ebp,and rbx will be saved only later if necessary.
A problem could arise if some code uses pt_regs.bp of this partial
stack frame, because it will contain a bogus value. Glauber's patch
makes pt_regs.bp contain the right value most of the time... Which
means that if the patch fixed something for him, the problem has only
been made unlikely to happen. The place where things should be fixed
are the places where pt_regs.bp is used, but not filled in.

Greetings,
    Alexander

> -Andi
-- 
  Alexander van Heukelum
  heukelum@fastmail.fm

-- 
http://www.fastmail.fm - Access your email from home and the web

