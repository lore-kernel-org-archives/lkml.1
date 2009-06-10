Return-Path: <linux-kernel-owner+w=401wt.eu-S1760366AbZFJT2R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760366AbZFJT2R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 15:28:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755123AbZFJT2C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 15:28:02 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:49573 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752375AbZFJT2A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 15:28:00 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Oliver Neukum <oliver@neukum.org>
Subject: Re: [patch update] Re: [linux-pm] Run-time PM idea (was: Re: [RFC][PATCH 0/2] PM: Rearrange core suspend code)
Date: Wed, 10 Jun 2009 21:27:56 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc8-rjw; KDE/4.2.4; x86_64; ; )
Cc: Alan Stern <stern@rowland.harvard.edu>,
       linux-pm@lists.linux-foundation.org,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.44L0.0906082233490.19072-100000@netrider.rowland.org> <200906101029.27529.rjw@sisk.pl> <200906101620.26559.oliver@neukum.org>
In-Reply-To: <200906101620.26559.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906102127.57136.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 10 June 2009, Oliver Neukum wrote:
> Am Mittwoch, 10. Juni 2009 10:29:26 schrieb Rafael J. Wysocki:
> > Argh, I forgot about some important things.
> >
> > First, there are devices with no parent (actually, it would be much easier
> > if they had a default dummy parent, but that's a separate issue).
> >
> > Second, the parent has to be taken into account in the asynchronous resume
> > path too (which BTW is more complicated).
> 
> What happens if the parent's parent is also suspended? It seems to me that
> you must code this recursively.

Hmm, I thought I did.

[Looks]

pm_request_resume(dev) will call pm_request_resume(dev->parent), if necessary,
and that will call pm_request_resume(dev->parent->parent) and so on.  Each of
them will queue a work item and the one for the topmost parent will be queued
first.  So, the resume requests for all parents will be executed before the
one for the device, due to the fact that the workqueue is singlethread.

Well, there is a bug related to it, namely pm_autosuspend() may change the
status to RPM_SUSPENDED after pm_request_resume() has changed it to
RPM_WAKE, that needs fixing.

Best,
Rafael
