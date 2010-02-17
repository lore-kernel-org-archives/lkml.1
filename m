Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757434Ab0BQWlh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 17:41:37 -0500
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:35504 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752819Ab0BQWlf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 17:41:35 -0500
Message-ID: <4B7C6FEC.7070904@bx.jp.nec.com>
Date: Wed, 17 Feb 2010 17:38:36 -0500
From: Keiichi KII <k-keiichi@bx.jp.nec.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Wu Fengguang <fengguang.wu@intel.com>, Ingo Molnar <mingo@elte.hu>,
       Chris Frost <frost@cs.ucla.edu>, Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jason Baron <jbaron@redhat.com>,
       Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "lwoodman@redhat.com" <lwoodman@redhat.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       Tom Zanussi <tzanussi@gmail.com>, "riel@redhat.com" <riel@redhat.com>,
       Munehiro Ikeda <m-ikeda@ds.jp.nec.com>,
       Atsushi Tsuji <a-tsuji@bk.jp.nec.com>
Subject: Re: [RFC PATCH -tip 0/2 v3] pagecache tracepoints proposal
References: <20100208155450.GA17055@localhost> <20100209162101.GA12840@localhost> <20100216122225.72E7.A69D9226@jp.fujitsu.com>
In-Reply-To: <20100216122225.72E7.A69D9226@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

(02/15/10 22:22), KOSAKI Motohiro wrote:
>>> Here is a scratch patch to exercise the "object collections" idea :)
>>>
>>> Interestingly, the pagecache walk is pretty fast, while copying out the trace
>>> data takes more time:
>>>
>>>         # time (echo / > walk-fs)
>>>         (; echo / > walk-fs; )  0.01s user 0.11s system 82% cpu 0.145 total
>>>
>>>         # time wc /debug/tracing/trace
>>>         4570 45893 551282 /debug/tracing/trace
>>>         wc /debug/tracing/trace  0.75s user 0.55s system 88% cpu 1.470 total
>>
>> Ah got it: it takes much time to "print" the raw trace data.
>>
>>> TODO:
>>>
>>> correctness
>>> - show file path name
>>>   XXX: can trace_seq_path() be called directly inside TRACE_EVENT()?
>>
>> OK, finished with the file name with d_path(). I choose not to mangle
>> the possible '\n' in file names, and simply show "?" for such files,
>> for the sake of speed.
> 
> 
> This patch is nicer than KII-san's one. I plan to test it on
> my local test environment awhile.

I don't think my patch is completely replaced by Wu's patch.
Both patches focus on pagecache and will work together for achieving
perf enhancement for mm like "perf mm".

His patch can efficiently dump a pagecache usage snapshot for a file system
or a file as he said.
And we will be able to just monitor pagecache increase and decrease
by taking some snapshots for pagecache using his patch.
My patch can monitor some pagecache behavior like pagecache hit ratio and
using frequency(e.g. the following outputs).

For example, the outputs shows yum's pagecache behavior analysis using my patch.
Please focus on inode 16 and 778 on the device(253:0).
The system has 5752 pagecaches for the inode 16 and 86 pagecaches for
the inode 778.
We will be able to know same information using his patch as well.
But we can get further detailed information about pagecache in the system
using my patch.
There is a big difference of using frequency between inode 16 and inode 778.
The inode 16 is used by the yum more same pagecaches than inode 778's.

And maybe it is useful to improve/tune pagecache management like pdflush.

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

Any comments are welcome.

Thanks,
Keiichi
