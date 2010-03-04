Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755743Ab0CDCZ5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 21:25:57 -0500
Received: from smtp-out.google.com ([216.239.44.51]:4257 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752979Ab0CDCZw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 21:25:52 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:x-system-of-record;
	b=iUfxiU9wTNuxZH8RBkKv2NG/7jJTE/MfND5M7IIKPDIkOZ+wJU3HIDkOUMUJITgMa
	x58bqmaYmEw+YY9XBK43A==
MIME-Version: 1.0
In-Reply-To: <e98e18941003031519v14d4f79cg33da5c3cf1f5ac03@mail.gmail.com>
References: <4B8DFFD7.2000908@cn.fujitsu.com>
	 <20100303143311.GA2866@redhat.com> <20100303154748.GC2866@redhat.com>
	 <e98e18941003031519v14d4f79cg33da5c3cf1f5ac03@mail.gmail.com>
Date: Wed, 3 Mar 2010 18:25:44 -0800
Message-ID: <1786ab031003031825m5467c86jf5c355df10001dd2@mail.gmail.com>
Subject: Re: [PATCH 2/1] io-controller: Add a new interface "policy" for IO 
	Controller
From: Chad Talbott <ctalbott@google.com>
To: guijianfeng@cn.fujitsu.com
Cc: vgoyal@redhat.com, jens.axboe@oracle.com, linux-kernel@vger.kernel.org,
       Nauman Rafique <nauman@google.com>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 3, 2010 at 3:19 PM, Nauman Rafique <nauman@google.com> wrote:
> On Wed, Mar 03, 2010 at 09:33:11AM -0500, Vivek Goyal wrote:
>> On Wed, Mar 03, 2010 at 02:21:11PM +0800, Gui Jianfeng wrote:
>> > You can use the following format to assigned specific weight for a given
>> > device:
>> > #echo "major:minor weight" > blkio.policy

>> Can we use a different name for per device weight file name than "blkio.policy".
>> May be "blkio.weight_device" or "blkio.weight_per_device" etc.

I agree with Vivek here, and his reasoning below.  This becomes more
important as more attributes are added.

>> The reason being that "blkio.policy" name might be more suitable to switch
>> between differnt kind of BW control policies (proportional, max bandwidth etc),
>> once we implement some kind of max BW controlling policies also. So it
>> might be a good idea to not use that file name for specifying per device
>> weights.
>
> Well, thinking more about it, what kind of policy you implement on a block
> device will not be a per cgroup property. It will not be the case that on
> a device you are implementing max-bw for one cgroup and proportional
> weight for other cgroup. It probably will be a per device attribute and
> if need be should be controlled by /sys/block/<dev> interface.
>
> Still, being very clear what a particular cgroup file does makes sense. So
> that in future for max-bw control, we can bring in more cgroup files like
> blkio.max_bw or blkio.max_iops etc which can co-exist with blkio.weight_device
> etc.

Agreed.  I'd like to add that since we are already thinking about
expanding the policy with more attributes, perhaps
blkio_update_group_weight_fn in blkio_policy_ops should be renamed to
blkio_policy_updated_fn.  Then it could be called if the user changed
any part of the policy.  Further, instead of storing "weight" in
blkio_cgroup, we could store a blkio_policy_node there instead.  Then
the handling of whole-cgroup and per-block-device policy items could
be more regular.

Some quick code comments:

policy_parse_and_set() could be simplified with scanf, like:

if (sscanf(buf, "%d:%d %d", &major, &minor, &temp) != 3)
        return -EINVAL;

blkcg_get_weight() might better be blkcg_get_policy() and it could
return a per-disk policy node, or fall back to the cgroup policy if
none existed for this dev.  This would be across policy attributes,
rather than just weight.

Thanks,
Chad
