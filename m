Return-Path: <linux-kernel-owner+w=401wt.eu-S1758824AbXKPH05@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758824AbXKPH05 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 02:26:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751675AbXKPH0u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 02:26:50 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45817 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751645AbXKPH0t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 02:26:49 -0500
Date: Thu, 15 Nov 2007 23:26:35 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Arjan van de Ven <arjan@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: x86: disable preemption in delay_tsc()
Message-Id: <20071115232635.d190acd7.akpm@linux-foundation.org>
In-Reply-To: <20071116071708.GA2103@elte.hu>
References: <200711150400.lAF40lIr020160@hera.kernel.org>
	<20071115194116.12c7a0f6@laptopd505.fenrus.org>
	<20071115195234.2dc8406d.akpm@linux-foundation.org>
	<20071116061332.GF16273@elte.hu>
	<20071115230859.d9ccea20.akpm@linux-foundation.org>
	<20071116071708.GA2103@elte.hu>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Nov 2007 08:17:08 +0100 Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > It sounds like it would work OK.  What is the setup cost for a usleep?  
> > I'd have thought that code which does something like
> > 
> > 	while (i++ < 1000) {
> > 		foo();
> > 		udelay(1);
> > 	}
> > 
> > would take qiute a bit longer with such a change?
> 
> full roundtrip cost ought to be below 10 usecs, depending on the system. 

Ow.  So the above timeout would take 10x longer.  That probably won't break
anything, but quite a few drivers do udelay(1) for post-IO settling times
and they might not like it.

> There's no problem doing a non-preemptible udelay up to 10 usecs and we
> could use usleep above that.

Yup, with a few smarts in there we could work out which is the best to use,
and also compensate for the setup costs.

It doesn't sound very 2.6.24ish though.

As a quicky things perhaps we could only do the preempt_disable()/preempt_enable()
if the TSCs are unsynced?  Do we reliably know that?  I guess not..
