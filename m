Return-Path: <linux-kernel-owner+w=401wt.eu-S1754855AbZCJPDx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754855AbZCJPDx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 11:03:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754179AbZCJPDm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 11:03:42 -0400
Received: from mx1.suse.de ([195.135.220.2]:47157 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753610AbZCJPDl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 11:03:41 -0400
Date: Tue, 10 Mar 2009 16:03:38 +0100
From: Nick Piggin <npiggin@suse.de>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Dave Hansen <haveblue@us.ibm.com>
Subject: Re: [patch 1/2] fs: mnt_want_write speedup
Message-ID: <20090310150338.GA8579@wotan.suse.de>
References: <20090310143718.GB15977@wotan.suse.de> <20090310144857.GX25995@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090310144857.GX25995@parisc-linux.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 10, 2009 at 08:48:57AM -0600, Matthew Wilcox wrote:
> On Tue, Mar 10, 2009 at 03:37:18PM +0100, Nick Piggin wrote:
> > costly, unfortunately). It results in about 900 bytes smaller code too. It
> > does increase the size of a vfsmount, however.
> 
> Only on 64-bit SMP systems, and then only by four bytes.  And, best of
> all, you can fix that if you care.  Look at this:
> 
>         /* --- cacheline 1 boundary (64 bytes) --- */
>         struct list_head           mnt_child;            /*    64    16 */
>         int                        mnt_flags;            /*    80     4 */
> 
>         /* XXX 4 bytes hole, try to pack */
> 
>         const char  *              mnt_devname;          /*    88     8 */
>         struct list_head           mnt_list;             /*    96    16 */
>         struct list_head           mnt_expire;           /*   112    16 */
> 
> So move mnt_flags to later in the struct (after the pointers), and move
> 
> > +#ifdef CONFIG_SMP
> > +     int *mnt_writers;
> > +#else
> > +     int mnt_writers;
> > +#endif
> 
> to be with the other pointers.  Bonus points for putting it between
>         struct mnt_namespace *     mnt_ns;               /*   184     8 */
> and
>         int                        mnt_id;               /*   192     4 */
> 
> so that it doesn't become a new 4-byte hole for those incredibly common
> 64-bit uniprocessor builds.  *cough*.

Oh good point, although yes I was more worried about mnt_writers in
the SMP case (yes I didn't state it very well). Basically I would be
worried if huge machinges have huge numbers of mounts.... but I think
a) if they did they would probably like the scalability improvements,
b) the improvement on smaller systems is so significant that 100s of
   CPU systems will have to find a way to cut down memory if it really
   was a problem for them.

