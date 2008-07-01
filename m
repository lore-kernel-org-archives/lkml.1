Return-Path: <linux-kernel-owner+w=401wt.eu-S1758060AbYGANoR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758060AbYGANoR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 09:44:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757596AbYGANnz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 09:43:55 -0400
Received: from mga09.intel.com ([134.134.136.24]:30837 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756986AbYGANnx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 09:43:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,731,1204531200"; 
   d="scan'208";a="301447007"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] dmatest: Simple DMA memcpy test client
Date: Tue, 1 Jul 2008 14:43:10 +0100
Message-ID: <7F38996F7185A24AB9071ED4950AD8C101C21EB2@swsmsx413.ger.corp.intel.com>
In-Reply-To: <f12847240806270219g29393497kea78dba6e3d66d8@mail.gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] dmatest: Simple DMA memcpy test client
thread-index: AcjYNt17KIjhCiCzRrmkFlrrVg6RogDRig8Q
From: "Sosnowski, Maciej" <maciej.sosnowski@intel.com>
To: <haavard.skinnemoen@atmel.com>
Cc: "Williams, Dan J" <dan.j.williams@intel.com>,
       "lkml" <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 01 Jul 2008 13:43:12.0022 (UTC) FILETIME=[6795B360:01C8DB80]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> ---------- Original message ----------
> From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
> Date: Jun 25, 2008 2:19 PM
> Subject: [PATCH] dmatest: Simple DMA memcpy test client
> To: Dan Williams <dan.j.williams@intel.com>
> Cc: linux-kernel@vger.kernel.org, Haavard Skinnemoen
<hskinnemoen@atmel.com>
> 
> 
> From: Haavard Skinnemoen <hskinnemoen@atmel.com>
> 
> This client tests DMA memcpy using various lengths and various offsets
> into the source and destination buffers. It will initialize both
> buffers with a repeatable pattern and verify that the DMA engine
copies
> the requested region and nothing more. It will also verify that the
> bytes aren't swapped around, and that the source buffer isn't
modified.
> 
> The dmatest module can be configured to test a specific device, a
> specific channel. It can also test multiple channels at the same time,
> and it can start multiple threads competing for the same channel.
> 
> Signed-off-by: Haavard Skinnemoen <hskinnemoen@atmel.com>
> 
> Changes since v2:
>  * Support testing multiple channels at the same time
>  * Support testing with multiple threads competing for the same
channel
>  * Use counting test patterns in order to catch byte ordering issues
> 
> Changes since v1:
>  * Remove extra dashes around "help"
>  * Remove "default n" from Kconfig
>  * Turn TEST_BUF_SIZE into a module parameter
>  * Return DMA_NAK instead of DMA_DUP
>  * Print unhandled events
>  * Support testing specific channels and devices
>  * Move to the end of the Makefile

With one comment below the patch looks fine to me.

Acked-by: Maciej Sosnowski <maciej.sosnowski@intel.com>

> ---
>  drivers/dma/Kconfig   |    7 +
>  drivers/dma/Makefile  |    1 +
>  drivers/dma/dmatest.c |  444
>  +++++++++++++++++++++++++++++++++++++++++++++++++ 3 files changed,
452
>  insertions(+), 0 deletions(-) create mode 100644
drivers/dma/dmatest.c
> 
> diff --git a/drivers/dma/Kconfig b/drivers/dma/Kconfig
> index 6239c3d..18f6ef3 100644
> --- a/drivers/dma/Kconfig
> +++ b/drivers/dma/Kconfig
> @@ -61,4 +61,11 @@ config NET_DMA
>          Since this is the main user of the DMA engine, it should be
enabled;
>          say Y here.
> 
> +config DMATEST
> +       tristate "DMA Test client"
> +       depends on DMA_ENGINE
> +       help
> +         Simple DMA test client. Say N unless you're debugging a
> +         DMA Device driver.
> +
>  endif
> diff --git a/drivers/dma/Makefile b/drivers/dma/Makefile
> index c8036d9..2ff6d7f 100644
> --- a/drivers/dma/Makefile
> +++ b/drivers/dma/Makefile
> @@ -4,3 +4,4 @@ obj-$(CONFIG_INTEL_IOATDMA) += ioatdma.o
>  ioatdma-objs := ioat.o ioat_dma.o ioat_dca.o
>  obj-$(CONFIG_INTEL_IOP_ADMA) += iop-adma.o
>  obj-$(CONFIG_FSL_DMA) += fsldma.o
> +obj-$(CONFIG_DMATEST) += dmatest.o
> diff --git a/drivers/dma/dmatest.c b/drivers/dma/dmatest.c
> new file mode 100644
> index 0000000..5c9fd10
> --- /dev/null
> +++ b/drivers/dma/dmatest.c
> @@ -0,0 +1,444 @@
> +/*
> + * DMA Engine test module
> + *
> + * Copyright (C) 2007 Atmel Corporation
> + *
> + * This program is free software; you can redistribute it and/or
modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +#include <linux/delay.h>
> +#include <linux/dmaengine.h>
> +#include <linux/init.h>
> +#include <linux/kthread.h>
> +#include <linux/module.h>
> +#include <linux/moduleparam.h>
> +#include <linux/random.h>
> +#include <linux/wait.h>
> +
> +static unsigned int test_buf_size = 16384;
> +module_param(test_buf_size, uint, S_IRUGO);
> +MODULE_PARM_DESC(test_buf_size, "Size of the memcpy test buffer");
> +
> +static char test_channel[BUS_ID_SIZE];
> +module_param_string(channel, test_channel, sizeof(test_channel),
S_IRUGO);
> +MODULE_PARM_DESC(channel, "Bus ID of the channel to test (default:
any)");
> +
> +static char test_device[BUS_ID_SIZE];
> +module_param_string(device, test_device, sizeof(test_device),
S_IRUGO);
> +MODULE_PARM_DESC(device, "Bus ID of the DMA Engine to test (default:
any)");
> +
> +static unsigned int threads_per_chan = 1;
> +module_param(threads_per_chan, uint, S_IRUGO);
> +MODULE_PARM_DESC(threads_per_chan,
> +               "Number of threads to start per channel (default:
1)");
> +
> +static unsigned int max_channels;
> +module_param(max_channels, uint, S_IRUGO);
> +MODULE_PARM_DESC(nr_channels,
> +               "Maximum number of channels to use (default: all)");
> +
> +/*
> + * Initialization patterns. All bytes in the source buffer has bit 7
> + * set, all bytes in the destination buffer has bit 7 cleared.
> + *
> + * Bit 6 is set for all bytes which are to be copied by the DMA
> + * engine. Bit 5 is set for all bytes which are to be overwritten by
> + * the DMA engine.
> + *
> + * The remaining bits are the inverse of a counter which increments
by
> + * one for each byte address.
> + */
> +#define PATTERN_SRC            0x80
> +#define PATTERN_DST            0x00
> +#define PATTERN_COPY           0x40
> +#define PATTERN_OVERWRITE      0x20
> +#define PATTERN_COUNT_MASK     0x1f
> +
> +struct dmatest_thread {
> +       struct list_head        node;
> +       struct task_struct      *task;
> +       struct dma_chan         *chan;
> +       u8                      *srcbuf;
> +       u8                      *dstbuf;
> +};
> +
> +struct dmatest_chan {
> +       struct list_head        node;
> +       struct dma_chan         *chan;
> +       struct list_head        threads;
> +};
> +
> +/*
> + * These are protected by dma_list_mutex since they're only used by
> + * the DMA client event callback
> + */
> +static LIST_HEAD(dmatest_channels);
> +static unsigned int nr_channels;
> +
> +static bool dmatest_match_channel(struct dma_chan *chan)
> +{
> +       if (test_channel[0] == '\0')
> +               return true;
> +       return strcmp(chan->dev.bus_id, test_channel) == 0;
> +}
> +
> +static bool dmatest_match_device(struct dma_device *device)
> +{
> +       if (test_device[0] == '\0')
> +               return true;
> +       return strcmp(device->dev->bus_id, test_device) == 0;
> +}
> +
> +static unsigned long dmatest_random(void)
> +{
> +       unsigned long buf;
> +
> +       get_random_bytes(&buf, sizeof(buf));
> +       return buf;
> +}
> +
> +static void dmatest_init_srcbuf(u8 *buf, unsigned int start, unsigned
int
> len) +{
> +       unsigned int i;
> +
> +       for (i = 0; i < start; i++)
> +               buf[i] = PATTERN_SRC | (~i & PATTERN_COUNT_MASK);
> +       for ( ; i < start + len; i++)
> +               buf[i] = PATTERN_SRC | PATTERN_COPY
> +                       | (~i & PATTERN_COUNT_MASK);;
> +       for ( ; i < test_buf_size; i++)
> +               buf[i] = PATTERN_SRC | (~i & PATTERN_COUNT_MASK);
> +}
> +
> +static void dmatest_init_dstbuf(u8 *buf, unsigned int start, unsigned
int
> len) +{
> +       unsigned int i;
> +
> +       for (i = 0; i < start; i++)
> +               buf[i] = PATTERN_DST | (~i & PATTERN_COUNT_MASK);
> +       for ( ; i < start + len; i++)
> +               buf[i] = PATTERN_DST | PATTERN_OVERWRITE
> +                       | (~i & PATTERN_COUNT_MASK);
> +       for ( ; i < test_buf_size; i++)
> +               buf[i] = PATTERN_DST | (~i & PATTERN_COUNT_MASK);
> +}
> +
> +static void dmatest_mismatch(u8 actual, u8 pattern, unsigned int
index,
> +               unsigned int counter, bool is_srcbuf)
> +{
> +       u8              diff = actual ^ pattern;
> +       u8              expected = pattern | (~counter &
PATTERN_COUNT_MASK);
> +       const char      *thread_name = current->comm;
> +
> +       if (is_srcbuf)
> +               pr_warning("%s: srcbuf[0x%x] overwritten!"
> +                               " Expected %02x, got %02x\n",
> +                               thread_name, index, expected, actual);
> +       else if ((pattern & PATTERN_COPY)
> +                       && (diff & (PATTERN_COPY |
PATTERN_OVERWRITE)))
> +               pr_warning("%s: dstbuf[0x%x] not copied!"
> +                               " Expected %02x, got %02x\n",
> +                               thread_name, index, expected, actual);
> +       else if (diff & PATTERN_SRC)
> +               pr_warning("%s: dstbuf[0x%x] was copied!"
> +                               " Expected %02x, got %02x\n",
> +                               thread_name, index, expected, actual);
> +       else
> +               pr_warning("%s: dstbuf[0x%x] mismatch!"
> +                               " Expected %02x, got %02x\n",
> +                               thread_name, index, expected, actual);
> +}
> +
> +static unsigned int dmatest_verify(u8 *buf, unsigned int start,
> +               unsigned int end, unsigned int counter, u8 pattern,
> +               bool is_srcbuf)
> +{
> +       unsigned int i;
> +       unsigned int error_count = 0;
> +       u8 actual;
> +
> +       for (i = start; i < end; i++) {
> +               actual = buf[i];
> +               if (actual != (pattern | (~counter &
PATTERN_COUNT_MASK))) {
> +                       if (error_count < 32)
> +                               dmatest_mismatch(actual, pattern, i,
counter,
> +                                               is_srcbuf);
> +                       error_count++;
> +               }
> +               counter++;
> +       }
> +
> +       if (error_count > 32)
> +               pr_warning("%s: %u errors suppressed\n",
> +                       current->comm, error_count - 32);
> +
> +       return error_count;
> +}
> +
> +/*
> + * This function repeatedly tests DMA transfers of various lengths
and
> + * offsets until it is told to exit by kthread_stop(). There may be
> + * multiple threads running this function in parallel for a single
> + * channel, and there may be multiple channels being tested in
> + * parallel.
> + *
> + * Before each test, the source and destination buffer is initialized
> + * with a known pattern. This pattern is different depending on
> + * whether it's in an area which is supposed to be copied or
> + * overwritten, and different in the source and destination buffers.
> + * So if the DMA engine doesn't copy exactly what we tell it to copy,
> + * we'll notice.
> + */
> +static int dmatest_func(void *data)
> +{
> +       struct dmatest_thread   *thread = data;
> +       struct dma_chan         *chan;
> +       const char              *thread_name;
> +       unsigned int            src_off, dst_off, len;
> +       unsigned int            error_count;
> +       unsigned int            failed_tests = 0;
> +       unsigned int            total_tests = 0;
> +       dma_cookie_t            cookie;
> +       enum dma_status         status;
> +       int                     ret;
> +
> +       thread_name = current->comm;
> +
> +       ret = -ENOMEM;
> +       thread->srcbuf = kmalloc(test_buf_size, GFP_KERNEL);
> +       if (!thread->srcbuf)
> +               goto err_srcbuf;
> +       thread->dstbuf = kmalloc(test_buf_size, GFP_KERNEL);
> +       if (!thread->dstbuf)
> +               goto err_dstbuf;
> +
> +       smp_rmb();
> +       chan = thread->chan;
> +       dma_chan_get(chan);
> +
> +       while (!kthread_should_stop()) {
> +               total_tests++;
> +
> +               len = dmatest_random() % test_buf_size + 1;
> +               src_off = dmatest_random() % (test_buf_size - len +
1);
> +               dst_off = dmatest_random() % (test_buf_size - len +
1);
> +
> +               dmatest_init_srcbuf(thread->srcbuf, src_off, len);
> +               dmatest_init_dstbuf(thread->dstbuf, dst_off, len);
> +
> +               cookie = dma_async_memcpy_buf_to_buf(chan,
> +                               thread->dstbuf + dst_off,
> +                               thread->srcbuf + src_off,
> +                               len);
> +               if (dma_submit_error(cookie)) {
> +                       pr_warning("%s: #%u: submit error %d with
> src_off=0x%x " +                                       "dst_off=0x%x
> len=0x%x\n", +                                       thread_name,
total_tests
> - 1, cookie, +                                       src_off, dst_off,
len);
> +                       msleep(100);
> +                       failed_tests++;
> +                       continue;
> +               }
> +               dma_async_memcpy_issue_pending(chan);
> +
> +               do {
> +                       msleep(1);
> +                       status = dma_async_memcpy_complete(
> +                                       chan, cookie, NULL, NULL);
> +               } while (status == DMA_IN_PROGRESS);
> +
> +               if (status == DMA_ERROR) {
> +                       pr_warning("%s: #%u: error during copy\n",
> +                                       thread_name, total_tests - 1);
> +                       failed_tests++;
> +                       continue;
> +               }
> +
> +               error_count = 0;
> +
> +               pr_debug("%s: verifying source buffer...\n",
thread_name);
> +               error_count += dmatest_verify(thread->srcbuf, 0,
src_off,
> +                               0, PATTERN_SRC, true);
> +               error_count += dmatest_verify(thread->srcbuf, src_off,
> +                               src_off + len, src_off,
> +                               PATTERN_SRC | PATTERN_COPY, true);
> +               error_count += dmatest_verify(thread->srcbuf, src_off
+ len,
> +                               test_buf_size, src_off + len,
> +                               PATTERN_SRC, true);
> +
> +               pr_debug("%s: verifying dest buffer...\n",
> +                               thread->task->comm);
> +               error_count += dmatest_verify(thread->dstbuf, 0,
dst_off,
> +                               0, PATTERN_DST, false);
> +               error_count += dmatest_verify(thread->dstbuf, dst_off,
> +                               dst_off + len, src_off,
> +                               PATTERN_SRC | PATTERN_COPY, false);
> +               error_count += dmatest_verify(thread->dstbuf, dst_off
+ len,
> +                               test_buf_size, dst_off + len,
> +                               PATTERN_DST, false);
> +
> +               if (error_count) {
> +                       pr_warning("%s: #%u: %u errors with "
> +                               "src_off=0x%x dst_off=0x%x
len=0x%x\n",
> +                               thread_name, total_tests - 1,
error_count,
> +                               src_off, dst_off, len);
> +                       failed_tests++;
> +               } else {
> +                       pr_debug("%s: #%u: No errors with "
> +                               "src_off=0x%x dst_off=0x%x
len=0x%x\n",
> +                               thread_name, total_tests - 1,
> +                               src_off, dst_off, len);
> +               }
> +       }
> +
> +       ret = 0;
> +       dma_chan_put(chan);
> +       kfree(thread->dstbuf);
> +err_dstbuf:
> +       kfree(thread->srcbuf);
> +err_srcbuf:
> +       pr_notice("%s: terminating after %u tests, %u failures (status
%d)\n",
> +                       thread_name, total_tests, failed_tests, ret);
> +       return ret;
> +}
> +
> +static void dmatest_cleanup_channel(struct dmatest_chan *dtc)
> +{
> +       struct dmatest_thread   *thread;
> +       struct dmatest_thread   *_thread;
> +       int                     ret;
> +
> +       list_for_each_entry_safe(thread, _thread, &dtc->threads, node)
{
> +               ret = kthread_stop(thread->task);
> +               pr_debug("dmatest: thread %s exited with status %d\n",
> +                               thread->task->comm, ret);
> +               list_del(&thread->node);
> +               kfree(thread);
> +       }
> +       kfree(dtc);
> +}
> +
> +static enum dma_state_client dmatest_add_channel(struct dma_chan
*chan)
> +{
> +       struct dmatest_chan     *dtc;
> +       struct dmatest_thread   *thread;
> +       unsigned int            i;
> +
> +       dtc = kmalloc(sizeof(struct dmatest_chan), GFP_ATOMIC);
> +       if (!dtc) {
> +               pr_warning("dmatest: No memory for %s\n",
chan->dev.bus_id);
> +               return DMA_NAK;
> +       }
> +
> +       dtc->chan = chan;
> +       INIT_LIST_HEAD(&dtc->threads);
> +
> +       for (i = 0; i < threads_per_chan; i++) {
> +               thread = kzalloc(sizeof(struct dmatest_thread),
GFP_KERNEL);
> +               if (!thread) {
> +                       pr_warning("dmatest: No memory for
%s-test%u\n",
> +                                       chan->dev.bus_id, i);
> +                       break;
> +               }
> +               thread->chan = dtc->chan;
> +               smp_wmb();
> +               thread->task = kthread_run(dmatest_func, thread,
"%s-test%u",
> +                               chan->dev.bus_id, i);
> +               if (IS_ERR(thread->task)) {
> +                       pr_warning("dmatest: Failed to run thread
> %s-test%u\n", +
chan->dev.bus_id, i);
> +                       kfree(thread);
> +                       break;
> +               }
> +
> +               /* srcbuf and dstbuf are allocated by the thread
itself */
> +
> +               list_add_tail(&thread->node, &dtc->threads);
> +       }
> +
> +       pr_info("dmatest: Started %u threads using %s\n", i,
> chan->dev.bus_id); +
> +       list_add_tail(&dtc->node, &dmatest_channels);
> +       nr_channels++;
> +
> +       return DMA_ACK;
> +}
> +
> +static enum dma_state_client dmatest_remove_channel(struct dma_chan
*chan)
> +{
> +       struct dmatest_chan     *dtc, *_dtc;
> +
> +       list_for_each_entry_safe(dtc, _dtc, &dmatest_channels, node) {
> +               if (dtc->chan == chan) {
> +                       list_del(&dtc->node);
> +                       dmatest_cleanup_channel(dtc);
> +                       pr_debug("dmatest: lost channel %s\n",
> +                                       chan->dev.bus_id);
> +                       return DMA_ACK;
> +               }
> +       }
> +
> +       return DMA_DUP;
> +}
> +
> +/*
> + * Start testing threads as new channels are assigned to us, and kill
> + * them when the channels go away.
> + *
> + * When we unregister the client, all channels are removed so this
> + * will also take care of cleaning things up when the module is
> + * unloaded.
> + */
> +static enum dma_state_client
> +dmatest_event(struct dma_client *client, struct dma_chan *chan,
> +               enum dma_state state)
> +{
> +       enum dma_state_client   ack = DMA_NAK;
> +
> +       switch (state) {
> +       case DMA_RESOURCE_AVAILABLE:
> +               if (dmatest_match_channel(chan)
> +                               && dmatest_match_device(chan->device)
> +                               && (!max_channels
> +                                       || nr_channels <
max_channels))
> +                       ack = dmatest_add_channel(chan);
> +               else
> +                       ack = DMA_DUP;
> +               break;

In case when nr_channels exceeds max_channels 
ack should be rather set to DMA_NAK than DMA_DUP.

> +
> +       case DMA_RESOURCE_REMOVED:
> +               ack = dmatest_remove_channel(chan);
> +               break;
> +
> +       default:
> +               pr_info("dmatest: Unhandled event %u (%s)\n",
> +                               state, chan->dev.bus_id);
> +               break;
> +       }
> +
> +       return ack;
> +}
> +
> +static struct dma_client dmatest_client = {
> +       .event_callback = dmatest_event,
> +};
> +
> +static int __init dmatest_init(void)
> +{
> +       dma_cap_set(DMA_MEMCPY, dmatest_client.cap_mask);
> +       dma_async_client_register(&dmatest_client);
> +       dma_async_client_chan_request(&dmatest_client);
> +
> +       return 0;
> +}
> +module_init(dmatest_init);
> +
> +static void __exit dmatest_exit(void)
> +{
> +       dma_async_client_unregister(&dmatest_client);
> +}
> +module_exit(dmatest_exit);
> +
> +MODULE_AUTHOR("Haavard Skinnemoen <hskinnemoen@atmel.com>");
> +MODULE_LICENSE("GPL v2");
> --
> 1.5.5.4

