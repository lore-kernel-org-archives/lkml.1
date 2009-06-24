Return-Path: <linux-kernel-owner+w=401wt.eu-S1754365AbZFXJz0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754365AbZFXJz0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 05:55:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752581AbZFXJzP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 05:55:15 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50803
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751666AbZFXJzO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 05:55:14 -0400
Date: Wed, 24 Jun 2009 02:55:18 -0700 (PDT)
Message-Id: <20090624.025518.75726622.davem@davemloft.net>
To: bzolnier@gmail.com
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 4/6] ide: allow ide_dev_read_id() to be called from the
 IRQ context
From: David Miller <davem@davemloft.net>
In-Reply-To: <200906241151.16506.bzolnier@gmail.com>
References: <200906240336.25263.bzolnier@gmail.com>
	<20090623.213535.52208572.davem@davemloft.net>
	<200906241151.16506.bzolnier@gmail.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Date: Wed, 24 Jun 2009 11:51:16 +0200

> You've put less than 2h (because that was the time since my post till your
> reply) into analysis of the bug, the related problems and the solution.
> 
> It could be that if you had put a bit more time into it and/or asked detailed
> technical questions related to the solution (i.e. "Why x needs to be there
> and we can't do y?") instead of keeping the technical discussion on the very
> vague level (which sounded like "can't we use block layer to process block
> requests because drive commands are block requests and raw commands are drive
> commands so we should use block layer") you would come to very different
> conclusions than you did initially.

I'm investigating alternative ways to this problem, less because
of the time I put into the investigation, but moreso because I'm
able to put fresh eyes onto the problem.

And also I don't know the IDE code as well as you do, which is
an advantage insofar as not falling into "oh I know how this
stuff works, therefore we can't..." kinds of mental traps.

Back to the technical side, ignoring the interrupt-or-not uglies,
there are two other reasons why using synchronization is better
here:

1) You want the device to be quiescent anyways when you do this
   SET_XFER command.  What better way than to plug the queue
   and make sure all currently outstanding requests complete?

   And as already discussed, we even already have logic to support
   this kind of thing for the sake of power-management.

2) All commands going into the device do so from a context from
   which we could take a sleeping lock such as a mutex.  It's
   therefore the most natural way to synchonize things.

I know you're busy, so I'll try to draft something up myself.

Thanks.
