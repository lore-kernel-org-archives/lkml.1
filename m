Return-Path: <linux-kernel-owner+w=401wt.eu-S1752544AbZERSl1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752544AbZERSl1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 14:41:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751722AbZERSlU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 14:41:20 -0400
Received: from vms173003pub.verizon.net ([206.46.173.3]:32970 "EHLO
	vms173003pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751396AbZERSlT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 14:41:19 -0400
Date: Mon, 18 May 2009 13:40:54 -0500
From: Corey Minyard <minyard@acm.org>
To: Ferenc Wagner <wferi@niif.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       openipmi-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [Openipmi-developer] modprobe ipmi_si hangs under 2.6.30-rc5
Message-id: <20090518184053.GA24134@minyard.local>
Reply-to: minyard@acm.org
References: <87tz3qnh7o.fsf@tac.ki.iif.hu>
 <20090516170959.8057c9e4.akpm@linux-foundation.org>
 <877i0eqpss.fsf@tac.ki.iif.hu>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-disposition: inline
In-reply-to: <877i0eqpss.fsf@tac.ki.iif.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 18, 2009 at 07:33:23PM +0200, Ferenc Wagner wrote:
> Andrew Morton <akpm@linux-foundation.org> writes:
> 
> > Well there have only been a handful of changes to ipmi since 2.6.29. 
> > Could you try a mini-bisection?
> >
> > Apply revert-1.patch, test
> > Apply revert-2.patch, test
> > Apply revert-3.patch, test
> > Apply revert-4.patch, test
> 
> After applying revert-1.patch, modprobe runs OK:
> 
> [   86.968156] IPMI System Interface driver.
> [   86.976276] ipmi_si: Trying SMBIOS-specified smic state machine at i/o address 0xecf4, slave address 0x20, irq 0
> [   87.117630] ipmi: Found new BMC (man_id: 0x0002a2,  prod_id: 0x0000, dev_id: 0x00)
> [   87.133078] IPMI smic interface initialized
> 
> I guess there's no point in trying the rest.

I think I see the problem.  Can you try the patch at the end of the
email?  I can't test it because I don't have an IPMI 1.0 sytem.
Thanks for setting up the mini-bisection, Andrew.

> 
> When loading with debug options, it still produces insane amount of
> debug messages continuously (first 671 lines of it attached).

Yes, full debugging generates a ton of output, it logs everything it does
in that case.

Thanks,

-corey


Set the current channel to the number of channels in an IPMI 1.0 system,
as this value is used to tell if the channel information has been
initialized.

Signed-off-by: Corey Minyard <cminyard@mvista.com>

diff --git a/drivers/char/ipmi/ipmi_msghandler.c b/drivers/char/ipmi/ipmi_msghandler.c
index aa83a08..48f4269 100644
--- a/drivers/char/ipmi/ipmi_msghandler.c
+++ b/drivers/char/ipmi/ipmi_msghandler.c
@@ -2856,6 +2856,7 @@ int ipmi_register_smi(struct ipmi_smi_handlers *handlers,
 		/* Assume a single IPMB channel at zero. */
 		intf->channels[0].medium = IPMI_CHANNEL_MEDIUM_IPMB;
 		intf->channels[0].protocol = IPMI_CHANNEL_PROTOCOL_IPMB;
+		intf->curr_channel = 1;
 	}
 
 	if (rv == 0)
