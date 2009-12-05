Return-Path: <linux-kernel-owner+w=401wt.eu-S1756989AbZLEVnv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756989AbZLEVnv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Dec 2009 16:43:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756859AbZLEVnn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Dec 2009 16:43:43 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49391 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756741AbZLEVnn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Dec 2009 16:43:43 -0500
Date: Sat, 5 Dec 2009 13:43:43 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: [GIT PULL] PM updates for 2.6.33
In-Reply-To: <200912052216.19540.rjw@sisk.pl>
Message-ID: <alpine.LFD.2.00.0912051334461.3649@localhost.localdomain>
References: <200912052216.19540.rjw@sisk.pl>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 5 Dec 2009, Rafael J. Wysocki wrote:
> 
> * Asynchronous suspend and resume infrastructure.  For now, PCI, ACPI and
>   serio devices are enabled to suspend and resume asynchronously.

I really think this is totally and utterly broken. Both from an 
implementation standpoint _and_ from a pure conceptual one.

Why isn't the suspend/resume async stuff just done like the init async 
stuff?

We don't need that crazy per-device flag for initialization, neither do we 
need drivers "enabling" any async code at all. They just do some things 
asynchronously, and then at the end of init time we wait for all those 
async events.

So why does suspend/resume need to do crazy sh*t instead?

It all looks terminally broken: you force async suspend for all PCI 
drivers, even when it makes no sense. Rather than let the drivers that 
already know how to do things like disk spinup asynchronously just do it 
that way.

The "timing" routines are also just crazy. What is the excuse for 
dpm_show_time() taking both start and stop times, since there is never any 
valid situation when it shouldn't have that do_gettimgofday(&stop) just 
before it? IOW - the whole end-time thing should be _inside_ 
dpm_show_time, rather than being done by the caller. No?

In other words - I'm not pulling this crazy thing. You'd better explain 
why it was done that way, when we already have done the same things better 
before in different ways.

				Linus
