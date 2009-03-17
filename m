Return-Path: <linux-kernel-owner+w=401wt.eu-S1756949AbZCQLfV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756949AbZCQLfV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 07:35:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755310AbZCQLfG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 07:35:06 -0400
Received: from smtp-outbound-1.vmware.com ([65.115.85.69]:59476 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755037AbZCQLfF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 07:35:05 -0400
Message-ID: <49BF8ABC.6040805@vflare.org>
Date: Tue, 17 Mar 2009 17:04:20 +0530
From: Nitin Gupta <ngupta@vflare.org>
Reply-To: ngupta@vflare.org
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [PATCH 0/3]: compressed in-memory swapping
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Antivirus: avast! (VPS 090316-0, 16-03-2009), Outbound message
X-Antivirus-Status: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Project home: http://code.google.com/p/compcache/

It allows creating a RAM based block device which acts as swap disk.
Pages swapped to this device are compressed and stored in memory itself.
This is a big win over swapping to slow hard-disk which are typically used
as swap disk. For flash, these suffer from wear-leveling issues when used
as swap disk - so again its helpful. For swapless systems, it allows more
apps to run.

Its now part of Ubuntu, ALT Linux and some other distros.

Some use cases:
  - Embedded Devices: Memory is scarce and adding more memory increases
    device cost. Also, flash storage suffers from wear-levelling issues.
  - Virtualization: For host/hypervisor, VM/guest memory is all anonymous
    memory. So, compcache can compress any part of guest. So we can host
    more VMs on same amount of memory.
  - Thinclients.

Testing/Performance:
  - Testing for use on Thinclients (contrib: Nai Xia):
     Details: http://code.google.com/p/compcache/wiki/LTSPPerf
     Summary: http://code.google.com/p/compcache/wiki/LTSPPerfSummary

     Summary: after the compcache was loaded:
         - The time of paging down one pdf page was reduced to 1/4~1/100
         - The time of switching from one firefox tab to another was reduced to 1/6
         - The capacity of kpdf was be increased from 2 pdf files to 11 pdf files.
         - The capacity of firefox was increased from 6 web pages to 15 web pages.

  - Testing on x86 and x64 VMs (256/512MB RAM, 1 VCPU, 512MB Swap):
    Started Fedora 10 and some "generic desktop" apps (KDE4, Firefox,
    filemanager, editors) - without compcache, system swapped heavily
    and very unresponsive. With compcache, very noticeable improvement
    in responsiveness.

  - Some reported running on PS3 systems though no performance stats
    available here.

Limitations:
  - Being a "swap disk" it can compress only anonymous memory. But as mentioned
    above, at hypervisor/host level, all guest memory is anonymous so any part
    of guest memory can be compressed.
  - Memory allocator used is not scalable at all (work in progress).
  - No run-time defragmentation, swapping of allocated memory - however,
    incompressible pages are forwarded to physical swap and can set limit
    on amount of memory used by compcache.

I do not claim performance gain for any arbitrary workload but as testing
shows, it certainly helps in some cases :)

Also note that this is a low risk change - it does not modify any part
of kernel. Its just an additional module. In case you find it hurting
performance, just unload this module and maybe use normal disk swap.

Any reviews/comments/suggestions are welcome.

Thanks,
Nitin
