Return-Path: <linux-kernel-owner+w=401wt.eu-S1759299AbZCPKQJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759299AbZCPKQJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 06:16:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753134AbZCPKPx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 06:15:53 -0400
Received: from mtagate2.de.ibm.com ([195.212.17.162]:34871 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753093AbZCPKPv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 06:15:51 -0400
Date: Mon, 16 Mar 2009 11:15:42 +0100
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Alex Chiang <achiang@hp.com>
Cc: Greg KH <gregkh@suse.de>, Tejun Heo <tj@kernel.org>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Ingo Molnar <mingo@elte.hu>,
       jbarnes@virtuousgeek.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sysfs: only allow one scheduled removal callback per
 kobj
Message-ID: <20090316111542.2be181c1@gondolin>
In-Reply-To: <20090313180736.GB5335@ldl.fc.hp.com>
References: <20090313180736.GB5335@ldl.fc.hp.com>
Organization: IBM Deutschland Research & Development GmbH Vorsitzender des
 Aufsichtsrats: Martin Jetter =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?= Erich
 Baier Sitz der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?= Registergericht:
 Amtsgericht Stuttgart, HRB 243294
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Mar 2009 12:07:36 -0600,
Alex Chiang <achiang@hp.com> wrote:

> The only way for a sysfs attribute to remove itself (without
> deadlock) is to use the sysfs_schedule_callback() interface.
> 
> Vegard Nossum discovered that a poorly written sysfs ->store
> callback can repeatedly schedule remove callbacks on the same
> device over and over, e.g.
> 
> 	$ while true ; do echo 1 > /sys/devices/.../remove ; done
> 
> If the 'remove' attribute uses the sysfs_schedule_callback API
> and also does not protect itself from concurrent accesses, its
> callback handler will be called multiple times, and will
> eventually attempt to perform operations on a freed kobject,
> leading to many problems.
> 
> Instead of requiring all callers of sysfs_schedule_callback to
> implement their own synchronization, provide the protection in
> the infrastructure.
> 
> Now, sysfs_schedule_callback will only allow one scheduled
> callback per kobject. On subsequent calls with the same kobject,
> return -EAGAIN.
> 
> This is a short term fix. The long term fix is to allow sysfs
> attributes to remove themselves directly, without any of this
> callback hokey pokey.
> 
> [cornelia.huck@de.ibm.com: s390 ccwgroup bits]
> Cc: cornelia.huck@de.ibm.com
> Reported-by: vegard.nossum@gmail.com
> Signed-off-by: Alex Chiang <achiang@hp.com>
> ---
>  drivers/s390/cio/ccwgroup.c |    5 +++--
>  fs/sysfs/file.c             |   26 +++++++++++++++++++++++---
>  2 files changed, 26 insertions(+), 5 deletions(-)

Acked-by: Cornelia Huck <cornelia.huck@de.ibm.com>
