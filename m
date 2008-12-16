Return-Path: <linux-kernel-owner+w=401wt.eu-S1756655AbYLPAJm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756655AbYLPAJm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 19:09:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753706AbYLPAJa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 19:09:30 -0500
Received: from wf-out-1314.google.com ([209.85.200.171]:60793 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753559AbYLPAJ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 19:09:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=KvYk31MPxKPnxlqWF8/ERXbo/MG7U9PR3fGb0xUExi0iOCeKO6tM3JSBthtq0qnfjL
         lM+u2of5PltnmtCoQRydtnaFUyTHu8YZXHjAy7uDN+WEK/G4C2WA+EW+UjTJHKfazmUe
         mceymJI3Hu8BGize9f6OG2zZf6MXfFt2sPCKc=
Message-ID: <e9c3a7c20812151609k2100fc8et5218e4e1f2336367@mail.gmail.com>
Date: Mon, 15 Dec 2008 17:09:27 -0700
From: "Dan Williams" <dan.j.williams@intel.com>
To: "Sosnowski, Maciej" <maciej.sosnowski@intel.com>
Subject: Re: [PATCH 11/13] dmaengine: kill struct dma_client and supporting infrastructure
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "hskinnemoen@atmel.com" <hskinnemoen@atmel.com>,
       "g.liakhovetski@gmx.de" <g.liakhovetski@gmx.de>,
       "nicolas.ferre@atmel.com" <nicolas.ferre@atmel.com>
In-Reply-To: <129600E5E5FB004392DDC3FB599660D70C8F3407@irsmsx504.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081114213300.32354.1154.stgit@dwillia2-linux.ch.intel.com>
	 <20081114213513.32354.58256.stgit@dwillia2-linux.ch.intel.com>
	 <129600E5E5FB004392DDC3FB599660D70C8F3407@irsmsx504.ger.corp.intel.com>
X-Google-Sender-Auth: 01d24fc940b64820
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 12, 2008 at 7:29 AM, Sosnowski, Maciej
<maciej.sosnowski@intel.com> wrote:
> Williams, Dan J wrote:
>> All users have been converted to either the general-purpose allocator,
>> dma_find_channel, or dma_request_channel.
>>
>> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
>> ---
> (...)
>>  /**
>> - * dma_chans_notify_available - broadcast available channels to the
>> clients
>> - */
>> -static void dma_clients_notify_available(void)
>> -{
>> -     struct dma_client *client;
>> -
>> -     mutex_lock(&dma_list_mutex);
>> -
>> -     list_for_each_entry(client, &dma_client_list, global_node)
>> -             dma_client_chan_alloc(client);
>> -
>> -     mutex_unlock(&dma_list_mutex);
>> -}
>
> I agree with Guennadi's concern about removing clients' notification
> of new devices available in the system.
> I understand that this design is based on polling instead,
> however polling is always less efficient approach.
> Do you think that restoring notifications in this redesigned dmaengine
> would be more painful than limiting clients to polling solution?
>

You are missing that net_dma has always "polled".  Consider the case
of how net_dma currently operates prior to ioatdma.ko being loaded.
It periodically calls get_softnet_dma() to see if a channel is
available, if it does not find one it falls back to a cpu copy.  All
that has changed is replacing this custom channel allocation routine
with the unified dma_find_channel() interface.  Channel notifications
are not required.  Either everything is built-in to guarantee that an
engine is available upon request[1], or the client is smart enough to
run without a channel for while like net_dma and raid offload.

Regards,
Dan

[1] http://marc.info/?l=linux-kernel&m=122835195303213&w=2
