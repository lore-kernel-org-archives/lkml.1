Return-Path: <linux-kernel-owner+w=401wt.eu-S1754176AbYKPRue@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754176AbYKPRue (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 12:50:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752078AbYKPRu0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 12:50:26 -0500
Received: from ppp-111-253.adsl.restena.lu ([158.64.111.253]:58183 "EHLO
	bonbons.gotdns.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751834AbYKPRu0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 12:50:26 -0500
Date: Sun, 16 Nov 2008 18:50:23 +0100
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Kay Sievers <kay.sievers@vrfy.org>, Len Brown <len.brown@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: Linux 2.6.28-rc5
Message-ID: <20081116185023.0c8c6717@neptune.home>
In-Reply-To: <alpine.LFD.2.00.0811160917220.3468@nehalem.linux-foundation.org>
References: <alpine.LFD.2.00.0811151444090.3468@nehalem.linux-foundation.org>
	<20081116140421.644e9ab2@neptune.home>
	<alpine.LFD.2.00.0811160917220.3468@nehalem.linux-foundation.org>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 16 November 2008 Linus Torvalds wrote:
> On Sun, 16 Nov 2008, Bruno Prémont wrote:
> > 
> > The following change is guilty on my machine (though I could not
> > find the matching commit on git.kernel.org :( )
> 
> It's commit 0794469da3f7b2093575cbdfc1108308dd3641ce: "ACPI: struct
> device 
> - replace bus_id with dev_name(), dev_set_name()", and yes, it seems 
> totally buggy. It replaced a test for "dev->bus" with
> "dev_name(dev)", which makes no sense.

Looks like the reason I couldn't find it was old cache on
git.kernel.org or something like that as the matching commit
now shows up.

> > Reverting the change below makes the error go away.
> 
> Does this smaller patch just make it go away?
Yes, that smaller patch fixes it as well

> That said, that whole function looks potentially buggy. Len - why is
> it safe to do "list_for_each_safe()" when you drop the
> acpi_device_lock in the middle? The "next" pointer that we look up
> may go away while the lock is dropped, I think.
> 
> 		Linus
> 
> ---
>  drivers/acpi/sleep/proc.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/acpi/sleep/proc.c b/drivers/acpi/sleep/proc.c
> index 64e591b..4dbc227 100644
> --- a/drivers/acpi/sleep/proc.c
> +++ b/drivers/acpi/sleep/proc.c
> @@ -366,7 +366,7 @@ acpi_system_wakeup_device_seq_show(struct
> seq_file *seq, void *offset) dev->wakeup.state.enabled ? "enabled" :
> "disabled"); if (ldev)
>  			seq_printf(seq, "%s:%s",
> -				   dev_name(ldev) ?
> ldev->bus->name : "no-bus",
> +				   ldev->bus ? ldev->bus->name :
> "no-bus", dev_name(ldev));
>  		seq_printf(seq, "\n");
>  		put_device(ldev);
> 
