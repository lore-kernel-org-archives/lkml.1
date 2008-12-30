Return-Path: <linux-kernel-owner+w=401wt.eu-S1753185AbYL3WQA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753185AbYL3WQA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 17:16:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751810AbYL3WPt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 17:15:49 -0500
Received: from mx2.netapp.com ([216.240.18.37]:47806 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751246AbYL3WPs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 17:15:48 -0500
X-IronPort-AV: E=Sophos;i="4.36,304,1228118400"; 
   d="scan'208";a="105950905"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: Pull request for FS-Cache, including NFS patches
Date: Tue, 30 Dec 2008 14:15:42 -0800
Message-ID: <7A24DF798E223B4C9864E8F92E8C93EC01AAFE66@SACMVEXC1-PRD.hq.netapp.com>
In-Reply-To: <1230662677.4952.37.camel@heimdal.trondhjem.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Pull request for FS-Cache, including NFS patches
Thread-Index: AclqrrGjJSTxrswpTCq3KUtmaXYGhAAGOkug
From: "Muntz, Daniel" <Dan.Muntz@netapp.com>
To: "Trond Myklebust" <trond.myklebust@fys.uio.no>
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Stephen Rothwell" <sfr@canb.auug.org.au>,
       "Bernd Schubert" <bernd.schubert@fastmail.fm>, <nfsv4@linux-nfs.org>,
       <linux-kernel@vger.kernel.org>, <steved@redhat.com>,
       <dhowells@redhat.com>, <linux-next@vger.kernel.org>,
       <linux-fsdevel@vger.kernel.org>, <rwheeler@redhat.com>
X-OriginalArrivalTime: 30 Dec 2008 22:15:45.0450 (UTC) FILETIME=[293CE8A0:01C96ACC]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> As for security, look at what MIT had to do to prevent local disk 
>> caching from breaking the security guarantees of AFS.
>
>See what David has added to the LSM code to provide the same guarantees
for cachefs...
>
>Trond

Unless it (at least) leverages TPM, the issues I had in mind can't
really be addressed in code.  One requirement is to prevent a local root
user from accessing fs information without appropriate permissions.
This leads to unwieldly requirements such as allowing only one user on a
machine at a time, blowing away the cache on logout, validating (e.g.,
refreshing) the kernel on each boot, etc.  Sure, some applications won't
care, but you're also potentially opening holes that users may not
consider.

  -Dan

-----Original Message-----
From: Trond Myklebust [mailto:trond.myklebust@fys.uio.no] 
Sent: Tuesday, December 30, 2008 10:45 AM
To: Muntz, Daniel
Cc: Andrew Morton; Stephen Rothwell; Bernd Schubert;
nfsv4@linux-nfs.org; linux-kernel@vger.kernel.org; steved@redhat.com;
dhowells@redhat.com; linux-next@vger.kernel.org;
linux-fsdevel@vger.kernel.org; rwheeler@redhat.com
Subject: RE: Pull request for FS-Cache, including NFS patches

On Mon, 2008-12-29 at 15:05 -0800, Muntz, Daniel wrote:
> Before throwing the 'FUD' acronym around, maybe you should re-read the

> details.  My point was that there were few users of cachefs even when 
> the technology had the potential for greater benefit (slower networks,

> less powerful servers, smaller memory caches).  Obviously cachefs can 
> improve performance--it's simply a function of workload and the 
> assumptions made about server/disk/network bandwidth.  However, I 
> would expect the real benefits and real beneficiaries to be fewer than

> in the past.  HOWEVER^2 I did provide some argument(s) in favor of 
> adding cachefs, and look forward to extensions to support delayed 
> write, offline operation, and NFSv4 support with real consistency 
> checking (as long as I don't have to take the customer calls ;-).  
> BTW, animation/video shops were one group that did benefit, and I 
> imagine they still could today (the one I had in mind did work across 
> Britain, the US, and Asia and relied on cachefs for overcoming slow 
> network connections).  Wonder if the same company is a RH customer...

I did read your argument. My point is that although the argument sounds
reasonable, it ignores the fact that the customer bases are completely
different. The people asking for cachefs on Linux typically run a
cluster of 2000+ clients all accessing the same read-only data from just
a handful of servers. They're primarily looking to improve the
performance and stability of the _servers_, since those are the single
point of failure of the cluster.

As far as I know, historically there has never been a market for 2000+
HP-UX, or even Solaris based clusters, and unless the HP and Sun product
plans change drastically, then simple economics dictates that nor will
there ever be such a market, whether or not they have cachefs support.

OpenSolaris is a different kettle of fish since it has cachefs, and does
run on COTS hardware, but there are other reasons why that hasn't yet
penetrated the HPC market.

> All the comparisons to HTTP browser implementations are, imho, absurd.
> It's fine to keep a bunch of http data around on disk because a) it's 
> RO data, b) correctness is not terribly important, and c) a human is 
> generally the consumer and can manually request non-cached data if 
> things look wonky.  It is a trivial case of caching.

See above. The majority of people I'm aware of that have been asking for
this are interested mainly in improving read-only workloads for data
that changes infrequently. Correctness tends to be important, but the
requirements are no different from those that apply to the page cache.
You mentioned the animation industry: they are prime example of an
industry that satisfies (a), (b), and (c). Ditto the oil and gas
exploration industry, as well as pretty much all scientific computing,
to mention only a few examples...

> As for security, look at what MIT had to do to prevent local disk 
> caching from breaking the security guarantees of AFS.

See what David has added to the LSM code to provide the same guarantees
for cachefs...

Trond

