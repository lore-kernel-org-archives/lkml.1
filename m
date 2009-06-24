Return-Path: <linux-kernel-owner+w=401wt.eu-S1756423AbZFXKnc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756423AbZFXKnc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 06:43:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752607AbZFXKnY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 06:43:24 -0400
Received: from mail-fx0-f213.google.com ([209.85.220.213]:60221 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752104AbZFXKnX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 06:43:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=rfyxUq3v+rpqK4EKwZGkijb32gOxWoS4v6j+dA0qMYWcabx+xhHwvORlr7+wf7x3HM
         s1KjYIcG1lMlNPTRQsn0REZx0XFvLsUdMv90ex/eLWKLzmVX/Ei97zhkCRtmPb9m7yDK
         7wgtHHwEv6MEqSyhVR19eVxd4GsCgGQYCw99Y=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: David Miller <davem@davemloft.net>
Subject: Re: [patch 4/6] ide: allow ide_dev_read_id() to be called from the IRQ context
Date: Wed, 24 Jun 2009 12:48:20 +0200
User-Agent: KMail/1.11.3 (Linux/2.6.30-next-20090623-11043-g1684859-dirty; KDE/4.2.3; i686; ; )
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <200906240336.25263.bzolnier@gmail.com> <200906241151.16506.bzolnier@gmail.com> <20090624.025518.75726622.davem@davemloft.net>
In-Reply-To: <20090624.025518.75726622.davem@davemloft.net>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200906241248.21173.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 24 June 2009 11:55:18 David Miller wrote:
> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Date: Wed, 24 Jun 2009 11:51:16 +0200
> 
> > You've put less than 2h (because that was the time since my post till your
> > reply) into analysis of the bug, the related problems and the solution.
> > 
> > It could be that if you had put a bit more time into it and/or asked detailed
> > technical questions related to the solution (i.e. "Why x needs to be there
> > and we can't do y?") instead of keeping the technical discussion on the very
> > vague level (which sounded like "can't we use block layer to process block
> > requests because drive commands are block requests and raw commands are drive
> > commands so we should use block layer") you would come to very different
> > conclusions than you did initially.
> 
> I'm investigating alternative ways to this problem, less because
> of the time I put into the investigation, but moreso because I'm
> able to put fresh eyes onto the problem.

Fresh look is always good, the problem is that you seem to be walking
on the thin line between fresh look and ignorance a bit too often at
the moment.  Yeah.. I know that this is temporary and that I'm acting
like an old IDE geezer.. ;)

> And also I don't know the IDE code as well as you do, which is
> an advantage insofar as not falling into "oh I know how this
> stuff works, therefore we can't..." kinds of mental traps.

We are heavily constrained by the difficult hardware, by the way other
kernel subsystems work, by some legacy user-space interfaces, by some
complex/fragile code parts and now also by the policy.

> Back to the technical side, ignoring the interrupt-or-not uglies,
> there are two other reasons why using synchronization is better
> here:
> 
> 1) You want the device to be quiescent anyways when you do this
>    SET_XFER command.  What better way than to plug the queue
>    and make sure all currently outstanding requests complete?
> 
>    And as already discussed, we even already have logic to support
>    this kind of thing for the sake of power-management.

Power management requests are kind of special and need block layer support.

Please take a look at REQ_DEVSET_EXEC special requests from ide-devsets.c
instead if you would like to investigate possibility of a cleaner (although
more invasive) solution.

> 2) All commands going into the device do so from a context from
>    which we could take a sleeping lock such as a mutex.  It's
>    therefore the most natural way to synchonize things.

The fact is that we need to synchronize against all commands going into
the device and they are synchronized using block queue (which is protected
with spinlock by block layer). Adding an extra mutex (even if possible)
into IDE request processing hot-path solely to fix this particular bug
would be an overkill from performance and the future maintainability POVs.

> I know you're busy, so I'll try to draft something up myself.

Ok, thanks.
