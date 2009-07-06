Return-Path: <linux-kernel-owner+w=401wt.eu-S1753872AbZGFOn5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753872AbZGFOn5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 10:43:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752814AbZGFOnu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 10:43:50 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:41760 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753349AbZGFOnt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 10:43:49 -0400
Message-ID: <4A520DA6.2040107@petalogix.com>
Date: Mon, 06 Jul 2009 16:43:50 +0200
From: Michal Simek <michal.simek@petalogix.com>
Reply-To: michal.simek@petalogix.com
User-Agent: Thunderbird 2.0.0.18 (X11/20081120)
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Paul Mundt <lethal@linux-sh.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       LTP <ltp-list@lists.sourceforge.net>,
       John Williams <john.williams@petalogix.com>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Grant Likely <grant.likely@secretlab.ca>, subrata@linux.vnet.ibm.com
Subject: Re: mmap syscall problem
References: <4A4DFB77.1080700@petalogix.com> <20090706121455.GA16908@linux-sh.org> <4A51F3F3.6040501@petalogix.com> <200907061616.12220.arnd@arndb.de>
In-Reply-To: <200907061616.12220.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann wrote:
> On Monday 06 July 2009, Michal Simek wrote:
>   
>>> Not necessarily, even on platforms that manage aliases in hardware
>>> mappings that violate the aliasing constraints can still result in
>>> undefined behaviour, this really depends more on your cache controller
>>> and MMU than anything else. I notice that microblaze sets SHMLBA to
>>> PAGE_SIZE, you may want to see if this test still breaks after bumping it
>>> up to something like PAGE_SIZE * 4.
>>>   
>>>       
>> Yes, test still break - behavior is the same. I don't have accurate
>> information about MMU unit
>> but I will ask a question about. We are able to turn off cache
>> controller directly in HW.
>>     
>
> There may still be a problem with data being queued in some write
> buffers that don't get flushed before reading back from another
> address.
>
> What happens in a simple user space program that mmaps the same
> page to two addresses? Something like
>
> #include <sys/mman.h>
> #include <fcntl.h>
> int main(void)
> {
> 	int fd = open("existing-4k-file", O_RDWR);
> 	char *p1 = mmap(0, 4096, PROT_READ | PROT_WRITE,
> 				MAP_SHARED, fd, 0);
> 	char *p2 = mmap(p1 + 4096, 4096, PROT_READ | PROT_WRITE,
> 				MAP_SHARED | MAP_FIXED, fd, 0);
>
> 	*p1 = 0xaa; *p2 = 0x55;
>   
I closed fd too.
    close(fd);
> 	return *p1; /* returns 0xaa if broken, 0x55 if correct */
> }
>   
# ls -la existing-4k-file
-rw-rw-r--    1 monstr   monstr       4096 Jul  6  2009 existing-4k-file

# ./test-arnd
# echo $?
85
# dd if=existing-4k-file of=/dev/console count=1 2>/dev/null
U#

in file is first char U (0x55) which is IMO correct.

Michal



> 	Arnd <><
>   


-- 
Michal Simek, Ing. (M.Eng)
PetaLogix - Linux Solutions for a Reconfigurable World
w: www.petalogix.com p: +61-7-30090663,+42-0-721842854 f: +61-7-30090663

