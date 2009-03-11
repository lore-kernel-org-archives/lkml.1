Return-Path: <linux-kernel-owner+w=401wt.eu-S1754318AbZCKRrm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754318AbZCKRrm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 13:47:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751342AbZCKRrd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 13:47:33 -0400
Received: from mtagate4.de.ibm.com ([195.212.29.153]:63991 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751282AbZCKRrd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 13:47:33 -0400
Date: Wed, 11 Mar 2009 18:47:29 +0100
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Greg KH <gregkh@suse.de>
Cc: Alex Chiang <achiang@hp.com>, Vegard Nossum <vegard.nossum@gmail.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Ingo Molnar <mingo@elte.hu>,
       jbarnes@virtuousgeek.org, tj@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH, RFC] sysfs: only allow one scheduled removal callback
 per kobj
Message-ID: <20090311184729.110761e4@gondolin>
In-Reply-To: <20090311153228.GA21217@suse.de>
References: <20090310232027.GC25665@ldl.fc.hp.com>
	<20090311044151.GB25840@suse.de>
	<20090311070359.GF25665@ldl.fc.hp.com>
	<20090311153228.GA21217@suse.de>
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

On Wed, 11 Mar 2009 08:32:28 -0700,
Greg KH <gregkh@suse.de> wrote:

> Why can't you use device_unregister()?  Or, you could use device_del(),
> which lets you rely on the fact that the device structure is still
> around for a bit, but it will disappear from sysfs.  Just don't forget
> to do the final put_device() on it to free the memory and "really"
> release it.
> 
> Or am I missing something else here?

You can't unregister a device from one of its attribute callbacks, it
locks up in sysfs (removing the sysfs dir waits for all active
references to be dropped, but the reference obtained before calling
->store won't be dropped until after ->store returned...)
device_schedule_callback() was introduced to solve exactly that problem.

(For the original oops, I'd rather solve the problem by making sure the
caller doesn't trigger removal several times - should probably be less
code than the proposed patch?)
