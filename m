Return-Path: <linux-kernel-owner+w=401wt.eu-S1757578AbXGMLFu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757578AbXGMLFu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 07:05:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752938AbXGMLFn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 07:05:43 -0400
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:57570 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752710AbXGMLFm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 07:05:42 -0400
To: Neil Horman <nhorman@redhat.com>
Cc: Bernhard Walle <bwalle@suse.de>, kexec@lists.infradead.org,
       linux-kernel@vger.kernel.org
Subject: Re: Determine version of kernel that produced vmcore
In-reply-to: <20070710120243.GA10121@hmsendeavour.rdu.redhat.com>
Message-Id: <20070713200533oomichi@mail.jp.nec.com>
References: <20070710120243.GA10121@hmsendeavour.rdu.redhat.com>
Mime-Version: 1.0
X-Mailer: WeMail32[2.51] ID:5W0000
From: "Ken'ichi Ohmichi" <oomichi@mxs.nes.nec.co.jp>
Date: Fri, 13 Jul 2007 20:05:33 +0900
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi all,

2007/07/10 08:02:43 -0400, Neil Horman <nhorman@redhat.com> wrote:
>> Besides Dan's plan, I'm planning the change of CONFIGFILE for distributors.
>> In the kernel building process, distributors need to make CONFIGFILE
>> on an older kernel (ex. RHEL5 kernel is built on RHEL4), and OSRELEASE
>> may be an older kernel. So OSRELEASE should be modified to the building
>> kernel version by hand, but it is not smart.
>> 
>> To solve this problem, I'm proposing 2 plans.
>> Could you give me your opinion ?
>> 
>> Plan 1:
>>   A new option [--osrelease="string"] is added.
>>   The OSRELEASE of CONFIGFILE is overwritten by "string".
>>   In the kernel building process, distributors should specify "string"
>>   as the building kernel version.
>> 
>> Plan2:
>>   Remove the OSRELEASE from CONFIGFILE.
>>   Instead of checking the OSRELEASE, makedumpfile only checks whether the
>>   area of /proc/vmcore specified by the symbol "system_utsname" in CONFIGFILE
>>   is the string "2.6.". If CONFIGFILE and /proc/vmcore don't match, the
>>   "system_utsname" must not point to the correct area in most cases.
>>   Old makedumpfile needs OSRELEASE, and it cannot work by new CONFIGFILE.
>>   But I think there are not any problems because old makedumpfile will not
>>   read new CONFIGFILE. Now, CONFIGFILE is used only by RHEL5's kdump initramfs,
>>   the CONFIGFILE is generated during 1st-kernel running. Even if CONFIGFILE
>>   will be updated, makedumpfile can read the CONFIGFILE because makedumpfile
>>   should be updated with CONFIGFILE.
>> 
>> 
>> I'd like to change the name of CONFIGFILE to mkdfinfo.
>> 
>Why not, instead of either plan above, just redefine OSRELEASE to be the version
>of the kernel the config file was built against?  i.e. when you build a config
>file, you need to specify a kernel to extract symbol information from, why not
>grab the utsname from that kernel and use that to set OSRELEASE?  When you're
>building a config file the running kernel on the system isn't really relevent
>anyway.

Did you say "makedumpfile should get OSRELEASE from a vmlinux file,
and output it to a mkdfinfo file", right ?
If so, you are right. I'm creating the patch for it.

BTW, I'd like to remove PAGESIZE from a mkdfinfo file.
While 2nd-kernel is running, new makedumpfile comes to consider
2nd-kernel PAGESIZE as 1st-kernel PAGESIZE without getting PAGESIZE
from a mkdfinfo file.

In current implementation, makedumpfile considers 2nd-kernel PAGESIZE
as 1st-kernel PAGESIZE if a vmlinux file is specified instead of a
mkdfinfo file. On the other hand, makedumpfile can get 1st-kernel
PAGESIZE correctly if a mkdfinfo file is specified, because there
is the rule that a mkdfinfo file should be generated on 1st-kernel.

Now, I will change this rule for generating a mkdfinfo file on the
kernel-building environment. I feel considering 2nd-kernel PAGESIZE
as 1st-kernel PAGESIZE is better than considering the PAGESIZE of
kernel-building environment, because 1st-kernel and 2nd-kernel have
the same PAGESIZE in most cases such as relocatable kernel.


Please let me know your opinion.


Thanks
Ken'ichi Ohmichi
