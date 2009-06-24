Return-Path: <linux-kernel-owner+w=401wt.eu-S1752154AbZFXK6z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752154AbZFXK6z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 06:58:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751185AbZFXK6r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 06:58:47 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:51817 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750800AbZFXK6q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 06:58:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=tWG/+1HmgFXotTn+ooaEsv0fVSusDA5s47eEGFVP7CQU9nA1s4QPbvJNrNSe2pQ+Qx
         eLJaOUbEwWrr+H5PehzQhnNYDfMcnR7M+RywEDsTToMsqpVFb/yk4gjAIgNBzbGqXNCV
         j8S8HhGne+3nuzhI4jTsssZY2F/OSMuDZrivY=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: David Miller <davem@davemloft.net>
Subject: Re: [patch 4/6] ide: allow ide_dev_read_id() to be called from the IRQ context
Date: Wed, 24 Jun 2009 13:04:14 +0200
User-Agent: KMail/1.11.3 (Linux/2.6.30-next-20090623-11043-g1684859-dirty; KDE/4.2.3; i686; ; )
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <200906240336.25263.bzolnier@gmail.com> <20090624.025518.75726622.davem@davemloft.net> <200906241248.21173.bzolnier@gmail.com>
In-Reply-To: <200906241248.21173.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906241304.14926.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 24 June 2009 12:48:20 Bartlomiej Zolnierkiewicz wrote:

> > 1) You want the device to be quiescent anyways when you do this
> >    SET_XFER command.  What better way than to plug the queue
> >    and make sure all currently outstanding requests complete?
> > 
> >    And as already discussed, we even already have logic to support
> >    this kind of thing for the sake of power-management.
> 
> Power management requests are kind of special and need block layer support.
> 
> Please take a look at REQ_DEVSET_EXEC special requests from ide-devsets.c
> instead if you would like to investigate possibility of a cleaner (although
> more invasive) solution.
> 
> > 2) All commands going into the device do so from a context from
> >    which we could take a sleeping lock such as a mutex.  It's
> >    therefore the most natural way to synchonize things.
> 
> The fact is that we need to synchronize against all commands going into
> the device and they are synchronized using block queue (which is protected
> with spinlock by block layer). Adding an extra mutex (even if possible)

We need to also take the synchronization between block queues of all devices
on the port and the serialized ports into account..  This is quite complex
and fragile code (vide cmd64x screaming IRQ issue ;)..

I would personally try going with 1) and avoid 2) at all costs..
