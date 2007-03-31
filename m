Return-Path: <linux-kernel-owner+w=401wt.eu-S1753764AbXCaRzs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753764AbXCaRzs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2007 13:55:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753762AbXCaRzs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Mar 2007 13:55:48 -0400
Received: from smtp101.sbc.mail.mud.yahoo.com ([68.142.198.200]:25710 "HELO
	smtp101.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753764AbXCaRzq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2007 13:55:46 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=t4xs1mdTAKiK+SUaxeE8StY8+veKXqQR5X3sQhNWUarOCqXbkrHPgWQcHUu9cQjdiYou2We2WRBYxgSr3woUp4oOtv2yPVAnNVQWimkt6ixvMlOZHgR3+5T+zM9IPn7xYxvEx7Dk3vbQZtxkxbVeBzgXtXZx1SOMsjzli9uCDAM=  ;
X-YMail-OSG: xG55hrcVM1k5Qx_16tTPwCIQhtLIVoQyCCSXZablYgFGI6me.LyD8JCC0EzLhr_cPLpnT8nZUA--
From: David Brownell <david-b@pacbell.net>
To: linux-pm@lists.linux-foundation.org
Subject: Re: [linux-pm] [PATCH v2] Add suspend/resume for HPET
Date: Sat, 31 Mar 2007 10:55:42 -0700
User-Agent: KMail/1.7.1
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       Jeff Chua <jeff.chua.linux@gmail.com>, linux-ide@vger.kernel.org,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>, gregkh@suse.de,
       linux-pm@lists.osdl.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@stusta.de>, linux-acpi@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       "Michael S. Tsirkin" <mst@mellanox.co.il>, Ingo Molnar <mingo@elte.hu>,
       jgarzik@pobox.com, Andrew Morton <akpm@linux-foundation.org>
References: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org> <1175358800.28263.36.camel@localhost.localdomain> <Pine.LNX.4.64.0703310943190.6730@woody.linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0703310943190.6730@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200703311055.43407.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 31 March 2007 9:53 am, Linus Torvalds wrote:
> 
> On Sat, 31 Mar 2007, Thomas Gleixner wrote:
> > 
> > Right, but clock - sources/events need to be extremly late suspended and
> > early resumed. How can we ensure this ?
> 
> Make them be at the top of the device tree by adding them early. That's 
> the whole point of the device tree after all - we have an ordering that is 
> enforced by its topology, and that we sort by when things were added.

Right, but "when things get added" doesn't correlate well to
"when they should get suspended/resumed".  It's also in basic
conflict with runtime PM models, where devices may be suspended
at essentially any time.  And sysdevs are even stranger.


One way out:  rather than constructing that list as devices get
enumerated, it could be constructed by a (linear-time, non-recursive)
walk of the device tree(s) before they get suspended.

(Or equivalently:  construct lists at enumeration time, but just
adding them *right after their parent* rather than at the end of
the list.)

Would that solve the problem here?  Potentially ... if the tree is
structured to meet Thomas' rules:

> > The required resume order is:
> > 
> > clocksources
> > timekeeping
> > clockevents
> > tick management

> So the only thing that needs to be done is to make sure that we add the 
> timer devices early during bootup - something we have to do *anyway*. If a 
> device is added early in bootup, that automatically means that it will be 
> suspended late, and resumed early - because we maintain that order all the 
> way through..

>             -- "clocksource" -- +-- HPET
>                                 |
>                                 +-- TSC
>                                 |
>                                 +-- i8259
>                                 |
>                                 +-- lapic timer
>                                 |
>                                 .. whatever else

If each of those were a device node, with "clocksource" suspend/resume
methods handling Thomas' "timekeeping" item, and simlarly for "clockevent"
devices ... I could see that all working neatly.

- Dave

