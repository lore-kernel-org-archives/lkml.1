Return-Path: <linux-kernel-owner+w=401wt.eu-S1761725AbYF2PRd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761725AbYF2PRd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2008 11:17:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760724AbYF2PRZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jun 2008 11:17:25 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58278 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760411AbYF2PRY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2008 11:17:24 -0400
Date: Sun, 29 Jun 2008 11:16:05 -0400
From: Rik van Riel <riel@redhat.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Hugh Dickins <hugh@veritas.com>, kosaki.motohiro@jp.fujitsu.com,
       Andrew Morton <akpm@linux-foundation.org>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>,
       Nick Piggin <npiggin@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] splitlru: BDI_CAP_SWAP_BACKED
Message-ID: <20080629111605.6bc749c7@bree.surriel.com>
In-Reply-To: <20080629173841.37CD.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <Pine.LNX.4.64.0806290117510.21758@blonde.site>
	<Pine.LNX.4.64.0806290122330.21758@blonde.site>
	<20080629173841.37CD.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Organization: Red Hat, Inc.
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 29 Jun 2008 17:48:59 +0900
KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> I'm not sure about this patch is perfect.
> but it seems makes sense and very good code.
> 
> So, I'll testing this patch for a while.
> 
> Rik, What do you think about it?

I have been running with a similar patch for a while, and
got my system to OOM :)

However, the patch is correct and the OOM is caused by
a different issue.  When stress-testing with a loopback
device on a tmpfs file, the VM thinks that we succeed
in evicting pages from the loopback device (file LRUs)
and continues scanning those LRUs.

Unfortunately for the VM, the loopback writepage function,
in combination with splice, end up moving the pages to the
anon LRUs, instead of freeing any pages.  

This confuses the balancing code, which thinks the pages
got freed.  As a result, the VM keeps scanning the file
LRUs and will eventually realize it failed to free any
memory.

One of Kosaki-san's recent patches may fix this, though.

-- 
All rights reversed.
