Return-Path: <linux-kernel-owner+w=401wt.eu-S1758097AbXGIAeX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758097AbXGIAeX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 20:34:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754249AbXGIAeP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 20:34:15 -0400
Received: from gate.crashing.org ([63.228.1.57]:39166 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753094AbXGIAeO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 20:34:14 -0400
Subject: Re: [PATCH] Remove process freezer from suspend to RAM pathway
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Alan Stern <stern@rowland.harvard.edu>, Kyle Moffett <mrmacman_g4@mac.com>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pavel Machek <pavel@ucw.cz>, Matthew Garrett <mjg59@srcf.ucam.org>,
       linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
In-Reply-To: <200707090006.32712.rjw@sisk.pl>
References: <Pine.LNX.4.44L0.0707081517540.11049-100000@netrider.rowland.org>
	 <1183929611.3388.303.camel@localhost.localdomain>
	 <200707090006.32712.rjw@sisk.pl>
Content-Type: text/plain
Date: Mon, 09 Jul 2007 10:33:37 +1000
Message-Id: <1183941217.3388.324.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


>  	drivers_sysfs_write()
> 		while(!suspend_trylock())
> 			try_to_icebox() --> or even try_to_freeze(), what's the difference?
> 
>  		hit hardware
> 		unlock_suspend()
> 
> where the PM core must wait for the suspend lock to get released (say with a
> timeout)?

Somewhat. What I'd like is to have that a construct of that sort on a
per-driver basis though :-) Now the question is, in what way would the
above be different from a simple suspend mutex ? I've been using mutexes
in the past for a couple of drivers (iirc, that's how I did it for
dmasound_pmac, though that driver is long past obsolescence now).

But yes, that's the idea, something under control of drivers, instead of
a 3rd party freezer that tries to hit at processes. 

> Hmm, perhaps we can use a special workqueue that's created before the suspend
> (say by the PM core) and starts processing jobs after the resume?

Yeah, whatever the implementation is, though, the interface should be
transparent. But then, I see little use of that. Mostly things like this
sysfs write to unbind Alan was talking about. Driver workqueues probably
need to be functioning all the way until the driver itself is suspended,
in which case, the driver may just flush_worqueues in it's suspend path
at the right time to make sure it doesn't exit with something still
pending.

Ben.


