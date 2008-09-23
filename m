Return-Path: <linux-kernel-owner+w=401wt.eu-S1754692AbYIWUVj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754692AbYIWUVj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 16:21:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752449AbYIWUVb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 16:21:31 -0400
Received: from smtp-out.google.com ([216.239.33.17]:41231 "EHLO
	smtp-out3.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752189AbYIWUVa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 16:21:30 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references:x-gmailtapped-by;
	b=mD73N5jk6WLakTG7Y0aqNPAYdyTtJKCgYYaJJ1XdZLmOFmyfDOt6u8Myo/MBSGw3s
	MvRh1ZC5gGEAwBvQXud1Q==
Message-ID: <532480950809231321g7be0dd09pe6a32426b361e676@mail.gmail.com>
Date: Tue, 23 Sep 2008 13:21:18 -0700
From: "Michael Rubin" <mrubin@google.com>
To: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [RFC] [PATCH -mm 0/2] memcg: per cgroup dirty_ratio
Cc: "Andrew Morton" <akpm@linux-foundation.org>, dradford@bluehost.com,
       m.innocenti@cineca.it, fernando@oss.ntt.co.jp,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       chlunde@ping.uio.no, dave@linux.vnet.ibm.com, dpshah@google.com,
       agk@sourceware.org, matt@bluehost.com, menage@google.com,
       "Andrea Righi" <righi.andrea@gmail.com>, eric.rannaud@gmail.com,
       balbir@linux.vnet.ibm.com
In-Reply-To: <20080924024437.DC21.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080912131816.e0cfac7a.akpm@linux-foundation.org>
	 <532480950809221641y3471267esff82a14be8056586@mail.gmail.com>
	 <20080924024437.DC21.KOSAKI.MOTOHIRO@jp.fujitsu.com>
X-GMailtapped-By: 172.24.198.88
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 23, 2008 at 10:48 AM, KOSAKI Motohiro
<kosaki.motohiro@jp.fujitsu.com> wrote:
> Why vm_dirty_ratio = 0.125 is wrong?
> it is hardly for parser maker, but it have nicer user experience.

Here's an idea to build off Kosaki's suggestion and incorporate other
previous suggestions.

What if we have two knobs for every ratio. So we could have
vm_dirty_ratio and also vm_dirty_KB

vm_dirty_KB allows the user to set the number of KB desired and also
read the amount of KB that has been set.

Writing to vm_dirty_ratio works just as before and only allows whole
percentages.
Reading from vm_dirty_ratio will return a reply as before except if KB
has been set it can return a number in percentages (rounded off to
thousandths).

This way we allow new functionality and preserve old functionality
while not surprising the user.
Maybe we should deprecate the vm_dirty_ratio interface also and point
folks to the vm_dirty_KB.

> We don't have any motivation of its interface change.

We are seeing problems where we are generating a lot of dirty memory
from asynchronous background writes while more important traffic is
operating with DIRECT_IO. The DIRECT_IO traffic will incur high
latency spikes as the pdflush hits the background threshold and tries
to write a lot of dirty buffers at once.

What we want to do is lower the background threshold low enough so
that we don't end up writing a lot of data at one time. As systems get
more and more memory this is and will become difficult. 1% of system
RAM could tie up a disk.

mrubin
