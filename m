Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752573Ab0CDCss (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 21:48:48 -0500
Received: from netrider.rowland.org ([192.131.102.5]:35499 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751555Ab0CDCsm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 21:48:42 -0500
Date: Wed, 3 Mar 2010 21:48:39 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Pavel Machek <pavel@ucw.cz>, Jens Axboe <jens.axboe@oracle.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       linux-pm <linux-pm@lists.linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [linux-pm] Is it supposed to be ok to call del_gendisk while
 userspace is frozen?
In-Reply-To: <201003040123.13617.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.1003032142580.6963-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Mar 2010, Rafael J. Wysocki wrote:

> > Very well.  Then we still need a solution to the original problem:  
> > Devices sometimes need to be unregistered during resume, but
> > del_gendisk() blocks on the writeback thread, which is frozen until
> > after the resume finishes.  How do you suggest this be fixed?
> 
> I thought about thawing the writeback thread earlier in such cases.
> 
> Would that makes sense / is it doable at all?

My thought exactly.  This is the only approach that also solves the 
following race:

	A driver is unloaded at the same time as a suspend starts.

	The writeback thread gets frozen.

	Then before the rmmod thread is frozen, it calls del_gendisk.

Delaying things by means of a workqueue (or the equivalent) might also 
work, but it doesn't seem as safe.  For example, some important 
writebacks might end up getting delayed until too late.

Alan Stern

