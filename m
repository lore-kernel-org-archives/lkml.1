Return-Path: <linux-kernel-owner+w=401wt.eu-S1758793AbYHDSWy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758793AbYHDSWy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 14:22:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758617AbYHDSWo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 14:22:44 -0400
Received: from qb-out-0506.google.com ([72.14.204.228]:31532 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755373AbYHDSWm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 14:22:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=VcnH6ju8BImvVgKWiRfvxhCPO68pj2SckorGxbRhMX/PlF87cvaNcTy0N6geITbcIC
         tc2kxMOuNi4dEbZOOSSAB1uFNGAIdzrcvnLdajWd+N6Yd2XFJ98cI1GKw4jLEVrMSh22
         U/cnZ8bEWrtSYDf7Wmq72ZCQB+vZKiC1/gQ7w=
Message-ID: <489748E6.5080106@gmail.com>
Date: Mon, 04 Aug 2008 20:22:30 +0200
From: Andrea Righi <righi.andrea@gmail.com>
Reply-To: righi.andrea@gmail.com
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Dave Hansen <dave@linux.vnet.ibm.com>
CC: Ryo Tsuruta <ryov@valinux.co.jp>, linux-kernel@vger.kernel.org,
       dm-devel@redhat.com, containers@lists.linux-foundation.org,
       virtualization@lists.linux-foundation.org,
       xen-devel@lists.xensource.com, agk@sourceware.org,
       Satoshi UCHIDA <s-uchida@ap.jp.nec.com>
Subject: Re: Too many I/O controller patches
References: <20080804.175126.193692178.ryov@valinux.co.jp> <1217870433.20260.101.camel@nimitz>
In-Reply-To: <1217870433.20260.101.camel@nimitz>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Hansen wrote:
> On Mon, 2008-08-04 at 17:51 +0900, Ryo Tsuruta wrote:
>> This series of patches of dm-ioband now includes "The bio tracking mechanism,"
>> which has been posted individually to this mailing list.
>> This makes it easy for anybody to control the I/O bandwidth even when
>> the I/O is one of delayed-write requests.
> 
> During the Containers mini-summit at OLS, it was mentioned that there
> are at least *FOUR* of these I/O controllers floating around.  Have you
> talked to the other authors?  (I've cc'd at least one of them).
> 
> We obviously can't come to any kind of real consensus with people just
> tossing the same patches back and forth.
> 
> -- Dave
> 

Dave,

thanks for this email first of all. I've talked with Satoshi (cc-ed)
about his solution "Yet another I/O bandwidth controlling subsystem for
CGroups based on CFQ".

I did some experiments trying to implement minimum bandwidth requirements
for my io-throttle controller, mapping the requirements to CFQ prio and
using the Satoshi's controller. But this needs additional work and
testing right now, so I've not posted anything yet, just informed
Satoshi about this.

Unfortunately I've not talked to Ryo yet. I've continued my work using a
quite different approach, because the dm-ioband solution didn't work
with delayed-write requests. Now the bio tracking feature seems really
prosiming and I would like to do some tests ASAP, and review the patch
as well.

But I'm not yet convinced that limiting the IO writes at the device
mapper layer is the best solution. IMHO it would be better to throttle
applications' writes when they're dirtying pages in the page cache (the
io-throttle way), because when the IO requests arrive to the device
mapper it's too late (we would only have a lot of dirty pages that are
waiting to be flushed to the limited block devices, and maybe this could
lead to OOM conditions). IOW dm-ioband is doing this at the wrong level
(at least for my requirements). Ryo, correct me if I'm wrong or if I've
not understood the dm-ioband approach.

Another thing I prefer is to directly define bandwidth limiting rules,
instead of using priorities/weights (i.e. 10MiB/s for /dev/sda), but
this seems to be in the dm-ioband TODO list, so maybe we can merge the
work I did in io-throttle to define such rules.

Anyway, I still need to look at the dm-ioband and bio-cgroup code in
details, so probably all I said above is totally wrong...

-Andrea
