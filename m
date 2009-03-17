Return-Path: <linux-kernel-owner+w=401wt.eu-S1758076AbZCQEwW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758076AbZCQEwW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 00:52:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751482AbZCQEwO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 00:52:14 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:31219 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751403AbZCQEwN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 00:52:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=vQBQrh13kCqFh5hWGbazCGAEpu4a5k7SQIEGbYjrqyesCwwGLvjEEx4gpyqMIdvWNl
         SEPQQlwZe32ho4biOrq4ZOIxEICqXyhloKVi30r4P2ENNovq0F4gU1ZuS73fHUUEP2/z
         ZiMBvF0BlWwE8YQ17hDwbHu4XNFnd0FhUqJiw=
MIME-Version: 1.0
In-Reply-To: <20090317.112019.147212126.nemoto@toshiba-tops.co.jp>
References: <20090313.011950.61509382.anemo@mba.ocn.ne.jp>
	 <20090313.231659.41197617.anemo@mba.ocn.ne.jp>
	 <1237240246.27945.6.camel@dwillia2-linux.ch.intel.com>
	 <20090317.112019.147212126.nemoto@toshiba-tops.co.jp>
Date: Mon, 16 Mar 2009 21:52:10 -0700
X-Google-Sender-Auth: 3f7286a669fae652
Message-ID: <e9c3a7c20903162152w6b73b4b8hba8004e7b349c447@mail.gmail.com>
Subject: Re: [PATCH 1/2] dmaengine: TXx9 Soc DMA Controller driver
From: Dan Williams <dan.j.williams@intel.com>
To: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: linux-mips@linux-mips.org, ralf@linux-mips.org,
       linux-kernel@vger.kernel.org, haavard.skinnemoen@atmel.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 16, 2009 at 7:20 PM, Atsushi Nemoto <anemo@mba.ocn.ne.jp> wrote:
> On Mon, 16 Mar 2009 14:50:46 -0700, Dan Williams <dan.j.williams@intel.com> wrote:
>> > And above "continue" looks buggy anyway.  Keeping incomplete channels
>> > in device->channels list looks very dangerous...
>>
>> Yes it does.  Here is the proposed fix:
>> ----->
>> dmaengine: fail device registration if channel registration fails
>>
>> From: Dan Williams <dan.j.williams@intel.com>
>>
>> Atsushi points out:
>> "If alloc_percpu or kzalloc failed, chan_id does not match with its
>> position in device->channels list.
>>
>> And above "continue" looks buggy anyway.  Keeping incomplete channels
>> in device->channels list looks very dangerous..."
>>
>> Reported-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
>> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
>
> Thanks, but it seems a hole sill exists.  If alloc_percpu or kzalloc
> for the first channel failed, when idr_ref will be freed ?
>

True, we need a check like the following:

        /* if we never registered a channel just release the idr */
        if (atomic_read(idr_ref) == 0) {
                mutex_lock(&dma_list_mutex);
                idr_remove(&dma_idr, device->dev_id);
                mutex_unlock(&dma_list_mutex);
                kfree(idr_ref);
                return rc;
        }

> Hmm.. why idr_ref is dynamically allocated?  Just putting it in
> dma_device makes thing more simple, no?
>

The sysfs device has a longer lifetime than dma_device.  See commit
41d5e59c [1].

--
Dan

[1] http://git.kernel.org/?p=linux/kernel/git/djbw/async_tx.git;a=commitdiff;h=41d5e59c

> ---
> Atsushi Nemoto
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
