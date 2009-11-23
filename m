Return-Path: <linux-kernel-owner+w=401wt.eu-S1757240AbZKWLcL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757240AbZKWLcL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 06:32:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757174AbZKWLcL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 06:32:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:7534 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757048AbZKWLcK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 06:32:10 -0500
Message-ID: <4B0A72AF.80702@redhat.com>
Date: Mon, 23 Nov 2009 13:31:59 +0200
From: Vadim Rozenfeld <vrozenfe@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: dlaor@redhat.com
CC: "Michael S. Tsirkin" <mst@redhat.com>,
       Anthony Liguori <aliguori@us.ibm.com>, qemu-devel@nongnu.org,
       linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
       Avi Kivity <avi@redhat.com>, Adam Litke <agl@us.ibm.com>
Subject: Re: [Qemu-devel] Re: virtio: Add memory statistics reporting to the
 balloon driver (V3)
References: <1258643169.3464.3.camel@aglitke> <1258643945.3464.5.camel@aglitke>	<20091123094425.GB3748@redhat.com> <4B0A6B59.6030102@redhat.com>
In-Reply-To: <4B0A6B59.6030102@redhat.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/23/2009 01:00 PM, Dor Laor wrote:
> On 11/23/2009 11:44 AM, Michael S. Tsirkin wrote:
>> On Thu, Nov 19, 2009 at 09:19:05AM -0600, Adam Litke wrote:
>>> Rusty and Anthony,
>>> If I've addressed all outstanding issues, please consider this patch 
>>> for
>>> inclusion.  Thanks.
>>>
>>> Changes since V2:
>>>   - Increase stat field size to 64 bits
>>>   - Report all sizes in kb (not pages)
>>>   - Drop anon_pages stat and fix endianness conversion
>>>
>>> Changes since V1:
>>>   - Use a virtqueue instead of the device config space
>>>
>>> When using ballooning to manage overcommitted memory on a host, a 
>>> system for
>>> guests to communicate their memory usage to the host can provide 
>>> information
>>> that will minimize the impact of ballooning on the guests.  The 
>>> current method
>>> employs a daemon running in each guest that communicates memory 
>>> statistics to a
>>> host daemon at a specified time interval.  The host daemon 
>>> aggregates this
>>> information and inflates and/or deflates balloons according to the 
>>> level of
>>> host memory pressure.  This approach is effective but overly complex 
>>> since a
>>> daemon must be installed inside each guest and coordinated to 
>>> communicate with
>>> the host.  A simpler approach is to collect memory statistics in the 
>>> virtio
>>> balloon driver and communicate them directly to the hypervisor.
>>>
>>> This patch enables the guest-side support by adding stats collection 
>>> and
>>> reporting to the virtio balloon driver.
>>>
>>> Signed-off-by: Adam Litke<agl@us.ibm.com>
>>> Cc: Rusty Russell<rusty@rustcorp.com.au>
>>> Cc: Anthony Liguori<anthony@codemonkey.ws>
>>> Cc: virtualization@lists.linux-foundation.org
>>> Cc: linux-kernel@vger.kernel.org
>>
>> that's pretty clean. some comments: I wrote them while off-line, and now
>> that I was going to send it out, I see that there's some overlap with
>> what Rusty wrote.  Still, here it is:
>>
>>> diff --git a/drivers/virtio/virtio_balloon.c 
>>> b/drivers/virtio/virtio_balloon.c
>>> index 200c22f..ebc9d39 100644
>>> --- a/drivers/virtio/virtio_balloon.c
>>> +++ b/drivers/virtio/virtio_balloon.c
>>> @@ -29,7 +29,7 @@
>>>   struct virtio_balloon
>>>   {
>>>       struct virtio_device *vdev;
>>> -    struct virtqueue *inflate_vq, *deflate_vq;
>>> +    struct virtqueue *inflate_vq, *deflate_vq, *stats_vq;
>>>
>>>       /* Where the ballooning thread waits for config to change. */
>>>       wait_queue_head_t config_change;
>>> @@ -50,6 +50,9 @@ struct virtio_balloon
>>>       /* The array of pfns we tell the Host about. */
>>>       unsigned int num_pfns;
>>>       u32 pfns[256];
>>> +
>>> +    /* Memory statistics */
>>> +    struct virtio_balloon_stat stats[VIRTIO_BALLOON_S_NR];
>>>   };
>>>
>>>   static struct virtio_device_id id_table[] = {
>>> @@ -155,6 +158,57 @@ static void leak_balloon(struct virtio_balloon 
>>> *vb, size_t num)
>>>       }
>>>   }
>>>
>>> +static inline void update_stat(struct virtio_balloon *vb, int idx,
>>> +                __le16 tag, __le64 val)
>>> +{
>>> +    BUG_ON(idx>= VIRTIO_BALLOON_S_NR);
>>> +    vb->stats[idx].tag = cpu_to_le16(tag);
>>> +    vb->stats[idx].val = cpu_to_le64(val);
>>
>> you should do le16_to_cpu etc on __le values.
>> Try running this patch through sparce checker.
>>
>>> +}
>>> +
>>> +#define K(x) ((x)<<  (PAGE_SHIFT - 10))
>>
>> can't this overflow?
>> also, won't it be simpler to just report memory is
>> in bytes, then just x * PAGE_SIZE instead of hairy constants?
>>
>>> +static void update_balloon_stats(struct virtio_balloon *vb)
>>> +{
>>> +    unsigned long events[NR_VM_EVENT_ITEMS];
>>
>> that's about 1/2K worth of stack space on a 64 bit machine.
>> better keep it as part of struct virtio_balloon.
>>
>>> +    struct sysinfo i;
>>> +    int idx = 0;
>>> +
>>> +    all_vm_events(events);
>>> +    si_meminfo(&i);
>>> +
>>> +    update_stat(vb, idx++, VIRTIO_BALLOON_S_SWAP_IN, 
>>> K(events[PSWPIN]));
>>> +    update_stat(vb, idx++, VIRTIO_BALLOON_S_SWAP_OUT, 
>>> K(events[PSWPOUT]));
>>> +    update_stat(vb, idx++, VIRTIO_BALLOON_S_MAJFLT, 
>>> events[PGMAJFAULT]);
>>> +    update_stat(vb, idx++, VIRTIO_BALLOON_S_MINFLT, events[PGFAULT]);
>>> +    update_stat(vb, idx++, VIRTIO_BALLOON_S_MEMFREE, K(i.freeram));
>>> +    update_stat(vb, idx++, VIRTIO_BALLOON_S_MEMTOT, K(i.totalram));
>
>
> Finally I found some data from our M$ neighbors. This is from 
> http://www.microsoft.com/whdc/system/sysperf/Perf_tun_srv-R2.mspx
>
> "When running Windows in the child partition, you can use the 
> following performance counters within a child partition to identify 
> whether the child partition is experiencing memory pressure and is 
> likely to perform better with a higher VM memory size:
>
> Memory – Standby Cache Reserve Bytes:
> Sum of Standby Cache Reserve Bytes and Free and Zero Page List Bytes 
> should be 200 MB or more on systems with 1 GB, and 300 MB or more on 
> systems with 2 GB or more of visible RAM.
>
> Memory – Free & Zero Page List Bytes:
> Sum of Standby Cache Reserve Bytes and Free and Zero Page List Bytes 
> should be 200 MB or more on systems with 1 GB, and 300 MB or more on 
> systems with 2 GB or more of visible RAM.
>
> Memory – Pages Input/Sec:
> Average over a 1-hour period is less than 10.
> "
>
> The biggest take out of it is that we may get #0-pages in windows.
> It's valuable information for the host since KSM will collapse all of 
> them anyway, so there is not point in ballooning them.
> Vadim, can you check if we can extract it from windows?
We can do it from kernel mode by calling ZwQuerySystemInformation 
function. But unfortunately SystemPerformanceInformation class is not 
documented anywhere, except for Gary Nebbet book.
It could be easier to query performance counters from user mode (say, 
some sort of very light service) and pass the information down to 
balloon driver.
Using WMI could be another option, but I need to check whether we can 
read performance  counters from WMI provider at kernel level.
>
>>> +}
>>> +
>>> +/*
>>> + * While most virtqueues communicate guest-initiated requests to 
>>> the hypervisor,
>>> + * the stats queue operates in reverse.  The driver initializes the 
>>> virtqueue
>>> + * with a single buffer.  From that point forward, all 
>>> conversations consist of
>>> + * a hypervisor request (a call to this function) which directs us 
>>> to refill
>>> + * the virtqueue with a fresh stats buffer.
>>> + */
>>> +static void stats_ack(struct virtqueue *vq)
>>> +{
>>> +    struct virtio_balloon *vb;
>>> +    unsigned int len;
>>> +    struct scatterlist sg;
>>> +
>>> +    vb = vq->vq_ops->get_buf(vq,&len);
>>> +    if (!vb)
>>> +        return;
>>> +
>>> +    update_balloon_stats(vb);
>>> +
>>> +    sg_init_one(&sg, vb->stats, sizeof(vb->stats));
>>> +    if (vq->vq_ops->add_buf(vq,&sg, 1, 0, vb)<  0)
>>> +        BUG();
>>> +    vq->vq_ops->kick(vq);
>>> +}
>>> +
>>>   static void virtballoon_changed(struct virtio_device *vdev)
>>>   {
>>>       struct virtio_balloon *vb = vdev->priv;
>>> @@ -205,10 +259,10 @@ static int balloon(void *_vballoon)
>>>   static int virtballoon_probe(struct virtio_device *vdev)
>>>   {
>>>       struct virtio_balloon *vb;
>>> -    struct virtqueue *vqs[2];
>>> -    vq_callback_t *callbacks[] = { balloon_ack, balloon_ack };
>>> -    const char *names[] = { "inflate", "deflate" };
>>> -    int err;
>>> +    struct virtqueue *vqs[3];
>>> +    vq_callback_t *callbacks[] = { balloon_ack, balloon_ack, 
>>> stats_ack };
>>> +    const char *names[] = { "inflate", "deflate", "stats" };
>>> +    int err, nvqs;
>>>
>>>       vdev->priv = vb = kmalloc(sizeof(*vb), GFP_KERNEL);
>>>       if (!vb) {
>>> @@ -221,13 +275,28 @@ static int virtballoon_probe(struct 
>>> virtio_device *vdev)
>>>       init_waitqueue_head(&vb->config_change);
>>>       vb->vdev = vdev;
>>>
>>> -    /* We expect two virtqueues. */
>>> -    err = vdev->config->find_vqs(vdev, 2, vqs, callbacks, names);
>>> +    /* We expect two virtqueues: inflate and deflate,
>>> +     * and optionally stat. */
>>> +    nvqs = virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_STATS_VQ) 
>>> ? 3 : 2;
>>> +    err = vdev->config->find_vqs(vdev, nvqs, vqs, callbacks, names);
>>>       if (err)
>>>           goto out_free_vb;
>>>
>>>       vb->inflate_vq = vqs[0];
>>>       vb->deflate_vq = vqs[1];
>>> +    if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_STATS_VQ)) {
>>> +        struct scatterlist sg;
>>> +        vb->stats_vq = vqs[2];
>>> +
>>> +        /*
>>> +         * Prime this virtqueue with one buffer so the hypervisor can
>>> +         * use it to signal us later.
>>> +         */
>>> +        sg_init_one(&sg, vb->stats, sizeof(vb->stats));
>>
>> should be "sizeof vb->stats"
>>
>>> +        if (vb->stats_vq->vq_ops->add_buf(vb->stats_vq,&sg, 1, 0, 
>>> vb)<  0)
>>> +            BUG();
>>> +        vb->stats_vq->vq_ops->kick(vb->stats_vq);
>>> +    }
>>>
>>>       vb->thread = kthread_run(balloon, vb, "vballoon");
>>>       if (IS_ERR(vb->thread)) {
>>> @@ -265,7 +334,9 @@ static void virtballoon_remove(struct 
>>> virtio_device *vdev)
>>>       kfree(vb);
>>>   }
>>>
>>> -static unsigned int features[] = { VIRTIO_BALLOON_F_MUST_TELL_HOST };
>>> +static unsigned int features[] = {
>>> +    VIRTIO_BALLOON_F_MUST_TELL_HOST, VIRTIO_BALLOON_F_STATS_VQ,
>>
>> one per line
>>
>>> +};
>>>
>>>   static struct virtio_driver virtio_balloon = {
>>>       .feature_table = features,
>>> diff --git a/include/linux/virtio_balloon.h 
>>> b/include/linux/virtio_balloon.h
>>> index 09d7300..a5c09e6 100644
>>> --- a/include/linux/virtio_balloon.h
>>> +++ b/include/linux/virtio_balloon.h
>>> @@ -6,6 +6,7 @@
>>>
>>>   /* The feature bitmap for virtio balloon */
>>>   #define VIRTIO_BALLOON_F_MUST_TELL_HOST    0 /* Tell before 
>>> reclaiming pages */
>>> +#define VIRTIO_BALLOON_F_STATS_VQ 1 /* Memory Stats virtqueue */
>>
>> align with a tab
>>>
>>>   /* Size of a PFN in the balloon interface. */
>>>   #define VIRTIO_BALLOON_PFN_SHIFT 12
>>> @@ -17,4 +18,19 @@ struct virtio_balloon_config
>>>       /* Number of pages we've actually got in balloon. */
>>>       __le32 actual;
>>>   };
>>> +
>>> +#define VIRTIO_BALLOON_S_SWAP_IN  0   /* Amount of memory swapped 
>>> in */
>>> +#define VIRTIO_BALLOON_S_SWAP_OUT 1   /* Amount of memory swapped 
>>> out */
>>> +#define VIRTIO_BALLOON_S_MAJFLT   2   /* Number of major faults */
>>> +#define VIRTIO_BALLOON_S_MINFLT   3   /* Number of minor faults */
>>> +#define VIRTIO_BALLOON_S_MEMFREE  4   /* Total amount of free 
>>> memory */
>>> +#define VIRTIO_BALLOON_S_MEMTOT   5   /* Total amount of memory */
>>
>> this seems to imply the total amount of memory in bytes?
>>
>>> +#define VIRTIO_BALLOON_S_NR       6
>>> +
>>> +struct virtio_balloon_stat
>>> +{
>>> +    __le16 tag;
>>> +    __le64 val;
>>
>> This might create padding issues e.g. when guest
>> is 32 bit and host is 64 bit. Better add padding
>> manually, or pack the structure (but packed structures
>> often cause gcc to generate terrible code).
>>
>>
>>> +};
>>> +
>>>   #endif /* _LINUX_VIRTIO_BALLOON_H */
>>>
>>>
>>> -- 
>>> Thanks,
>>> Adam
>>>
>>> _______________________________________________
>>> Virtualization mailing list
>>> Virtualization@lists.linux-foundation.org
>>> https://lists.linux-foundation.org/mailman/listinfo/virtualization
>> _______________________________________________
>> Virtualization mailing list
>> Virtualization@lists.linux-foundation.org
>> https://lists.linux-foundation.org/mailman/listinfo/virtualization
>
>
>

