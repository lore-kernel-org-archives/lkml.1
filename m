Return-Path: <linux-kernel-owner+w=401wt.eu-S1765338AbXF1SOX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765338AbXF1SOX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 14:14:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761043AbXF1SOR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 14:14:17 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:48912 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761905AbXF1SOQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 14:14:16 -0400
Date: Thu, 28 Jun 2007 20:15:21 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Takashi Iwai <tiwai@suse.de>, lkml <linux-kernel@vger.kernel.org>,
       akpm <akpm@linux-foundation.org>, perex@suse.cz
Subject: Re: [PATCH -mm] ALSA portman2x4 section mismatch
Message-ID: <20070628181521.GA8011@uranus.ravnborg.org>
References: <20070626153013.264f5a92.randy.dunlap@oracle.com> <s5h3b0dg1fr.wl%tiwai@suse.de> <20070628102438.cafa1b41.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070628102438.cafa1b41.randy.dunlap@oracle.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 28, 2007 at 10:24:38AM -0700, Randy Dunlap wrote:
> On Wed, 27 Jun 2007 12:02:32 +0200 Takashi Iwai wrote:
> 
> > At Tue, 26 Jun 2007 15:30:13 -0700,
> > Randy Dunlap wrote:
> > > 
> > > From: Randy Dunlap <randy.dunlap@oracle.com>
> > > 
> > > FIx section mismatch when CONFIG_HOTPLUG=n:
> > > 
> > > WARNING: sound/built-in.o(.exit.text+0x271): Section mismatch: reference to .init.text:snd_p
> > > ortman_unregister_all (between 'snd_portman_module_exit' and 'alsa_mpu401_uart_exit')
> > > 
> > > Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> > 
> > I applied it to ALSA tree now because it's the simplest way to fix
> > this warning.  But, I'm still wondering whether it was really wrong.
> > 
> > The function snd_portmap_unregister_all() is called both from the
> > module init and exit functions.  Would the module_exit function be
> > called even CONFIG_MODULE=n ?
> 
> No, it's not called when the driver is built-in.
> 
> > If not, __init_or_module should be
> > correct since the function is called only from module_init.
> 
> [adding Sam to cc:]
> 
> I see.  So to try to summarize:
> 
> When CONFIG_MODULES=n, __exit functions can be allowed to reference
> __init functions since the __init functions won't be called because
> the __exit functions are not invoked.
> 
> Does that sound correct?
In the CONFIG_MODULES=n case the __exit section is discarded so yes they
can reference anything without causing breakage.
But that said this is by no means a logical thing to allow from the principle
of minimum suprise.

>  Can & should modpost add this knowledge?
So modpost should not have this knowledge. A better approach is either to fix
the relations or drom the __init/__exit marker for a few sections.
The __init/__exit parts are mainly of benefit in two cases:
1) When someone has a lot of built-in drivers
2) In the embedded world with scarce memory

As for 1) this is a non-typical case not worth optimizing too much against.
As for 2) this is where the biggest benefit are.

Considering this alsa drivers are likely not typical embedded so here dropping a few
__init/__exit markings should be safe.
But it also depends on what other code is invoked from these functions.

	Sam
