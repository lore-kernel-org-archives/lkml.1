Return-Path: <linux-kernel-owner+w=401wt.eu-S1753351AbXHVAYV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753351AbXHVAYV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 20:24:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751007AbXHVAYK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 20:24:10 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:61896 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828AbXHVAYJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 20:24:09 -0400
Date: Tue, 21 Aug 2007 20:23:14 -0400
From: Chris Mason <chris.mason@oracle.com>
To: Fengguang Wu <wfg@mail.ustc.edu.cn>
Cc: Andrew Morton <akpm@osdl.org>, Ken Chen <kenchen@google.com>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 0/6] writeback time order/delay fixes take 3
Message-ID: <20070821202314.335e86ec@think.oraclecorp.com>
In-Reply-To: <386910467.21100@ustc.edu.cn>
References: <386910467.21100@ustc.edu.cn>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 12 Aug 2007 17:11:20 +0800
Fengguang Wu <wfg@mail.ustc.edu.cn> wrote:

> Andrew and Ken,
> 
> Here are some more experiments on the writeback stuff.
> Comments are highly welcome~ 

I've been doing benchmarks lately to try and trigger fragmentation, and
one of them is a simulation of make -j N.  It takes a list of all
the .o files in the kernel tree, randomly sorts them and then
creates bogus files with the same names and sizes in clean kernel trees.

This is basically creating a whole bunch of files in random order in a
whole bunch of subdirectories.

The results aren't pretty:

http://oss.oracle.com/~mason/compilebench/makej/compare-compile-dirs-0.png

The top graph shows one dot for each write over time.  It shows that
ext3 is basically writing all over the place the whole time.  But, ext3
actually wins the read phase, so the layout isn't horrible.  My guess
is that if we introduce some write clustering by sending a group of
inodes down at the same time, it'll go much much better.

Andrew has mentioned bringing a few radix trees into the writeback paths
before, it seems like file servers and other general uses will benefit
from better clustering here.

I'm hoping to talk you into trying it out ;)

-chris
