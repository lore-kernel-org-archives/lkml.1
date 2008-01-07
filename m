Return-Path: <linux-kernel-owner+w=401wt.eu-S1758146AbYAGRX2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758146AbYAGRX2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 12:23:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754180AbYAGRXU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 12:23:20 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:56116 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752558AbYAGRXT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 12:23:19 -0500
Date: Mon, 7 Jan 2008 12:23:17 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Johannes Berg <johannes@sipsolutions.net>, Greg KH <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>, Len Brown <lenb@kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: [PATCH] PM: Acquire device locks on suspend
In-Reply-To: <200801071752.00138.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.0801071207090.2748-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Jan 2008, Rafael J. Wysocki wrote:

> Please see the patch at: http://lkml.org/lkml/2008/1/6/298 .  It represents my
> current idea about how to do that.

It has some problems.

First, note that the list manipulations in dpm_suspend(), 
device_power_down(), and so on aren't protected by dpm_list_mtx.  So 
your patch could corrupt the list pointers.  Are you assuming that no 
other threads can be running at this time?

Note also that device_pm_destroy_suspended() does up(&dev->sem), but it 
doesn't know whether or not dev->sem was locked to begin with.

Do you want to rule out the possibility of a driver's suspend or remove 
methods calling destroy_suspended_device() on its own device?  With 
your synchronous approach, this would mean that the suspend/resume 
method would indirectly end up calling the remove method.  This is 
dangerous at best; with USB it would be a lockdep violation.  With an 
asynchronous approach, on the other hand, this wouldn't be a problem.

Alan Stern

