Return-Path: <linux-kernel-owner+w=401wt.eu-S1755940AbZCJOt2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755940AbZCJOt2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 10:49:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752970AbZCJOtR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 10:49:17 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:44227 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751466AbZCJOtQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 10:49:16 -0400
Date: Tue, 10 Mar 2009 08:48:57 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Nick Piggin <npiggin@suse.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Dave Hansen <haveblue@us.ibm.com>
Subject: Re: [patch 1/2] fs: mnt_want_write speedup
Message-ID: <20090310144857.GX25995@parisc-linux.org>
References: <20090310143718.GB15977@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090310143718.GB15977@wotan.suse.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 10, 2009 at 03:37:18PM +0100, Nick Piggin wrote:
> costly, unfortunately). It results in about 900 bytes smaller code too. It
> does increase the size of a vfsmount, however.

Only on 64-bit SMP systems, and then only by four bytes.  And, best of
all, you can fix that if you care.  Look at this:

        /* --- cacheline 1 boundary (64 bytes) --- */
        struct list_head           mnt_child;            /*    64    16 */
        int                        mnt_flags;            /*    80     4 */

        /* XXX 4 bytes hole, try to pack */

        const char  *              mnt_devname;          /*    88     8 */
        struct list_head           mnt_list;             /*    96    16 */
        struct list_head           mnt_expire;           /*   112    16 */

So move mnt_flags to later in the struct (after the pointers), and move

> +#ifdef CONFIG_SMP
> +     int *mnt_writers;
> +#else
> +     int mnt_writers;
> +#endif

to be with the other pointers.  Bonus points for putting it between
        struct mnt_namespace *     mnt_ns;               /*   184     8 */
and
        int                        mnt_id;               /*   192     4 */

so that it doesn't become a new 4-byte hole for those incredibly common
64-bit uniprocessor builds.  *cough*.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
