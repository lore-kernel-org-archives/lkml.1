Return-Path: <linux-kernel-owner+w=401wt.eu-S965168AbXBQK6b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965168AbXBQK6b (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 05:58:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965169AbXBQK6b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 05:58:31 -0500
Received: from oola.is.scarlet.be ([193.74.71.23]:36643 "EHLO
	oola.is.scarlet.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965168AbXBQK6a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 05:58:30 -0500
Message-ID: <45D6DFC8.4060503@scarlet.be>
Date: Sat, 17 Feb 2007 10:58:16 +0000
From: Joel Soete <soete.joel@scarlet.be>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Tejun Heo <htejun@gmail.com>
CC: Luming Yu <luming.yu@gmail.com>, Alan Cox <alan@redhat.com>,
       Ioan Ionita <opslynx@gmail.com>, Alan <alan@lxorguk.ukuu.org.uk>,
       linux-kernel@vger.kernel.org, jgarzik@pobox.com
Subject: Re: 2.6.20-rc6 libata PATA ATAPI CDROM is not working
References: <df47b87a0611161522o3ad007f5i8804c876c50e591c@mail.gmail.com>	 <20061116235048.3cd91beb@localhost.localdomain>	 <df47b87a0611161730p70e1dd41iad7d27a0bf9283ff@mail.gmail.com>	 <df47b87a0611161734h818fc4dneaad5eeaa7e3c392@mail.gmail.com>	 <20061117100559.GA10275@devserv.devel.redhat.com>	 <459286C2.7080705@scarlet.be> <45943C15.4010506@scarlet.be>	 <459B31AE.709@gmail.com> <459BE5AC.70703@scarlet.be>	 <45BB51F9.5070100@scarlet.be> <3877989d0701270610h7a950125n10d439c3bebce9d0@mail.gmail.com> <45BB64F1.1000105@scarlet.be> <45CFBBD1.5090703@gmail.com> <45D0D133.8070801@scarlet.be> <45D1F6E4.2080102@scarlet.be> <45D201D6.4050908@gmail.com>
In-Reply-To: <45D201D6.4050908@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Tejun,

Sorry for delay but I was a bit busy this week.

Tejun Heo wrote:
> Hello, Joel.
> 
> Joel Soete wrote:
>> A small update:
>> your patch also works against 2.6.20
> 
> Glad to hear that.
> 
>> but seems that open the door to numerous other pb:
>> 1/ pb to burn cd:
>> # md5sum cd060213.iso
>> 6a1248783a21722816b972aa9bae9d5e  cd060213.iso
>>
>> # ll cd060213.iso
>> -rwxr-xr-x 1 root root 3213312 Feb 13  2006 cd060213.iso
>>
>> # dd if=/dev/sr0 bs=1 count=3213312 | md5sum
>> dd: reading `/dev/sr0': Input/output error
>> 0337e9846d17779945c5c252d4f897f0  -
>> 3129344+0 records in
>> 3129344+0 records out
>> 3129344 bytes (3.1 MB) copied, 36.6963 seconds, 85.3 kB/s
>>
>> eventhought cdrecord seems to be successfull???
> 
> Hmm... 82K difference.  Can you burn an iso and md5sum the files 
> contained in the image and burned cd?
> 
Ok comparing the content of the original image:
# mount -t iso9660 -o ro -o loop /MultiCd/cd060213.iso /mnt/cd
# find /mnt/cd -type f -exec md5sum {} \;
37149d4961c0484f2cceb1a1614b253d  /mnt/cd/boot.cat
4ab996554b0e7ade115a3f284b876612  /mnt/cd/boot.msg
fbdc51c29d54dd227427b2ef90e1961e  /mnt/cd/initrd.cgz
92c9a50bed71257c29f069ec5dd819fc  /mnt/cd/isolinux.bin
927ce1096693b3a44af0e0d8a2ad720c  /mnt/cd/isolinux.cfg
4afcf65ff8259a3bccd0cf9f91675529  /mnt/cd/scsi.cgz
4714742585da795c3a69c262ce8c35ef  /mnt/cd/vmlinuz

and the content of the burned cd:
# mount /cdrom
# find /cdrom -type f -exec md5sum {} \;
37149d4961c0484f2cceb1a1614b253d  /cdrom/boot.cat
4ab996554b0e7ade115a3f284b876612  /cdrom/boot.msg
fbdc51c29d54dd227427b2ef90e1961e  /cdrom/initrd.cgz
92c9a50bed71257c29f069ec5dd819fc  /cdrom/isolinux.bin
927ce1096693b3a44af0e0d8a2ad720c  /cdrom/isolinux.cfg
4afcf65ff8259a3bccd0cf9f91675529  /cdrom/scsi.cgz
4714742585da795c3a69c262ce8c35ef  /cdrom/vmlinuz

it seems ok?

What is it lost???


>> 2/ (but that should be much more related to scsi api) sdcXX > sdc15 
>> doesn't works ;-(
>> # sfdisk -l /dev/sdc
>>
>> Disk /dev/sdc: 1826 cylinders, 255 heads, 63 sectors/track
>> Units = cylinders of 8225280 bytes, blocks of 1024 bytes, counting from 0
>>
>>    Device Boot Start     End   #cyls    #blocks   Id  System
>> /dev/sdc1   *      0+    195     196-   1574338+   b  W95 FAT32
>> /dev/sdc2        196    1825    1630   13092975    5  Extended
[snip]
>> /dev/sdc23       881+   1533     653-   5245191   83  Linux
>> /dev/sdc24      1795    1825      31     249007+  83  Linux
> 
> Whee, you have 24 partitions?
yes: it was dated from the early time I was testing various distro to choose one ;-)

>  Due to the way SCSI block device numbers 
> are laid out, SCSI supports only upto 15 partitions per device.
> 
Ah, I never had chance to use a disk array with fc connection on one of my linux boxe, so I don't know how can it works with 
up to 255 luns?

Thanks again,
	Joel
