Return-Path: <linux-kernel-owner+w=401wt.eu-S1754446AbXEHRTI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754446AbXEHRTI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 13:19:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966051AbXEHRTH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 13:19:07 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:57186 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754257AbXEHRTF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 13:19:05 -0400
Date: Tue, 8 May 2007 22:48:41 +0530
From: Vivek Goyal <vgoyal@in.ibm.com>
To: Bernhard Walle <bwalle@suse.de>
Cc: Morton Andrew Morton <akpm@linux-foundation.org>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.21-rc7-mm2 "irqpoll" seems to be broken
Message-ID: <20070508171841.GA29733@in.ibm.com>
Reply-To: vgoyal@in.ibm.com
References: <20070426093620.GB2626@in.ibm.com> <20070426082405.67a0fdd2.akpm@linux-foundation.org> <20070430084833.GA16173@in.ibm.com> <20070502221932.GA488@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070502221932.GA488@suse.de>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 03, 2007 at 12:19:32AM +0200, Bernhard Walle wrote:
> * Vivek Goyal <vgoyal@in.ibm.com> [2007-04-30 10:48]:
> > 
> > handle_edge_irq() already makes sure that desc->action is not null, still
> > note_interrupt() is receiving desc->action as null, that's strange. On my 
> > system this is happening for irq 4 and /proc/interrupt shows that it is
> > coming from "serial".
> 
> Unfortunately, I couldn't reproduce this here. Vivek, do you have time
> to take a look at this at your site? For the meanwhile, should I
> create a patch that checks for desc->action in note_interrupt(), too?
> 

Hi Bernhard,

I can reproduce this problem only on one machine. I think there is some
race condition and your code somehow just exposes it.

I put few WARN_ON(!desc->action) in handle_edge_irq() and what I find
that after handle_IRQ_event(), desc->action has become null. That means
in the meantime somebody has gone ahead and modified the desc. This must
have happened because we have release desc->lock while running
handle_IRQ_event().

This means there is a race somewhere. It is verified by the fact that
this problem does not occur if same system is booted with only one
cpu (maxcpus=1).

Thanks
Vivek
