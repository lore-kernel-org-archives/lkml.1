Return-Path: <linux-kernel-owner+w=401wt.eu-S934264AbXCWBfW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934264AbXCWBfW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 21:35:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934266AbXCWBfW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 21:35:22 -0400
Received: from tmailer.gwdg.de ([134.76.10.23]:60966 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934264AbXCWBfV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 21:35:21 -0400
Date: Fri, 23 Mar 2007 02:34:04 +0100 (MET)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Eric Dumazet <dada1@cosmosbay.com>
cc: Tomas M <tomas@slax.org>, linux-kernel@vger.kernel.org
Subject: Re: max_loop limit
In-Reply-To: <20070322144210.73dfaf83.dada1@cosmosbay.com>
Message-ID: <Pine.LNX.4.61.0703230232320.9555@yvahk01.tjqt.qr>
References: <460236CE.1030303@slax.org> <20070322110058.GB23664@tatooine.rebelbase.local>
 <46026A92.4020106@slax.org> <20070322144210.73dfaf83.dada1@cosmosbay.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Mar 22 2007 14:42, Eric Dumazet wrote:
>Instead of using :
>
>static struct loop_device *loop_dev;
>loop_dev = kmalloc(max_loop * sizeof(struct loop_device));
>
>Switch to :
>
>static struct loop_device **loop_dev;
>loop_dev = kmalloc(max_loop * sizeof(void *));
>if (!loop_dev) rollback...
>for (i = 0 ; i < max_loop ; i++) {
>	loop_dev[i] = kmalloc(sizeof(struct loop_device));
>	if (!loop_dev[i]) rollback...
>}
>
>This time, you would be limited to 16384 loop devices on x86_64, 32768 on i386
>:)

Oh noes. Please use a linked list (kmalloc cope = perfect) if you really need
loads of loopdevs. Sorta

 struct loopdev {
    struct list_head lh;
    int lo_number;
 };

to keep the /dev/loop%d number consistent across loopdev removal.
Maybe it's better to even use an rbtree (linked list does not scale to it).


Jan
-- 
