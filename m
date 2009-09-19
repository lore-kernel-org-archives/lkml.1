Return-Path: <linux-kernel-owner+w=401wt.eu-S1756699AbZISJ14@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756699AbZISJ14 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 05:27:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753307AbZISJ1z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 05:27:55 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:19126 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751903AbZISJ1x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 05:27:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=RCMl+ksnTQpSCNqGr3D0t7h9EjLXv3bmEkqSCN35Hr8h5IBJZFRvvoDwd6cG6j5UFr
         ml9sMJ8+tm7WlYDpyyhfFNLbUZL1v7asrlEZIqqHKfzsKV3hntDS5OsD+qqTo1fezhAv
         VR5M0Sji1V9xmgqS0UCZDUS3V2WkDApboCIy8=
Message-ID: <4AB4A25C.9000904@gmail.com>
Date: Sat, 19 Sep 2009 11:20:28 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1.1) Gecko/20090715 SUSE/3.0b3-8.6 Thunderbird/3.0b3
MIME-Version: 1.0
To: Krzysztof Helt <krzysztof.h1@wp.pl>
CC: linux-input@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: hid-core: fix lockdep in hid_input_report()
References: <20090919081549.669b6773.krzysztof.h1@wp.pl>
In-Reply-To: <20090919081549.669b6773.krzysztof.h1@wp.pl>
X-Enigmail-Version: 0.97a
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/19/2009 08:15 AM, Krzysztof Helt wrote:
> There is a lockdep warning in the hid_input_report() due to dynamic allocation
> of a temporary buffer.
> Change the buffer to a local variable. The buffer size is 512 chars.

I personally don't like this approach. Adding 0.5k to a stack is not a
good idea (and it is worse when one looks at the long trace). I think
hid_ctrl should call hid_input_report with 1 as the last argument instead.

> The lockdep trace is:
> 
> WARNING: at kernel/lockdep.c:2457 lockdep_trace_alloc+0xca/0xd0()
> Hardware name: Product Name
> Modules linked in: usbhid(+) hid uhci_hcd ne2k_pci via_agp 8390 i2c_via
> Pid: 0, comm: swapper Not tainted 2.6.31 #74
> Call Trace:
>  [<c0243b8a>] ? lockdep_trace_alloc+0xca/0xd0
>  [<c0221d1c>] warn_slowpath_common+0x7c/0xa0
>  [<c0243b8a>] ? lockdep_trace_alloc+0xca/0xd0
>  [<c0221d55>] warn_slowpath_null+0x15/0x20
>  [<c0243b8a>] lockdep_trace_alloc+0xca/0xd0
>  [<c027d2c8>] kmem_cache_alloc+0x28/0x100
>  [<cc9359ef>] ? hid_input_report+0x6f/0x220 [hid]
>  [<cc9359ef>] hid_input_report+0x6f/0x220 [hid]
>  [<cc94cabf>] hid_ctrl+0x7f/0x180 [usbhid]
>  [<c03b28b1>] usb_hcd_giveback_urb+0x41/0xa0
>  [<cc91a3fc>] uhci_giveback_urb+0x8c/0x280 [uhci_hcd]
>  [<c0279853>] ? dma_pool_free+0xd3/0x120
>  [<cc919848>] ? uhci_free_td+0x58/0xa0 [uhci_hcd]
>  [<cc91ac01>] uhci_scan_schedule+0x301/0x910 [uhci_hcd]
>  [<cc91cac4>] uhci_irq+0x94/0x940 [uhci_hcd]
>  [<c0245c43>] ? __lock_acquire+0x433/0xab0
>  [<c0206246>] ? mask_and_ack_8259A+0x66/0x100
>  [<c03b494b>] usb_hcd_irq+0x6b/0x90
>  [<c0255e7d>] handle_IRQ_event+0x2d/0xc0
>  [<c0257e85>] handle_level_irq+0x65/0xe0
>  [<c0204c74>] handle_irq+0x34/0x60
>  [<c0204bc9>] do_IRQ+0x39/0xb0
>  [<c024365c>] ? trace_hardirqs_on_caller+0x12c/0x180
>  [<c020328e>] common_interrupt+0x2e/0x40
>  [<c0208d48>] ? default_idle+0x38/0x50
>  [<c02108df>] apm_cpu_idle+0x10f/0x290
>  [<c0201b11>] cpu_idle+0x21/0x40
>  [<c045892d>] rest_init+0x4d/0x60
>  [<c0575815>] start_kernel+0x235/0x280
>  [<c05751f0>] ? unknown_bootoption+0x0/0x210
>  [<c057503f>] __init_begin+0x3f/0x50

