Return-Path: <linux-kernel-owner+w=401wt.eu-S932189AbXCVNmL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932189AbXCVNmL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 09:42:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932203AbXCVNmL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 09:42:11 -0400
Received: from pfx2.jmh.fr ([194.153.89.55]:50834 "EHLO pfx2.jmh.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932189AbXCVNmK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 09:42:10 -0400
Date: Thu, 22 Mar 2007 14:42:10 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
To: Tomas M <tomas@slax.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: max_loop limit
Message-Id: <20070322144210.73dfaf83.dada1@cosmosbay.com>
In-Reply-To: <46026A92.4020106@slax.org>
References: <460236CE.1030303@slax.org>
	<20070322110058.GB23664@tatooine.rebelbase.local>
	<46026A92.4020106@slax.org>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Mar 2007 12:37:54 +0100
Tomas M <tomas@slax.org> wrote:

> The question is not "Why do we need more than 255 loops?".
> The question should be "Why do we need the hardcoded 255-limit in kernel 
> while there is no reason for it at all?"
> 
> My patch simply removes the hardcoded limitation.

Hello Tomas, welcome !

Well, its an attempt to remove a hardcoded limit, but as you said in the Changelog, it really depends on kmalloc() being able to allocate a large continous memory zone. Alas it might fail.
The golden rule is to avoid all allocations larger than PAGE_SIZE :)

On x86_64, sizeof(struct loop_device) is 368, so the 'new limit' would be 356 instead of 256...

You might want a more radical patch : 

Instead of using :

static struct loop_device *loop_dev;
loop_dev = kmalloc(max_loop * sizeof(struct loop_device));

Switch to :

static struct loop_device **loop_dev;
loop_dev = kmalloc(max_loop * sizeof(void *));
if (!loop_dev) rollback...
for (i = 0 ; i < max_loop ; i++) {
	loop_dev[i] = kmalloc(sizeof(struct loop_device));
	if (!loop_dev[i]) rollback...
}

This time, you would be limited to 16384 loop devices on x86_64, 32768 on i386 :)
