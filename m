Return-Path: <linux-kernel-owner+w=401wt.eu-S1753238AbZKQUiM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753238AbZKQUiM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 15:38:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753171AbZKQUiK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 15:38:10 -0500
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:5960 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752257AbZKQUiI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 15:38:08 -0500
Subject: Re: [RFC] Block IO Controller V2 - some results
From: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: jens.axboe@oracle.com, linux-kernel@vger.kernel.org
In-Reply-To: <1258404660.3533.150.camel@cail>
References: <1258404660.3533.150.camel@cail>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 17 Nov 2009 15:38:09 -0500
Message-ID: <1258490289.18095.13.camel@cail>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vivek - 

I've updated the runs - the results are shown at the end, I culled out
the write-related runs (haven't converted to direct I/O yet for those).

Next steps: Going to refresh to V3 of the patches and add in 

http://groups.google.com/group/linux.kernel/browse_thread/thread/3b62f0665f0912b6/34ec9456c7da1bb7?lnk=raot

and convert the write-side to doing direct I/O (that would include the
rdwr tests, btw). 

----------------------------------------------------------------------

I've relabeled things:

i0 = io control generated in the kernel, but not enabled
i1 = io control generated in the kernel, and is enabled

g0 = group_idle=0
g1 = group_idle=1 (default)

s8 = slide_idle=8 (default)
s0 = slice_idle=0

It looks like when the io control stuff is enabled we have random read
problems. 

When it is enabled and slice_idle is set to 0 we see sequential reads
drop noticeably:

---- ---- - --------- --------- --------- --------- --------- ---------
Mode RdWr N   base     i0,gX,sX i1,g1,s8  i1,g0,s8  i1,g1,s0  i1,g0,s0
---- ---- - --------- --------- --------- --------- --------- ---------
rnd  rd   2      17.3      17.1       9.1       9.3       9.4       9.5
rnd  rd   4      27.1      27.1       8.2       8.0       8.0       8.0
rnd  rd   8      37.1      37.1       7.1       6.8       6.7       6.8

seq  rd   2     610.2     608.1     607.7     611.0     551.1     550.3
seq  rd   4     608.4     601.5     607.7     609.6     549.6     550.0
seq  rd   8     605.7     603.7     604.0     605.6     547.2     546.7

===============================================================

----------- ---- ---- - ----- ----- ----- ----- ----- ----- ----- -----
Test        Mode RdWr N test0 test1 test2 test3 test4 test5 test6 test7
----------- ---- ---- - ----- ----- ----- ----- ----- ----- ----- -----
base        rnd  rd   2   8.6   8.6
base        rnd  rd   4   6.8   6.8   6.8   6.7
base        rnd  rd   8   4.7   4.6   4.6   4.6   4.6   4.6   4.6   4.6

base        seq  rd   2 306.2 304.0
base        seq  rd   4 150.1 152.4 151.9 154.0
base        seq  rd   8  77.2  75.9  75.9  73.9  77.0  75.7  75.0  74.9

----------- ---- ---- - ----- ----- ----- ----- ----- ----- ----- -----
Test        Mode RdWr N test0 test1 test2 test3 test4 test5 test6 test7
----------- ---- ---- - ----- ----- ----- ----- ----- ----- ----- -----
i0,gX,sX    rnd  rd   2   8.6   8.6
i0,gX,sX    rnd  rd   4   6.8   6.8   6.7   6.7
i0,gX,sX    rnd  rd   8   4.7   4.6   4.6   4.7   4.6   4.6   4.6   4.6

i0,gX,sX    seq  rd   2 303.1 305.0
i0,gX,sX    seq  rd   4 150.8 151.6 149.0 150.2
i0,gX,sX    seq  rd   8  77.0  76.3  74.5  74.0  77.9  75.5  74.0  74.6

----------- ---- ---- - ----- ----- ----- ----- ----- ----- ----- -----
Test        Mode RdWr N test0 test1 test2 test3 test4 test5 test6 test7
----------- ---- ---- - ----- ----- ----- ----- ----- ----- ----- -----
i1,g1,s8    rnd  rd   2   2.8   6.3
i1,g1,s8    rnd  rd   4   0.7   1.5   2.5   3.5
i1,g1,s8    rnd  rd   8   0.2   0.4   0.5   0.7   0.9   1.2   1.4   1.7

i1,g1,s8    seq  rd   2 221.6 386.1
i1,g1,s8    seq  rd   4  70.6 128.1 181.7 227.3
i1,g1,s8    seq  rd   8  21.4  40.3  55.8  71.2  85.1  99.1 109.4 121.7

----------- ---- ---- - ----- ----- ----- ----- ----- ----- ----- -----
Test        Mode RdWr N test0 test1 test2 test3 test4 test5 test6 test7
----------- ---- ---- - ----- ----- ----- ----- ----- ----- ----- -----
i1,g0,s8    rnd  rd   2   4.7   4.7
i1,g0,s8    rnd  rd   4   2.0   2.0   2.0   2.0
i1,g0,s8    rnd  rd   8   0.9   0.9   0.9   0.8   0.8   0.8   0.9   0.9

i1,g0,s8    seq  rd   2 305.9 305.0
i1,g0,s8    seq  rd   4 154.0 153.3 151.2 151.1
i1,g0,s8    seq  rd   8  76.1  76.1  74.5  74.9  75.4  75.8  76.1  76.6

----------- ---- ---- - ----- ----- ----- ----- ----- ----- ----- -----
Test        Mode RdWr N test0 test1 test2 test3 test4 test5 test6 test7
----------- ---- ---- - ----- ----- ----- ----- ----- ----- ----- -----
i1,g1,s0    rnd  rd   2   4.7   4.7
i1,g1,s0    rnd  rd   4   2.0   2.0   2.0   2.0
i1,g1,s0    rnd  rd   8   0.8   0.8   0.8   0.8   0.8   0.8   0.8   0.9

i1,g1,s0    seq  rd   2 275.6 275.5
i1,g1,s0    seq  rd   4 136.0 137.5 137.4 138.7
i1,g1,s0    seq  rd   8  68.6  68.6  68.5  68.6  67.1  68.6  68.3  68.9

----------- ---- ---- - ----- ----- ----- ----- ----- ----- ----- -----
Test        Mode RdWr N test0 test1 test2 test3 test4 test5 test6 test7
----------- ---- ---- - ----- ----- ----- ----- ----- ----- ----- -----
i1,g0,s0    rnd  rd   2   4.7   4.7
i1,g0,s0    rnd  rd   4   2.0   2.0   2.0   2.0
i1,g0,s0    rnd  rd   8   0.8   0.8   0.8   0.8   0.8   0.8   0.8   0.9

i1,g0,s0    seq  rd   2 275.2 275.1
i1,g0,s0    seq  rd   4 136.7 137.2 137.5 138.7
i1,g0,s0    seq  rd   8  68.8  68.2  68.5  68.4  67.2  68.8  68.4  68.5


