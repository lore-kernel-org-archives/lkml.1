Return-Path: <linux-kernel-owner+w=401wt.eu-S1761184AbZFJVh7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761184AbZFJVh7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 17:37:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758058AbZFJVht
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 17:37:49 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:50812 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757559AbZFJVhs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 17:37:48 -0400
From: Oliver Neukum <oliver@neukum.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [patch update] Re: [linux-pm] Run-time PM idea (was: Re: [RFC][PATCH 0/2] PM: Rearrange core suspend code)
Date: Wed, 10 Jun 2009 23:38:34 +0200
User-Agent: KMail/1.10.3 (Linux/2.6.27.21-0.1-default; KDE/4.1.3; x86_64; ; )
Cc: Alan Stern <stern@rowland.harvard.edu>,
       linux-pm@lists.linux-foundation.org,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.44L0.0906082233490.19072-100000@netrider.rowland.org> <200906101620.26559.oliver@neukum.org> <200906102127.57136.rjw@sisk.pl>
In-Reply-To: <200906102127.57136.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200906102338.35183.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 10. Juni 2009 21:27:56 schrieb Rafael J. Wysocki:
> > What happens if the parent's parent is also suspended? It seems to me
> > that you must code this recursively.
>
> Hmm, I thought I did.
>
> [Looks]
>
> pm_request_resume(dev) will call pm_request_resume(dev->parent), if
> necessary, and that will call pm_request_resume(dev->parent->parent) and so
> on.  Each of them will queue a work item and the one for the topmost parent
> will be queued first.  So, the resume requests for all parents will be
> executed before the one for the device, due to the fact that the workqueue
> is singlethread.

Sneaky, I overlooked that.

> Well, there is a bug related to it, namely pm_autosuspend() may change the
> status to RPM_SUSPENDED after pm_request_resume() has changed it to
> RPM_WAKE, that needs fixing.

Ok, maybe this is related. You recurse if the parent isn't in RPM_ACTIVE.
But that is not enough. You must ensure that all the nodes higher up stay
in RPM_ACTIVE. It seems to me that you must go up until you find an
active node (or the root) and put it a blocked state.

	Regards
		Oliver

