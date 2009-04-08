Return-Path: <linux-kernel-owner+w=401wt.eu-S1757214AbZDHXtz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757214AbZDHXtz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 19:49:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754355AbZDHXtp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 19:49:45 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:47078 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754028AbZDHXtn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 19:49:43 -0400
Message-ID: <49DD380B.5080101@oracle.com>
Date: Wed, 08 Apr 2009 16:49:31 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: alan-jenkins@tuffmail.co.uk, Rusty Russell <rusty@rustcorp.com.au>,
       Arjan van de Ven <arjan@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       wireless <linux-wireless@vger.kernel.org>
Subject: Re: Regression in 2.6.30-rc1 since commit acae0515 - wireless broken
References: <49DC2DF5.3010603@lwfinger.net> <49DC31EA.8050208@linux.intel.com>	 <200904081631.09150.rusty@rustcorp.com.au>	 <49DCB976.4020200@lwfinger.net> <9b2b86520904081006m6e6b5276v834c3565b0f6f4c7@mail.gmail.com> <49DCDF9E.8000605@lwfinger.net>
In-Reply-To: <49DCDF9E.8000605@lwfinger.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt701.oracle.com [141.146.40.71]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010202.49DD37FB.016C:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Larry Finger wrote:
> Alan Jenkins wrote:
>> On 4/8/09, Larry Finger <Larry.Finger@lwfinger.net> wrote:
>>
>> Something is very wrong with request_module(), this is just the most
>> obvious symptom.  It also seems to affect libusual (loading
>> usb-storage) and FAT (loading NLS modules).
>>
>> If I hotplug my wireless device, it then loads correctly.  So I'm
>> guessing wireless modules e.g. encryption modules get loaded too
>> asynchronously.   I.e. on boot, the  sub-modules are loaded too late.
>> But when I hotplug the device, the modules are already loaded.
>>
>> Same with FAT - it fails on first attempt to mount because of missing
>> NLS module, then works on second mount,
>>
>> I agree that commit looks like it should be a no-op though :-).
>> I will try to confirm the OP's bisection by reverting the commit, acae0515.
> 
> I added printk's to the entry and exit from __request_module and obtained the
> following:
> 
> module: __request_module entered for module snd-hda-codec-id:14f15051
> module: loading module snd-hda-codec-id:14f15051 - call_usermodehelper returned 0
> module: __request_module entered for module ecb(arc4)
> module: loading module ecb(arc4) - call_usermodehelper returned 256
> module: __request_module entered for module ecb
> module: loading module ecb - call_usermodehelper returned 0
> module: __request_module entered for module char-major-4-68
> module: loading module char-major-4-68 - call_usermodehelper returned 256
> module: __request_module entered for module char-major-4
> module: loading module char-major-4 - call_usermodehelper returned 256
> module: __request_module entered for module char-major-4-69
> module: loading module char-major-4-69 - call_usermodehelper returned 256
> module: __request_module entered for module char-major-4
> module: loading module char-major-4 - call_usermodehelper returned 256
> module: __request_module entered for module char-major-4-70
> module: loading module char-major-4-70 - call_usermodehelper returned 256
> module: __request_module entered for module char-major-4
> module: loading module char-major-4 - call_usermodehelper returned 256
> module: __request_module entered for module char-major-4-71
> module: loading module char-major-4-71 - call_usermodehelper returned 256
> module: __request_module entered for module char-major-4
> module: loading module char-major-4 - call_usermodehelper returned 256
> module: __request_module entered for module net-pf-10
> module: loading module net-pf-10 - call_usermodehelper returned 256
> module: __request_module entered for module net-pf-10
> module: loading module net-pf-10 - call_usermodehelper returned 256
> module: __request_module entered for module net-pf-10
> module: loading module net-pf-10 - call_usermodehelper returned 256
> module: __request_module entered for module net-pf-10
> module: loading module net-pf-10 - call_usermodehelper returned 256
> module: __request_module entered for module net-pf-10
> module: loading module net-pf-10 - call_usermodehelper returned 256
> module: __request_module entered for module net-pf-10
> module: loading module net-pf-10 - call_usermodehelper returned 256
> module: __request_module entered for module net-pf-10
> module: loading module net-pf-10 - call_usermodehelper returned 256
> module: __request_module entered for module net-pf-10
> module: loading module net-pf-10 - call_usermodehelper returned 256
> module: __request_module entered for module net-pf-10
> module: loading module net-pf-10 - call_usermodehelper returned 256
> module: __request_module entered for module net-pf-10
> module: loading module net-pf-10 - call_usermodehelper returned 256
> module: __request_module entered for module net-pf-10
> module: loading module net-pf-10 - call_usermodehelper returned 256
> module: __request_module entered for module net-pf-10
> module: loading module net-pf-10 - call_usermodehelper returned 256
> module: __request_module entered for module net-pf-10
> module: loading module net-pf-10 - call_usermodehelper returned 256
> module: __request_module entered for module net-pf-10
> module: __request_module entered for module net-pf-10
> module: loading module net-pf-10 - call_usermodehelper returned 256
> module: loading module net-pf-10 - call_usermodehelper returned 256
> module: __request_module entered for module net-pf-10
> module: loading module net-pf-10 - call_usermodehelper returned 256
> module: __request_module entered for module net-pf-10
> module: loading module net-pf-10 - call_usermodehelper returned 256
> module: __request_module entered for module net-pf-10
> module: loading module net-pf-10 - call_usermodehelper returned 256
> module: __request_module entered for module net-pf-10
> module: loading module net-pf-10 - call_usermodehelper returned 256
> module: __request_module entered for module net-pf-10
> module: loading module net-pf-10 - call_usermodehelper returned 256
> module: __request_module entered for module net-pf-10
> module: loading module net-pf-10 - call_usermodehelper returned 256
> 
> According to the description of the routine, it should return 0 on success and a
> negative number for an error. Where do the values of "256" mean?

Here's a quick explanation (Linus explained this to me 6-8 years ago;
I bet his was better than mine, but I can't find his).

256 = 0x0100

Inside the kernel, a program's exit code/status is split into 2 8-bit fields,
so this exit status is (0x01, 0x00).  The low 8 bits (0x00 in this example)
store an internal code for why the program is exiting (or did exit).  E.g.:

0xlow_7_bits = 0 => exited, exit status is in "high" 8 bits
else 0x80 bit set => core dumped, else killed, with exit status in low 7 bits


So it looks like /sbin/modprobe exited with an exit status of 1...
whatever that means (fatal error or usage() printed or module not found).


See kernel/[signal.c & exit.c] for uses of 0x80...

HTH.
-- 
~Randy
