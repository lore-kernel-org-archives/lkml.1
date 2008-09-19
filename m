Return-Path: <linux-kernel-owner+w=401wt.eu-S1755943AbYISU27@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755943AbYISU27 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 16:28:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754338AbYISU2s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 16:28:48 -0400
Received: from ey-out-2122.google.com ([74.125.78.25]:44364 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755613AbYISU2r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 16:28:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=x6+a9KBOq5qiLM7tUqvje+it6UeioBlv0NTid68GwQd3N3uZ/+61/xPqIVj6pLKEyk
         xphigDuLBwQ+I+Zf1cSgXusrnJC5jb8tIfFr1053h0dk0AbZrO2cHAUi53yrsW5gLm7J
         wxagOA2U3/48FkKLCPzsqy0lvtZAZQrkdwy3Y=
Message-ID: <48D40B78.6060709@gmail.com>
Date: Fri, 19 Sep 2008 22:28:40 +0200
From: Andrea Righi <righi.andrea@gmail.com>
Reply-To: righi.andrea@gmail.com
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: Hirokazu Takahashi <taka@valinux.co.jp>, ryov@valinux.co.jp,
       linux-kernel@vger.kernel.org, dm-devel@redhat.com,
       containers@lists.linux-foundation.org,
       virtualization@lists.linux-foundation.org,
       xen-devel@lists.xensource.com, fernando@oss.ntt.co.jp,
       balbir@linux.vnet.ibm.com, xemul@openvz.org, agk@sourceware.org,
       jens.axboe@oracle.com
Subject: Re: dm-ioband + bio-cgroup benchmarks
References: <20080918.210418.226794540.ryov@valinux.co.jp> <20080918131554.GB20640@redhat.com> <20080919.202031.86647893.taka@valinux.co.jp> <20080919131019.GA3606@redhat.com>
In-Reply-To: <20080919131019.GA3606@redhat.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal wrote:
> On Fri, Sep 19, 2008 at 08:20:31PM +0900, Hirokazu Takahashi wrote:
>>> To avoid creation of stacking another device (dm-ioband) on top of every
>>> device we want to subject to rules, I was thinking of maintaining an
>>> rb-tree per request queue. Requests will first go into this rb-tree upon
>>> __make_request() and then will filter down to elevator associated with the
>>> queue (if there is one). This will provide us the control of releasing
>>> bio's to elevaor based on policies (proportional weight, max bandwidth
>>> etc) and no need of stacking additional block device.
>> I think it's a bit late to control I/O requests there, since process
>> may be blocked in get_request_wait when the I/O load is high.
>> Please imagine the situation that cgroups with low bandwidths are
>> consuming most of "struct request"s while another cgroup with a high
>> bandwidth is blocked and can't get enough "struct request"s.
>>
>> It means cgroups that issues lot of I/O request can win the game.
>>
> 
> Ok, this is a good point. Because number of struct requests are limited
> and they seem to be allocated on first come first serve basis, so if a
> cgroup is generating lot of IO, then it might win.
> 
> But dm-ioband will face the same issue. Essentially it is also a request
> queue and it will have limited number of request descriptors. Have you 
> modified the logic somewhere for allocation of request descriptors to the
> waiting processes based on their weights? If yes, the logic probably can
> be implemented here too.

Maybe throttling dirty page ratio in memory could help to avoid this problem.
I mean, if a cgroup is exceeding the i/o limits do ehm... something.. also at
the balance_dirty_pages() level.

-Andrea
