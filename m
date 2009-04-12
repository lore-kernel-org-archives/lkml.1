Return-Path: <linux-kernel-owner+w=401wt.eu-S1758571AbZDLH0N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758571AbZDLH0N (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Apr 2009 03:26:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755820AbZDLHZy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Apr 2009 03:25:54 -0400
Received: from mga03.intel.com ([143.182.124.21]:47763 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755521AbZDLHZw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Apr 2009 03:25:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,174,1239001200"; 
   d="scan'208";a="130525079"
Date: Sun, 12 Apr 2009 14:50:51 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "npiggin@suse.de" <npiggin@suse.de>,
       "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
       "yinghan@google.com" <yinghan@google.com>
Subject: Re: [PATCH 7/9] readahead: sequential mmap readahead
Message-ID: <20090412065051.GA5737@localhost>
References: <20090410060957.442203404@intel.com> <20090410061254.719205499@intel.com> <20090410163413.a014bde0.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090410163413.a014bde0.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 11, 2009 at 07:34:13AM +0800, Andrew Morton wrote:
> On Fri, 10 Apr 2009 14:10:04 +0800
> Wu Fengguang <fengguang.wu@intel.com> wrote:
> 
> > Auto-detect sequential mmap reads and do readahead for them.
> > 
> > The sequential mmap readahead will be triggered when
> > - sync readahead: it's a major fault and (prev_offset == offset-1);
> > - async readahead: minor fault on PG_readahead page with valid readahead state.
> > 
> > The benefits of doing readahead instead of read-around:
> > - less I/O wait thanks to async readahead
> > - double real I/O size and no more cache hits
> > 
> > The single stream case is improved a little.
> > For 100,000 sequential mmap reads:
> > 
> >                                     user       system    cpu        total
> > (1-1)  plain -mm, 128KB readaround: 3.224      2.554     48.40%     11.838
> > (1-2)  plain -mm, 256KB readaround: 3.170      2.392     46.20%     11.976
> > (2)  patched -mm, 128KB readahead:  3.117      2.448     47.33%     11.607
> > 
> > The patched (2) has smallest total time, since it has no cache hit overheads
> > and less I/O block time(thanks to async readahead). Here the I/O size
> > makes no much difference, since there's only one single stream.
> > 
> > Note that (1-1)'s real I/O size is 64KB and (1-2)'s real I/O size is 128KB,
> > since the half of the read-around pages will be readahead cache hits.
> > 
> > This is going to make _real_ differences for _concurrent_ IO streams.
> > 
> > Cc: Nick Piggin <npiggin@suse.de>
> > Cc: Linus Torvalds <torvalds@linux-foundation.org>
> > Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
> > ---
> >  mm/filemap.c |    3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> > 
> > --- mm.orig/mm/filemap.c
> > +++ mm/mm/filemap.c
> > @@ -1471,7 +1471,8 @@ static void do_sync_mmap_readahead(struc
> >  	if (VM_RandomReadHint(vma))
> >  		return;
> >  
> > -	if (VM_SequentialReadHint(vma)) {
> > +	if (VM_SequentialReadHint(vma) ||
> > +			offset - 1 == (ra->prev_pos >> PAGE_CACHE_SHIFT)) {
> >  		page_cache_sync_readahead(mapping, ra, file, offset, 1);
> >  		return;
> >  	}
> > 
> 
> We've always believed that readaround was beneficial for more random
> access patterns - classically faulting in an executable.  Although I
> don't recall that this belief was very well substantiated.
> 
> (The best results I ever got was by doing readaround and setting the
> size to a few MB, so we slurp the entire executable into memory in one
> hit.  lol.)
> 
> So my question is: what is the probability that this change will
> inadvertently cause a randomish-access workload to fall into readahead
> (rather than readaround) mode, and what is the impact when this
> happens?

Good question!

I did some measuring in order to answer this question.

It's an NFS-root debian desktop system, readahead size = 60 pages.
The numbers are grabbed after a fresh boot into console.

approach        pgmajfault      RA miss ratio   mmap IO count   avg IO size(pages)
   A            383             31.6%           383             11
   B            225             32.4%           390             11
   C            224             32.6%           307             13

case A: mmap sync/async readahead disabled
case B: mmap sync/async readahead enabled, with enforced full async readahead size
case C: mmap sync/async readahead enabled, with enforced full sync/async readahead size
or:
A = vanilla 2.6.30-rc1
B = A plus this patchset
C = B plus the following change

@@ static void do_sync_mmap_readahead(struc
 	if (VM_SequentialReadHint(vma) ||
 			offset - 1 == (ra->prev_pos >> PAGE_CACHE_SHIFT)) {
-		page_cache_sync_readahead(mapping, ra, file, offset, 1);
+		page_cache_sync_readahead(mapping, ra, file, offset, ra->ra_pages);
 
The theory is
- readahead is _good_ for clustered random reads, and can perform
  _better_ than readaround because they could be _async_.
For this patchset:
- sync readahead size could be smaller than readaround size, hence may
  make things worse by produce more smaller IOs
- async readahead size is guaranteed to be larger than readaround
  size, and they are _async_, hence will mostly behave better

The summaries on the numbers are
- there are good possibilities for random mmap reads to trigger readahead
- 'pgmajfault' is reduced by 1/3, due to the _async_ nature of readahead
- case C can further reduce IO count by 1/4
- readahead miss ratios are not quite affected

Final conclusion:
- this patchset reduced major faults by 1/3 and no other overheads;
- mmap io can be further reduced by 1/4 with the following patch.

Raw data follows.

Thanks,
Fengguang
---

Note:
- The duplicate cats are run in different fresh boots, which shows
  that data variances are <1%.
- The readahead miss ratio is approximated by
  (unreferenced pages reported by page-types) / (LRU file pages reported by meminfo)

A: disable sync/async mmap readahead(only readaround)
-----------------------------------------------------

pgmajfault 383
readahead miss ratio ~= 3576 : (36988+8244)/4 = 31.6%
wfg@hp ~% cat /debug/readahead/stats
pattern         count sync_count mmap_count  eof_count       size async_size     actual
initial0          515        515          0        325          4          3          2
subsequent         44          1          0         29         17         17          7
marker             18          0          0         12         11         11          6
around            383        383        383        185         60          0         25
random             43         43          0          4          1          0          1
all              1003        942        383        555         26          2         11
wfg@hp ~% cat /debug/readahead/stats
pattern         count sync_count mmap_count  eof_count       size async_size     actual
initial0          510        510          0        320          4          3          2
subsequent         44          1          0         29         17         17          7
marker             18          0          0         12         11         11          6
around            383        383        383        185         60          0         25
random             43         43          0          4          1          0          1
all               998        937        383        550         26          2         11
wfg@hp ~% cat /debug/readahead/stats
pattern      ra_count   io_count sync_count mmap_count  eof_count    ra_size async_size    io_size
initial0          514        499        499          0        324          4          3          2
subsequent         44         21          1          0          6         17         17         15
marker             18          7          0          0          1         11         11         17
around            383        383        383        383        185         60          0         25
random             43         43         43          0          4          1          0          1
all              1002        953        926        383        520         26          2         11
wfg@hp ~% sudo ./page-types
  flags page-count       MB    symbolic-flags    long-symbolic-flags
0x00000     496335     1938  __________________
0x00004          1        0  __R_______________  referenced
0x00008          8        0  ___U______________  uptodate
0x00014          5        0  __R_D_____________  referenced,dirty
0x00020          1        0  _____l____________  lru
0x00028       3576       13  ___U_l____________  uptodate,lru
0x0002c       5539       21  __RU_l____________  referenced,uptodate,lru
0x00068       3752       14  ___U_lA___________  uptodate,lru,active
0x0006c       1467        5  __RU_lA___________  referenced,uptodate,lru,active
0x00078          3        0  ___UDlA___________  uptodate,dirty,lru,active
0x0007c         17        0  __RUDlA___________  referenced,uptodate,dirty,lru,active
0x00080       2390        9  _______S__________  slab
0x000c0        108        0  ______AS__________  active,slab
0x00228         89        0  ___U_l___x________  uptodate,lru,reclaim
0x0022c         43        0  __RU_l___x________  referenced,uptodate,lru,reclaim
0x00268         21        0  ___U_lA__x________  uptodate,lru,active,reclaim
0x0026c         73        0  __RU_lA__x________  referenced,uptodate,lru,active,reclaim
0x00400        540        2  __________B_______  buddy
  total     513968     2007
wfg@hp ~% cat /proc/meminfo
MemTotal:        1978892 kB
MemFree:         1878628 kB
Buffers:               0 kB
Cached:            45312 kB
SwapCached:            0 kB
Active:            17608 kB
Inactive:          36988 kB
Active(anon):       9364 kB
Inactive(anon):        0 kB
Active(file):       8244 kB
Inactive(file):    36988 kB
Unevictable:           0 kB
Mlocked:               0 kB
SwapTotal:             0 kB
SwapFree:              0 kB
Dirty:                 0 kB
Writeback:             0 kB
AnonPages:          9160 kB
Mapped:             9588 kB
Slab:              26700 kB
SReclaimable:      14064 kB
SUnreclaim:        12636 kB
PageTables:         1648 kB
NFS_Unstable:          0 kB
Bounce:                0 kB
WritebackTmp:          0 kB
CommitLimit:      989444 kB
Committed_AS:      34640 kB
VmallocTotal:   34359738367 kB
VmallocUsed:       83404 kB
VmallocChunk:   34359654179 kB
DirectMap4k:        5824 kB
DirectMap2M:     2050048 kB


B: mmap sync/async readahead enabled, with enforced full async readahead size
-----------------------------------------------------------------------------

pgmajfault 225
readahead miss ratio ~= 3666 : (37080+8192)/4 = 32.4%
wfg@hp ~% cat /debug/readahead/stats # zero lines stripped
pattern         count sync_count mmap_count  eof_count       size async_size     actual
initial0          548        548         40        336          4          3          2
initial             5          5          4          1          4          3          3
subsequent        276          2        231        144         31         31         19
marker            151          0        133        131         54         54          6
around            180        180        180        142         60          0         19
random             43         43          0          4          1          0          1
all              1203        778        588        758         25         15          9
wfg@hp ~% cat /debug/readahead/stats            
pattern         count sync_count mmap_count  eof_count       size async_size     actual
initial0          560        560         40        347          4          3          2
initial             6          6          4          2          4          3          3
subsequent        275          2        232        143         32         31         19
marker            152          0        134        132         54         54          6
around            181        181        181        143         60          0         19
random             43         43          0          4          1          0          1
all              1217        792        591        771         24         15          9
wfg@hp ~% cat /debug/readahead/stats # an extended and more accurate version
pattern      ra_count   io_count sync_count mmap_count  eof_count    ra_size async_size    io_size
initial0          547        532        532         40        335          4          3          2
initial             4          4          4          4          0          4          3          4
subsequent        275        165          2        144         33         32         31         33
marker            151         29          0         22          9         54         54         33
around            180        180        180        180        142         60          0         19
random             43         43         43          0          4          1          0          1
all              1200        953        761        390        523         25         15         11
wfg@hp ~% sudo ./page-types
   flags        page-count       MB  symbolic-flags           long-symbolic-flags
0x000004                 1        0  __R____________________  referenced
0x000020                 1        0  _____l_________________  lru
0x000028              3666       14  ___U_l_________________  uptodate,lru
0x00002c              5587       21  __RU_l_________________  referenced,uptodate,lru
0x000068               549        2  ___U_lA________________  uptodate,lru,active
0x00006c              1506        5  __RU_lA________________  referenced,uptodate,lru,active
0x000080              1469        5  _______S_______________  slab
0x0000c0                49        0  ______AS_______________  active,slab
0x000228                49        0  ___U_l___x_____________  uptodate,lru,reclaim
0x000400               533        2  __________B____________  buddy
0x000800             19245       75  ___________r___________  reserved
0x002008                11        0  ___U_________b_________  uptodate,swapbacked
0x002068              3231       12  ___U_lA______b_________  uptodate,lru,active,swapbacked
0x00206c                25        0  __RU_lA______b_________  referenced,uptodate,lru,active,swapbacked
0x002078                 3        0  ___UDlA______b_________  uptodate,dirty,lru,active,swapbacked
0x00207c                17        0  __RUDlA______b_________  referenced,uptodate,dirty,lru,active,swapbacked
0x010000                15        0  ________________H______  head
0x010014                 1        0  __R_D___________H______  referenced,dirty,head
0x010080               909        3  _______S________H______  slab,head
0x0100c0                59        0  ______AS________H______  active,slab,head
0x020000              4266       16  _________________T_____  tail
0x020014                 4        0  __R_D____________T_____  referenced,dirty,tail
0x400000            472772     1846  ______________________n  noflags
   total            513968     2007
wfg@hp ~% cat /proc/meminfo
MemTotal:        1978892 kB
MemFree:         1878776 kB
Buffers:               0 kB
Cached:            45352 kB
SwapCached:            0 kB
Active:            17456 kB
Inactive:          37080 kB
Active(anon):       9264 kB
Inactive(anon):        0 kB
Active(file):       8192 kB
Inactive(file):    37080 kB
Unevictable:           0 kB
Mlocked:               0 kB
SwapTotal:             0 kB
SwapFree:              0 kB
Dirty:                 0 kB
Writeback:             0 kB
AnonPages:          9184 kB
Mapped:             9588 kB
Slab:              26592 kB
SReclaimable:      14016 kB
SUnreclaim:        12576 kB
PageTables:         1624 kB
NFS_Unstable:          0 kB
Bounce:                0 kB
WritebackTmp:          0 kB
CommitLimit:      989444 kB
Committed_AS:      34640 kB
VmallocTotal:   34359738367 kB
VmallocUsed:       83404 kB
VmallocChunk:   34359654179 kB
DirectMap4k:        5824 kB
DirectMap2M:     2050048 kB


B: mmap sync/async readahead enabled, with enforced full sync/async readahead size
----------------------------------------------------------------------------------

pgmajfault 224
readahead miss ratio ~= 3760 : (37596+8484)/4 = 32.6%

wfg@hp ~% cat /debug/readahead/stats
pattern         count sync_count mmap_count  eof_count       size async_size     actual
initial0          554        554         40        354         12          7          5
initial             4          4          4          3        120         60         63
subsequent        185          1        142        119         33         33         19
marker            147          0        129        130         54         54          5
around            179        179        179        142         60          0         19
random             43         43          0          4          1          0          1
all              1112        781        494        752         29         16         10
wfg@hp ~% cat /debug/readahead/stats
pattern         count sync_count mmap_count  eof_count       size async_size     actual
initial0          550        550         40        350         12          7          5
initial             4          4          4          3        120         60         63
subsequent        186          1        142        120         33         33         19
marker            147          0        129        130         54         54          5
around            179        179        179        142         60          0         19
random             43         43          0          4          1          0          1
all              1109        777        494        749         29         16         10
wfg@hp ~% cat /debug/readahead/stats
pattern      ra_count   io_count sync_count mmap_count  eof_count    ra_size async_size    io_size
initial0          551        536        536         40        351         12          7          5
initial             4          4          4          4          3        120         60         63
subsequent        186         87          1         66         21         33         33         41
marker            147         25          0         18          8         54         54         31
around            179        179        179        179        142         60          0         19
random             43         43         43          0          4          1          0          1
all              1110        874        763        307        529         29         16         13
wfg@hp ~% sudo ./page-types
  flags page-count       MB    symbolic-flags    long-symbolic-flags
0x00000     496178     1938  __________________
0x00004          1        0  __R_______________  referenced
0x00008         12        0  ___U______________  uptodate
0x00014          5        0  __R_D_____________  referenced,dirty
0x00020          1        0  _____l____________  lru
0x00028       3760       14  ___U_l____________  uptodate,lru
0x0002c       5566       21  __RU_l____________  referenced,uptodate,lru
0x00068       3806       14  ___U_lA___________  uptodate,lru,active
0x0006c       1546        6  __RU_lA___________  referenced,uptodate,lru,active
0x00078          3        0  ___UDlA___________  uptodate,dirty,lru,active
0x0007c         17        0  __RUDlA___________  referenced,uptodate,dirty,lru,active
0x00080       2393        9  _______S__________  slab
0x000c0        109        0  ______AS__________  active,slab
0x00228         48        0  ___U_l___x________  uptodate,lru,reclaim
0x00400        523        2  __________B_______  buddy
  total     513968     2007
wfg@hp ~% cat /proc/meminfo 
MemTotal:        1978892 kB
MemFree:         1877516 kB
Buffers:               0 kB
Cached:            46160 kB
SwapCached:            0 kB
Active:            18012 kB
Inactive:          37596 kB
Active(anon):       9528 kB
Inactive(anon):        0 kB
Active(file):       8484 kB
Inactive(file):    37596 kB
Unevictable:           0 kB
Mlocked:               0 kB
SwapTotal:             0 kB
SwapFree:              0 kB
Dirty:                 0 kB
Writeback:             0 kB
AnonPages:          9328 kB
Mapped:             9748 kB
Slab:              26920 kB
SReclaimable:      14324 kB
SUnreclaim:        12596 kB
PageTables:         1632 kB
NFS_Unstable:          0 kB
Bounce:                0 kB
WritebackTmp:          0 kB
CommitLimit:      989444 kB
Committed_AS:      34800 kB
VmallocTotal:   34359738367 kB
VmallocUsed:       83404 kB
VmallocChunk:   34359654179 kB
DirectMap4k:        5824 kB
DirectMap2M:     2050048 kB

