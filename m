Return-Path: <linux-kernel-owner+w=401wt.eu-S1760349AbYG1Ut6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760349AbYG1Ut6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 16:49:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752446AbYG1Utu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 16:49:50 -0400
Received: from ns2.gothnet.se ([82.193.160.251]:7217 "EHLO
	GOTHNET-SMTP2.gothnet.se" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753906AbYG1Uts (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 16:49:48 -0400
X-Greylist: delayed 956 seconds by postgrey-1.27 at vger.kernel.org; Mon, 28 Jul 2008 16:49:48 EDT
Message-ID: <488E2CED.1040207@tungstengraphics.com>
Date: Mon, 28 Jul 2008 22:32:45 +0200
From: =?ISO-8859-1?Q?Thomas_Hellstr=F6m?= <thomas@tungstengraphics.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080306)
MIME-Version: 1.0
To: Dave Airlie <airlied@gmail.com>
CC: Jiri Slaby <jirislaby@gmail.com>, airlied@linux.ie,
       Andrew Morton <akpm@linux-foundation.org>,
       dri-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1 repost #1] DRM: don't enable irqs in locking
References: <1216975369-6749-1-git-send-email-jirislaby@gmail.com> <21d7e9970807250154q4a1958f5k45f62408e97ae3c7@mail.gmail.com>
In-Reply-To: <21d7e9970807250154q4a1958f5k45f62408e97ae3c7@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-BitDefender-Scanner: Mail not scanned due to license constraints
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Airlie wrote:
> On Fri, Jul 25, 2008 at 6:42 PM, Jiri Slaby <jirislaby@gmail.com> wrote:
>   
>> drm_lock_take(); and drm_lock_free(); are called from
>> drm_locked_tasklet_func(); which disables interrupts when grabbing its
>> spinlock.
>>
>> Don't allow these locking functions to re-enable interrupts when
>> the tasklet expects them disabled. I.e. use spin_lock_irqsave instead of
>> spin_lock_bh (with their unlock opposites).
>>     
>
> Hmm this has bounced through 2-3 variations.. Thomas any ideas what
> the final correct answer is?
>
> Dave.
>   
Hmm,
Yes, this bug could occur, but the remedy is not to use 
spin_lock_irqsave() for lock_data::spinlock but to avoid calling 
drm_lock_take with the drm_device::tasklet_lock held with irqs disabled.
I'll see if I can come up with a patch.

/Thomas


>> We will get such a warnings otherwise:
>> ------------[ cut here ]------------
>> WARNING: at kernel/softirq.c:136 local_bh_enable_ip+0x8b/0xb0()
>> Modules linked in: arc4 ecb crypto_blkcipher cryptomgr crypto_algapi ath5k usbhid mac80211 ohci1394 hid led_class floppy cfg80211 ff_memless ieee1394 rtc_cmos evdev [last unloaded: freq_table]
>> Pid: 0, comm: swapper Not tainted 2.6.26-rc8-mm1_64 #427
>>
>> Call Trace:
>>  <IRQ>  [<ffffffff8023813f>] warn_on_slowpath+0x5f/0x90
>> [...]
>>  [<ffffffff8023e1fb>] local_bh_enable_ip+0x8b/0xb0
>>  [<ffffffff8055b2cf>] _spin_unlock_bh+0xf/0x20
>>  [<ffffffff803b0bd1>] drm_lock_take+0x81/0xe0
>>  [<ffffffff803b006b>] drm_locked_tasklet_func+0x4b/0xb0
>>  [<ffffffff8023daf9>] tasklet_hi_action+0x69/0xf0
>>  [<ffffffff8023e3e4>] __do_softirq+0x84/0xf0
>> [stack snipped]
>>
>> Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
>> Cc: David Airlie <airlied@linux.ie>
>> ---
>>  drivers/gpu/drm/drm_lock.c |   12 +++++++-----
>>  1 files changed, 7 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/gpu/drm/drm_lock.c b/drivers/gpu/drm/drm_lock.c
>> index 0998723..79943e4 100644
>> --- a/drivers/gpu/drm/drm_lock.c
>> +++ b/drivers/gpu/drm/drm_lock.c
>> @@ -196,10 +196,11 @@ int drm_unlock(struct drm_device *dev, void *data, struct drm_file *file_priv)
>>  int drm_lock_take(struct drm_lock_data *lock_data,
>>                  unsigned int context)
>>  {
>> +       unsigned long flags;
>>        unsigned int old, new, prev;
>>        volatile unsigned int *lock = &lock_data->hw_lock->lock;
>>
>> -       spin_lock_bh(&lock_data->spinlock);
>> +       spin_lock_irqsave(&lock_data->spinlock, flags);
>>        do {
>>                old = *lock;
>>                if (old & _DRM_LOCK_HELD)
>> @@ -211,7 +212,7 @@ int drm_lock_take(struct drm_lock_data *lock_data,
>>                }
>>                prev = cmpxchg(lock, old, new);
>>        } while (prev != old);
>> -       spin_unlock_bh(&lock_data->spinlock);
>> +       spin_unlock_irqrestore(&lock_data->spinlock, flags);
>>
>>        if (_DRM_LOCKING_CONTEXT(old) == context) {
>>                if (old & _DRM_LOCK_HELD) {
>> @@ -270,17 +271,18 @@ static int drm_lock_transfer(struct drm_lock_data *lock_data,
>>  */
>>  int drm_lock_free(struct drm_lock_data *lock_data, unsigned int context)
>>  {
>> +       unsigned long flags;
>>        unsigned int old, new, prev;
>>        volatile unsigned int *lock = &lock_data->hw_lock->lock;
>>
>> -       spin_lock_bh(&lock_data->spinlock);
>> +       spin_lock_irqsave(&lock_data->spinlock, flags);
>>        if (lock_data->kernel_waiters != 0) {
>>                drm_lock_transfer(lock_data, 0);
>>                lock_data->idle_has_lock = 1;
>> -               spin_unlock_bh(&lock_data->spinlock);
>> +               spin_unlock_irqrestore(&lock_data->spinlock, flags);
>>                return 1;
>>        }
>> -       spin_unlock_bh(&lock_data->spinlock);
>> +       spin_unlock_irqrestore(&lock_data->spinlock, flags);
>>
>>        do {
>>                old = *lock;
>> --
>> 1.5.6.2
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>>
>>     



