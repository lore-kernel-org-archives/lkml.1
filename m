Return-Path: <linux-kernel-owner+w=401wt.eu-S1030258AbXEHONs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030258AbXEHONs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 10:13:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967449AbXEHONs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 10:13:48 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:53205 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967285AbXEHONr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 10:13:47 -0400
Date: Tue, 8 May 2007 07:14:53 -0700
From: Greg KH <greg@kroah.com>
To: Dan Kruchinin <dubalom@gmail.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       linux-usb-devel@lists.sourceforge.net
Subject: Re: [PATCH -mm] drivers/usb/core/config.c: kzalloc(0,..)
Message-ID: <20070508141453.GA12771@kroah.com>
References: <a8f16e2b0705072003m6172df63l199090149edd7612@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a8f16e2b0705072003m6172df63l199090149edd7612@mail.gmail.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 08, 2007 at 07:03:08AM +0400, Dan Kruchinin wrote:
>  The following patch fixes such SLUB report(when someone tries to
>  allocate 0 bytes):
>  --
>  May  8 00:19:15 midgard kernel: [   21.933467] BUG: at
>  include/linux/slub_def.h:88 kmalloc_index()
>  May  8 00:19:15 midgard kernel: [   21.933470]
>  [show_registers+410/736] show_trace_log_lvl+0x1a/0x30
>  May  8 00:19:15 midgard kernel: [   21.933478]
>  [print_trace_warning_symbol+50/64] show_trace+0x12/0x20
>  May  8 00:19:15 midgard kernel: [   21.933482]  [fixup_irqs+38/192]
>  dump_stack+0x16/0x20
>  May  8 00:19:15 midgard kernel: [   21.933485]  [do_lookup+195/400]
>  get_slab+0x213/0x230
>  May  8 00:19:15 midgard kernel: [   21.933489]  [do_lookup+309/400]
>  __kmalloc_track_caller+0x15/0x40
>  May  8 00:19:15 midgard kernel: [   21.933493]  [__vunmap+25/240]
>  __kzalloc+0x19/0x50
>  May  8 00:19:15 midgard kernel: [   21.933498]  [<df05778e>]
>  usb_parse_configuration+0x85e/0xe70 [usbcore]
>  May  8 00:19:15 midgard kernel: [   21.933520]  [<df057fcb>]
>  usb_get_configuration+0x12b/0x450 [usbcore]
>  May  8 00:19:15 midgard kernel: [   21.933535]  [<df04ed87>]
>  usb_new_device+0x17/0x1c0 [usbcore]
>  May  8 00:19:15 midgard kernel: [   21.933550]  [<df05073a>]
>  hub_thread+0x79a/0xfd0 [usbcore]
>  May  8 00:19:15 midgard kernel: [   21.933564]
>  [run_posix_cpu_timers+1218/2064] kthread+0x42/0x70
>  May  8 00:19:15 midgard kernel: [   21.933569]  [math_error+87/240]
>  kernel_thread_helper+0x7/0x10
>  May  8 00:19:15 midgard kernel: [   21.933572]  =======================
>  --
> 
>  The problem was in drivers/usb/core/config.c in function 
>  usb_parse_interface:
>  ---
>  num_ep = num_ep_orig = alt->desc.bNumEndpoints;
>  ...
>  len = sizeof(struct usb_host_endpoint) * num_ep;
>  alt->endpoint = kzalloc(len, GFP_KERNEL);
>  ---
> 
>  num_ep can be 0, as it was in my case, so following patch makes this
>  situation more obvious
>  and clear.

Well, the whitespace was damaged, but the idea looks sane.  Care to
respin this?

However, what kind of device do you have that you have no endpoints for
an interface?  Why have the interface then?

thanks,

greg k-h
