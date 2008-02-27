Return-Path: <linux-kernel-owner+w=401wt.eu-S1758146AbYB0Uh1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758146AbYB0Uh1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 15:37:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757573AbYB0UhO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 15:37:14 -0500
Received: from gate.crashing.org ([63.228.1.57]:53696 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757494AbYB0UhN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 15:37:13 -0500
Subject: Re: Fundamental flaw in system suspend, exposed by freezer removal
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44L0.0802251010330.2133-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.0802251010330.2133-100000@iolanthe.rowland.org>
Content-Type: text/plain
Date: Thu, 28 Feb 2008 07:36:10 +1100
Message-Id: <1204144570.15052.256.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2008-02-25 at 10:39 -0500, Alan Stern wrote:
> Ongoing efforts to remove the freezer from the system suspend and
> hibernation code ("system sleep" is the proper catch-all term) have
> turned up a fundamental flaw in the Power Management subsystem's
> design.  In brief, we cannot handle the race between hotplug addition
> of new devices and suspending all existing devices.

 .../...

Yup, old problem, I think I've said a long time ago that it's the
reponsibility of bus drivers (such as USB khub) to stop issuing device
additions when suspend is in progress. It might be possible to still do
removal tho.

> The only possible solution is to have the drivers themselves be
> responsible for preventing calls to device_add() or device_register()  
> during a system sleep.  (It's also necessary to prevent driver binding,
> but this isn't a major issue.) 

Agreed.

>  The most straightforward approach is to
> add a new pair of driver methods: one to disable adding children and
> one to re-enable it.  Of course this would represent a significant
> addition to the Power Management driver interface.

No, I think the global notifier is plenty for now. Later on, we can
re-add early-suspend, late-resume, or we can finally turn the whole
thing into a recursive call tree where the parents are the ones calling
the children suspend :-) But for now, I think the global notifier is
enough.

Cheers,
Ben.


