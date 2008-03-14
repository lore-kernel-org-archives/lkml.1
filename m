Return-Path: <linux-kernel-owner+w=401wt.eu-S1755282AbYCNFPp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755282AbYCNFPp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 01:15:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752405AbYCNFPg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 01:15:36 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:41515 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752325AbYCNFPf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 01:15:35 -0400
Message-ID: <47DA09F0.2030506@np.css.fujitsu.com>
Date: Fri, 14 Mar 2008 14:15:28 +0900
From: Kentaro Makita <k-makita@np.css.fujitsu.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Cc: dgc@sgi.com
Subject: Re: [PATCH][BUGFIX][RFC] fix soft lock up at NFS mount by making
 limitation of dentry_unused
References: <20080306055416.GF155407@sgi.com> <47CF9A1F.50300@np.css.fujitsu.com> <20080308171911.E365.KOSAKI.MOTOHIRO@jp.fujitsu.com>
In-Reply-To: <20080308171911.E365.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Content-Type: multipart/mixed;
 boundary="------------080408050400060209000903"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080408050400060209000903
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi David
On Thu, 6 Mar 2008 16:54:16 +1100  David Chinner wrote:
>> No, we need a smarter free list structure. There have been several attempts
>> at this in the past. Two that I can recall off the top of my head:
>>
>> 	- per node unused LRUs
>> 	- per superblock unusued LRUs
>> I guess we need to revisit this again, because limiting the size of
>> the cache like this is not an option.
I 'm interesting in your patch. I 'll test two patches above if there
is newer version based on latest kernel.

>> Try something that relies on leaving the working set on the unused
>> list, like NFS server benchmarks that have a working set of tens of
>> million of files....
>>
I tested following, and I found no regressions except one case.
 - kernbench-0.24 on local ext3 and nfs
 - dbench-3.04 on local ext3 and nfs
 - IOzone-3.291 on local ext3 and nfs
-Basic file operations (create/delete/list/copy/move) on local ext3 and nfs

but I found one performance regression in my patch at following case.
 - On local ext3, remove 1,000,000 files in a directory spends 23% more time.
 (18m34.901s to 21m55.047s)

I 'm trying to fix it and post again.
Thank you for your suggestion.

Best Regards,
Kentaro Makita

--------------080408050400060209000903
Content-Type: text/plain;
 name="regression test results"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="regression test results"

-------------------------------------------------------------------------------
Basic file operations :
w/o  patch on local ext3:
target \  operations   | create     |  delete    |  list    |  copy      |  move
-----------------------+----------------------------------------------------------------------------------
1000 dirs x 1000 files | 22m6.930s  | 0m32.682s  | 0m0.037s | 1m31.506s  | 0m2.154s
1000000 files          | 22m37.759s | 18m34.901s | 0m0.002s | 19m24.388s | 0m0.156s
(elapsed time : second(s))

with patch on local ext3:
target \   operations  | create     |  delete    |  list    |  copy       |  move
-----------------------+---------------------------------------------------------------------------------
1000 dirs x 1000 files | 21m54.470s | 0m32.040s  | 0m0.008s |  1m30.796s  | 0m2.943s
1000000 files          | 22m8.381s  | 21m55.047s | 0m0.020s |  21m25.779s | 0m0.052s
(elapsed time : second(s))

w/o  patch on nfs:
target \   operations   | create     |  delete     |  list     |  copy      |  move
------------------------+----------------------------------------------------------------------------------
1000000 files           | 140m7.649s | 293m46.285s | 0m0.098s  | 432m7.720s | 0m0.674s
(elapsed time : second(s))

with patch on nfs:
target \   operations   | create      |  delete     |  list    |  copy       |  move
------------------------+--------------------------------------------------------------------------------
1000000 files           | 141m53.534s | 290m17.669s | 0m0.040s | 440m51.964s | 0m0.361s
(elapsed time : second(s))

IOzone:
# ./iozone -Ra > logfile
on ext3:		
			   bytes / sec (Average)
                	  w/o patch	 with patch
Writer Report   	499,136   	502,536   	100.68%
Re-writer Report	1,774,772   	1,790,133   	100.87%
Reader Report   	3,761,592   	3,818,147   	101.50%
Re-reader Report	5,723,402   	6,020,088   	105.18%
Random Read Report	5,343,096   	5,588,652   	104.60%
Random Write Report	2,054,678   	2,102,237   	102.31%
Backward Read Report	3,628,740   	3,696,570   	101.87%
Record Rewrite Report	3,697,344   	3,760,118   	101.70%
Stride Read Report	4,899,821   	5,053,645   	103.14%
Fwrite Report   	493,434   	493,464   	100.01%
Re-fwrite Report	1,505,555   	1,516,702   	100.74%
Fread Report    	3,330,627   	3,363,825   	101.00%
Re-fread Report 	5,404,997   	5,572,977   	103.11%

on nfs:		
			   bytes / sec (Average)
                	  w/o patch	 with patch
Writer Report   	2,397,539   	2,495,369   	104.08%
Re-writer Report	2,534,827   	2,539,019   	100.17%
Reader Report   	3,692,377   	3,711,528   	100.52%
Re-reader Report	5,783,150   	5,745,256   	99.34%
Random Read Report	5,569,286   	5,663,204   	101.69%
Random Write Report	2,982,048   	2,988,895   	100.23%
Backward Read Report	3,694,922   	3,710,797   	100.43%
Record Rewrite Report	5,844,580   	5,873,414   	100.49%
Stride Read Report	5,043,812   	5,060,472   	100.33%
Fwrite Report   	1,769,812   	1,788,991   	101.08%
Re-fwrite Report	1,964,384   	1,978,361   	100.71%
Fread Report    	3,362,162   	3,293,340   	97.95%
Re-fread Report 	5,441,776   	5,441,807   	100.00%

kernbench-0.42:
# kernbench -M
w/o  patch on local ext3:
2.6.25-rc5
Average Half load -j 12 Run (std deviation):
Elapsed Time 105.354 (0.608383)
User Time 1072.59 (1.42999)
System Time 68.406 (0.540074)
Percent CPU 1082.4 (5.17687)
Context Switches 75067.2 (2425.63)
Sleeps 155188 (2167.44)

Average Optimal load -j 96 Run (std deviation):
Elapsed Time 69.028 (0.523374)
User Time 1106.83 (36.1126)
System Time 67.735 (0.82922)
Percent CPU 1416 (351.761)
Context Switches 105700 (32397.8)
Sleeps 161568 (7136.89)

with patch on local ext3:
2.6.25-rc5dentry
Average Half load -j 12 Run (std deviation):
Elapsed Time 104.962 (0.0630079)
User Time 1071.74 (0.374993)
System Time 68.578 (0.301032)
Percent CPU 1086 (0.707107)
Context Switches 77173.8 (513.063)
Sleeps 156710 (669.205)

Average Optimal load -j 96 Run (std deviation):
Elapsed Time 68.826 (0.942804)
User Time 1107.5 (37.7007)
System Time 67.901 (0.770086)
Percent CPU 1422.2 (354.748)
Context Switches 107092 (31559.1)
Sleeps 161884 (6220.1)

w/o  patch on nfs:
2.6.25-rc5
Average Half load -j 12 Run (std deviation):
Elapsed Time 237.71 (6.4713)
User Time 1087.07 (1.42099)
System Time 190.306 (0.941637)
Percent CPU 537.2 (15.0233)
Context Switches 358822 (8395.04)
Sleeps 4.46148e+06 (53959.4)

Average Optimal load -j 96 Run (std deviation):
Elapsed Time 286.312 (4.8972)
User Time 1127.59 (42.7355)
System Time 304.32 (120.184)
Percent CPU 545.5 (14.6382)
Context Switches 603299 (257858)
Sleeps 9.21507e+06 (5.01086e+06)

with patch on nfs:
2.6.25-rc5dentry
Average Half load -j 12 Run (std deviation):
Elapsed Time 257.704 (8.20142)
User Time 1087.19 (0.992084)
System Time 191.294 (1.11267)
Percent CPU 496 (15.5885)
Context Switches 356975 (14893.6)
Sleeps 4.42764e+06 (68507.4)

Average Optimal load -j 96 Run (std deviation):
Elapsed Time 293.448 (2.64979)
User Time 1127.5 (42.5004)
System Time 308.478 (123.531)
Percent CPU 519.3 (26.9281)
Context Switches 601352 (258290)
Sleeps 9.2956e+06 (5.13148e+06)

dbench-3.04:
(on local and nfs directories)
# dbench 100

w/o patch on local ext3:
Throughput 186.4 MB/sec 100 procs

with patch on local ext3:
Throughput 215.831 MB/sec 100 procs

w/o patch on nfs:
Throughput 3.13253 MB/sec 100 procs

with patch on nfs:
Throughput 3.37892 MB/sec 100 procs
-----------------------------------------------------------------------------------

--------------080408050400060209000903--
