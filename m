Return-Path: <linux-kernel-owner+w=401wt.eu-S1753941AbYIDXsJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753941AbYIDXsJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 19:48:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751868AbYIDXr5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 19:47:57 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:51286 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751568AbYIDXr4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 19:47:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=l/M73Lb5nxqTaZ3cIXIq08mOZOmK22820xCan4oObL9KvCE2/vw6R3U50GS5V5nxd3
         7JL2PuC6nhfJ8boql8EkUr4GRnNermC3SGBBM3mBSMSG9eSm6fe1LABb3iHHlbHS9A3I
         jlwg0uAMLnvlhZW71nwHdzMGdL+tionnulXRU=
Message-ID: <1df1788c0809041647n5f5e4d64yaa2f47d3302494fe@mail.gmail.com>
Date: Thu, 4 Sep 2008 20:47:54 -0300
From: "=?UTF-8?Q?Br=C3=A1ulio_Barros_de_Oliveira?=" <brauliobo@gmail.com>
To: Mat <jackdachef@gmail.com>
Subject: Re: Re: reiserfs do_journal_end unnecessary hd wake up?
Cc: reiserfs-devel@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <1df1788c0809041632h726fff6cq2eacd86076215017@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
References: <loom.20080904T211127-782@post.gmane.org>
	 <1df1788c0809041538x8d41eb8s80966f25aa2ade21@mail.gmail.com>
	 <1df1788c0809041628m269f13c3l27d9f9dd59a42fef@mail.gmail.com>
	 <1df1788c0809041632h726fff6cq2eacd86076215017@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha id m84NmSdq014897

just found out! it is konsole, unbelievable! going to file a bugreport right now.again, thank you very much for the support.brÃ¡ulio
On Thu, Sep 4, 2008 at 8:32 PM, BrÃ¡ulio Barros de Oliveira<brauliobo@gmail.com> wrote:> but (as always there is), the situation is not good yet when using kde4.> with it, i can't find out which process is accessing the hd, cause> iotop only shows a pdflush access.> i've tried to kill some apps, but it didn't help. any other trace technic?>> regards,> brÃ¡ulio>> On Thu, Sep 4, 2008 at 8:28 PM, BrÃ¡ulio Barros de Oliveira> <brauliobo@gmail.com> wrote:>> hello mat, here comes the results of each action.>> in all the process i've used the iotop (what a great utility you>> pointed!), and always saw only the pdflush process acessing the hd. no>> user interface were used.>> the apm is set to 128 with hdparm>>>> ok, then try the following:>>>> you at least should have noatime,nodiratime,commit=600>>>> :) that did the job! also, i've tested without the commit option,>> which didn't changed the result.>>>> enabled for the reiserfs or >=ext3 filesystems>>>> you can also try data=writeback (but beware this might put your data at risk !)>>>> * can't try>>>> select the anticipatory i/o scheduler>> and set following stuff>>>> :( no change.>>>> echo "16" > /proc/sys/vm/page-cluster>> # default: 3>> #>>>> :( no change.>>>> echo "60" > /proc/sys/vm/swappiness>> # default: 60>> # By default, Linux will aggressively swap processes out of physical memory onto>> disk in order to keep the disk cache as large as possible.>> # This means that pages that haven't been used recently will be pushed into swap>> long before the system even comes close to running out of memory, which is an>> unexpected behavior compared to some operating systems.>> # The /proc/sys/vm/swappiness parameter controls how aggressive Linux is in this>> area.>>>> :( no change.>>>> echo "3000" > /proc/sys/vm/dirty_expire_centisecs>> # default: 3000 (30 seconds)>> #2 how long data can be in the page cache before it is considered expired and>> must be written at the next opportunity. Note that this default is very long: a>> full 30 seconds. That means that under normal circumstances, unless you write>> enough to trigger the other pdflush method, Linux won't actually commit anything>> you write until 30 seconds later.>>>> :( no change.>>>> echo "6000"  > /proc/sys/vm/dirty_writeback_centisecs>> # default: 500 (5 seconds)>> #1 how often pdflush wakes up to write data to disk. The default wakes up the>> two (or more) active threads every five seconds.>> # suggestion: 6000 (every 60 seconds)>>>> :( no change.>>>> echo "15" > /proc/sys/vm/dirty_background_ratio>> # default: 10>> #3 Maximum percentage of active memory that can be filled with dirty pages>> before pdflush begins to write them>>>> echo "50"   > /proc/sys/vm/dirty_ratio #modified>> # default: 40>> #4 Maximum percentage of total memory that can be filled with dirty pages before>> processes are forced to write dirty buffers themselves during their time slice>> instead of being allowed to do more writes.>> # modified: 50>>>> echo "25" > /proc/sys/vm/vfs_cache_pressure>>>> for i in /sys/block/sd*; do>>        /bin/echo "anticipatory" >  $i/queue/scheduler>> done>>>> for i in /sys/block/sd*; do>>        /bin/echo "0" >  $i/queue/iosched/antic_expire>> done>>>> for i in /sys/block/sd*; do>>        /bin/echo "150" >  $i/queue/iosched/read_expire>> done>>>> for i in /sys/block/sd*; do>>        /bin/echo "750" >  $i/queue/iosched/read_batch_expire>> done>>>> for i in /sys/block/sd*; do>>        /bin/echo "1200" >  $i/queue/iosched/write_batch_expire>> done>>>> for i in /sys/block/sd*; do>>        /bin/echo "1024" >  $i/queue/nr_requests>> done>>>> for i in /sys/block/sd*; do>>        /bin/echo "256" >  $i/queue/read_ahead_kb>> done>>>> for i in /sys/block/sd*; do>>        /bin/echo "256" >  $i/queue/max_sectors_kb>> done>>>> for i in /sys/class/scsi_host/host*; do>>        /bin/echo "min_power" >  $i/link_power_management_policy>> done>>>>>>>>>> try to disable each and every unneeded daemon or applets, programs, etc.>>>> by using:>>>> * powertop>> * iotop>> * htop>> * top>> * lsof | grep /home>> * ...>>>ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
