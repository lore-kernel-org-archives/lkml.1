Return-Path: <linux-kernel-owner+w=401wt.eu-S1759255AbYGOUuO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759255AbYGOUuO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 16:50:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763658AbYGOUtp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 16:49:45 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56683 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763095AbYGOUto (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 16:49:44 -0400
Date: Tue, 15 Jul 2008 13:48:48 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Rik van Riel <riel@redhat.com>
Cc: linux-kernel@vger.kernel.org, Lee.Schermerhorn@hp.com,
       kosaki.motohiro@jp.fujitsu.com
Subject: Re: [PATCH][RFC] evict streaming IO cache first
Message-Id: <20080715134848.cf2204b9.akpm@linux-foundation.org>
In-Reply-To: <20080715160948.097b14a4@cuia.bos.redhat.com>
References: <20080715160948.097b14a4@cuia.bos.redhat.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Jul 2008 16:09:48 -0400
Rik van Riel <riel@redhat.com> wrote:

> This patch still needs some testing under various workloads
> on different hardware - the approach should work but the
> threshold may need tweaking.
> 

More than "some"!

> 
> When there is a lot of streaming IO going on, we do not want
> to scan or evict pages from the working set.  The old VM used
> to skip any mapped page, but still evict indirect blocks and
> other data that is useful to cache.

I'd be surprised if indirect blocks are getting kicked - they tend to
be awfully sticky due to frequent touch_buffer()s or equivalent.

inode blocks tend to be pretty sticky too - this is affected a lot by
whether or not atime updates are enabled.

directory blocks might be less sticky, but that might be what we want
to happen.

> This patch adds logic to skip scanning the anon lists and
> the active file list if most of the file pages are on the
> inactive file list (where streaming IO pages live), while
> at the lowest scanning priority.
> 
> If the system is not doing a lot of streaming IO, eg. the
> system is running a database workload, then more often used
> file pages will be on the active file list and this logic
> is automatically disabled.
> 
