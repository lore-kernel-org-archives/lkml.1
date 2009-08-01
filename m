Return-Path: <linux-kernel-owner+w=401wt.eu-S1751872AbZHAPr3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751872AbZHAPr3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Aug 2009 11:47:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751711AbZHAPr0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Aug 2009 11:47:26 -0400
Received: from netrider.rowland.org ([192.131.102.5]:50958 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751660AbZHAPrZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Aug 2009 11:47:25 -0400
Date: Sat, 1 Aug 2009 11:47:24 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Jason Wessel <jason.wessel@windriver.com>
cc: gregkh@suse.de, <linux-usb@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>, <dbrownell@users.sourceforge.net>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Yinghai Lu <yinghai@kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH 07/10] ehci-dbgp,ehci: Allow early or late use of the
 dbgp device
In-Reply-To: <4A736380.8030101@windriver.com>
Message-ID: <Pine.LNX.4.44L0.0908011144110.20464-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 31 Jul 2009, Jason Wessel wrote:

> Alan Stern wrote:
> > What happens across a system suspend?
> >
> >   
> 
> I assume you mean as a test case:
> 
> echo -n mem > /sys/power/state
> 
> The dbgp device goes away entirely, when used with
> earlyprintk=dbgp,keep.  But there is a way to fix it reasonably
> easily.  Perhaps you might ack this resume patch, if you agree?
> 
> Jason.
> 
> ---
> From: Jason Wessel <jason.wessel@windriver.com>
> Subject: [PATCH] ehci-dbgp,ehci: Allow dbpg to work with suspend/resume
> 
> In order for the dbgp driver to survive suspend/resume, on every ehci
> resume operation the debug controller must get re-initialized.
> 
> Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
> Cc: Greg KH <gregkh@suse.de>
> Cc: Alan Stern <stern@rowland.harvard.edu>
> Cc: dbrownell@users.sourceforge.net
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Yinghai Lu <yinghai@kernel.org>
> Cc: "Eric W. Biederman" <ebiederm@xmission.com>
> 
> ---
>  drivers/usb/host/ehci-hub.c |    6 ++++++
>  1 file changed, 6 insertions(+)
> 
> --- a/drivers/usb/host/ehci-hub.c
> +++ b/drivers/usb/host/ehci-hub.c
> @@ -204,6 +204,13 @@ static int ehci_bus_resume (struct usb_h
>  		return -ESHUTDOWN;
>  	}
>  
> +	if (unlikely(ehci->debug)) {
> +		if (ehci->debug && !dbgp_reset_prep())
> +			ehci->debug = NULL;
> +		else
> +			dbgp_external_startup();
> +	}
> +
>  	/* Ideally and we've got a real resume here, and no port's power
>  	 * was lost.  (For PCI, that means Vaux was maintained.)  But we
>  	 * could instead be restoring a swsusp snapshot -- so that BIOS was

It looks fine to me.  Would you perhaps want to make dbgp_reset_prep()
automatically call dbgp_external_startup() on success so that ehci-hcd
doesn't have to?

Alan Stern

