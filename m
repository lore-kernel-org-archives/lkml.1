Return-Path: <linux-kernel-owner+w=401wt.eu-S1753227AbYKQPNe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753227AbYKQPNe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 10:13:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751657AbYKQPNW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 10:13:22 -0500
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:43078 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752861AbYKQPNS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 10:13:18 -0500
Message-Id: <1226934797.27015.1285211523@webmail.messagingengine.com>
X-Sasl-Enc: 25EV+TyIRCegje3PkWaLY2HwflmDa6kdz62RAAAxk2Xw 1226934797
From: "Alexander van Heukelum" <heukelum@fastmail.fm>
To: "Glauber Costa" <glommer@redhat.com>
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
 <20081117121444.GA13427@poweredge.glommer>
Subject: Re: [RFC] x86: save_args out of line
In-Reply-To: <20081117121444.GA13427@poweredge.glommer>
Date: Mon, 17 Nov 2008 16:13:17 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Nov 2008 10:14:44 -0200, "Glauber Costa" <glommer@redhat.com>
said:
> On Sun, Nov 16, 2008 at 03:29:01PM +0100, Alexander van Heukelum wrote:
> > From: Alexander van Heukelum <heukelum@sleipnir.lusi.uni-sb.de>
> > 
> > The macro "interrupt" in entry_64.S generates a lot of code. This
> > patch moves most of its contents into an external function. It
> > saves anywhere between 500 and 2500 bytes of text depending on the
> > configuration.
> > 
> > The function returns with an altered stackpointer.
> > 
> > Dwarf2-annotations are most probably wrong or missing.
> > 
> > There is a comment in the original code about saving rbp twice, but
> > I don't understand what the code tries to do. First of all, the
> > second copy of rbp is written below the stack.
> This is not for the stack, but to keep the registers as the pt_regs
> struct
> expects them. We'll be casting this structure later, and not doing that
> can lead to bogus code, whenever we cast regs->bp.
> 
> > Second, if the current
> > stack is already the irqstack, this second copy is overwritten. Third,
> > as far as I can tell, ebp should not be saved in pt_regs at all at
> > this stage as it is 'preserved' due to the C calling conventions. So
> > I left this second copy out and everything seems to work fine. If it
> > wouldn't, all exceptions and NMIs would be dangerous anyhow, as far
> > as I can see.
> Try testing with a kernel with CONFIG_FRAME_POINTER turned on.

Hi Glauber,

Thanks for your reply, but I'm afraid I still don't see why this
second copy is needed.

A CONFIG_FRAME_POINTER configuration seems to be working fine. Of
course regs->bp will give a bogus value, but so will r12, r13,
r14, r15, and rbx. However, if you have CONFIG_FRAME_POINTER=y,
then rbp can be trusted to be used as a framepointer... so one
should get it directly from the registers, not from regs->bp.

Could you give me a configuration that fails, and describe what
goes wrong? Probably the right fix is not to use regs->bp.

Greetings,
    Alexander

> >
> > Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>
> > Cc: Glauber Costa <gcosta@redhat.com>
-- 
  Alexander van Heukelum
  heukelum@fastmail.fm

-- 
http://www.fastmail.fm - mmm... Fastmail...

