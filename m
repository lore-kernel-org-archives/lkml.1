Return-Path: <linux-kernel-owner+w=401wt.eu-S1755051AbXJ0N2X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755051AbXJ0N2X (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 09:28:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752819AbXJ0N2Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 09:28:16 -0400
Received: from nat-132.atmel.no ([80.232.32.132]:63259 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752079AbXJ0N2Q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 09:28:16 -0400
Date: Sat, 27 Oct 2007 15:28:16 +0200
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: Shannon Nelson <shannon.nelson@intel.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       shannon.nelson@intel.com, greg@kroah.com, dan.j.williams@intel.com
Subject: Re: [PATCH] DMAENGINE: too many kref_put calls
Message-ID: <20071027152816.2d447c70@siona>
In-Reply-To: <20071026235648.5737.45405.stgit@localhost.localdomain>
References: <20071026235648.5737.45405.stgit@localhost.localdomain>
Organization: Atmel
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.12.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Oct 2007 16:56:48 -0700
Shannon Nelson <shannon.nelson@intel.com> wrote:

> @@ -134,8 +134,7 @@ static void dma_async_device_cleanup(struct kref
> *kref); 
>  static void dma_dev_release(struct device *dev)
>  {
> -	struct dma_chan *chan = to_dma_chan(dev);
> -	kref_put(&chan->device->refcount, dma_async_device_cleanup);
> +	return;
>  }

Hmm...what prevents dma_chan_cleanup() from being called while someone
still holds a reference to the "class" device? This will allow the
module removal to proceed, the device to be freed, and things will blow
up...

I think my patch is better. By taking two references, the order in
which the cleanup functions are called doesn't matter -- both have to
complete before the module removal is allowed to proceed.

Håvard
