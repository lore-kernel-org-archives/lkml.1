Return-Path: <linux-kernel-owner+w=401wt.eu-S1758570AbXJCOew@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758570AbXJCOew (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 10:34:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753559AbXJCOem
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 10:34:42 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:36934 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754300AbXJCOel (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 10:34:41 -0400
Subject: Re: [TOMOYO 05/15](repost) Domain transition handler functions.
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: jmorris@namei.org, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, chrisw@sous-sol.org
In-Reply-To: <200710032319.ABF69743.VJQMLHFOFOtFOS@I-love.SAKURA.ne.jp>
References: <200710032024.DJF78662.FHOLtMSFOOFJVQ@I-love.SAKURA.ne.jp>
	 <20071003.204356.05853536.yoshfuji@linux-ipv6.org>
	 <Xine.LNX.4.64.0710030529580.6431@us.intercode.com.au>
	 <200710032204.DFF51552.OFOSOFMVQtHLJF@I-love.SAKURA.ne.jp>
	 <1191417864.5599.2.camel@lappy>
	 <200710032319.ABF69743.VJQMLHFOFOtFOS@I-love.SAKURA.ne.jp>
Content-Type: text/plain
Date: Wed, 03 Oct 2007 16:28:56 +0200
Message-Id: <1191421736.5599.18.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2007-10-03 at 23:19 +0900, Tetsuo Handa wrote:
> Hello.
> 
> Thank you for pointing out.
> 
> Peter Zijlstra wrote:
> > > Currently, TOMOYO Linux avoids read_lock, on the assumption that
> > > (1) First, ptr->next is initialized with NULL.
> > > (2) Later, ptr->next is assigned non-NULL address.
> > > (3) Assigning to ptr->next is done atomically.
> >  (4) wmb after asigning ptr->next
> >  (5) rmb before reading ptr->next
> Excuse me, but I didn't understand why (4) and (5) are needed.
> 
> append_function() {
> 
>   down(semaphore_for_write_protect);
>   ...
>   ptr = head;
>   while (ptr->next) ptr = ptr->next;
>   ptr->next = new_entry;
>   ...
>   up(semaphore_for_write_protect);
> 
> }

If at all possible, use struct mutex.

> read_function() {
> 
>   for (ptr = head; ptr; ptr = ptr->next) {
>     ...
>   }
> 
> }
> 
> Are (4) and (5) needed even when (3) is exclusively protected by down() and up() ?

the up() would do 4. 5 ensures another cpu will actually see it. Althoug
in practise the various cache invalidations driven by the workload will
ensure it will become visible eventually anyway.

