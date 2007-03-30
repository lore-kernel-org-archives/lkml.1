Return-Path: <linux-kernel-owner+w=401wt.eu-S1945971AbXC3KeS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945971AbXC3KeS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 06:34:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945972AbXC3KeS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 06:34:18 -0400
Received: from wr-out-0506.google.com ([64.233.184.233]:48207 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945971AbXC3KeR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 06:34:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=e6ecw/kjtr13qkugq+VMn1cCDhxZpXAK+YKPvtL974y0EuMozZyH0P2oXCh/mNcu7ZNcbrexfKLt+hUpuCEIF3L6HIPJsuamoSzsdlDPTB3U3qBQFVL+qPBSCcTaP+QQafo/bh77OtmVjsAWKhk/dbyexKqmJY9QRPsttDsIB7s=
Message-ID: <6d6a94c50703300334w6b4787f3p144715de5166d7bc@mail.gmail.com>
Date: Fri, 30 Mar 2007 18:34:15 +0800
From: "Aubrey Li" <aubreylee@gmail.com>
To: "David Howells" <dhowells@redhat.com>, vapier.adi@gmail.com,
       jie.zhang@analog.com
Subject: Re: [PATCH] nommu arch dont zero the anonymous mapping by adding UNINITIALIZE flag
Cc: bryan.wu@analog.com, "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <10785.1175247540@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1175226172.15391.66.camel@roc-desktop>
	 <10785.1175247540@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/30/07, David Howells <dhowells@redhat.com> wrote:
> Wu, Bryan <bryan.wu@analog.com> wrote:
>
> > It takes lots of time in malloc()->mmap()->do_mmap_private()->memset(). When
> > malloc a big area, memset() the area to zero makes the performance very bad.
>
> Ummm...
>
> How do you then cope with attempting to run that same application under
> MMU-mode Linux?  Won't MMU mmap() give EINVAL?  If so, then that'd be grounds
> for NAK'ing this patch in the form given.
>
> My theory is that NOMMU binaries should run just as well under an MMU-mode
> kernel as under a NOMMU kernel.
>
> What you're asking for is also a security risk - though obviously on NOMMU-mode
> one that's fairly irrelevant.  It might even make a lot of sense there to move
> the clearance into uClibc where possible rather than doing it in the kernel.
>
> On MMU-mode kernels, the option should just be ignored.
>
> I'd also recommend you stick a 'D' on the end of 'MAP_UNINITIALIZE' or may be
> call it MAP_UNCLEARED'.  But that's a minor point, but you're not telling
> mmap() to go and uninitialise the memory...
>
> Lastly, why do you actually need VM_UNINITIALIZE at all?  The flag is only used
> in a place where MAP_UNINITIALIZE is still available (okay, you'll have to hand
> it down as an extra argument).  That looks like a waste of a VM_xxx flag, and
> we don't have that many to spare.
>

Well, I don't understand why we have to clear the allocation memory.
I suggest we just remove the memset(addr, 0, len) operation at all.
Read the malloc manual, you'll get
--------
malloc() allocates size bytes and returns a pointer to the allocated memory.
****The memory is not cleared.****
--------
So, if not clearing the memory causes one application hang/crash,
that's the bug of that application and it need to be fixed.

The patch in my option is:
------------------------------------
diff --git a/mm/nommu.c b/mm/nommu.c
index cbbc137..fe2b6d4 100644
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -759,10 +759,6 @@ static int do_mmap_private(struct vm_are
                /* clear the last little bit */
                if (ret < len)
                        memset(base + ret, 0, len - ret);
-
-       } else {
-               /* if it's an anonymous mapping, then just clear it */
-               memset(base, 0, len);
        }

        return 0;
----------------------------------------

-Aubrey
