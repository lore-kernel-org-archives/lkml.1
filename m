Return-Path: <linux-kernel-owner+w=401wt.eu-S1753177AbZKPQXz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753177AbZKPQXz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 11:23:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752810AbZKPQXy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 11:23:54 -0500
Received: from smtp-outbound-1.vmware.com ([65.115.85.69]:53536 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752790AbZKPQXy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 11:23:54 -0500
Message-ID: <4B017C93.3010807@vmware.com>
Date: Mon, 16 Nov 2009 17:23:47 +0100
From: Thomas Hellstrom <thellstrom@vmware.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090822)
MIME-Version: 1.0
To: Dave Airlie <airlied@gmail.com>
CC: Jerome Glisse <jglisse@redhat.com>,
       "dri-devel@lists.sf.net" <dri-devel@lists.sf.net>,
       LKML <linux-kernel@vger.kernel.org>,
       Chris Wilson <chris@chris-wilson.co.uk>
Subject: Re: [PATCH 2/2] drm: mm always protect change to unused_nodes with
 	unused_lock spinlock
References: <1258142218-2070-1-git-send-email-jglisse@redhat.com> <21d7e9970911151542n49f15a9dn6481d0bc2bdfbc45@mail.gmail.com>
In-Reply-To: <21d7e9970911151542n49f15a9dn6481d0bc2bdfbc45@mail.gmail.com>
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Airlie wrote:
> On Sat, Nov 14, 2009 at 5:56 AM, Jerome Glisse <jglisse@redhat.com> wrote:
>   
>> unused_nodes modification needs to be protected by unused_lock spinlock.
>> Here is an example of an usage where there is no such protection without
>> this patch.
>>
>>  Process 1: 1-drm_mm_pre_get(this function modify unused_nodes list)
>>             2-spin_lock(spinlock protecting mm struct)
>>             3-drm_mm_put_block(this function might modify unused_nodes
>>               list but doesn't protect modification with unused_lock)
>>             4-spin_unlock(spinlock protecting mm struct)
>>  Process2:  1-drm_mm_pre_get(this function modify unused_nodes list)
>> At this point Process1 & Process2 might both be doing modification to
>> unused_nodes list. This patch add unused_lock protection into
>> drm_mm_put_block to avoid such issue.
>>     
>
> Have we got a bug number or reproducer for this?
>
> I've cc'ed Thomas and Chris who were last ppl to touch drm_mm.c for some
> sort of acks.
>
> Dave.
>
>   
>> Signed-off-by: Jerome Glisse <jglisse@redhat.com>
>> ---
>>  drivers/gpu/drm/drm_mm.c |    9 +++++++++
>>  1 files changed, 9 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/gpu/drm/drm_mm.c b/drivers/gpu/drm/drm_mm.c
>> index c861d80..97dc5a4 100644
>> --- a/drivers/gpu/drm/drm_mm.c
>> +++ b/drivers/gpu/drm/drm_mm.c
>> @@ -103,6 +103,11 @@ static struct drm_mm_node *drm_mm_kmalloc(struct drm_mm *mm, int atomic)
>>        return child;
>>  }
>>
>> +/* drm_mm_pre_get() - pre allocate drm_mm_node structure
>> + * drm_mm:     memory manager struct we are pre-allocating for
>> + *
>> + * Returns 0 on success or -ENOMEM if allocation fails.
>> + */
>>  int drm_mm_pre_get(struct drm_mm *mm)
>>  {
>>        struct drm_mm_node *node;
>> @@ -253,12 +258,14 @@ void drm_mm_put_block(struct drm_mm_node *cur)
>>                                prev_node->size += next_node->size;
>>                                list_del(&next_node->ml_entry);
>>                                list_del(&next_node->fl_entry);
>> +                               spin_lock(&mm->unused_lock);
>>                                if (mm->num_unused < MM_UNUSED_TARGET) {
>>                                        list_add(&next_node->fl_entry,
>>                                                 &mm->unused_nodes);
>>                                        ++mm->num_unused;
>>                                } else
>>                                        kfree(next_node);
>> +                               spin_unlock(&mm->unused_lock);
>>                        } else {
>>                                next_node->size += cur->size;
>>                                next_node->start = cur->start;
>> @@ -271,11 +278,13 @@ void drm_mm_put_block(struct drm_mm_node *cur)
>>                list_add(&cur->fl_entry, &mm->fl_entry);
>>        } else {
>>                list_del(&cur->ml_entry);
>> +               spin_lock(&mm->unused_lock);
>>                if (mm->num_unused < MM_UNUSED_TARGET) {
>>                        list_add(&cur->fl_entry, &mm->unused_nodes);
>>                        ++mm->num_unused;
>>                } else
>>                        kfree(cur); 
>> +               spin_unlock(&mm->unused_lock);
>>        }
>>  }
>>
>> --
>> 1.6.5.2
>>
>>
>>     
Hmm. Ouch. The patch looks correct, although I'm not 100% sure it's OK 
to kfree() within a spinlocked region? Perhaps better to take it out.

/Thomas



