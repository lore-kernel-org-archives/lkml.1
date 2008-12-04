Return-Path: <linux-kernel-owner+w=401wt.eu-S1758466AbYLDSwS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758466AbYLDSwS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 13:52:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756002AbYLDSv4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 13:51:56 -0500
Received: from yw-out-2324.google.com ([74.125.46.31]:15834 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755880AbYLDSvz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 13:51:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=oU8FhmRz5b8rnRr5GspwBVTiGYpmnfMIuus8w0IJyWHbVbeiREVu7qWyOqj7Rl7l0I
         TuKcqeN80yNuRNsHSViPmqfIEPEQqyT+CNwNY+6oS24p9CczrryEkfiYOOe5KltDX044
         cs+BrQ1p1Xj70q97qgnWgS4lc1VGUIP2uJbL0=
Message-ID: <e9c3a7c20812041051l44bd8086o97c12d77a116f62@mail.gmail.com>
Date: Thu, 4 Dec 2008 11:51:53 -0700
From: "Dan Williams" <dan.j.williams@intel.com>
To: "Guennadi Liakhovetski" <g.liakhovetski@gmx.de>
Subject: Re: [PATCH 03/13] dmaengine: up-level reference counting to the module level
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       maciej.sosnowski@intel.com, hskinnemoen@atmel.com,
       nicolas.ferre@atmel.com
In-Reply-To: <Pine.LNX.4.64.0812041746400.5079@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081114213300.32354.1154.stgit@dwillia2-linux.ch.intel.com>
	 <20081114213432.32354.2427.stgit@dwillia2-linux.ch.intel.com>
	 <Pine.LNX.4.64.0812041746400.5079@axis700.grange>
X-Google-Sender-Auth: beeaf46455fafbae
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 4, 2008 at 9:56 AM, Guennadi Liakhovetski
<g.liakhovetski@gmx.de> wrote:
>> +
>> +     /* try to grab channels */
>> +     list_for_each_entry_safe(device, _d, &dma_device_list, global_node)
>> +             list_for_each_entry(chan, &device->channels, device_node) {
>> +                     err = dma_chan_get(chan);
>
> Dan, could you please explain this: dma_chan_get() takes a reference on
> the channel _and_ calls .device_alloc_chan_resources() on first invocation
> for a specific channel. I now see three locations in dmaengine.c, where
> dma_chan_get() is called: in dma_request_channel() - logical, but also in
> dmaengine_get() and dma_async_device_register(), and these latter two I
> don't understand. I do not understand why we have to grab references and
> allocate resources for all (public) channels on all controllers in the
> system if someone just called dmaengine_get()?

Consider the case where a subsystem that consumes engines like
async_tx or net_dma loads before engines are available in the system.
They will have taken a reference against dmaengine, but calls to
dma_find_channel will return NULL.  Once a channel driver is loaded
dma_find_channel() can start returning results, and it is at this
point that resources must be allocated and the backing module pinned.
So dmaengine_get() means "I am interested in offloading stuff, if you
see an offload resource grab it and prep it so I can discover it with
dma_find_channel()".

>
>> @@ -420,6 +443,19 @@ int dma_async_device_register(struct dma_device *device)
>>       }
>>
>>       mutex_lock(&dma_list_mutex);
>> +     list_for_each_entry(chan, &device->channels, device_node) {
>> +             /* if clients are already waiting for channels we need to
>> +              * take references on their behalf
>> +              */
>> +             if (dmaengine_ref_count && dma_chan_get(chan) == -ENODEV) {
>> +                     /* note we can only get here for the first
>> +                      * channel as the remaining channels are
>> +                      * guaranteed to get a reference
>> +                      */
>
> This is the second location - where and how are clients waiting for
> channels? In the old implementation clients had notification callbacks,
> which were called as new channels became available. Now clients are gone,
> so, what is meant here?
>

The assumption is that mem-to-mem offload clients poll dma_find_channel().

Regards,
Dan
