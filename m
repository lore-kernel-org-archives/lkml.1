Return-Path: <linux-kernel-owner+w=401wt.eu-S1753101AbYLLTX7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753101AbYLLTX7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 14:23:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751320AbYLLTXq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 14:23:46 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:55050 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751269AbYLLTXp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 14:23:45 -0500
Message-ID: <4942BA24.8070105@vlnb.net>
Date: Fri, 12 Dec 2008 22:23:16 +0300
From: Vladislav Bolkhovitin <vst@vlnb.net>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
CC: linux-scsi@vger.kernel.org,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Mike Christie <michaelc@cs.wisc.edu>, Jeff Garzik <jeff@garzik.org>,
       Boaz Harrosh <bharrosh@panasas.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, scst-devel@lists.sourceforge.net,
       Bart Van Assche <bart.vanassche@gmail.com>,
       Joel Becker <joel.becker@oracle.com>
Subject: Re: [PATCH][RFC 5/23]: SCST /proc interface
References: <494009D7.4020602@vlnb.net>  <49400C81.3010801@vlnb.net> <1229026987.4153.555.camel@haakon2.linux-iscsi.org>
In-Reply-To: <1229026987.4153.555.camel@haakon2.linux-iscsi.org>
Content-Type: text/plain; charset=KOI8-R; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX1++COkBsH0YBTaluXy78AzfwNJgEhm6tNpv5Nf
 LXgDOYVjbe6MEWEh0efFrm5LdyLMdmpQQM/PZJM3h5sB9eHIcM
 3Dp97hGysRp3W4wBwkayg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nicholas A. Bellinger wrote:
> On Wed, 2008-12-10 at 21:37 +0300, Vladislav Bolkhovitin wrote:
>> This patch contains SCST the /proc interface.
>>
>> A description of this interface can be found in the patch with the
>> SCST core documentation.
>>
>> Since a procfs-based configuration interface is unacceptable for new 
>> kernel modules, in the next review iteration SCST's configuration 
>> interface will be replaced by a sysfs-based configuration interface. 
>> This patch is not intended to be included in the Linux kernel, but is 
>> posted here, because as of today this configuration interface is 
>> necessary when using SCST.
>>
>> Unfortunately, configfs is not (yet) suited for configuring SCST. This 
>> is, because configfs is user space driven, so kernel can't create 
>> subdirectories on it, and all files on configfs are limited to 4K in 
>> size. It makes impossible for kernel to show, e.g., a list of connected 
>> initiators. Hence, with configfs it is necessary to have one more 
>> interface to show such data, e.g. sysfs-based. 
> 
> Btw, please stop spreading FUD about ConfigFS.  ConfigFS works great for
> Target_Core_Mod and LIO-Target v3.0, and is what I have found as the
> *BEST* foundation for generic target mod moving forward.  This is not
> based on a hypothetical discussion or on a long term TODO list, this has
> been determined from actually writing the code, which is located at:
> 
> http://git.kernel.org/?p=linux/kernel/git/nab/lio-core-2.6.git;a=blob;f=drivers/lio-core/target_core_configfs.c
> 
> http://git.kernel.org/?p=linux/kernel/git/nab/lio-core-2.6.git;a=blob;f=drivers/lio-core/iscsi_target_configfs.c
> 
> So please, just because you don't want to acknowledge ConfigFS in your
> own work, do not act like there is not already thounsands of lines of
> ConfigFS code up and running for the generic target mode and LIO-Target.

Nicholas,

You have an *exceptional* ability don't see what you don't want to see. 
It has already happened with Persistent Reservations over pass-through 
backend (see the end of http://lkml.org/lkml/2008/7/10/328 and 
subsequent messages in this thread) and now this is happening with 
configfs. I already 2 times described you why configfs isn't appropriate 
for a SCSI target (the first time in 
http://lkml.org/lkml/2008/10/21/259), but you keep refusing to see it. 
In short:

1. Kernel can't create subdirectories in configfs

2. Sysfs doesn't allow files >4K

3. What you have been doing to live with the above limitations is 
implementing "access allowed only for explicitly specified initiators 
and forbidden for all others" security approach. This approach is 
unacceptable on practice. The majority of people simply define available 
devices for a target and don't bother with listing initiators, which 
allowed to connect to it. But you forces them to do that and keep doing 
again and again for each related network change.

In contrast, sysfs allows kernel to create subdirectories. It will allow 
to workaround the 4K limitation by a simple subdirectories hierarchy. 
So, both security approaches ("access allowed only for explicitly 
specified initiators and forbidden for all others" and "access forbidden 
only for explicitly specified initiators and allowed for all others") 
can be seamlessly implemented on sysfs as it is currently done on procfs 
in SCST.

Vlad
