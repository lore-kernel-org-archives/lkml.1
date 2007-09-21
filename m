Return-Path: <linux-kernel-owner+w=401wt.eu-S1757899AbXIUNAR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757899AbXIUNAR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 09:00:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754276AbXIUNAF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 09:00:05 -0400
Received: from www.osadl.org ([213.239.205.134]:33596 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751606AbXIUNAE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 09:00:04 -0400
Subject: Re: 2.6.23-rc6-mm1: failure to boot on HP nx6325, no sound when
	booted, USB-related WARNING
From: Thomas Gleixner <tglx@linutronix.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jaroslav Kysela <perex@suse.cz>, Takashi Iwai <tiwai@suse.de>,
       linux-usb-devel@lists.sourceforge.net,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Ingo Molnar <mingo@elte.hu>, miklos@szeredi.hu,
       Len Brown <len.brown@intel.com>,
       David Shaohua Li <shaohua.li@intel.com>
In-Reply-To: <200709210030.20662.rjw@sisk.pl>
References: <20070918011841.2381bd93.akpm@linux-foundation.org>
	 <alpine.LFD.0.999.0709201437310.16478@woody.linux-foundation.org>
	 <1190325929.3085.79.camel@chaos>  <200709210030.20662.rjw@sisk.pl>
Content-Type: text/plain
Date: Fri, 21 Sep 2007 14:59:59 +0200
Message-Id: <1190379599.3213.8.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 (2.12.0-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael,

On Fri, 2007-09-21 at 00:30 +0200, Rafael J. Wysocki wrote:
> > -ETOOTIRED led me too a wrong conclusion, but still it is a valuable
> > hint that this change is making things work again.
> 
> Yes, it is.
> 
> > I need to go down into the details of the swsusp_suspend() code path to
> > figure out, what's the root cause. 
> 
> If you need any help from me with that, please let me know.

I'm zooming in. It seems, that the ACPI idle code plays tricks with us.
After debugging the swsusp_suspend() code path I figured out, that we
end up in C2 or deeper power states while we run the suspend code. The
same happens when we come back on resume. It looks like we disable stuff
in the ACPI BIOS, which makes the C2 and deeper power states misbehave.
I hacked the idle loop arch code to use halt() right before we call
device_suspend() and switch back to the acpi idle code right after
device_resume(). This solves the problem as well.

Len, any opinion on this one ?

	tglx


