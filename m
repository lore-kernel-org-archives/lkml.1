Return-Path: <linux-kernel-owner+w=401wt.eu-S1760980AbZFJXm5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760980AbZFJXm5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 19:42:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759536AbZFJXms
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 19:42:48 -0400
Received: from netrider.rowland.org ([192.131.102.5]:51386 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1759042AbZFJXms (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 19:42:48 -0400
Date: Wed, 10 Jun 2009 19:42:50 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Oliver Neukum <oliver@neukum.org>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch update] Re: [linux-pm] Run-time PM idea (was: Re:
 [RFC][PATCH 0/2] PM: Rearrange core suspend code)
In-Reply-To: <200906110107.23023.oliver@neukum.org>
Message-ID: <Pine.LNX.4.44L0.0906101942280.29717-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Jun 2009, Oliver Neukum wrote:

> Am Donnerstag, 11. Juni 2009 00:01:20 schrieb Rafael J. Wysocki:
> > We have queued up resume requests for the device's parent, its parent etc.,
> > the topmost one goes first.  The workqueue is singlethread, so
> > pm_autoresume() is going to be run for all parents before the device
> > itself, so if that were the only resume mechanism, it would be enough to
> > check if the parent is RPM_ACTIVE.
> 
>             A (IDLE)
>     /                                \
> B (SUSPENDED)         C (SUSPENDED)
> 
> Suppose C is to be resumed. This means first in case of A the request
> to suspend would be cancelled. Here you drop the locks:
> 
> +           && (dev->parent->power.runtime_status == RPM_IDLE
> +             || dev->parent->power.runtime_status == RPM_SUSPENDING
> +             || dev->parent->power.runtime_status == RPM_SUSPENDED)) {
> +               spin_unlock_irqrestore(&dev->power.lock, flags);
> +               spin_unlock_irqrestore(&dev->parent->power.lock, parent_flags);
> +
> +               /* We have to resume the parent first. */
> +               pm_request_resume(dev->parent);
> 
> But after pm_request_resume() returns there's no means to make sure
> nothing alters it back to RPM_SUSPENDED. The workqueue doesn't help
> you because you've scheduled nothing by that time. The suspension will
> work because C is still in RPM_SUSPENDED.

This is an example where usage counters come in handy.

Alan Stern

