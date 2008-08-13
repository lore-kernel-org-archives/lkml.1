Return-Path: <linux-kernel-owner+w=401wt.eu-S1754208AbYHMIAy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754208AbYHMIAy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 04:00:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752262AbYHMIAp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 04:00:45 -0400
Received: from mga01.intel.com ([192.55.52.88]:62127 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752209AbYHMIAn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 04:00:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,200,1217833200"; 
   d="scan'208";a="606361265"
From: "Li, Shaohua" <shaohua.li@intel.com>
To: Ingo Molnar <mingo@elte.hu>
CC: lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>
Date: Wed, 13 Aug 2008 16:00:39 +0800
Subject: RE: [patch]fastboot: remove duplicate unpack_to_rootfs()
Thread-Topic: [patch]fastboot: remove duplicate unpack_to_rootfs()
Thread-Index: Acj9GIwMWA3hoU/gRLa6K50OPnaFUAAAThxA
Message-ID: <76780B19A496DC4B80439008DAD7076C0CF55596@PDSMSX501.ccr.corp.intel.com>
References: <1218607669.3463.9.camel@sli10-desk.sh.intel.com>
 <20080813074503.GB398@elte.hu>
In-Reply-To: <20080813074503.GB398@elte.hu>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



>-----Original Message-----
>From: Ingo Molnar [mailto:mingo@elte.hu]
>Sent: Wednesday, August 13, 2008 3:45 PM
>To: Li, Shaohua
>Cc: lkml; Andrew Morton; Arjan van de Ven
>Subject: Re: [patch]fastboot: remove duplicate unpack_to_rootfs()
>
>
>* Shaohua Li <shaohua.li@intel.com> wrote:
>
>> we check if initrd is initramfs first and then do real unpack. The
>> check isn't required, we can directly do unpack. If initrd isn't
>> initramfs, we can remove garbage. In my laptop, this saves 0.1s boot
>> time. This penalizes non-initramfs case, but now initramfs is mostly
>> widely used.
>
>clever concept!
>
>a few observations about the cleanup function:
>
>> +static void __init clean_rootfs(void)
>> +{
>> +     int fd = sys_open("/", O_RDONLY, 0);
>
>can this ever fail?
I thought there will be a panic if it fails, so I didn't explicitly add a check here. I can add one.

>> +     struct linux_dirent64 *dirp = buf;
>> +     int count;
>> +
>> +     memset(buf, 0, PAGE_SIZE);
>
>overflow: clearly allocating a 1024 bytes buffer and then clearing 4096
>bytes isnt that good?
Oops, I use 4096 first and found it's too big, so changed to 1024, but forgot change all. My bad.

>you could introduce a default-off CONFIG_DEBUG_ROOTFS_CLEANUP option
>that does two runs of unpack_to_rootfs() and inserts an artificial
>clean_rootfs() inbetween? Even if that debug patch doesnt get integrated
>its a good test for the cleanup function.
Actually I did the test already, just forgot change all size.

>> +     while (count > 0) {
>> +             while (count > 0) {
>> +                     struct stat st;
>> +
>> +                     sys_newlstat(dirp->d_name, &st);
>
>can this ever fail? If yes we should at least WARN_ON_ONCE().
I'll add check.

>> +                     if (S_ISDIR(st.st_mode))
>> +                             sys_rmdir(dirp->d_name);
>> +                     else
>> +                             sys_unlink(dirp->d_name);
>> +
>> +                     count -= dirp->d_reclen;
>
>can this ever zero-underflow, with a sufficiently corrupted initramfs?
>We should check for 0 underflow to be sure.
>> +                     dirp = (void *)dirp + dirp->d_reclen;
>
>likewise, we should size-overflow check this pointer. Failure modes of
>overrunning the buffer are subtle and hard to notice/track down.
I'm not quite sure here. Do you think the .d_reclen can be a incorrect value?

>>  static int __init populate_rootfs(void)
>>  {
>>       char *err = unpack_to_rootfs(__initramfs_start,
>> @@ -531,13 +563,15 @@ static int __init populate_rootfs(void)
>>               int fd;
>>               printk(KERN_INFO "checking if image is initramfs...");
>>               err = unpack_to_rootfs((char *)initrd_start,
>> -                     initrd_end - initrd_start, 1);
>> +                     initrd_end - initrd_start, 0);
>>               if (!err) {
>>                       printk(" it is\n");
>> -                     unpack_to_rootfs((char *)initrd_start,
>> -                             initrd_end - initrd_start, 0);
>>                       free_initrd();
>>                       return 0;
>> +             } else {
>> +                     clean_rootfs();
>> +                     unpack_to_rootfs(__initramfs_start,
>> +                              __initramfs_end - __initramfs_start, 0);
>>               }
>
>the dry_run variable is now unused in unpack_to_rootfs() and could be
>eliminated.
Ok, I can cleanup this.

Thanks,
Shaohua
