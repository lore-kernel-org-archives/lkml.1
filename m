Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752591AbYLROeo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752591AbYLROeo (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 09:34:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751790AbYLROeb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 09:34:31 -0500
Received: from mga09.intel.com ([134.134.136.24]:56101 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751660AbYLROea convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 09:34:30 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.36,243,1228118400"; 
   d="scan'208";a="475079768"
From: "Sosnowski, Maciej" <maciej.sosnowski@intel.com>
To: "Williams, Dan J" <dan.j.williams@intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "hskinnemoen@atmel.com" <hskinnemoen@atmel.com>,
        "g.liakhovetski@gmx.de" <g.liakhovetski@gmx.de>,
        "nicolas.ferre@atmel.com" <nicolas.ferre@atmel.com>
Date: Thu, 18 Dec 2008 14:34:18 +0000
Subject: RE: [PATCH 11/13] dmaengine: kill struct dma_client and supporting
 infrastructure
Thread-Topic: [PATCH 11/13] dmaengine: kill struct dma_client and supporting
 infrastructure
Thread-Index: AclfEpW2QtLwhWoSTIOuSph3uJB/LACBprJQ
Message-ID: <129600E5E5FB004392DDC3FB599660D70C984F6E@irsmsx504.ger.corp.intel.com>
References: <20081114213300.32354.1154.stgit@dwillia2-linux.ch.intel.com>
	 <20081114213513.32354.58256.stgit@dwillia2-linux.ch.intel.com>
	 <129600E5E5FB004392DDC3FB599660D70C8F3407@irsmsx504.ger.corp.intel.com>
 <e9c3a7c20812151609k2100fc8et5218e4e1f2336367@mail.gmail.com>
In-Reply-To: <e9c3a7c20812151609k2100fc8et5218e4e1f2336367@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dan Williams wrote:
> On Fri, Dec 12, 2008 at 7:29 AM, Sosnowski, Maciej
> <maciej.sosnowski@intel.com> wrote:
>> Williams, Dan J wrote:
>>> All users have been converted to either the general-purpose
>>> allocator, dma_find_channel, or dma_request_channel.
>>> 
>>> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
>>> ---
>> (...)
>>>  /**
>>> - * dma_chans_notify_available - broadcast available channels to
>>> the clients 
>>> - */
>>> -static void dma_clients_notify_available(void)
>>> -{
>>> -     struct dma_client *client;
>>> -
>>> -     mutex_lock(&dma_list_mutex);
>>> -
>>> -     list_for_each_entry(client, &dma_client_list, global_node)
>>> -             dma_client_chan_alloc(client);
>>> -
>>> -     mutex_unlock(&dma_list_mutex);
>>> -}
>> 
>> I agree with Guennadi's concern about removing clients' notification
>> of new devices available in the system.
>> I understand that this design is based on polling instead,
>> however polling is always less efficient approach.
>> Do you think that restoring notifications in this redesigned
>> dmaengine would be more painful than limiting clients to polling
>> solution? 
>> 
> 
> You are missing that net_dma has always "polled".  Consider the case
> of how net_dma currently operates prior to ioatdma.ko being loaded.
> It periodically calls get_softnet_dma() to see if a channel is
> available, if it does not find one it falls back to a cpu copy.  All
> that has changed is replacing this custom channel allocation routine
> with the unified dma_find_channel() interface.  Channel notifications
> are not required.  Either everything is built-in to guarantee that an
> engine is available upon request[1], or the client is smart enough to
> run without a channel for while like net_dma and raid offload.

My comment here was rather more general than ioatdma/net_dma specific.
You are of course right that net_dma has been always based on polling.
I am rather worrying a bit that this change limits all current and future clients
to polling approach only, not letting them base on notifications anymore.

> 
> Regards,
> Dan
> 
> [1] http://marc.info/?l=linux-kernel&m=122835195303213&w=2

Regards,
Maciej