Return-Path: <linux-kernel-owner+w=401wt.eu-S1752403Ab0AKWbl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752403Ab0AKWbl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 17:31:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752245Ab0AKWbj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 17:31:39 -0500
Received: from mail-qy0-f185.google.com ([209.85.221.185]:44899 "EHLO
	mail-qy0-f185.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752192Ab0AKWbh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 17:31:37 -0500
X-Greylist: delayed 475 seconds by postgrey-1.27 at vger.kernel.org; Mon, 11 Jan 2010 17:31:37 EST
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=dmySJEO7I5830j5XLDfT8y1aDG3gFulAQ29+SDWBw6dXn4NZSXWjBl7y/x6VK0rB2+
         qodbRtOKX+Z7DqwLCKhKTSfPUiqxNJFs3Q09Zqv6nATv6MlbOZam+LvvSKWku6Cb7Y0U
         04S/u9KG27PeUPMZdW1QtfQ2YSxae6a2UcoW0=
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1001111550270.6492@axis700.grange>
References: <Pine.LNX.4.64.1001111550270.6492@axis700.grange>
Date: Mon, 11 Jan 2010 15:23:41 -0700
X-Google-Sender-Auth: 5ace39a62229f659
Message-ID: <e9c3a7c21001111423i42b68f1bq661af793dec05f91@mail.gmail.com>
Subject: Re: dmaengine: query current transfer status
From: Dan Williams <dan.j.williams@intel.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-kernel@vger.kernel.org,
       Maciej Sosnowski <maciej.sosnowski@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 11, 2010 at 7:59 AM, Guennadi Liakhovetski
<g.liakhovetski@gmx.de> wrote:
> Hi
>
> I'm using the dmaengine API with an ASoC driver (soon to be submitted),
> and I have to provide a callback to ALSA to query the progress of the
> current transfer (the .pointer() method from struct snd_pcm_ops).
> Currently I only can provide this information with a period size
> precision. Wouldn't it make sense to add an optional hook to dmaengine for
> that? I certainly could add this as a platform-specific extension to the
> specific dmaengine driver, I'm using (shdma), but that'd be ugly. Ideas?
> Specific proposals for the prototype? I could cook up a patch if there are
> no principal objections against this.

No principal objections, but we already have a method for querying the
status of a transaction ->device_is_tx_complete().  I'd rather change
the semantics of this method to return the inflight state of the
operation in addition to the channel's progress.  Perhaps pass in a
pointer to a new dma_tx_info (name?) struct that gets filled in with
the cookie information in addition to the current position of the
operation in question.

Something like:

struct dma_tx_info {
     dma_cookie_t last;
     dma_cookie_t used;
     unsigned long pos;
}

enum dma_status (*device_is_tx_complete)(struct dma_chan *chan,
dma_cookie_t cookie, struct dma_tx_info *info)

--
Dan
