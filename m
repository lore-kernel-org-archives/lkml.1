Return-Path: <linux-kernel-owner+w=401wt.eu-S1755343AbZLIPYI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755343AbZLIPYI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 10:24:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754911AbZLIPYH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 10:24:07 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:44351 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754869AbZLIPYG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 10:24:06 -0500
Date: Wed, 9 Dec 2009 10:24:04 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Zhang Rui <rui.zhang@intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: Async resume patch (was: Re: [GIT PULL] PM updates for 2.6.33)
In-Reply-To: <alpine.LFD.2.00.0912081852320.3560@localhost.localdomain>
Message-ID: <Pine.LNX.4.44L0.0912090959230.4120-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Dec 2009, Linus Torvalds wrote:

> On Tue, 8 Dec 2009, Alan Stern wrote:
> > 
> > You mean, if A comes before B in the list and A must suspend after B?  
> 
> But if they are not topologically ordered, then A wouldn't necessarily be 
> before B on the list in the first place.

Okay, I see what you're getting at.  Yes, this is quite true -- if A
doesn't precede B in dpm_list then A can't safely wait for B to
suspend.  To put it another way, only list-compatible constraints are
feasible.

This shouldn't be a problem.  If it were we'd be seeing it right now, 
because A would _always_ suspend before B.

> Of course, if we've mucked with the list by hand and made sure the 
> ordering is ok, then that's a different issue. But your whole point seemed 
> to be that the device could impose its own ordering in its suspend 
> callback, which is not true on its own without external ordering.

No, sorry for not making it clearer.  I was assuming all long that the 
non-tree constraints were compatible with the list ordering.

In fact these considerations already affect the USB resume operations, 
even without asynchronous resume.  The code relies on the fact that the 
PCI layer registers sibling devices on a slot in order of increasing 
function number.  There's no guarantee this will remain true in the 
future (it may already be wrong AFAIK), so putting in some explicit 
list manipulation is the prudent thing to do.

Alan Stern

