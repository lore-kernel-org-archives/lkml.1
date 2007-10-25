Return-Path: <linux-kernel-owner+w=401wt.eu-S1761404AbXJYOsp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761404AbXJYOsp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 10:48:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753917AbXJYOsh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 10:48:37 -0400
Received: from mx1.redhat.com ([66.187.233.31]:40182 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756880AbXJYOsg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 10:48:36 -0400
Date: Thu, 25 Oct 2007 15:48:33 +0100
From: Alasdair G Kergon <agk@redhat.com>
To: device-mapper development <dm-devel@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [dm-devel] [PATCH] dm: noflush resizing (0/3)
Message-ID: <20071025144833.GN10006@agk.fab.redhat.com>
Mail-Followup-To: device-mapper development <dm-devel@redhat.com>,
	linux-kernel@vger.kernel.org
References: <471FB83D.4060307@ce.jp.nec.com> <20071025012456.GK10006@agk.fab.redhat.com> <4720A59A.8060001@ce.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4720A59A.8060001@ce.jp.nec.com>
User-Agent: Mutt/1.4.1i
Organization: Red Hat UK Ltd. Registered in England and Wales, number 03798903. Registered Office: Amberley Place, 107-111 Peascod Street, Windsor, Berkshire, SL4 1TE.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 25, 2007 at 10:18:02AM -0400, Jun'ichi Nomura wrote:
> There is no guarantee that the I/O flowing through the device again.
> The table might need be replaced again, but to do that, the resume
> should have been completed to let the userspace know it.

Then the first attempt to set the size could be made to fail
(because it could not get the lock immediately) and the
size could be set after the second resume instead.

- Setting the size would lag behind the actual size the dm table was
supporting, but (given the usage cases discussed) this would not matter.

> bdget() in noflush suspend has a possibility of stall.

So we cannot avoid fixing that: we require immediate return
with failure instead of waiting.

> OTOH, calling bdget() and i_size_write() outside of the lock
> can cause race with other table swapping and may result in setting
> wrong device size.

If the size setting is removed from the lock, then it becomes
"set the inode size to match the current size of the table" and
races would not matter - each "set size" attempt would set it
to the instantaneous live table size, not a cached value that
could be out-of-date.

Alasdair
-- 
agk@redhat.com
