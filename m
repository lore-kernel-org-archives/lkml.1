Return-Path: <linux-kernel-owner+w=401wt.eu-S1756775AbYLKQnT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756775AbYLKQnT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 11:43:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756074AbYLKQnI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 11:43:08 -0500
Received: from wf-out-1314.google.com ([209.85.200.174]:50954 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755779AbYLKQnH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 11:43:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=dbXo3YxiSC2wT4210gf+ZqA1oBL3Pyb411RPm/BYpLEj1iNxCQqEVUYK8VXQch8+3/
         m3VlRmZDQnY1MB8o1DOAT2d2DU9CFZnE6ZEbohLHJHkRaH5yqC7hxg5rr+y/7cItXbQR
         7FXf3cVE9vMlJP3+nbIJvkFlDIJXHBV66ZJWo=
Message-ID: <e9c3a7c20812110843p32d768c1k8e119d23b12a5fd0@mail.gmail.com>
Date: Thu, 11 Dec 2008 09:43:05 -0700
From: "Dan Williams" <dan.j.williams@intel.com>
To: "Guennadi Liakhovetski" <g.liakhovetski@gmx.de>
Subject: Re: [PATCH 1/4 v2] dmaengine: add a tx_free method to struct dma_async_tx_descriptor
Cc: linux-kernel@vger.kernel.org, linux-fbdev-devel@lists.sourceforge.net,
       adaplas@gmail.com, "Sascha Hauer" <s.hauer@pengutronix.de>,
       linux-arm-kernel@lists.arm.linux.org.uk
In-Reply-To: <Pine.LNX.4.64.0812111639540.6881@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0812101122250.4578@axis700.grange>
	 <Pine.LNX.4.64.0812101129340.4578@axis700.grange>
	 <e9c3a7c20812101158h3de9c604i1c88bb7c412ccf02@mail.gmail.com>
	 <Pine.LNX.4.64.0812110011440.8273@axis700.grange>
	 <e9c3a7c20812101801r19c8fb40s6b8ce9bd6c565fed@mail.gmail.com>
	 <Pine.LNX.4.64.0812111639540.6881@axis700.grange>
X-Google-Sender-Auth: d211953d82c5ec65
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 11, 2008 at 8:55 AM, Guennadi Liakhovetski
<g.liakhovetski@gmx.de> wrote:
> How does the struct's size impact their cache utilisation then?

Increasing the size may push some fields across a cache-line boundary
leading to an additional cache-lines that need to
filled/kept-coherent/etc...  See pahole:
http://lwn.net/Articles/206805/

>
>> > And you mean, that increasing the size
>> > of the struct by one pointer and letting users explicitly free those
>> > descriptors when they want is worse than introducing a tasklet that will
>> > have to periodically scan the list of descriptors while other hot paths
>> > will move elements to and from this list, look for acked elements, lock
>> > the list and free those elements? Periodically, because although we have
>> > an event when to free them - on ioctl - there is no API to trigger that
>> > tasklet.
>>
>> There are a few events that trigger this: completion interrupt,
>> someone polls is_tx_complete, we run out of descriptors.
>
> Sorry, actually, it's not VIDIOC_DQBUF where we have to free buffer(s),
> it's VIDIOC_STREAMOFF. And in a normal case there are no more completion
> interrupts, no allocation requests, and noone is interested in
> is_tx_complete. Normally you would just get a dma_release_channel after
> that. Or, of course, the application may decide to restart capture, then
> we get requests, completions, etc. again. So, yes, I could do this, it
> just seems a bit unnatural to me.

Could the application tolerate another call to dma_request_channel
when it restarts?  I.e. just call dma_release_channel from the ioctl
to clean everything up and not worry about another free() mechanism?

Thanks,
Dan
