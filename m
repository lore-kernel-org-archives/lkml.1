Return-Path: <linux-kernel-owner+w=401wt.eu-S1764751AbYBLU4W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764751AbYBLU4W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 15:56:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758382AbYBLU4O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 15:56:14 -0500
Received: from g4t0015.houston.hp.com ([15.201.24.18]:19419 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756950AbYBLU4O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 15:56:14 -0500
Message-ID: <47B207EB.8090204@hp.com>
Date: Tue, 12 Feb 2008 15:56:11 -0500
From: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <jens.axboe@oracle.com>, npiggin@suse.de, dgc@sgi.com,
       arjan@linux.intel.com
Subject: Re: IO queueing and complete affinity w/ threads: Some results
References: <47B0B69B.1050807@hp.com>
In-Reply-To: <47B0B69B.1050807@hp.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Whilst running a series of file system related loads on our 32-way*, I dropped down to a 16-way w/ only 24 disks, and ran two kernels: the original set of Jens' patches and then his subsequent kthreads-based set. Here are the results:

Original:
A Q C |  MBPS   Avg Lat StdDev |  Q-local Q-remote | C-local C-remote
----- | ------ -------- ------ | -------- -------- | ------- --------
X X X | 1850.4 0.413880 0.0109 |      0.0  55860.8 |     0.0  27946.9
X X A | 1850.6 0.413848 0.0106 |      0.0  55859.2 |     0.0  27946.1
X X I | 1850.6 0.413830 0.0107 |      0.0  55858.5 | 27945.8      0.0
----- | ------ -------- ------ | -------- -------- | ------- --------
X A X | 1850.0 0.413949 0.0106 |  55843.7      0.0 |     0.0  27938.3
X A A | 1850.2 0.413931 0.0107 |  55844.2      0.0 |     0.0  27938.6
X A I | 1850.4 0.413862 0.0107 |  55854.3      0.0 | 27943.7      0.0
----- | ------ -------- ------ | -------- -------- | ------- --------
X I X | 1850.9 0.413764 0.0107 |      0.0  55866.2 |     0.0  27949.6
X I A | 1850.5 0.413854 0.0108 |      0.0  55855.0 |     0.0  27944.0
X I I | 1850.4 0.413848 0.0105 |      0.0  55854.6 | 27943.8      0.0
===== | ====== ======== ====== | ======== ======== | ======= ========
I X X | 1570.7 0.487686 0.0142 |      0.0  47406.1 |     0.0  23719.5
I X A | 1570.8 0.487666 0.0143 |      0.0  47409.3 | 23721.2      0.0
I X I | 1570.8 0.487664 0.0142 |      0.0  47410.7 | 23721.8      0.0
----- | ------ -------- ------ | -------- -------- | ------- --------
I A X | 1570.9 0.487642 0.0144 |  47412.2      0.0 |     0.0  23722.6
I A A | 1570.8 0.487647 0.0141 |  47411.2      0.0 | 23722.1      0.0
I A I | 1570.8 0.487651 0.0143 |  47410.8      0.0 | 23721.9      0.0
----- | ------ -------- ------ | -------- -------- | ------- --------
I I X | 1570.8 0.487683 0.0142 |  47410.2      0.0 |     0.0  23721.6
I I A | 1571.1 0.487591 0.0146 |  47415.0      0.0 | 23724.0      0.0
I I I | 1571.0 0.487623 0.0143 |  47412.5      0.0 | 23722.8      0.0
===== | ====== ======== ====== | ======== ======== | ======= ========
rq=0  | 1726.7 0.443562 0.0120 |  52118.6      0.0 |  2138.6  23937.2
rq=1  | 1820.5 0.420729 0.0110 |  54938.2      0.0 |     0.0  27485.6
----- | ------ -------- ------ | -------- -------- | ------- --------


kthreads-based:
A Q C |  MBPS   Avg Lat StdDev |  Q-local Q-remote | C-local C-remote
----- | ------ -------- ------ | -------- -------- | ------- --------
X X X | 1850.5 0.413867 0.0107 |      0.0  55854.7 |     0.0  27943.8
X X A | 1850.9 0.413763 0.0107 |      0.0  55867.0 |     0.0  27950.0
X X I | 1850.3 0.413911 0.0109 |      0.0  55849.0 | 27941.0      0.0
----- | ------ -------- ------ | -------- -------- | ------- --------
X A X | 1851.0 0.413730 0.0107 |  55871.4      0.0 |     0.0  27952.2
X A A | 1850.1 0.413919 0.0107 |  55845.5      0.0 |     0.0  27939.2
X A I | 1850.8 0.413789 0.0108 |  55864.8      0.0 | 27948.9      0.0
----- | ------ -------- ------ | -------- -------- | ------- --------
X I X | 1850.5 0.413849 0.0107 |      0.0  55856.5 |     0.0  27944.8
X I A | 1850.6 0.413818 0.0108 |      0.0  55860.2 |     0.0  27946.6
X I I | 1850.8 0.413764 0.0108 |      0.0  55866.7 | 27949.8      0.0
===== | ====== ======== ====== | ======== ======== | ======= ========
I X X | 1570.9 0.487662 0.0145 |      0.0  47410.1 |     0.0  23721.6
I X A | 1570.7 0.487691 0.0142 |      0.0  47406.9 | 23720.0      0.0
I X I | 1570.7 0.487688 0.0141 |      0.0  47406.5 | 23719.8      0.0
----- | ------ -------- ------ | -------- -------- | ------- --------
I A X | 1570.9 0.487661 0.0144 |  47415.4      0.0 |     0.0  23724.2
I A A | 1570.8 0.487648 0.0141 |  47409.1      0.0 | 23721.0      0.0
I A I | 1570.7 0.487667 0.0141 |  47406.1      0.0 | 23719.5      0.0
----- | ------ -------- ------ | -------- -------- | ------- --------
I I X | 1570.8 0.487691 0.0142 |  47409.3      0.0 |     0.0  23721.2
I I A | 1570.9 0.487644 0.0142 |  47408.8      0.0 | 23720.9      0.0
I I I | 1570.6 0.487671 0.0141 |  47412.5      0.0 | 23722.8      0.0
===== | ====== ======== ====== | ======== ======== | ======= ========
rq=0  | 1742.1 0.439676 0.0118 |  52578.1      0.0 |  3602.6  22703.0
rq=1  | 1745.0 0.438918 0.0115 |  52666.3      0.0 |  3473.0  22876.6
----- | ------ -------- ------ | -------- -------- | ------- --------

For the first 18 sets on both kernels the results are very similar, the last two rq=0/1 sets are perturbed too much by application placement (I would guess). Have to think about that some more.

Alan
* What I'm doing on the 32-way is to compare and contrast mkfs, untar, kernel make & kernel clean times with different combinations of Q, C and RQ. [[This is currently with the "Jens original" patch, if things go well, I can do an overnight run with the kthreads-based patch.]]
