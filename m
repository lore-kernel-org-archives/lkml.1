Return-Path: <linux-kernel-owner+w=401wt.eu-S1754649AbXJHSLy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754649AbXJHSLy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 14:11:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754610AbXJHSLr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 14:11:47 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:18102 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753838AbXJHSLq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 14:11:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=HyyPkqRij7tYEwiKOZPREHnnM9CRUC+s0tpuDNDsJQRFN9uw/Mkg4CjyoVpJW69V15TMbaM8f++3s+GZ8RTeVeMRYro/FXwbhZAGqLf7pI12hTxD/mSJKhhM+K061cWU1bQQPD+mV9TCYI4CgoNNsbzOmWPElmuv3MjKT3hUeto=
Date: Mon, 8 Oct 2007 20:11:36 +0200
To: Konstantin Oshovskij <limulus@balticum-tv.lt>
Cc: linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: kernel 2.6.22.9-cfs-v22 compile warnings
Message-ID: <20071008181135.GA27024@Ahmed>
References: <470A23D0.8080503@balticum-tv.lt>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <470A23D0.8080503@balticum-tv.lt>
User-Agent: Mutt/1.5.11
From: "Ahmed S. Darwish" <darwish.07@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Konstantin,

On Mon, Oct 08, 2007 at 03:34:24PM +0300, Konstantin Oshovskij wrote:
>
> Hello,
> i have encountered 2.6.22.9 compile warnings. This is the first time i
> decided to report them. I had various compile warnings with earlier
> kernel versions, its just i didnt had courage to report them :)  I'm
> using instructions from REPORTING-BUGS file as template so please bear
> with me :)
> 

The "may be used uninitialized" errors are false positives from GCC. Mostly
this happens from code paths like: 

int x, y; 
set_method(&x); 
y = x;

> fs/xfs/xfs_bmap.c: In function 'xfs_bmap_rtalloc':
> fs/xfs/xfs_bmap.c:2650: warning: 'rtx' is used uninitialized in this
> function
> 

Hidden by uninitialized_var() macro in latest pull. This macro silence
the gcc by using the trick: #define uninitialized_var(x) x = x

> function
> ipc/msg.c:390: warning: 'setbuf.mode' may be used uninitialized in
> this function
>   CC      ipc/sem.o
> ipc/sem.c: In function 'sys_semctl':
> ipc/sem.c:861: warning: 'setbuf.uid' may be used uninitialized in this
> function
> ipc/sem.c:861: warning: 'setbuf.gid' may be used uninitialized in this
> function
> ipc/sem.c:861: warning: 'setbuf.mode' may be used uninitialized in
> this function
> 

Already hidden now by the uninitialized_var() macro.

> drivers/pci/search.c: In function 'pci_find_slot':
> drivers/pci/search.c:99: warning: 'pci_find_device' is deprecated
> (declared at include/linux/pci.h:477)

pci_find_slot is using pci_find_device on purpose here (equivalent to the
safe pci_get_slot method).

> drivers/pci/search.c: At top level:
> drivers/pci/search.c:434: warning: 'pci_find_device' is deprecated
> (declared at drivers/pci/search.c:241)
> drivers/pci/search.c:434: warning: 'pci_find_device' is deprecated
> (declared at drivers/pci/search.c:241)
> 

False positives from function definition and from the innocent EXPORT_SYMBOL
macro (It makes the method available to kernel modules).

Regards,

-- 
Ahmed S. Darwish
HomePage: http://darwish.07.googlepages.com
Blog: http://darwish-07.blogspot.com
