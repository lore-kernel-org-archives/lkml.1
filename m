Return-Path: <linux-kernel-owner+w=401wt.eu-S1756266AbXJCNrB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756266AbXJCNrB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 09:47:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754184AbXJCNqx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 09:46:53 -0400
Received: from aun.it.uu.se ([130.238.12.36]:59839 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753232AbXJCNqw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 09:46:52 -0400
Date: Wed, 3 Oct 2007 15:46:32 +0200 (MEST)
Message-Id: <200710031346.l93DkWbE028800@harpo.it.uu.se>
From: Mikael Pettersson <mikpe@it.uu.se>
To: kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: [PATCH 1/3] signal(i386): alternative signal stack wraparound occurs
Cc: linux-kernel@vger.kernel.org, mikpe@it.uu.se, shiwh@cn.fujitsu.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Oct 2007 22:20:46 +0900, KAMEZAWA Hiroyuki wrote:
> On Wed, 3 Oct 2007 21:40:29 +0900
> KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> 
> > On Wed, 3 Oct 2007 14:20:07 +0200 (MEST)
> > Mikael Pettersson <mikpe@it.uu.se> wrote:
> > 
> > > What I don't agree with is the logic itself:
> > > - You only catch altstack overflow caused by the kernel pushing
> > >   a sigframe. You don't catch overflow caused by the user-space
> > >   signal handler pushing its own stack frame after the sigframe.
> > > - SUSv3 specifies the effect of altstack overflow as "undefined".
> > > - The overflow problem can be solved in user-space: allocate the
> > >   altstack with mmap(), then mprotect() the lowest page to prevent
> > >   accesses to it. Any overflow into it, by the kernel's signal
> > >   delivery code or by the user-space signal handler, will be caught.
> > > 
> > > So this patch gets a NAK from me.
> > > 
> > 
> > I can understand what you say, but a program which meets this problem
> > cannot be debugged ;(
> > 
> > gdb just shows infinit loop of function frames and origignal signal frame
> > which includes the most important information is overwritten.
> > 
> there is a difference among user's stack overflow and kernel's.
>  - user's stack overflow just breaks memory next to stack frame.
>  - kernel's altstack overflow, which this patch tries to fix, breaks
>    the bottom of altstack  bacause %esp goes back to the bottom
>    of ths altstack when it exceeds altstack range.
>    This behavior overwrite orignail stack frame and shows  infinit loop
>    of function call to gdb and never stop with 100% cpu usage.

The proposed kernel signal delivery patch only handles the case
where the /sigframe/ ends up overlapping the end of the altstack.
If the sigframe remains within the altstack boundaries but the
user-space signal handler adds an /ordinary stack frame/ that
moves SP beyond the altstack limit, then the kernel patch solves
nothing and recursive signals will cause altstack wraparound.

On the other hand, the user-space technique of making the lowest
page(s) in the altstack inaccessible handles both cases of overflow.

/Mikael
