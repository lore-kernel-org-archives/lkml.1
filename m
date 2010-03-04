Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754418Ab0CDPGU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 10:06:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:8776 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753871Ab0CDPGS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 10:06:18 -0500
Date: Thu, 4 Mar 2010 10:06:09 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Chad Talbott <ctalbott@google.com>
Cc: guijianfeng@cn.fujitsu.com, jens.axboe@oracle.com,
       linux-kernel@vger.kernel.org, Nauman Rafique <nauman@google.com>
Subject: Re: [PATCH 2/1] io-controller: Add a new interface "policy" for IO
	Controller
Message-ID: <20100304150609.GA18786@redhat.com>
References: <4B8DFFD7.2000908@cn.fujitsu.com> <20100303143311.GA2866@redhat.com> <20100303154748.GC2866@redhat.com> <e98e18941003031519v14d4f79cg33da5c3cf1f5ac03@mail.gmail.com> <1786ab031003031825m5467c86jf5c355df10001dd2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1786ab031003031825m5467c86jf5c355df10001dd2@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 03, 2010 at 06:25:44PM -0800, Chad Talbott wrote:
> On Wed, Mar 3, 2010 at 3:19 PM, Nauman Rafique <nauman@google.com> wrote:
> > On Wed, Mar 03, 2010 at 09:33:11AM -0500, Vivek Goyal wrote:
> >> On Wed, Mar 03, 2010 at 02:21:11PM +0800, Gui Jianfeng wrote:
> >> > You can use the following format to assigned specific weight for a given
> >> > device:
> >> > #echo "major:minor weight" > blkio.policy
> 
> >> Can we use a different name for per device weight file name than "blkio.policy".
> >> May be "blkio.weight_device" or "blkio.weight_per_device" etc.
> 
> I agree with Vivek here, and his reasoning below.  This becomes more
> important as more attributes are added.
> 
> >> The reason being that "blkio.policy" name might be more suitable to switch
> >> between differnt kind of BW control policies (proportional, max bandwidth etc),
> >> once we implement some kind of max BW controlling policies also. So it
> >> might be a good idea to not use that file name for specifying per device
> >> weights.
> >
> > Well, thinking more about it, what kind of policy you implement on a block
> > device will not be a per cgroup property. It will not be the case that on
> > a device you are implementing max-bw for one cgroup and proportional
> > weight for other cgroup. It probably will be a per device attribute and
> > if need be should be controlled by /sys/block/<dev> interface.
> >
> > Still, being very clear what a particular cgroup file does makes sense. So
> > that in future for max-bw control, we can bring in more cgroup files like
> > blkio.max_bw or blkio.max_iops etc which can co-exist with blkio.weight_device
> > etc.
> 
> Agreed.  I'd like to add that since we are already thinking about
> expanding the policy with more attributes, perhaps
> blkio_update_group_weight_fn in blkio_policy_ops should be renamed to
> blkio_policy_updated_fn.  Then it could be called if the user changed
> any part of the policy.

Currently there is only one policy (proportional weight) and there is
only one attribute (weight). So I think we can leave the function name
as it is. We can make it more generic as we introduce new policies or
policy attributes.

> Further, instead of storing "weight" in
> blkio_cgroup, we could store a blkio_policy_node there instead.

Sorry, did not get it. Are you suggesting that don't store group weight in
blkio_cgroup, instead store it in blkio_policy_node? But we don't create
blkio_policy_node, until and unless user create a specific weight policy
for a device. 

> Then
> the handling of whole-cgroup and per-block-device policy items could
> be more regular.
> 
> Some quick code comments:
> 
> policy_parse_and_set() could be simplified with scanf, like:
> 
> if (sscanf(buf, "%d:%d %d", &major, &minor, &temp) != 3)
>         return -EINVAL;
> 
> blkcg_get_weight() might better be blkcg_get_policy() and it could
> return a per-disk policy node, or fall back to the cgroup policy if
> none existed for this dev.  This would be across policy attributes,
> rather than just weight.

This is an interesting idea. But again we can implement it once we have
more policy attributes. For the time being, it is simple to understand
that get group weight from blk-cgroup layer for that particular device.

Thanks
Vivek
