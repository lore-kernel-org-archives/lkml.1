Return-Path: <linux-kernel-owner+w=401wt.eu-S1759105AbXKUKoS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759105AbXKUKoS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 05:44:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753484AbXKUKoG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 05:44:06 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:63093 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753218AbXKUKoF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 05:44:05 -0500
Date: Wed, 21 Nov 2007 11:43:52 +0100
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: "Nelson, Shannon" <shannon.nelson@intel.com>
Cc: "Williams, Dan J" <dan.j.williams@intel.com>,
       <linux-kernel@vger.kernel.org>, "Olof Johansson" <olof@lixom.net>
Subject: Re: [PATCH] dmaengine: Simple DMA memcpy test client
Message-ID: <20071121114352.454c4d05@dhcp-255-175.norway.atmel.com>
In-Reply-To: <BAE9DCEF64577A439B3A37F36F9B691C03752493@orsmsx418.amr.corp.intel.com>
References: <1195558354-23150-1-git-send-email-hskinnemoen@atmel.com>
	<BAE9DCEF64577A439B3A37F36F9B691C03752493@orsmsx418.amr.corp.intel.com>
Organization: Atmel Norway
X-Mailer: Claws Mail 3.1.0-rc1 (GTK+ 2.12.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Nov 2007 09:34:38 -0800
"Nelson, Shannon" <shannon.nelson@intel.com> wrote:

> >-----Original Message-----
> >From: Haavard Skinnemoen [mailto:hskinnemoen@atmel.com] 

> >+#define TEST_BUF_SIZE		(16384)
> 
> You might make this a module parameter so we can test with various
> sizes.

Good idea.

> >+static enum dma_state_client
> >+dmatest_event(struct dma_client *client, struct dma_chan *chan,
> >+		enum dma_state state)
> >+{
> >+	struct dmatest		*test = to_dmatest(client);
> >+	enum dma_state_client	ack = DMA_DUP;
> 
> DMA_NAK is better default for DMA_RESOURCE_AVAILABLE once you've got the
> channel you want, as that will stop DMAEngine from handing you more, and
> doesn't bother the DMA_RESOURCE_REMOVED process.

Right. I'll fix that.

> >+
> >+	spin_lock(&test->lock);
> >+	switch (state) {
> >+	case DMA_RESOURCE_AVAILABLE:
> >+		if (!test->chan) {
> >+			printk(KERN_INFO "dmatest: Got channel %s\n",
> >+				chan->dev.bus_id);
> >+			test->chan = chan;
> >+			wake_up_interruptible(&test->wq);
> >+			ack = DMA_ACK;
> >+		}
> >+		break;
> 
> Do you ever want to test a specific channel?  Is there a way to identify
> specific channels, perhaps by checking the PCI bus/chan/func?  This
> could be useful in debugging specific hardware issues - a frilly extra
> feature and very HW specific, but potentially useful.  I suppose this
> might also depend upon your hardware - is there more than one channel in
> your gizmo?

Yes, my gizmo has three channels, but they're all identical with
respect to the basic memcpy() functionality. I suppose we could add a
module parameter to specify the bus_id of the channel to be tested.

Another nice feature would be to start multiple threads exercising
several channels in parallel. In its current form, this module probably
won't find many hard-to-debug race conditions...

> >+
> >+	case DMA_RESOURCE_REMOVED:
> >+		if (test->chan == chan) {
> 
> Should you use your test->lock here? 

The whole switch() block runs with test->lock held.

> >+			printk(KERN_INFO "dmatest: Lost channel %s\n",
> >+				chan->dev.bus_id);
> >+			test->chan = NULL;
> >+			ack = DMA_ACK;
> >+		}
> >+		break;
> >+
> >+	default:
> 
> Since this is a test program, perhaps a printk() here might be useful...

Yes, probably. Maybe we should even handle suspend/resume as well...

> >+	for (;;) {
> >+		DEFINE_WAIT(chan_wait);
> >+
> >+		pr_debug("dmatest: Waiting for a channel...\n");
> >+		for (;;) {
> >+			spin_lock(&test->lock);
> >+			prepare_to_wait(&test->wq, &chan_wait,
> >+					TASK_UNINTERRUPTIBLE);
> 
> Hmmm - so the only way to trigger the loop is to remove then add a
> channel, basically rmmod and insmod your dma driver?  It would be nice
> to have a method to trigger more than one test, maybe even a stream of
> copy requests.  Or am I asking for too many features?  :-)

No, it will keep going until the channel is removed. It will prepare to
wait, check if it's already got a channel and if so, break out
immediately and run a test. Otherwise, it will call schedule() and wait
for the event callback to wake it up.

> >+			if (kthread_should_stop()) {
> >+				should_stop = true;
> >+				break;
> >+			}
> >+
> >+			if (test->chan) {
> >+				chan = test->chan;
> >+				dma_chan_get(chan);
> 
> I suppose you are doing this extra get and put to be absolutely sure the
> channel doesn't disappear out from under you, even though your
> dmatest_event() already ACK'd the removal, right?

The idea is that when someone attempts to remove a channel in the
middle of a test, the extra dma_chan_get() will make sure that the
channel isn't actually removed until the test is done. The event
callback will set test->chan to NULL, thus putting the thread to sleep
the next time around. It will also ACK the removal, causing the
reference count to drop so that when the currently running test is done
and dma_chan_put() is called, the channel will be released.

I guess we could NAK the removal, but that means we need some way to
signal the thread that it needs to call dma_chan_put() at some point. I
think the current code is nice and symmetric since adding and removing
channels is handled in mostly the same way.

> Thanks for posting this.

Thanks for reviewing :-)

Håvard
