Return-Path: <linux-kernel-owner+w=401wt.eu-S1755285AbYGVKlR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755285AbYGVKlR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 06:41:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753769AbYGVKlF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 06:41:05 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58387 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753727AbYGVKlE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 06:41:04 -0400
Date: Tue, 22 Jul 2008 03:34:04 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Nadia.Derbey@bull.net
Cc: matthltc@us.ibm.com, linux-kernel@vger.kernel.org,
       Solofo.Ramangalahy@bull.net
Subject: Re: [PATCH 1/1] IPC - Do not use a negative value to re-enable
 msgmni automatic recomputing
Message-Id: <20080722033404.c46aab44.akpm@linux-foundation.org>
In-Reply-To: <20080704063729.600339000@bull.net>
References: <20080704063715.300337000@bull.net>
	<20080704063729.600339000@bull.net>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 04 Jul 2008 08:37:16 +0200 Nadia.Derbey@bull.net wrote:

> Resending after fixing the issues pointed out by Matt.
> Now applies to 2.6.26-rc8-mm1.
> 
> [PATCH 01/01]
> 
> This patch proposes an alternative to the "magical positive-versus-negative
> number trick" Andrew complained about last week in
> http://lkml.org/lkml/2008/6/24/418.
> 
> This had been introduced with the patches that scale msgmni to the amount of
> lowmem. With these patches, msgmni has a registered notification routine
> that recomputes msgmni value upon memory add/remove or ipc namespace creation/
> removal.
> 
> When msgmni is changed from user space (i.e. value written to the proc file),
> that notification routine is unregistered, and the way to make it registered
> back is to write a negative value into the proc file. This is the "magical
> positive-versus-negative number trick".
> 
> To fix this, a new proc file is introduced: /proc/sys/kernel/auto_msgmni.
> This file acts as ON/OFF for msgmni automatic recomputing.
> 
> With this patch, the process is the following:
> 1) kernel boots in "automatic recomputing mode"
>    /proc/sys/kernel/msgmni contains the value that has been computed (depends
>                            on lowmem)
>    /proc/sys/kernel/automatic_msgmni contains "1"
> 
> 2) echo <val> > /proc/sys/kernel/msgmni
>    . sets msg_ctlmni to <val>
>    . de-activates automatic recomputing (i.e. if, say, some memory is added
>      msgmni won't be recomputed anymore)
>    . /proc/sys/kernel/automatic_msgmni now contains "0"
> 
> 3) echo "0" > /proc/sys/kernel/automatic_msgmni
>    . de-activates msgmni automatic recomputing
>      this has the same effect as 2) except that msg_ctlmni's value stays
>      blocked at its current value)
> 
> 3) echo "1" > /proc/sys/kernel/automatic_msgmni
>    . recomputes msgmni's value based on the current available memory size
>      and number of ipc namespaces
>    . re-activates automatic recomputing for msgmni.
> 

Sigh.  I suppose it's a bit better.

> ---
>  include/linux/ipc_namespace.h |    3 +
>  ipc/ipc_sysctl.c              |   72 ++++++++++++++++++++++++++++++++++--------
>  ipc/ipcns_notifier.c          |   20 ++++++++---

Could we get this all documented for our poor users please?

Documentation/filesystems/proc.txt is probably the most appropriate
place.

