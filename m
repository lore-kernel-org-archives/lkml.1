Return-Path: <linux-kernel-owner+w=401wt.eu-S1760295AbYHELQd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760295AbYHELQd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 07:16:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757681AbYHELQZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 07:16:25 -0400
Received: from wx-out-0506.google.com ([66.249.82.229]:37381 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755752AbYHELQX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 07:16:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=N7lkaf8lPVNgLQlvxL4+Ms1tu9mT6QcAwNSujyNCeOtKHTqkCzEjlBNIg1VRAthiHB
         VF2dpNB8qS7MPZAxoz1h4+5B+w+Bk2wCjSxaHiviwWX7I9p61AH8Ynm6Y4uZEWh+eAeT
         +lNDL4UhmlbxOoxc8SLj5wZT1suY9NFU2/Xgk=
Message-ID: <48983682.2040707@gmail.com>
Date: Tue, 05 Aug 2008 14:16:18 +0300
From: Maxim Levitsky <maximlevitsky@gmail.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Mikulas Patocka <mpatocka@redhat.com>
CC: dm-devel@redhat.com, linux-kernel@vger.kernel.org,
       Alasdair G Kergon <agk@redhat.com>, Milan Broz <mbroz@redhat.com>
Subject: Re: [ANNOUNCE] beta version of LVM snapshot merging
References: <Pine.LNX.4.64.0808041349570.19355@devserv.devel.redhat.com>
In-Reply-To: <Pine.LNX.4.64.0808041349570.19355@devserv.devel.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mikulas Patocka wrote:
> Hi
> 
> I'd like announce beta version of snapshot merging. The patches can be 
> downloaded at http://people.redhat.com/mpatocka/patches/ The patches are 
> against kernel 2.6.26, device-mapper.1.02.27 and LVM2.2.02.39.
> 
> The snapshot merging allows you to merge snapshot content back into the 
> original device. The most useful use for this feature is the possibility 
> to rollback state of the whole computer after failed package upgrade, 
> administrator's error or so.
> 
> Merging of a snapshot is initiated with command "lvconvert -M 
> vg/lv_snapshot". lvconvert polls for the termination of merging and then 
> automatically removes the merging snapshot. If the computer crashes, the 
> merging resumes after a crash and background polling is restarted too 
> (from lvchange -ay or vgchange -ay command).
> 
> While the merging is active, any accesses to the origin device are 
> dicrected the snapshot that is being merged. When the merging finishes, 
> the origin target is seamlessly reloaded and the merging snapshot is 
> dropped. The filesystem can stay mounted during this time.
> 
> There are three types of merging:
> 
> --nameorigin (default) - the resulting logical volume will have name, 
> minor number and UUID of the original origin volume. When this mode is 
> used, neither snapshot nor the origin can be mounted when the merging 
> starts. (but you can mount the origin immediatelly after you start 
> merging, you don't have to wait until it finishes)
> 
> --namesnapshot - the resulting logical volume will have name, minor number 
> and UUID of the snapshot to be merged. When the merging starts, the 
> snapshot can be mounted and the origin cannot be mounted.
> 
> --onactivate - marks the snapshot for merge on next activate (when 
> lvchange -ay or vgchange -ay changes the state from inactiva to active), 
> but doesn't do actual merging. This option is useful if you need to merge 
> over a filesystem that cannot be unmounted (for example root) --- use 
> lvconvert -M --onactivate and reboot the computer. On next reboot, the 
> merge will start and the system will run with root filesystem 
> corresponding to the snapshot that is being merged.
> 
> You can have multiple snapshots before you start merging, any existing 
> snapshots are maintained stable (i.e. new exceptions to them are allocated 
> if the merging modifies the origin). The exception is --namesnapshot 
> option which requires that you have only one snapshot. While the merging 
> is in progress, new ssnapshots cannot be created.
> For example:
> - take snapshot before system-wide package update
> - do update
> - now suppose that you don't like the result of the update:
> - take another snapshot
> - initiate -M --onactivate with the first snapshot
> - reboot
> - after reboot you are running with root filesystem in the state before 
> the update and you can examine the result of the update on the second 
> snapshot. If you decide that you like the update anyway, you can merge it 
> back again (with reboot).
> (don't forget to regenerate lvm on your initramdisk if you are going to 
> try this on root filesystem).
> 
> 
> This implementation of snapshot merging is meant to be stable, report any 
> possible bugs to me.

< offtopic>

this is exactly what I want and need, I played once with the snapshots
but found that there is no way to merge them back, thus this will make
linux be able to do full rollback. Amazing.

Now the only big thing linux is missing now, is support for good packet 
writing since both direct DVDRW and pktcdvd writing is very slow.

The solution here is to create a specialized implementation of UDF 
filesystem that uses its own caches and is bypassing VFS completly.

Maybe do it with fuse?


And probably it would be great to fuse RAID and LVM systems so we can 
have one standard volume manager.


</offtopic>



This can be used together with hibernating, to snapshot full system?
Full integration with swsusp would be great.

Thanks a million for such a good work.
As soon as I have free time I will try this.

Best regards,
	Maxim Levitsky




