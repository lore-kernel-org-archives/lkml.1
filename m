Return-Path: <linux-kernel-owner+w=401wt.eu-S1751740AbXA0OQq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751740AbXA0OQq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jan 2007 09:16:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751749AbXA0OQq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jan 2007 09:16:46 -0500
Received: from ug-out-1314.google.com ([66.249.92.171]:14141 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751740AbXA0OQp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jan 2007 09:16:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=S5Z7nbeIDhP4Rbp9DOpGxHyKMPonvwFDKX8TQZY4JV4JLWfMAONHszupPhPXeyGmfrccNdp9dMnpirHS4sOCPKUAOoSz7F8hbSQg1D7jXX9rGUAZFdgcJ1gckJHsVUtVt5H8qohkEX+vgFNHAt60BMYu+FkXSQNphu0/dnhPDI0=
From: Denis Vlasenko <vda.linux@googlemail.com>
To: 7eggert@gmx.de
Subject: Re: O_DIRECT question
Date: Sat, 27 Jan 2007 15:14:31 +0100
User-Agent: KMail/1.8.2
Cc: Bill Davidsen <davidsen@tmr.com>, Michael Tokarev <mjt@tls.msk.ru>,
       Phillip Susi <psusi@cfl.rr.com>, Linus Torvalds <torvalds@osdl.org>,
       Viktor <vvp01@inbox.ru>, Aubrey <aubreylee@gmail.com>,
       Hua Zhong <hzhong@gmail.com>, Hugh Dickins <hugh@veritas.com>,
       linux-kernel@vger.kernel.org, hch@infradead.org, kenneth.w.chen@in
References: <7BYkO-5OV-17@gated-at.bofh.it> <7HIPV-8kp-35@gated-at.bofh.it> <E1HAo72-0000kF-Vz@be1.lrz>
In-Reply-To: <E1HAo72-0000kF-Vz@be1.lrz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200701271514.31203.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 27 January 2007 15:01, Bodo Eggert wrote:
> Denis Vlasenko <vda.linux@googlemail.com> wrote:
> > On Friday 26 January 2007 19:23, Bill Davidsen wrote:
> >> Denis Vlasenko wrote:
> >> > On Thursday 25 January 2007 21:45, Michael Tokarev wrote:
> 
> >> >> But even single-threaded I/O but in large quantities benefits from
> >> >> O_DIRECT significantly, and I pointed this out before.
> >> > 
> >> > Which shouldn't be true. There is no fundamental reason why
> >> > ordinary writes should be slower than O_DIRECT.
> >> > 
> >> Other than the copy to buffer taking CPU and memory resources.
> > 
> > It is not required by any standard that I know. Kernel can be smarter
> > and avoid that if it can.
> 
> The kernel can also solve the halting problem if it can.
> 
> Do you really think an entropy estamination code on all access patterns in the
> system will be free as in beer,

Actually I think we need this heuristic:

if (opened_with_O_STREAM && buffer_is_aligned
		&& io_size_is_a_multiple_of_sectorsize)
	do_IO_directly_to_user_buffer_without_memcpy

is not *that* compilcated.

I think that we can get rid of O_DIRECT peculiar requirements
"you *must* not cache me" + "you *must* write me directly to bare metal"
by replacing it with O_STREAM ("*advice* to not cache me") + O_SYNC
("write() should return only when data is written to storage, not sooner").

Why?

Because these O_DIRECT "musts" are rather unusual and overkill. Apps
should not have that much control over what kernel does internally;
and also O_DIRECT was mixing shampoo and conditioner on one bottle
(no-cache and sync writes) - bad API.
--
vda
