Return-Path: <linux-kernel-owner+w=401wt.eu-S1754112AbZKLU3n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754112AbZKLU3n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 15:29:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753098AbZKLU3h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 15:29:37 -0500
Received: from acsinet12.oracle.com ([141.146.126.234]:22304 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753059AbZKLU3g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 15:29:36 -0500
Date: Thu, 12 Nov 2009 15:27:48 -0500
From: Chris Mason <chris.mason@oracle.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Andrew Morton <akpm@linux-foundation.org>, Frans Pop <elendil@planet.nl>,
       Jiri Kosina <jkosina@suse.cz>,
       Sven Geggus <lists@fuchsschwanzdomain.de>,
       Karol Lewandowski <karol.k.lewandowski@gmail.com>,
       Tobias Oetiker <tobi@oetiker.ch>, linux-kernel@vger.kernel.org,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Rik van Riel <riel@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Stephan von Krawczynski <skraw@ithnet.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [PATCH 0/7] Reduce GFP_ATOMIC allocation failures, candidate
 fix V3
Message-ID: <20091112202748.GC2811@think>
Mail-Followup-To: Chris Mason <chris.mason@oracle.com>,
	Mel Gorman <mel@csn.ul.ie>,
	Andrew Morton <akpm@linux-foundation.org>,
	Frans Pop <elendil@planet.nl>, Jiri Kosina <jkosina@suse.cz>,
	Sven Geggus <lists@fuchsschwanzdomain.de>,
	Karol Lewandowski <karol.k.lewandowski@gmail.com>,
	Tobias Oetiker <tobi@oetiker.ch>, linux-kernel@vger.kernel.org,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
	Pekka Enberg <penberg@cs.helsinki.fi>,
	Rik van Riel <riel@redhat.com>,
	Christoph Lameter <cl@linux-foundation.org>,
	Stephan von Krawczynski <skraw@ithnet.com>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	Kernel Testers List <kernel-testers@vger.kernel.org>
References: <1258054211-2854-1-git-send-email-mel@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1258054211-2854-1-git-send-email-mel@csn.ul.ie>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: acsmt357.oracle.com [141.146.40.157]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4AFC6FCE.0095:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 12, 2009 at 07:30:06PM +0000, Mel Gorman wrote:
> Sorry for the long delay in posting another version. Testing is extremely
> time-consuming and I wasn't getting to work on this as much as I'd have liked.
> 
> Changelog since V2
>   o Dropped the kswapd-quickly-notice-high-order patch. In more detailed
>     testing, it made latencies even worse as kswapd slept more on high-order
>     congestion causing order-0 direct reclaims.
>   o Added changes to how congestion_wait() works
>   o Added a number of new patches altering the behaviour of reclaim
> 
> Since 2.6.31-rc1, there have been an increasing number of GFP_ATOMIC
> failures. A significant number of these have been high-order GFP_ATOMIC
> failures and while they are generally brushed away, there has been a large
> increase in them recently and there are a number of possible areas the
> problem could be in - core vm, page writeback and a specific driver. The
> bugs affected by this that I am aware of are;

Thanks for all the time you've spent on this one.  Let me start with
some more questions about the workload ;)

> 2. A crypted work partition and swap partition was created. On my
>    own setup, I gave no passphrase so it'd be easier to activate without
>    interaction but there are multiple options. I should have taken better
>    notes but the setup goes something like this;
> 
> 	cryptsetup create -y crypt-partition /dev/sda5
> 	pvcreate /dev/mapper/crypt-partition
> 	vgcreate crypt-volume /dev/mapper/crypt-partition
> 	lvcreate -L 5G -n crypt-logical crypt-volume
> 	lvcreate -L 2G -n crypt-swap crypt-volume
> 	mkfs -t ext3 /dev/crypt-volume/crypt-logical
> 	mkswap /dev/crypt-volume/crypt-swap
> 
> 3. With the partition mounted on /scratch, I
> 	cd /scratch
> 	mkdir music
> 	git clone git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git linux-2.6
> 
> 4. On a normal partition, I expand a tarball containing test scripts available at
> 	http://www.csn.ul.ie/~mel/postings/latency-20091112/latency-tests-with-results.tar.gz
> 
> 	There are two helper programs that run as part of the test - a fake
> 	music player and a fake gitk.
> 
> 	The fake music player uses rsync with bandwidth limits to start
> 	downloading a music folder from another machine. It's bandwidth
> 	limited to simulate playing music over NFS.

So the workload is gitk reading a git repo and a program reading data
over the network.  Which part of the workload writes to disk?

-chris

