Return-Path: <linux-kernel-owner+w=401wt.eu-S1751725AbYC3Fx1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751725AbYC3Fx1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2008 01:53:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751147AbYC3FxT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Mar 2008 01:53:19 -0400
Received: from wooster.rojer.pp.ru ([80.68.242.188]:51365 "EHLO
	wooster.rojer.pp.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751130AbYC3FxS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2008 01:53:18 -0400
X-Greylist: delayed 567 seconds by postgrey-1.27 at vger.kernel.org; Sun, 30 Mar 2008 01:53:17 EDT
Message-ID: <47EF2890.9010704@rojer.pp.ru>
Date: Sun, 30 Mar 2008 06:43:44 +0100
From: Deomid Ryabkov <myself@rojer.pp.ru>
User-Agent: Thunderbird 2.0.0.12 (X11/20080309)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Send-Q on UDP socket growing steadily - why?
Content-Type: text/plain; charset=KOI8-R; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This has started recently and i'm at a loss as to why.
Send-Q on a moderately active UDP socket keeps growing steadily until it 
reaches ~128K (wmem_max?) at which point socket writes start failing.
The application in question is standard ntpd from Fedora 7, kernel is 
the latest available for the distro, that is
2.6.23.15-80.fc7 #1 SMP Sun Feb 10 16:52:18 EST 2008 x86_64

BIND, running on the same machine, does not exhibit this problem, but 
that may be because it does not get nearly as much load as ntpd,
which is part of the pool.ntp.org. That said, load is really not very 
high, on the order of 10 QPS, and machine is 99+% idle.
ntpd seems to be doing its usual select-recvmsg-sendto routine, nothing 
out of the ordinary.
And yet, Send-Q keeps growing at _exactly_ 360 bytes every 10 seconds, 
here's a sample of output shortly after ntpd restart:

# while sleep 1; do netstat -na | grep 177:123; done
udp        0  17280 89.111.168.177:123          
0.0.0.0:*                              
udp        0  17280 89.111.168.177:123          
0.0.0.0:*                              
udp        0  17280 89.111.168.177:123          
0.0.0.0:*                              
udp        0  17280 89.111.168.177:123          
0.0.0.0:*                              
udp        0  17280 89.111.168.177:123          
0.0.0.0:*                              
udp        0  17280 89.111.168.177:123          
0.0.0.0:*                              
udp        0  17280 89.111.168.177:123          
0.0.0.0:*                              
udp        0  17280 89.111.168.177:123          
0.0.0.0:*                              
-------> +360 bytes
udp        0  17640 89.111.168.177:123          
0.0.0.0:*                              
udp        0  17640 89.111.168.177:123          
0.0.0.0:*                              
udp        0  17640 89.111.168.177:123          
0.0.0.0:*                              
udp        0  17640 89.111.168.177:123          
0.0.0.0:*                              
udp        0  17640 89.111.168.177:123          
0.0.0.0:*                              
udp        0  17640 89.111.168.177:123          
0.0.0.0:*                              
udp        0  17640 89.111.168.177:123          
0.0.0.0:*                              
udp        0  17640 89.111.168.177:123          
0.0.0.0:*                              
udp        0  17640 89.111.168.177:123          
0.0.0.0:*                              
udp        0  17640 89.111.168.177:123          
0.0.0.0:*                              
-------> +360 bytes, 10 seconds later
udp        0  18000 89.111.168.177:123          
0.0.0.0:*                              
udp        0  18000 89.111.168.177:123          
0.0.0.0:*                              
udp        0  18000 89.111.168.177:123          
0.0.0.0:*                              
udp        0  18000 89.111.168.177:123          
0.0.0.0:*                              
udp        0  18000 89.111.168.177:123          
0.0.0.0:*                              
udp        0  18000 89.111.168.177:123          
0.0.0.0:*                              
udp        0  18000 89.111.168.177:123          
0.0.0.0:*                              
udp        0  18000 89.111.168.177:123          
0.0.0.0:*                              
udp        0  18000 89.111.168.177:123          
0.0.0.0:*                              
udp        0  18000 89.111.168.177:123          
0.0.0.0:*                              
-------> +360 bytes, 10 seconds later
udp        0  18360 89.111.168.177:123          0.0.0.0:*              
[...]
etc, etc.

My understanding is that non-empty send queue for UDP sockets should be 
very rare occurence,
maybe under extreme loads. And then there's this steady creep...
What's going on? It almost looks like something is leaking somewhere.

-- 
Deomid Ryabkov aka Rojer
myself@rojer.pp.ru
rojer@sysadmins.ru
ICQ: 8025844

