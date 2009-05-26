Return-Path: <linux-kernel-owner+w=401wt.eu-S1758431AbZEZVQa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758431AbZEZVQa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 17:16:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754949AbZEZVQX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 17:16:23 -0400
Received: from fmailhost04.isp.att.net ([207.115.11.54]:55903 "EHLO
	fmailhost04.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751449AbZEZVQW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 17:16:22 -0400
X-Greylist: delayed 301 seconds by postgrey-1.27 at vger.kernel.org; Tue, 26 May 2009 17:16:22 EDT
X-Originating-IP: [141.151.175.151]
Date: Tue, 26 May 2009 17:10:59 -0400
From: gapeters@worldnet.att.net
To: linux-kernel@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>,
       Auke Kok <auke-jan.h.kok@intel.com>
Subject: Re: [Bug #13371] s2disk hangs with kernel 2.6.29 and later, SATA,
	Gigabyte EG45M-DS2H - culprit found
Message-ID: <20090526211058.GB2538@indigo.myhome.westell.com>
Reply-To: jerry_734@verizon.net
Mail-Followup-To: jerry_734@verizon.net, linux-kernel@vger.kernel.org,
	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	Kernel Testers List <kernel-testers@vger.kernel.org>,
	Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>,
	Auke Kok <auke-jan.h.kok@intel.com>
References: <GtY7d2eWpoK.A.ioC.MQcGKB@chimera> <200905251448.40907.bzolnier@gmail.com> <20090525134522.GA7805@arbonne.lan> <200905251630.21781.bzolnier@gmail.com> <20090525171305.GA5855@arbonne.lan> <20090525230259.GA5098@vilya>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090525230259.GA5098@vilya>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Mailer: pmail 0.8.46L Jan 22 2006 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 26, 2009 at 01:03:00AM +0200, Richard Atterer wrote:
> Hello,
> 
> "Jerry" contacted me off-list with information about the root of the 
> problem - many thanks indeed!!!
> 
> It turns out that the e100 driver is responsible. (The motherboard actually 
> has a r8169 chip, but I added an old Intel PCI ethernet card I own.)
> 
> By rmmoding e100 before s2disk, the problem goes away. Jerry mentions that 
> he once saw a message about e100 failing to load its microcode - I never 
> saw such a message.
> 
> The most recent e100 commit ac7c992 by Thadeu Lima de Souza Cascardo (Apr 
> 28) made some changes to the behaviour in the case of shutdown vs. suspend, 
> maybe the problem is there? (But note that during bisecting, I tested 
> kernels older than that commit, and not all of them worked.) Before that, 
> f902283 (Mar 3 2008) mentions suspend in the log message.
> 
> Cheers,
> 
>   Richard
> 
> -- 

I think I saw the firmware loader failure during resume. If you leave the
system alone for ~2 minutes it will resume, but the e100 won't work &
any thing "touching" it will go into an un-interruptable sleep
(ifconfig, cat'ing some of its /sys files).

IIRC started with 2.6.29, with the change to net drivers to use the
firmware loader. During the hibernate, for some reason, the e100 is
suspended then resumed, at which point it requests its firmware.
Userspace is frozen so the firmware load times out (the 2 minute timeout
which is why I guessed you were having the same problem).

During resume, the e100 is apparently resumed *before* userspace is
un-frozen, so again it times out loading its firmware. At this point
it's unusable.

	Jerry
