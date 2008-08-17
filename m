Return-Path: <linux-kernel-owner+w=401wt.eu-S1753514AbYHQUWt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753514AbYHQUWt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2008 16:22:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751291AbYHQUWl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Aug 2008 16:22:41 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:21056 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751084AbYHQUWk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2008 16:22:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=MQEjtzaVLAKSaAiZlFLK52o1jwbGuL2E5iUDKFTG0/v6zEp4tFqugCDh08WaOqLpGd
         4929h/sHGa9v+EWVEY3X02edrX0GRMW37CJdyvBGkdUDwImPrbVhPe8tl/BdfH3r3LI1
         gruvNiazWVB8qqFbuOneqUwFemlTkZUHFCrYs=
Message-ID: <f2b895370808171322v4e60e4aft856c93b15ee262b6@mail.gmail.com>
Date: Sun, 17 Aug 2008 22:22:39 +0200
From: "Marc Villemade" <mastachand@gmail.com>
To: "Arjan van de Ven" <arjan@infradead.org>
Subject: Re: [Follow-up] Physical memory disappeared from /proc/meminfo
Cc: "Rik van Riel" <riel@redhat.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20080817124212.6048fa71@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <f2b895370808171059x4bd0296frf50b07ae7af21375@mail.gmail.com>
	 <20080817145906.06ccd795@riellaptop.surriel.com>
	 <f2b895370808171226l13728b1dg7e79051c158e21f3@mail.gmail.com>
	 <20080817124212.6048fa71@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 17, 2008 at 9:42 PM, Arjan van de Ven <arjan@infradead.org> wrote:
> On Sun, 17 Aug 2008 21:26:07 +0200
> "Marc Villemade" <mastachand@gmail.com> wrote:
>
>> hey
>>
>> Thanks for your answer, but it still doesn't come close. I'm up to 1.5
>> Gig adding what i said. and PageTables + VMallocTotal equals 160 Mo.
>> Sounds unlikely to me that something unaccounted for might go up to
>> 1.4 Gig, don't you think ? Or maybe it is accounted somewhere else
>> than /proc/meminfo ? Please point me to the right place if so.
>>
>
> you're not accidentally using shmfs or tmpfs are you ?
> (or otherwise have a leak in sysv shm)
>
>
> you can use the "ipcs" command to see your shm allocation
>
> (and for tmpfs/shmfs... check if you have it mounted anywhere.
> Something like /dev being on shmfs and /dev/null being a file not a
> device can.. totally screw you over)
>

hey,

here are my mount points:

6_days_uptime_machine ~ # mount
/dev/evms/root on / type ext3 (rw,noatime)
proc on /proc type proc (rw)
sysfs on /sys type sysfs (rw,noexec,nosuid,nodev)
udev on /dev type tmpfs (rw,nosuid)
devpts on /dev/pts type devpts (rw,nosuid,noexec)
/dev/evms/boot on /boot type ext3 (rw,noatime)
/dev/evms/data on /data type ext3 (rw,noatime,data=journal)
/dev/evms/queue on /mnt/queue type ext3 (rw,noatime)
none on /dev/shm type tmpfs (rw)
/dev on /opt/bizanga/chroot/dev type none (rw,bind)
usbfs on /proc/bus/usb type usbfs (rw,noexec,nosuid,devmode=0664,devgid=85)
binfmt_misc on /proc/sys/fs/binfmt_misc type binfmt_misc
(rw,noexec,nosuid,nodev)

so shmfs is never used, but tmpfs is for /dev and /dev/shm. Do you
think that would be an issue ?

and it looks like i'm not using any shared mem either :
6_days_uptime_machine ~ # ipcs -a

------ Shared Memory Segments --------
key        shmid      owner      perms      bytes      nattch     status

------ Semaphore Arrays --------
key        semid      owner      perms      nsems

------ Message Queues --------
key        msqid      owner      perms      used-bytes   messages


And i've also checked that all /dev entries are devices. Thanks for the tip.

After Ryk's email, i started looking a little more closely to the
other values in /proc/meminfo and /proc/zoneinfo and i would like to
have more information about zoneinfo. It seems that most of the
inactive pages are in HighMem :

        active   148512
        inactive 403735
        scanned  0 (a: 0 i: 0)

and what does the scanned line mean ? And what about the fact that
it's all 0 ? Means that it's never been scanned for reclaimable space
? Maybe that's where my problem lies !? Any more info on those proc
entries would be greatly appreciated. My friend google didn't have a
lot of good answers, neither did the Kernel documentation.


Marc Villemade
