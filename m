Return-Path: <linux-kernel-owner+w=401wt.eu-S1759872AbZCSROI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759872AbZCSROI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 13:14:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756961AbZCSRNy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 13:13:54 -0400
Received: from g4t0015.houston.hp.com ([15.201.24.18]:32857 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751066AbZCSRNx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 13:13:53 -0400
Date: Thu, 19 Mar 2009 11:13:51 -0600
From: Alex Chiang <achiang@hp.com>
To: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Cc: jbarnes@virtuousgeek.org, shimada-yxb@necst.nec.co.jp,
       linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 00/12] PCI core learns hotplug
Message-ID: <20090319171351.GI8074@ldl.fc.hp.com>
References: <20090318222426.887.1008.stgit@bob.kio> <49C25203.60005@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49C25203.60005@jp.fujitsu.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>:
> Alex Chiang wrote:
>> We're getting close to the new merge window, and I _think_ this
>> patch series is ready for consideration. Notably:
>>
>> 	- multiple rescans/removes of devices with and without bridges
>> 	- verified that resource allocation after multiple remove/rescan
>> 	  cycles is the same as what we had during initial boot
>> 	- fixes the complete suckage of fakephp (that I created)
>> 	- doesn't affect existing hotplug drivers
>> 	- tested on x86 and ia64 platforms
>>
>> Please review, and consider testing. For testing ease, you can pull
>> from my git branch:
>>
>> 	git://git.kernel.org/pub/scm/linux/kernel/git/achiang/pci-hotplug.git
>> 	branch 'test-20090318' is what you want
>>
>
> When I rescan the bus even without remove anything, I got the
> following messages. And enable count of the bridge is incremented
> every time.
>
> [17240.309096] pci 0000:2d:00.0: BAR 6: bogus alignment [0x0-0x0] flags 0x2
> [17240.309135] pcieport-driver 0000:00:01.0: setting latency timer to 64
> [17240.309143] pcieport-driver 0000:00:02.0: setting latency timer to 64
> [17240.309150] pcieport-driver 0000:14:00.0: setting latency timer to 64
> [17240.309159] pcieport-driver 0000:15:00.0: setting latency timer to 64
> [17240.309166] pcieport-driver 0000:15:01.0: setting latency timer to 64
> [17240.309174] pcieport-driver 0000:15:02.0: setting latency timer to 64
> [17240.309182] pci 0000:14:00.3: setting latency timer to 64
> [17240.309189] pcieport-driver 0000:00:03.0: setting latency timer to 64
> [17240.309198] pcieport-driver 0000:2a:00.0: setting latency timer to 64
> [17240.309207] pcieport-driver 0000:2b:02.0: setting latency timer to 64
> [17240.309215] pcieport-driver 0000:2b:04.0: setting latency timer to 64
> [17240.309223] pcieport-driver 0000:00:04.0: setting latency timer to 64
> [17240.309231] pcieport-driver 0000:2e:00.0: setting latency timer to 64
> [17240.309240] pcieport-driver 0000:2f:02.0: setting latency timer to 64
> [17240.309248] pcieport-driver 0000:2f:04.0: setting latency timer to 64
> [17240.309256] pcieport-driver 0000:00:06.0: setting latency timer to 64
> [17240.309264] pcieport-driver 0000:51:00.0: setting latency timer to 64
> [17240.309273] pcieport-driver 0000:52:02.0: setting latency timer to 64
> [17240.309281] pcieport-driver 0000:52:04.0: setting latency timer to 64
> [17240.309291] pci 0000:64:00.0: setting latency timer to 64
> [17240.309300] pcieport-driver 0000:00:1c.0: setting latency timer to 64
> [17240.309308] pci 0000:00:1e.0: setting latency timer to 64

I will investigate these.

> [root@localhost pci]# echo 1 > rescan
> [root@localhost pci]# cat /sys/bus/pci/devices/0000\:2f\:04.0/enable
> 6
> [root@localhost pci]# echo 1 > rescan
> [root@localhost pci]# cat /sys/bus/pci/devices/0000\:2f\:04.0/enable
> 7
> [root@localhost pci]# echo 1 > rescan
> [root@localhost pci]# cat /sys/bus/pci/devices/0000\:2f\:04.0/enable
> 8
> [root@localhost pci]# echo 1 > rescan
> [root@localhost pci]# cat /sys/bus/pci/devices/0000\:2f\:04.0/enable
> 9

Hm, that's because I'm calling pci_enable_bridges()
unconditionally every time even if we didn't add any new bridges,
which is obviously wrong.

I will try and figure out a fix for this.

Thanks for testing.

/ac

