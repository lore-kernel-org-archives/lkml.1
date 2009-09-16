Return-Path: <linux-kernel-owner+w=401wt.eu-S1752502AbZIPHXW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752502AbZIPHXW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 03:23:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750812AbZIPHXT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 03:23:19 -0400
Received: from mail-yx0-f171.google.com ([209.85.210.171]:55042 "EHLO
	mail-yx0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750696AbZIPHXS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 03:23:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=LE8bas+KqyVHYHCjag864cR4HllQBR5ho+Z0uD9qch4cybYu1AW8X/+SVy1lsEZQh/
         zxW+sPqVaJNjY6loZQAFkID1mNnkvmAYinY4xxuMw0K1e3rmlpK1HldLwn35zBTTyifn
         /Tsz3j5p8UAsFHkD0KhRQ5rRiw10PEqroRBAE=
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.0909151202560.17028@wotan.suse.de>
References: <20090915085441.GF23126@kernel.dk>
	 <alpine.LNX.2.00.0909151202560.17028@wotan.suse.de>
Date: Wed, 16 Sep 2009 16:16:46 +0900
Message-ID: <28c262360909160016m19edee02g9215669f854e1026@mail.gmail.com>
Subject: Re: BUG: sleeping function called from invalid context at 
	mm/slub.c:1717
From: Minchan Kim <minchan.kim@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       linux-mm <linux-mm@kvack.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Jiri.

On Tue, Sep 15, 2009 at 7:10 PM, Jiri Kosina <jkosina@suse.cz> wrote:
> On Tue, 15 Sep 2009, Jens Axboe wrote:
>
>> This is new with todays -git:
>>
>> BUG: sleeping function called from invalid context at mm/slub.c:1717
>> in_atomic(): 1, irqs_disabled(): 1, pid: 0, name: swapper
>> Pid: 0, comm: swapper Not tainted 2.6.31 #206
>> Call Trace:
>>  <IRQ>  [<ffffffff8103eb23>] __might_sleep+0xf3/0x110
>>  [<ffffffff810e4d83>] kmem_cache_alloc+0x123/0x170
>>  [<ffffffff813306c9>] hid_input_report+0x89/0x3a0
>>  [<ffffffffa00cd5f4>] hid_ctrl+0xa4/0x1f0 [usbhid]
>>  [<ffffffff8108a4c7>] ? handle_IRQ_event+0xa7/0x1e0
>>  [<ffffffffa004da1f>] usb_hcd_giveback_urb+0x3f/0xa0 [usbcore]
>>  [<ffffffffa0074ab4>] uhci_giveback_urb+0xb4/0x240 [uhci_hcd]
>>  [<ffffffffa00750e7>] uhci_scan_schedule+0x357/0xab0 [uhci_hcd]
>>  [<ffffffffa0077a01>] uhci_irq+0x91/0x190 [uhci_hcd]
>>  [<ffffffffa004d44e>] usb_hcd_irq+0x2e/0x70 [usbcore]
>>  [<ffffffff8108a4c7>] handle_IRQ_event+0xa7/0x1e0
>>  [<ffffffff8108c58c>] handle_fasteoi_irq+0x7c/0xf0
>>  [<ffffffff8100f176>] handle_irq+0x46/0xa0
>>  [<ffffffff8100e49a>] do_IRQ+0x6a/0xf0
>>  [<ffffffff8100c853>] ret_from_intr+0x0/0xa
>>
>> And I notice there's a HID merge from yesterday, Jiri CC'ed.
>
> Thanks for letting me know. The patch below should fix it.
>
>
>
> From: Jiri Kosina <jkosina@suse.cz>
> Subject: [PATCH] HID: fix non-atomic allocation in hid_input_report
>
> 'interrupt' variable can't be used to safely determine whether
> we are running in atomic context or not, as we might be called from
> during control transfer completion through hid_ctrl() in atomic
> context with interrupt == 0.

I am not a USB expert so It might be dump comment. :)

We have to change description of hid_input_report.

 * @interrupt: called from atomic?

I think it lost meaning.
I am worried that interrupt variable is propagated down
to sub functions. Is it right on sub functions?

One more thing, I am concerned about increasing
GFP_ATOMIC customers although we can avoid it.
Is it called rarely?
Could you find a alternative method to overcome this issue?


>
> Reported-by: Jens Axboe <jens.axboe@oracle.com>
> Signed-off-by: Jiri Kosina <jkosina@suse.cz>
> ---
>  drivers/hid/hid-core.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
> index 342b7d3..ca9bb26 100644
> --- a/drivers/hid/hid-core.c
> +++ b/drivers/hid/hid-core.c
> @@ -1089,8 +1089,7 @@ int hid_input_report(struct hid_device *hid, int type, u8 *data, int size, int i
>                return -1;
>        }
>
> -       buf = kmalloc(sizeof(char) * HID_DEBUG_BUFSIZE,
> -                       interrupt ? GFP_ATOMIC : GFP_KERNEL);
> +       buf = kmalloc(sizeof(char) * HID_DEBUG_BUFSIZE, GFP_ATOMIC);
>
>        if (!buf) {
>                report = hid_get_report(report_enum, data);
> --
> 1.5.6
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>



-- 
Kind regards,
Minchan Kim
