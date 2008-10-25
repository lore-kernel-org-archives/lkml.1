Return-Path: <linux-kernel-owner+w=401wt.eu-S1753082AbYJYJj5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753082AbYJYJj5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2008 05:39:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752024AbYJYJjs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Oct 2008 05:39:48 -0400
Received: from fk-out-0910.google.com ([209.85.128.188]:9558 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751676AbYJYJjr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2008 05:39:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=GwgLEJ1ITe8ZpRKW28gW+zm6FTHcylVecybPrQWzrT9yENXAIUcun9o9ne0M47rnTx
         H1wOe4aTM/+wBgTSvIxqPCyJBX8JnjBaaMQWh5sI/+2BhC1nDi0whlnr1Pak9fxhG9qT
         iFgy5rHI2sy9rOSpCA7hktM9UUFJHRgag2ZVg=
Date: Sat, 25 Oct 2008 11:40:43 +0200
From: "Carlos R. Mafra" <crmafra2@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: arjan@linux.intel.com
Subject: [2.6.28-rc1 regression] wmifinfo dockapp takes 100% of cpu
	(bisected)
Message-ID: <20081025094043.GA4438@localhost.aei.mpg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have just tested 2.6.28-rc1 and I bisected a particular regression
which I faced to 8ff3e8e85fa6c312051134b3953e397feb639f51 ("select: 
switch select() and poll() over to hrtimers") from Arjan (added to Cc:).

The symptom is that one little Window Maker dockapp I use, called wmifinfo,
starts to use 100% of the cpu. I have to kill it to avoid staying at the
maximum 2000 MHz.

The dockapp apparently enters an infinite loop, because I used strace
for a few moments and the log file had more than 1 million lines.
The block of commands which kept repeating itself in the strace log
was:

open("/proc/net/dev", O_RDONLY)         = 9
fstat(9, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7fa374ccb000
read(9, "Inter-|   Receive               "..., 1024) = 694
read(9, "", 1024)                       = 0
close(9)                                = 0
munmap(0x7fa374ccb000, 4096)            = 0
ioctl(5, SIOCGIFCONF, {0, {}})          = 0
ioctl(5, SIOCGIFFLAGS, {ifr_name="eth0", ifr_flags=IFF_BROADCAST|IFF_MULTICAST}) = 0
ioctl(5, SIOCGIFHWADDR, {ifr_name="eth0", ifr_hwaddr=00:1a:80:4a:7f:37}) = 0
ioctl(5, SIOCGIFADDR, {ifr_name="eth0", ???}) = -1 EADDRNOTAVAIL (Cannot assign requested address)
ioctl(5, SIOCGIFNETMASK, {ifr_name="eth0", ???}) = -1 EADDRNOTAVAIL (Cannot assign requested address)
lseek(6, 0, SEEK_SET)                   = 0
read(6, "Iface\tDestination\tGateway \tFlags"..., 1024) = 128
read(6, "", 1024)                       = 0
lseek(7, 0, SEEK_SET)                   = 0
read(7, "Inter-| sta-|   Quality        |"..., 1024) = 238
read(7, "", 1024)                       = 0
lseek(8, 0, SEEK_SET)                   = 0
read(8, "Inter-|   Receive               "..., 1024) = 694
read(8, "", 1024)                       = 0
read(3, 0x228ff54, 4096)                = -1 EAGAIN (Resource temporarily unavailable)
select(4, [3], [3], NULL, NULL)         = 1 (out [3])
writev(3, [{">\0\7\0\1\0`\0\1\0`\0\7\0`\0@\0\0\0\0\0\0\0@\0@\0>\0\7\0"..., 616}], 1) = 616
read(3, 0x228ff54, 4096)                = -1 EAGAIN (Resource temporarily unavailable)
read(3, 0x228ff54, 4096)                = -1 EAGAIN (Resource temporarily unavailable)
select(4, [3], [3], NULL, NULL)         = 1 (out [3])
writev(3, [{">\0\7\0\1\0`\0\6\0`\0\7\0`\0\0\0\0\0\0\0\0\0\206\0Z\0", 28}], 1) = 28
read(3, 0x228ff54, 4096)                = -1 EAGAIN (Resource temporarily unavailable)
select(4, [3], NULL, NULL, {0, 5000000}) = -1 EINVAL (Invalid argument)
select(4, [3], [3], NULL, NULL)         = 1 (out [3])
writev(3, [{">\0\7\0\1\0`\0\5\0`\0\7\0`\0\0\0\0\0\0\0\0\0\206\0Z\0", 28}], 1) = 28
read(3, 0x228ff54, 4096)                = -1 EAGAIN (Resource temporarily unavailable)
select(4, [3], NULL, NULL, {0, 5000000}) = -1 EINVAL (Invalid argument)
read(3, 0x228ff54, 4096)                = -1 EAGAIN (Resource temporarily unavailable)
select(4, [3], NULL, NULL, {0, 5000000}) = -1 EINVAL (Invalid argument)
read(3, 0x228ff54, 4096)                = -1 EAGAIN (Resource temporarily unavailable)
select(4, [3], NULL, NULL, {0, 5000000}) = -1 EINVAL (Invalid argument)
read(3, 0x228ff54, 4096)                = -1 EAGAIN (Resource temporarily unavailable)


I got to that commit by git bisect, but I could not revert it cleanly to really 
prove it is the cause of the problem. So I apologize in advance if this commit
is not the true culprit.

I can test any patches.
