Return-Path: <linux-kernel-owner+w=401wt.eu-S1754448AbXKZHyk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754448AbXKZHyk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 02:54:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753214AbXKZHya
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 02:54:30 -0500
Received: from mail.suse.de ([195.135.220.2]:52333 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753193AbXKZHy3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 02:54:29 -0500
Date: Mon, 26 Nov 2007 08:54:26 +0100
From: Hannes Reinecke <hare@suse.de>
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Laurent Riffard <laurent.riffard@free.fr>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: 2.6.24-rc3-mm1: I/O error, system hangs
Message-ID: <20071126075426.GC11261@ochil.suse.de>
References: <20071120204525.ff27ac98.akpm@linux-foundation.org> <4744A6F2.4030302@free.fr> <20071121144116.c932727b.akpm@linux-foundation.org> <4746814F.80502@free.fr> <4746866B.5070207@suse.de> <4746BB9D.2030508@suse.de> <1195926253.3195.16.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1195926253.3195.16.camel@localhost.localdomain>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 24, 2007 at 07:44:13PM +0200, James Bottomley wrote:
> Probing intermittent failures in Domain Validation, even with the fixes
> applied leads me to the conclusion that there are further problems with
> this commit:
> 
> commit fc5eb4facedbd6d7117905e775cee1975f894e79
> Author: Hannes Reinecke <hare@suse.de>
> Date:   Tue Nov 6 09:23:40 2007 +0100
> 
>     [SCSI] Do not requeue requests if REQ_FAILFAST is set
>  
> The essence of the problems is that you're causing REQ_FAILFAST to
> terminate commands with error on requeuing conditions, some of which are
> relatively common on most SCSI devices.  While this may be the correct
> behaviour for multi-path, it's certainly wrong for the previously
> understood meaning of REQ_FAILFAST, which was don't retry on error,
> which is why domain validation and other applications use it to control
> error handling, but don't expect to get failures for a simple requeue
> are now spitting errors.
> 
> I honestly can't see that, even for the multi-path case, returning an
> error when we're over queue depth is the correct thing to do (it may not
> matter to something like a symmetrix, but an array that has a non-zero
> cost associated with a path change, like a CPQ HSV or the AVT
> controllers, will show fairly large slow downs if you do this).  Even if
> this is the desired behaviour (and I think that's a policy issue),
> DID_NO_CONNECT is almost certainly the wrong error to be sending back.
> 
> This patch fixes up domain validation to work again correctly, however,
> I really think it's just a bandaid.  Do you want to rethink the above
> commit?
> 
Given the amounted error, yes, I'll have to.
But we still face the initial problem that requeued requests will be
stuck in the queue forever (ie until the timeout catches it), causing
failover to be painfully slow.

Anyway, I'll think it over.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N�rnberg
GF: Markus Rex, HRB 16746 (AG N�rnberg)
