Return-Path: <linux-kernel-owner+w=401wt.eu-S933410AbXCIWbo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933410AbXCIWbo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 17:31:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767572AbXCIWbo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 17:31:44 -0500
Received: from services106.cs.uwaterloo.ca ([129.97.152.164]:39500 "EHLO
	services106.cs.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933410AbXCIWbn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 17:31:43 -0500
X-Greylist: delayed 1708 seconds by postgrey-1.27 at vger.kernel.org; Fri, 09 Mar 2007 17:31:42 EST
Date: Fri, 9 Mar 2007 17:03:11 -0500 (EST)
From: Ashif Harji <asharji@cs.uwaterloo.ca>
To: linux-kernel@vger.kernel.org
Subject: do_generic_mapping_read performance issue
Message-ID: <Pine.GSO.4.64.0703081612290.1080@cpu102.cs.uwaterloo.ca>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-2.0 (services106.cs.uwaterloo.ca [129.97.152.132]); Fri, 09 Mar 2007 17:03:13 -0500 (EST)
X-Miltered: at endeis with ID 45F1D9A1.000 by Joe's j-chkmail (http://j-chkmail.ensmp.fr)!
X-UUID: 06c8248c-fb52-4daa-b597-3d31270d94d9
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi, I am encountering a performance problem, which I have tracked into the 
Linux kernel. The problem occurs with my experimental web server that uses 
sendfile to repeatedly transmit files.  The files are based on the static 
portion of the SPECweb99 fileset and range in size to model a reasonable 
workload.  With this workload, a significant number of the requests are 
for files of size 4 KB or less.

I have determined that the performance problems occurs in the function
do_generic_mapping_read in file mm/filemap.c for kernel version 2.6.20.1.
Here is the specific code fragment:

         /*
          * When (part of) the same page is read multiple times
          * in succession, only mark it as accessed the first time.
          */
         if (prev_index != index)
                 mark_page_accessed(page);


The implication of this code is that for files of size less than or equal 
to a single page, the page associated with such a file is likely to get 
evicted from the cache regardless of how frequently it is accessed.  The 
reason is that after the first access, prev_index is always zero and index 
can only be zero. Hence, mark_page_accessed is never called after the 
first time the file is requested.  As a result, the page is evicted from 
the cache no matter how frequently it is used.  By changing the kernel to 
always call mark_page_accessed for these files, the server throughput is 
increased by as much as 20%.

I was wondering if anyone could explain why the call to mark_page_accessed 
is conditional? That is, what problem it is trying to solve. It would seem 
that in many scenarios, if the same page is accessed repeatedly, then it 
would be appropriate to keep that page cached.

Please personally CC me on any responses.

thanks,
ashif.
