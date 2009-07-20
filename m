Return-Path: <linux-kernel-owner+w=401wt.eu-S1754260AbZGTWsC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754260AbZGTWsC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 18:48:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754191AbZGTWsA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 18:48:00 -0400
Received: from mail.candelatech.com ([208.74.158.172]:44481 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754094AbZGTWsA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 18:48:00 -0400
X-Greylist: delayed 2305 seconds by postgrey-1.27 at vger.kernel.org; Mon, 20 Jul 2009 18:48:00 EDT
Message-ID: <4A64EB1F.4000602@candelatech.com>
Date: Mon, 20 Jul 2009 15:09:35 -0700
From: Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Error mounting FC8 NFS server with 2.6.31-rc3 NFSv4 client.
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I tried mounting an NFS server running FC8 (2.6.26.8-57.fc8 kernel)
using a Fedora 11 system running an un-patched 2.6.31-rc3 64-bit kernel.

I am not sure at all that the FC8 system is set up to handle NFSv4 properly, but
I was expecting some sort of useful error if that was the case.

Instead, I get this continually spewing to /var/log/messages:

Error: state manager failed on NFSv4 server 192.168.100.6 with error 2
Error: state manager failed on NFSv4 server 192.168.100.6 with error 2
Error: state manager failed on NFSv4 server 192.168.100.6 with error 2
Error: state manager failed on NFSv4 server 192.168.100.6 with error 2
...

On the file-server, I see this:
Jul 19 04:47:59 fs2 kernel: nfs4_cb: server 192.168.100.196 not responding, timed out
Jul 19 04:49:29 fs2 kernel: nfs4_cb: server 192.168.100.196 not responding, timed out
Jul 19 04:49:29 fs2 ntpd[2585]: kernel time sync status change 0001
Jul 19 04:50:59 fs2 kernel: nfs4_cb: server 192.168.100.196 not responding, timed out


I added some debug patches (on top of my other patches, including those to nfs)
and got some debug info:

It seems that nfs4_init_clientid is returning -2, and establish_clid is returning
-2.  This causes reclaim lease logic to fail, and that causes state manager to print
out the error repeatedly.  -2 means ENOENT.


As far as I can tell, the mount never completes, staying in D state and filling up
logs (I deleted a 16GB /var/log/messages file a few minutes ago!)

The mount command I'm trying is:
mount -t nfs4 192.168.100.6:/export/tmp /mnt/lf/nfs4-0


My kernel config is found here:
http://www.candelatech.com/oss/i7_config.txt


Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

