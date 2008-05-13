Return-Path: <linux-kernel-owner+w=401wt.eu-S1759568AbYEMI5U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759568AbYEMI5U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 04:57:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757465AbYEMI5K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 04:57:10 -0400
Received: from sineb-mail-2.sun.com ([192.18.19.7]:46393 "EHLO
	sineb-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755144AbYEMI5I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 04:57:08 -0400
X-Greylist: delayed 529 seconds by postgrey-1.27 at vger.kernel.org; Tue, 13 May 2008 04:57:07 EDT
Date: Tue, 13 May 2008 14:18:12 +0530
From: Kalpak Shah <Kalpak.Shah@Sun.COM>
Subject: Re: [PATCH] ext3/4: fix uninitialized bs in	ext3/4_xattr_set_handle()
In-reply-to: <4828DE73.2070001@redhat.com>
To: Eric Sandeen <sandeen@redhat.com>
Cc: Tiger Yang <tiger.yang@oracle.com>, linux-ext4@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Message-id: <1210668492.4016.6.camel@localhost>
MIME-version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6)
Content-type: multipart/mixed; boundary="Boundary_(ID_YnBUVn67hUeuQDlRERYT1A)"
References: <4827B878.50903@oracle.com> <4828DE73.2070001@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Boundary_(ID_YnBUVn67hUeuQDlRERYT1A)
Content-type: text/plain
Content-transfer-encoding: 7BIT

Hi Eric,

On Mon, 2008-05-12 at 19:18 -0500, Eric Sandeen wrote:
> Tiger Yang wrote:
> > Hi,
> > I met a bug when I try to replace a xattr entry in ibody with a big size 
> > value. But in ibody there has no space for the new value. So it should 
> > set new xattr entry in block and remove the old xattr entry in ibody.
> > 
> > Best regards,
> > tiger
> > 
> 
> Tiger, do you have a testcase handy to demonstrate this?

Attached is a simple script to reproduce the problem.

> 
> Is the new, large out-of-inode xattr unique so that it does not match
> any existing attribute block, I assume?

I don't quite understand what you mean but the problem is that in
ext3_xattr_set_handle(), the EA being replaced is found in the
inode-body (by function ext3_xattr_ibody_find) and hence
ext3_xattr_block_find() is not called initially. So in this test-case
when we have to delete an EA from the inode and add it into the external
block, bs turns out to be uninitialized and therefore a new EA block
gets allocated instead of the existing one being used.

Thanks,
Kalpak

> 
> Thanks,
> 
> -Eric
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--Boundary_(ID_YnBUVn67hUeuQDlRERYT1A)
Content-type: application/x-shellscript; name=reproducer.sh
Content-transfer-encoding: 7BIT
Content-disposition: attachment; filename=reproducer.sh

MNTPT=/mnt/temp

#format test fs
touch img
mkfs.ext3 -F -b 4096 -I 512 img 50000 > /dev/null
mount -t ext3 -o loop,user_xattr img  $MNTPT
touch $MNTPT/foo

# create EAs so that extra space in inode is filled and external block is needed
for (( i = 0; i < 20; i++ )); do 
	setfattr -n user.foobar$i -v foobar $MNTPT/foo
done

umount $MNTPT
# note EA block no
old_blk=`debugfs -R "stat foo" img 2>&1 | grep "ACL" | cut -d' ' -f3`
echo "Old xattr block no: $old_blk"

mount -t ext3 -o loop,user_xattr img  $MNTPT
# replace in-inode EA such that it should "overflow" into external EA blok
setfattr -n user.foobar1 -v foobarfoobarfoobarfoobarfoobarfoobarfoobar $MNTPT/foo

getfattr -d $MNTPT/foo # shows that EAs from external block are lost
umount $MNTPT
# EA block no should not change with these operations - but it does
new_blk=`debugfs -R "stat foo" img 2>&1 | grep "ACL" | cut -d' ' -f3`

if [ $old_blk -ne $new_blk ]; then
	echo "new xattr block no: $new_blk - old xattr's except the one being replaced are lost"
fi

--Boundary_(ID_YnBUVn67hUeuQDlRERYT1A)--
