Return-Path: <linux-kernel-owner+w=401wt.eu-S1753616AbXJWDpz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753616AbXJWDpz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 23:45:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751869AbXJWDpr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 23:45:47 -0400
Received: from mx1.redhat.com ([66.187.233.31]:52196 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751846AbXJWDpq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 23:45:46 -0400
Date: Mon, 22 Oct 2007 20:45:39 -0700
From: Pete Zaitcev <zaitcev@redhat.com>
To: vitalivanov@gmail.com
Cc: w@1wt.eu, gregkh@suse.de, linux-usb-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, zaitcev@redhat.com
Subject: Re: [2.4 patch] Port of adutux driver from 2.6 kernel to 2.4.
Message-Id: <20071022204539.d3e1d291.zaitcev@redhat.com>
In-Reply-To: <1192815634.7965.53.camel@dell1.softservecom.com>
References: <1192383445.8372.18.camel@dell1.softservecom.com>
	<20071014182542.GA2832@1wt.eu>
	<35fbaa3e0710141345w484b941em831282cf0d49b5c@mail.gmail.com>
	<20071014223921.GA4677@1wt.eu>
	<1192542889.29039.66.camel@dell1.softservecom.com>
	<20071016154138.GA23326@1wt.eu>
	<1192559051.29039.139.camel@dell1.softservecom.com>
	<1192644776.10761.60.camel@dell1.softservecom.com>
	<35fbaa3e0710190826uae4e7b7u7d8f3139e1697030@mail.gmail.com>
	<20071019095313.76990765.zaitcev@redhat.com>
	<1192815634.7965.53.camel@dell1.softservecom.com>
Organization: Red Hat, Inc.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Oct 2007 20:40:35 +0300, Vitaliy Ivanov <vitalivanov@gmail.com> wrote:

Hi, Vitaly, I added you on cc: for the 2.6 cleanup. Please double-check
what I'm doing there and use it for your 2.4 version. I hope my intentions
get clearer with an example. Now, about the specific question:

> Static lock minor_table_mutex is used for minor table structure.
> And dev->sem for dev manipulations and that's why for open_count.
> If you will simply browse /drivers/usb dir for 2.4 you will see that
> such approach is widely used there.
> What's not right?

The fundamental reason why you cannot lock a free-able structure with
an in-structure lock is this. Imagine thread A locks in order to process
a disconnect. Thread B wants to open and waits for the lock. Notice that
the struct is not open, so thread A frees it. At this point, thread B
is using a freed memory.

The solution is to lock the instance struct dev with dev->mtx, except
for the open count, which is locked by a static lock (I'm ignoring
interrupts here, which cannot use mutexes).

I'm sorry to say, you're quite right: a number of drivers in 2.4 got
it wrong, and some (like adutux) carried it through 2.6.23.

-- Pete
