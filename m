Return-Path: <linux-kernel-owner+w=401wt.eu-S1752069AbXDBQRw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752069AbXDBQRw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 12:17:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752082AbXDBQRw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 12:17:52 -0400
Received: from mu-out-0910.google.com ([209.85.134.189]:28306 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752069AbXDBQRv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 12:17:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=MFA9PmgVmMgFZRar8dEkKW2ZKY19zNYykjQn15+6uepYSI+Do99f8sPgjj1JCDfQ99w77BCU652Epql0/lpnq/xBBZLE+okD4EEs2lIfGpMhUmrS4pzziJwBo4OoWWweiQ1dwD1OSqLRQHbrekWCYE7/V9o3uKzJFAhIaZbTpqk=
Message-ID: <6278d2220704020917h69d7c0d1t7ac61a544ec23f4@mail.gmail.com>
Date: Mon, 2 Apr 2007 17:17:48 +0100
From: "Daniel J Blueman" <daniel.blueman@gmail.com>
To: "Zoltan Menyhart" <Zoltan.Menyhart@bull.net>
Subject: Re: copy_one_pte()
Cc: "Linux Kernel" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 13 Mar, 20:20, Zoltan Menyhart <Zoltan.Menyh...@free.fr> wrote:
> I had a look at copy_one_pte().
> I cannot see any ioproc_update_page() call, not even for the COW pages.
> Is it intentional?

There could be an ioproc_update_range() call in
memory.c:copy_pte_range(), after the pte_unmap_unlock(), and this
would be an optimisation, since explicitly updating the mappings in
the Quadrics RDMA NIC avoids the need for the NIC to trap and update
it's MMU later.

The code which implements [1] this takes the pagetable locks with
pte_offset_map_lock(), and uses one of the kmap_atomic slots, so has
to be after the pagetables are unlocked. The
ioproc_invalidate_page/range() calls are different and can't live with
this race, so have to be used with the pagetable locks held.

Daniel

--- [1]

http://lwn.net/Articles/133627/
http://www.quadrics.com/linux

> We can live with a COW page for a considerably long time.
> How could the IO-PROC. know that a process-ID / user virt. addr. pair
> refers to the same page?
>
> The comment above ioproc_update_page() says that every time when a PTE
> is created / modified...
>
> Thanks,
>
> ZoltanMenyhart
-- 
Daniel J Blueman
