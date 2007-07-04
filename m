Return-Path: <linux-kernel-owner+w=401wt.eu-S1759205AbXGDT0R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759205AbXGDT0R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 15:26:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756525AbXGDT0I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 15:26:08 -0400
Received: from mail-gw2.sa.eol.hu ([212.108.200.109]:42975 "EHLO
	mail-gw2.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756453AbXGDT0H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 15:26:07 -0400
To: stern@rowland.harvard.edu
CC: oliver@neukum.org, paulus@samba.org, rjw@sisk.pl, mjg59@srcf.ucam.org,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
In-reply-to: <Pine.LNX.4.44L0.0707041139100.25704-100000@netrider.rowland.org>
	(message from Alan Stern on Wed, 4 Jul 2007 11:42:03 -0400 (EDT))
Subject: Re: [linux-pm] [PATCH] Remove process freezer from suspend to RAM
 pathway
References: <Pine.LNX.4.44L0.0707041139100.25704-100000@netrider.rowland.org>
Message-Id: <E1I6ATN-0007QS-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 04 Jul 2007 21:25:09 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Remember what I wrote a few minutes ago about khubd and ksuspend_usbd
> wanting to resume devices during a system suspend transition?  This is
> exactly what happens when those threads aren't frozen.

OK, let me summarize the situation as I see it now: there are two
camps, the pro-freezers and the anti-freezers.

Pro-freezers say:

  - don't remove the freezer, otherwise we'll have to deal with
    numerous problems in drivers

Anti-freezers say:

  - let's remove the freezer, which causes numerous problems

Alan summerized the pro-freezer arguments well I think.  What are the
anti-freezer arguments then?

After having looked at the freezer and done some experiments with it,
the most obvious problem looks to be, that it can get stuck on a
process doing uninterruptible sleep.  And yes, this can happen if a
fuse filesystem daemon is frozen before a filesystem user is.  And
this is not something that can be fixed in fuse, some filesystem calls
(rename(2) for example) are simply not restartable.

This doesn't explain the deadlocks, but it could cause failure to
suspend which would be pretty annoying.

Does this affect other things than fuse?

Can this be fixed?

It seems to be a fundamental problem with the freezer: while it does
make sure that user processes are not calling into drivers during
suspend, it also disallows perfectly harmless non-driver calls as
well.

Miklos
