Return-Path: <linux-kernel-owner+w=401wt.eu-S1756802AbZAHBTS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756802AbZAHBTS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 20:19:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751465AbZAHBTE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 20:19:04 -0500
Received: from casper.infradead.org ([85.118.1.10]:51874 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751332AbZAHBTB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 20:19:01 -0500
Date: Wed, 7 Jan 2009 17:21:02 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/7] V3 of the async function call patches
Message-ID: <20090107172102.47f778d4@infradead.org>
In-Reply-To: <alpine.LFD.2.00.0901071611490.3283@localhost.localdomain>
References: <20090107151151.458333c1@infradead.org>
	<alpine.LFD.2.00.0901071611490.3283@localhost.localdomain>
Organization: Intel
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.14.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Jan 2009 16:17:24 -0800 (PST)
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> 
> On Wed, 7 Jan 2009, Arjan van de Ven wrote:
> >
> > version 3 of the async function call patches
> > 
> > * Dropped the ACPI part; it broke i surprising ways; needs a rethink
> >   (working with Len and co on that)
> > * Included asynchronous delete()
> 
> Ok, I pulled this, because I really do want the boot speedups and the 
> previous version missed the last merge window, but after booting it,
> I started to worry:
> 
> My dmesg shows:
> 
>  [    2.264955] sd 5:0:0:0: [sdb] Write cache: enabled, read cache:
> enabled, doesn't support DPO or FUA [    2.264958]  sdb:<6>Freeing
> unused kernel memory: 408k freed
> 
> Ouch. How come that "Freeing unused kernel memory" got done in the
> middle of the sdb partition thing?
> 
> There's a async_synchronize_full() there before the free_initmem(),
> but I'm worrying that it just isn't working. Hmm? What am I missing?
> 

ok this part looks funny but it's not really (and it's safe I think).

The async sata thing launches another async thing (the scsi partition
scan).
The synchronize_full() waits for the sata to complete, but doesn't wait
for things that the sata async schedules after the wait started.

is this a problem? not right now, but it means we have a rule that if
an async item schedules another async item, the second one cannot be
__init. (which is ok right now.. scsi already had some of this async
anyway).

I could make the async_full() be more strict if that makes you feel
better, but for this specific purpose it would be over-synchronizing.


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
