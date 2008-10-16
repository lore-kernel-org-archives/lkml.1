Return-Path: <linux-kernel-owner+w=401wt.eu-S1753287AbYJPGMN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753287AbYJPGMN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 02:12:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752346AbYJPGLm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 02:11:42 -0400
Received: from hera.kernel.org ([140.211.167.34]:56786 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751826AbYJPGLh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 02:11:37 -0400
Message-ID: <48F6DA77.7090303@kernel.org>
Date: Thu, 16 Oct 2008 15:08:55 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Elias Oltmanns <eo@nebensachen.de>
CC: Alex Chiang <achiang@hp.com>, jeff@redhat.com, linux-ide@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] stop gcc warning about uninitialized 'dev' in	ata_scsi_scan_host
References: <20081015232505.GB9272@ldl.fc.hp.com>	<48F6A2E7.5090005@kernel.org> <20081016034042.GA27621@ldl.fc.hp.com>	<48F6BAFE.6080106@kernel.org> <87r66hjcwv.fsf@denkblock.local>
In-Reply-To: <87r66hjcwv.fsf@denkblock.local>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 16 Oct 2008 06:10:52 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Elias Oltmanns wrote:
>> I think the current policy is blaming gcc but I also added quite a few
>> bogus NULL initializations here and there and caught several bugs thanks
>> to those warnings.  We can think about adding an additional annotation
>> with leading double underbars which indicate that certain pointer
>> arguments to functions expect (or are okay with) pointers to
>> uninitialized variables which should be able to remove many of those
>> spurious warnings (on the caller side, the compiler can ignore the
>> warning and on the callee side the compiler can check whether it's being
>> dereferenced without being written to).  Does anyone know whether gcc
>> already has that type of annotation?
> 
> Well, I don't know of this particular kind of annotation. However, I
> don't quite see how that would solve the reported issue.

I was thinking about the warning in sata_via.c and for such cases the
compiler doesn't have any other way of figuring out whether it's okay
or not (the sata_via case, the compiler can actually do as the callee
is in the same file but you know what I mean).

> Here, dev is a local variable and the warning is generated due to
> the line
> 
> 		if (dev != last_failed_dev) {
> 
> For this sort of thing we have:
> 
> 	struct ata_device *uninitialized_var(dev);

Ah.. thanks.

> Or is that precisely the thing you did *not* want?

I don't know.  Later versions of gcc doesn't issue warning because it
knows "if (!link)" always triggers if dev is not initialized.  I don't
think we should be adding those annotations if the current gen
compiler can already figure that out as it only decreases
debuggability when something actually gets broken there.

Thanks.

-- 
tejun
