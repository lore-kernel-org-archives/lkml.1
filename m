Return-Path: <linux-kernel-owner+w=401wt.eu-S1757578AbXJHB7N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757578AbXJHB7N (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2007 21:59:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753048AbXJHB66
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Oct 2007 21:58:58 -0400
Received: from py-out-1112.google.com ([64.233.166.177]:62045 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753009AbXJHB64 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2007 21:58:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=aUfFIjF1DB7tUdDNURZ952zYZR2BaTsggmAtPDA3PeX0IxOfX/AoIrq0Yeq8vc6ivqlgk3VWr/dENxslHsMNksTjhDdHRQgPYx0BkiF6dHvIh222lUl+ltHkjs9RrJKdinyfRH4VTZGUe/rsCsV5+kk43EhCXGI41IeWW52VFAA=
Message-ID: <cfa94dc20710071858l71ba6115p716d24f1bbcce1c@mail.gmail.com>
Date: Sun, 7 Oct 2007 18:58:54 -0700
From: "Ryan Finnie" <ryan@finnie.org>
To: "Pekka J Enberg" <penberg@cs.helsinki.fi>
Subject: Re: msync(2) bug(?), returns AOP_WRITEPAGE_ACTIVATE to userland
Cc: "Erez Zadok" <ezk@cs.sunysb.edu>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, "Colin Watson" <cjwatson@ubuntu.com>
In-Reply-To: <Pine.LNX.4.64.0710072255280.688@sbz-30.cs.Helsinki.FI>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0710072255280.688@sbz-30.cs.Helsinki.FI>
X-Google-Sender-Auth: 8dddd981df5c9227
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/7/07, Pekka J Enberg <penberg@cs.helsinki.fi> wrote:
> On 10/7/07, Erez Zadok <ezk@cs.sunysb.edu> wrote:
> > Anyway, some Ubuntu users of Unionfs reported that msync(2) sometimes
> > returns AOP_WRITEPAGE_ACTIVATE (decimal 524288) back to userland.
> > Therefore, some user programs fail, esp. if they're written such as
> > this:
>
...
> It's a kernel bug. AOP_WRITEPAGE_ACTIVATE is a hint to the VM to avoid
> writeback of the page in the near future. I wonder if it's enough that we
> change the return value to zero from
> mm/page-writeback.c:write_cache_pages() in case we hit AOP_WRITEPAGE_ACTIVE...

Doesn't appear to be enough.  I can't figure out why (since it appears
write_cache_pages bubbles up directly to sys_msync), but with that
patch applied, in my test case[1], msync returns -1 EIO.  However,
with the exact same kernel without that patch applied, msync returns
524288 (AOP_WRITEPAGE_ACTIVATE).  But as your patch specifically flips
524288 to 0, I can't figure out how it eventually returns  -1 EIO.

Ryan

[1] "apt-get check" on a unionfs2 mount backed by tmpfs over cdrom,
standard livecd setup
