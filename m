Return-Path: <linux-kernel-owner+w=401wt.eu-S932381AbYB2NS2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932381AbYB2NS2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 08:18:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753482AbYB2NSS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 08:18:18 -0500
Received: from g1t0028.austin.hp.com ([15.216.28.35]:26179 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753271AbYB2NSR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 08:18:17 -0500
Message-ID: <47C8061A.6080009@hp.com>
Date: Fri, 29 Feb 2008 08:18:18 -0500
From: Mark Seger <Mark.Seger@hp.com>
Organization: Consulting and Architecture
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: util-linux-ng@vger.kernel.org, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Collectl now support monitoring Interrupts by CPU
References: <477FDAA8.2030001@hp.com>
In-Reply-To: <477FDAA8.2030001@hp.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In keeping with the spirit of adding new useful features when they help 
solve real world problems, I've added this ability to collectl as a 
direct result of a problem we were recently having when doing some 
network performance testing.  It turned out all the interrupts were 
being processed by cpu0 (this was on an 8-core system) but all collectl 
told us was the aggregate number!  Once we moved to a NIC/driver that 
supported multiple queues that could distribute interrupts to multiple 
CPUs it only made sense to enhance collectl to let us verify that this 
was indeed happening - I personally find examining /proc/interrupts for 
changes more trouble than it's worth.

In any event, the following is an example of how collectl can present 
this data, first summarized by CPU:

#Time     Cpu0 Cpu1 Cpu2 Cpu3 Cpu4 Cpu5 Cpu6 Cpu7
12:49:55  4828  16K 1000  16K   18  16K  16K    0
12:49:56  4804  16K 1000  16K    0  16K  16K    0
12:49:57  4811  16K 1000  16K   18  16K  16K    0
12:49:58  4789  16K 1000  16K    0  17K  16K   44

and here by the type of the interrupt itself:

# INTERRUPT DETAILS
#          Int    Cpu0   Cpu1   Cpu2   Cpu3   Cpu4   Cpu5   Cpu6   Cpu7 
  Type            Device(s)
12:48:50   082       0      0      0   7731      0      0      0      
0   PCI-MSI-X       eth2 (queue 0)
12:48:50   098       0      0      0      0   2037      0      0      
0   PCI-MSI-X       eth2 (queue 2)
12:48:50   122       0      0   2240      0      0      0      0      
0   PCI-MSI-X       eth2 (queue 5)
12:48:50   138       0   7084      0      0      0      0      0      
0   PCI-MSI-X       eth2 (queue 7)
12:48:50   154       0      0      0      0      0   7723      0      
0   PCI-MSI-X       eth3 (queue 0)
12:48:50   162    9082      0      0      0      0      0      0      
0   PCI-MSI-X       eth3 (queue 1)
12:48:50   178       0      0      0      0      0      0   8253      
0   PCI-MSI-X       eth3 (queue 3)
12:48:50   210       0      0      0      0      0      0      0   
6417   PCI-MSI-X       eth3 (queue 7)
12:48:50   218       1      0      0      0      0      0      0      
0   PCI-MSI         eth0

You can also look at all CPU loads and interrupts together like this:

# SINGLE CPU STATISTICS
#            CPU  USER NICE  SYS WAIT IRQ  SOFT STEAL IDLE INTRPT
07:09:28       0     0    0    0    0    0    0     0  100     16
07:09:28       1     0    0    0    0    0    0     0  100      0
07:09:28       2     0    0    0    0    0    0     0  100    999
07:09:28       3     0    0    0    0    0    0     0  100     16

For those not familiar with collectl, you can collect virtually 
everything all the existing linux 'stat' utilitie provide plus a lot 
more such as processes (including I/O stats), Infininband, Quadrics, 
Slab, Lustre and more.  Plus a lot more feature too numerous to list but 
there's a pretty good summary here - 
http://collectl.sourceforge.net/Features.html

But don't take my word for it, check out the website at 
http://collectl.sourceforge.net/ where you can see a pretty good set of 
examples in the documentation and even follow the tutorial.

-mark
