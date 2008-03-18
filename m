Return-Path: <linux-kernel-owner+w=401wt.eu-S1753900AbYCRE0W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753900AbYCRE0W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2008 00:26:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752620AbYCRE0O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Mar 2008 00:26:14 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:37268 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752612AbYCRE0N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2008 00:26:13 -0400
Date: Tue, 18 Mar 2008 09:56:49 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Yakov Lerner <iler.ml@gmail.com>, prasanna@in.ibm.com,
       anil.s.keshavamurthy@intel.com, davem@davemloft.net,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Subject: kprobes-x86: correct post-eip value in
	post_hander()
Message-ID: <20080318042649.GA6741@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <E1Jao7N-0005OC-Fe@io.site5.com> <20080317051956.GB7229@in.ibm.com> <f36b08ee0803170359w675130bas296b5276da5f2a3d@mail.gmail.com> <20080317123951.GC7229@in.ibm.com> <47DEEDF1.6050403@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47DEEDF1.6050403@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 17, 2008 at 06:17:21PM -0400, Masami Hiramatsu wrote:
> Ananth N Mavinakayanahalli wrote:
> > On Mon, Mar 17, 2008 at 12:59:05PM +0200, Yakov Lerner wrote:
> >> On Mon, Mar 17, 2008 at 7:19 AM, Ananth N Mavinakayanahalli
> >> <ananth@in.ibm.com> wrote:
> >>> On Sun, Mar 16, 2008 at 03:21:21AM -0500, Yakov Lerner wrote:
> >>>  >
> >>>  > I was trying to get the address of instruction to be executed
> >>>  > next after the kprobed instruction.  But regs->eip in post_handler()
> >>>  > contains value which is useless to the user. It's pre-corrected value.
> >>>  > This value is difficult to use without access to resume_execution(), which
> >>>  > is not exported anyway.
> >>>  > I moved the invocation of post_handler() to *after* resume_execution().
> >>>  > Now regs->eip contains meaningful value in post_handler().
> >>>  >
> >>>  > I do not think this change breaks any backward-compatibility.
> >>>  > To make meaning of the old value, post_handler() would need access to
> >>>  > resume_execution() which is not exported.  I have difficulty to believe
> >>>  > that previous, uncorrected, regs->eip can be meaningfully used in
> >>>  > post_handler().
> >>>
> >>>  resume_execution() exists not just for the program counter fixups after
> >>>  out-of-line singlestepping, but is also as an insurance to put the
> >>>  program counter back to the correct address in case the user's
> >>>  post_handler() mucks around with it. That isn't possible with this
> >>>  change :-(
> >> I see your point. This can be prevented by saving and restoring regs->ip
> >> around the post_handler() call, no ? Current code is beautiful. Saving and
> >> restoring regs->ip would make this place look ugly.
> >>
> >> Otoh, if the post_handler() wants to crash the kernel, it can do it
> >> in thousand ways, not just by trashing regs->ip, no ?
> > 
> > Of course, there still are other ways to shoot yourself in the foot with
> > the post_handler(), but, atleast for cases we can control, we need to do
> > the right thing.
> 
> Ananth, I think we can not prevent it even if resume_execution() is called
> after post_handler, because resume_execution() refers reg->ip...:-(

OK, I see what you are referring to... though we use kp.addr and
kp.ainsn.insn to start with, we'll need the knowledge of regs->ip at the
end.

> And Yakov, I think you might need to make a patchset against all arch which
> support kprobes, because this patch modifies expected behavior of kprobes
> only on x86.

Agreed.

> IMHO, Yakov's suggestion will be also good for resume_execution(), because
> it only has to clean up after expectable-single-stepping. (user code is
> unexpectable... we can not control all of that)

Ananth
