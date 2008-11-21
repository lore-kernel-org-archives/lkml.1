Return-Path: <linux-kernel-owner+w=401wt.eu-S1756956AbYKUWQh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756956AbYKUWQh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 17:16:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752792AbYKUWQ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 17:16:29 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45152 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752668AbYKUWQ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 17:16:28 -0500
Date: Fri, 21 Nov 2008 14:16:21 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Takashi Iwai <tiwai@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix array overflow in parport_serial.c
Message-Id: <20081121141621.fe4277bb.akpm@linux-foundation.org>
In-Reply-To: <s5habbu9wzb.wl%tiwai@suse.de>
References: <s5habbu9wzb.wl%tiwai@suse.de>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Nov 2008 17:35:20 +0100
Takashi Iwai <tiwai@suse.de> wrote:

> Subject: [PATCH] Fix array overflow in parport_serial.c

Please prefer titles in the form

	subsystem identifer: what was done to it

I renamed this one to

	parport_serial: fix array overflow

> Date: Thu, 20 Nov 2008 17:35:20 +0100
> User-Agent: Wanderlust/2.12.0 (Your Wildest Dreams) SEMI/1.14.6 (Maruoka)
>  FLIM/1.14.7 (Sanj__) APEL/10.6 Emacs/22.3
>  (x86_64-suse-linux-gnu) MULE/5.0 (SAKAKI)
> 
> The netmos_9xx5_combo type assumes that PCI SSID provides always the
> correct value for the number of parallel and serial ports, but there
> are indeed broken devices with wrong numbers, which may result in
> Oops.
> 
> This patch simply adds the check of the array range.
> 
> Reference: Novell bnc#447067
> 	https://bugzilla.novell.com/show_bug.cgi?id=447067
> 
> Signed-off-by: Takashi Iwai <tiwai@suse.de>
> 
> ---
> diff --git a/drivers/parport/parport_serial.c b/drivers/parport/parport_serial.c
> index e2e95b3..101ed49 100644
> --- a/drivers/parport/parport_serial.c
> +++ b/drivers/parport/parport_serial.c
> @@ -70,6 +70,8 @@ static int __devinit netmos_parallel_init(struct pci_dev *dev, struct parport_pc
>  	 * parallel ports and <S> is the number of serial ports.
>  	 */
>  	card->numports = (dev->subsystem_device & 0xf0) >> 4;
> +	if (card->numports > ARRAY_SIZE(card->addr))

hm.  ARRAY_SIZE returns an unsigned type so we don't have to worry
about negative values when doing comparisons like this.  Not that
card->numports could be negative anyway, but it's always nice to set
readers' minds at rest..

> +		card->numports = ARRAY_SIZE(card->addr);
>  	return 0;
>  }


Should we emit some kind of warning when this is detected?  I guess
not, if we're sure that there will never be a situation in which users
find that some of their ports don't work?

