Return-Path: <linux-kernel-owner+w=401wt.eu-S1753358AbYLZPmk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753358AbYLZPmk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2008 10:42:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752201AbYLZPmc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Dec 2008 10:42:32 -0500
Received: from proxy3.bredband.net ([195.54.101.73]:44968 "EHLO
	proxy3.bredband.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752211AbYLZPmb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2008 10:42:31 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ap1IANuJVEnVQJ+/PGdsb2JhbACBbIceilkBAQEBNQGpZFiPM4ZE
Message-ID: <4954FB62.4090306@zappa.cx>
Date: Fri, 26 Dec 2008 16:42:26 +0100
From: Andreas Sundstrom <sunkan@zappa.cx>
User-Agent: Mozilla-Thunderbird 2.0.0.17 (X11/20081018)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: 2.6.28 ext4, xen and lvm volume becomes ro after snapshot
References: <4954BAAB.9090108@zappa.cx> <20081226140721.GN9871@mit.edu>
In-Reply-To: <20081226140721.GN9871@mit.edu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Theodore Tso wrote:
> On Fri, Dec 26, 2008 at 12:06:19PM +0100, Andreas Sundstrom wrote:
>   
>> I use a little script that backup this xen VM from xen dom0.
>>
>> Here is the interesting part of my script:
>> /usr/sbin/xm sysrq xenfw1 s
>> /usr/sbin/xm pause xenfw1
>> sync
>> /sbin/lvm lvcreate --snapshot --permission rw --size 1G --name xenfw1_s
>> /dev/3w250g/xenfw1 > /dev/null
>> /usr/sbin/xm unpause xenfw1
>> /bin/mount -o ro,noatime /dev/3w250g/xenfw1_s /mnt/snapshots/xenfw1 ||
>> /bin/rmdir /mnt/snapshots/xenfw1
>> # Here's where the actual backups take place
>> /bin/umount /mnt/snapshots/xenfw1 2> /dev/null
>> /sbin/lvm lvremove --force /dev/3w250g/xenfw1_s > /dev/null
>>     
>
> OK, so this is being run on Xen Dom0, which means your doing the
> snapshot from Host OS, while the guest OS is suspended, correct?
>   
Correct
>   
>> After the "lvcreate --snapshot" if I check within the xen VM (with cat
>> /proc/mounts) I can see that / changed from rw to ro:
>> Before snapshot:
>> /dev/root / ext4 rw,noatime,barrier=1,noextents,data=ordered 0 0
>> After snapshot:
>> /dev/root / ext4 ro,noatime,barrier=1,noextents,data=ordered 0 0
>>     
>
> But this was done from the guest OS --- what is /dev/root in the guest
> OS?  Am I right in assuming it is the device /dev/3w250g/xenfw1?
> Stupid question --- if this is the case, why are you taking the
> snapshot from the Host OS?  It won't be a consistent snapshot, given
> that it was mounted in the Guest OS, and all you've done in the Guest
> OS is to ask it to sync the filesystem.  Given that there's no pause
> between sysrq s and the pause, the write operations probably haven't
> even been completed before the pause takes place, so the snapshot
> probably has a chance of in pretty bad shape as it is.
>   
You're probably correct, I already have a "sleep 1" that I missed to
include in my e-mail though.
Let's not analyze the backup method so much, it's not a very important
machine and I mostly want config files to be backed up and they are
pretty consistent at all times anyway.
>> It was not possible to do "mount -o remount,rw /":
>> mount -o remount,rw /                                                 
>>     
>
> There are multiple potential reasons for this, but I'm guessing this
> was caused by an aborted journal, probably caused by an I/O error when
> trying to write to the journal.  This may very well be related to
> pausing guest OS in the middle of a write operations that would have
> been caused by the sysrq s, but that's a guess; we need more
> information about exactly what is going on.
>   
You are correct about the aborted journal but it's not caused by
anythingelse than the lvm snapshot.
> If you could reproduce this and send back the messages from dmesg in
> the guest OS, that would be quite helpful.  You might also try adding
> a sleep 2 between the sysrq s and the pause xenfw1 commands, and see
> if the problem goes away.  That's just a stab in the dark, of course,
> but it's a simple enough thing to try.
>   
Ok, I used another Xen VM for testing now.

While I was testing now I noticed that I even could take the snapshot
while the system is not started and the error would still occur.
No problems with ext3 with the same kernel that I've seen yet.

Here's one way to reproduce:
# lvs | grep xenfw2
  xenfw2          3w250g -wi-a-   1.00G # Notice the last "-" which is
not "o"
  xenfw2_swap     3w250g -wi-a- 196.00M
# lvcreate --snapshot --permission rw --size 1G --name xenfw2_s
/dev/3w250g/xenfw2
  Logical volume "xenfw2_s" created
# lvs | grep xenfw2
  xenfw2          3w250g owi-a-   1.00G
  xenfw2_s        3w250g swi-a-   1.00G xenfw2   0.00
  xenfw2_swap     3w250g -wi-a- 196.00M
# xm create xenfw2 -c # To start the Xen VM with console attached

Here's what I think is the relevant part of the kernel output

[    0.317797] EXT4-fs warning (device xvda1): ext4_fill_super: extents
feature not enabled on this filesystem, use tune2fs.     
[   
0.317822]                                                                                                                   

[    0.326805] EXT4-fs: barriers
enabled                                                                                         

[    0.336488] kjournald2 starting.  Commit interval 5
seconds                                                                   
[    0.336514] EXT4-fs: delayed allocation
enabled                                                                               

[    0.336610] EXT4-fs: mballoc
enabled                                                                                          

[    0.336622] EXT4-fs: mounted filesystem with ordered data
mode.                                                               
[    0.336651] VFS: Mounted root (ext4 filesystem)
readonly.                                                                     

[    0.336880] Freeing unused kernel memory: 280k
freed                                                                          

[    0.337936] Write protecting the kernel text:
2624k                                                                           

[    0.338358] Write protecting the kernel read-only data: 1028k
[snip]
[    7.636849] blkfront: xvda1: write barrier op failed     
[    7.636867] blkfront: xvda1: barriers disabled          
[    7.636877] end_request: I/O error, dev xvda1, sector 4512
[    7.636892] end_request: I/O error, dev xvda1, sector 4512
[    7.636933] Aborting journal on device xvda1:8.          
[    7.637602] ext4_abort called.                           
[    7.637616] EXT4-fs error (device xvda1): ext4_journal_start_sb:
Detected aborted journal
[    7.637633] Remounting filesystem
read-only                                             
[    7.652152] EXT4-fs error (device xvda1) in ext4_reserve_inode_write:
Journal has aborted

Let me know if I can help with more information

/Andreas
