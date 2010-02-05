Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933574Ab0BEC3U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 21:29:20 -0500
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:53486 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932600Ab0BEC3R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 21:29:17 -0500
Message-ID: <4B6B7FBF.9090005@bx.jp.nec.com>
Date: Thu, 04 Feb 2010 21:17:35 -0500
From: Keiichi KII <k-keiichi@bx.jp.nec.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, mingo@elte.hu
CC: lwoodman@redhat.com, linux-mm@kvack.org, Tom Zanussi <tzanussi@gmail.com>,
       riel@redhat.com, rostedt@goodmis.org, akpm@linux-foundation.org,
       fweisbec@gmail.com, Munehiro Ikeda <m-ikeda@ds.jp.nec.com>,
       Atsushi Tsuji <a-tsuji@bk.jp.nec.com>,
       Keiichi KII <k-keiichi@bx.jp.nec.com>
Subject: [RFC PATCH -tip 0/2 v3] pagecache tracepoints proposal
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This is v3 of a patchset to add some tracepoints for pagecache.

I would propose several tracepoints for tracing pagecache behavior and
a script for these.
By using both the tracepoints and the script, we can analysis pagecache behavior
like usage or hit ratio with high resolution like per process or per file. 
Example output of the script looks like:

[process list]
o yum-3215
                          cache find  cache hit  cache hit
        device      inode      count      count      ratio
  --------------------------------------------------------
         253:0         16      34434      34130     99.12%
         253:0        198       9692       9463     97.64%
         253:0        639        647        628     97.06%
         253:0        778         32         29     90.62%
         253:0       7305      50225      49005     97.57%
         253:0     144217         12         10     83.33%
         253:0     262775         16         13     81.25%
*snip*

-------------------------------------------------------------------------------

[file list]
        device              cached
     (maj:min)      inode    pages
  --------------------------------
         253:0         16     5752
         253:0        198     2233
         253:0        639       51
         253:0        778       86
         253:0       7305    12307
         253:0     144217       11
         253:0     262775       39
*snip*

[process list]
o yum-3215
        device              cached    added  removed      indirect
     (maj:min)      inode    pages    pages    pages removed pages
  ----------------------------------------------------------------
         253:0         16    34130     5752        0             0
         253:0        198     9463     2233        0             0
         253:0        639      628       51        0             0
         253:0        778       29       78        0             0
         253:0       7305    49005    12307        0             0
         253:0     144217       10       11        0             0
         253:0     262775       13       39        0             0
*snip*
  ----------------------------------------------------------------
  total:                    102346    26165        1             0

We can now know system-wide pagecache usage by /proc/meminfo.
But we have no method to get higher resolution information like per file or
per process usage than system-wide one.
A process may share some pagecache or add a pagecache to the memory or
remove a pagecache from the memory.
If a pagecache miss hit ratio rises, maybe it leads to extra I/O and
affects system performance.

So, by using the tracepoints we can get the following information.
 1. how many pagecaches each process has per each file
 2. how many pages are cached per each file
 3. how many pagecaches each process shares
 4. how often each process adds/removes pagecache
 5. how long a pagecache stays in the memory
 6. pagecache hit rate per file

Especially, the monitoring pagecache usage per each file and pagecache hit 
ratio would help us tune some applications like database.
And it will also help us tune the kernel parameters like "vm.dirty_*".

Changelog since v2
  o add new script to monitor pagecache hit ratio per process.
  o use DECLARE_EVENT_CLASS

Changelog since v1
  o Add a script based on "perf trace stream scripting support".

Any comments are welcome.
--
Keiichi Kii <k-keiichi@bx.jp.nec.com>


