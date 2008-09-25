Return-Path: <linux-kernel-owner+w=401wt.eu-S1755369AbYIYXki@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755369AbYIYXki (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 19:40:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753783AbYIYXk1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 19:40:27 -0400
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:53430 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752705AbYIYXk0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 19:40:26 -0400
Date: Thu, 25 Sep 2008 17:40:04 -0600
From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH, RFC] ext4: Use preallocation when reading from the	inode
 table
In-reply-to: <20080924203559.GK9929@mit.edu>
To: Theodore Tso <tytso@mit.edu>, Ric Wheeler <rwheeler@redhat.com>,
       Chris Mason <chris.mason@oracle.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-ext4@vger.kernel.org,
       linux-kernel@vger.kernel.org
Message-id: <20080925234004.GR10950@webber.adilger.int>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7BIT
Content-disposition: inline
X-GPG-Key: 1024D/0D35BED6
X-GPG-Fingerprint: 7A37 5D79 BF1B CECA D44F  8A29 A488 39F5 0D35 BED6
References: <20080924013014.GA9747@mit.edu> <48DA3F56.8090806@redhat.com>
 <1222266034.7160.191.camel@think.oraclecorp.com>
 <E1KhvsB-0002Ik-Ex@closure.thunk.org>
 <20080923101613.58768083@lxorguk.ukuu.org.uk>
 <20080923115045.GI10950@webber.adilger.int> <48D8DEAE.4080309@redhat.com>
 <20080924013014.GA9747@mit.edu> <48DA3F56.8090806@redhat.com>
 <20080924203559.GK9929@mit.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sep 24, 2008  16:35 -0400, Theodore Ts'o wrote:
> On the other hand, if we take your iop/s and translate them to
> milliseconds so we can measure the latency in the case where the
> workload is essentialy doing random reads, and then cross correlated
> it with my measurements, we get this table:

Comparing the incremental benefit of each step:

> i/o size iops/s  ms latency  % degredation         % improvement
>     	 	    	     of random inodes   of related inodes I/O
>    4k	  131       7.634      
>    8k	  130	    7.692	0.77%		    11.3%
                                       1.57%              10.5%
>   16k	  128	    7.813	2.34%		    21.8%
                                       1.63%               7.8%
>   32k	  126	    7.937	3.97%		    29.6%
                                       4.29%               5.9%
>   64k	  121	    8.264	8.26%		    35.5%
                                       7.67%               4.5%
>  128k	  113	    8.850      15.93%		    40.0%
                                      16.07%               2.4%
>  256k	  100	   10.000      31.00%		    42.4%
> 
> Depending on whether you believe that workloads involving random inode
> reads are more common compared to related inodes I/O, the sweet spot
> is probably somewhere between 32k and 128k.  I'm open to opinions
> (preferably backed up with more benchmarks of likely workloads) of
> whether we should use a default value of inode_readahead_bits of 4 or
> 5 (i.e., 64k, my original guess, or 128k, in v2 of the patch).  But
> yes, making it tunable is definitely going to be necessary, since for
> different workloads (i.e squid vs. git repositories) will have very
> different requirements.

It looks like moving from 64kB to 128kB readahead might be a loss for
"unknown" workloads, since that increases latency by 7.67% for the random
inode case, but we only get 4.5% improvement in the sequential inode case.
Also recall that at large scale "htree" breaks down to random inode
lookup so that isn't exactly a fringe case (though readahead may still
help if the cache is large enough).

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

