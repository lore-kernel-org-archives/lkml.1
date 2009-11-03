Return-Path: <linux-kernel-owner+w=401wt.eu-S1752644AbZKCGOo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752644AbZKCGOo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 01:14:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751467AbZKCGOo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 01:14:44 -0500
Received: from gw1.cosmosbay.com ([212.99.114.194]:57648 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751145AbZKCGOn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 01:14:43 -0500
Message-ID: <4AEFCA49.4020305@gmail.com>
Date: Tue, 03 Nov 2009 07:14:33 +0100
From: Eric Dumazet <eric.dumazet@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Benjamin LaHaise <bcrl@lhnet.ca>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Octavian Purdila <opurdila@ixiacom.com>, netdev@vger.kernel.org,
       Cosmin Ratiu <cratiu@ixiacom.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] sysfs directory scaling: rbtree for dirent name lookups
References: <20091101163130.GA7911@kvack.org> <20091103035058.GA19515@kroah.com>
In-Reply-To: <20091103035058.GA19515@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Tue, 03 Nov 2009 07:14:36 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH a écrit :
> On Sun, Nov 01, 2009 at 11:31:30AM -0500, Benjamin LaHaise wrote:
>> Use an rbtree in sysfs_dirent to speed up file lookup times
>>
>> Systems with large numbers (tens of thousands and more) of network 
>> interfaces stress the sysfs code in ways that make the linear search for 
>> a name match take far too long.  Avoid this by using an rbtree.
> 
> What kind of speedups are you seeing here?  And do these changes cause a
> memory increase due to the structure changes which outweigh the
> speedups?
> 
> What kind of test are you doing to reproduce this?
> 

Its curious because in my tests the biggest problems come from
kernel/sysctl.c (__register_sysctl_paths) consuming 80% of cpu
in following attempt to create 20.000 devices

(disable hotplug before trying this, and ipv6 too !)
modprobe dummy numdummies=20000

I believe we should address __register_sysctl_paths() scalability
problems too.

I dont know what is the 'sentinel' we allocate after each struct ctl_table
But I suspect we could reduce size requirement of the 'sentinel' to include
only needed fields for the sentinel (and move them at start of ctl_table)

        /*
         * For each path component, allocate a 2-element ctl_table array.
         * The first array element will be filled with the sysctl entry
         * for this, the second will be the sentinel (ctl_name == 0).
         *
         * We allocate everything in one go so that we don't have to
         * worry about freeing additional memory in unregister_sysctl_table.
         */
        header = kzalloc(sizeof(struct ctl_table_header) +
                         (2 * npath * sizeof(struct ctl_table)), GFP_KERNEL);

Then, adding an rb_node in ctl_table_header to speedup __register_sysctl_paths() a bit
