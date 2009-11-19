Return-Path: <linux-kernel-owner+w=401wt.eu-S1753038AbZKSSZh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753038AbZKSSZh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 13:25:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753278AbZKSSZg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 13:25:36 -0500
Received: from smtp.eu.citrix.com ([62.200.22.115]:52758 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753052AbZKSSZf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 13:25:35 -0500
X-Greylist: delayed 592 seconds by postgrey-1.27 at vger.kernel.org; Thu, 19 Nov 2009 13:25:35 EST
X-IronPort-AV: E=Sophos;i="4.44,772,1249257600"; 
   d="scan'208";a="8136339"
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-ID: <19205.35669.210191.691969@mariner.uk.xensource.com>
Date: Thu, 19 Nov 2009 18:15:49 +0000
To: Jiri Kosina <jkosina@suse.cz>
CC: Alan Cox <alan@linux.intel.com>, Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Markus Armbruster <armbru@redhat.com>, Michal Hocko <mhocko@suse.cz>
Subject: Re: [PATCH] Do not read IIR in serial8250_start_tx when
 UART_BUG_TXEN
In-Reply-To: <alpine.LSU.2.00.0911191734570.15039@wotan.suse.de>
References: <alpine.LSU.2.00.0911181101090.15039@wotan.suse.de>
	<alpine.LSU.2.00.0911191734570.15039@wotan.suse.de>
X-Mailer: VM 8.0.9 under Emacs 21.4.1 (i486-pc-linux-gnu)
From: Ian Jackson <Ian.Jackson@eu.citrix.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Kosina writes ("Re: [PATCH] Do not read IIR in serial8250_start_tx when UART_BUG_TXEN"):
> Does anyone have any comments about this please?
> 
> In a nutshell -- this is needed so that we make the UART_BUG_TXEN really 
> harmless (which I guess it originally inteded to be, but reading IIR has 
> some unwanted sideeffects and is in fact not needed).

Yes.

> We need to have this in to handle properly the cases in which BUG_TXEN is 
> misdetected, and we can't blacklist such systems as we do for some SoL 
> hardware (see commit b6adea334c6c (" 8250: fix boot hang with serial 
> console when using with Serial Over Lan port"). Also there doesn't seem to 
> be any straightforward way to workaround the misdetection, so this seems 
> to be proper fix, unbreaking all the possible scenarios.

Unless the code has changed, the UART_BUG_TXEN detection is
fundamentally broken and racy.  So fixing that too would be good (and
possible, when I looked at it).

But even without fixing the UART_BUG_TXEN detection, the IIR read is
absolutely and definitely wrong.  The only purpose of the IIR read is
to avoid an unnecessary but harmless call to transmit_chars.

It seems to me that the author of the UART_BUG_TXEN patch did not
appreciate that reading the IIR was not side effect free, and that
they were just trying a minor (and perhaps ill-advised) optimisation.

In any case we don't have any useful information (in comments or
commit logs) explaining why they did it this way and it is (a) easily
seen to be buggy and (b) causes actual real problems.

So my patch should be applied.  The last time we discussed this we had
some kind of FUD along the lines of "but real serial ports often have
bugs so you can't reason about them properly".  I don't think that's a
sensible basis for discussion.  How can it be falsified ?

If there is some specific bug that real ports have that might be
relevant, sure, take it into account.  But we should not have the
situation where we hear the mere assertion that there often are bugs;
therefore reasoning doesn't show change to be safe; therefore no
change can be made.

Ian.
