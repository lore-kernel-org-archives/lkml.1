Return-Path: <linux-kernel-owner+w=401wt.eu-S1754031AbYHDEI0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754031AbYHDEI0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 00:08:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751175AbYHDEIR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 00:08:17 -0400
Received: from mx2.suse.de ([195.135.220.15]:41541 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750942AbYHDEIQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 00:08:16 -0400
From: Neil Brown <neilb@suse.de>
To: Paul Collins <paul@burly.ondioline.org>
Date: Mon, 4 Aug 2008 14:08:07 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18582.32935.501672.689845@notabene.brown>
Cc: "J. Bruce Fields" <bfields@fieldses.org>, linuxppc-dev@ozlabs.org,
       nfsv4@linux-nfs.org, linux-kernel@vger.kernel.org
Subject: Re: nfsd, v4: oops in find_acceptable_alias, ppc32 Linux, post-2.6.27-rc1
In-Reply-To: message from Paul Collins on Monday August 4
References: <87tze38vzt.fsf@burly.wgtn.ondioline.org>
	<20080802184554.GB715@fieldses.org>
	<87abfvm4cc.fsf@burly.wgtn.ondioline.org>
	<877iayy4qc.fsf@burly.wgtn.ondioline.org>
	<18581.40960.737792.454035@notabene.brown>
	<87r696l1yo.fsf@burly.wgtn.ondioline.org>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday August 4, paul@burly.ondioline.org wrote:
> Neil Brown <neilb@suse.de> writes:
> >
> > What filesystem is being exported here?
> 
> Boring old ext3 (on LVM, on dm-crypt).


Good.  That makes it easier.
> 
> > Can you get an assembly version of exportfs_decode_fh, so we can check
> > what is happening at 0xa8 (and 0x4c).
> 

Thanks.

bctrl appears to be the indirect-function-call opcode.  There are
three of them one each for
  ->fh_to_dentry
  acceptable
  ->fh_to_parent

0xa8 is 'acceptable'.

In the first traceback, the crash was a call from very early in 
find_acceptable_alias,  The first significant thing it does is call
the 'acceptable' function.

So it seems clear that 'acceptable' is NULL.
It is equally clear that we never ever set it to NULL in the code.
The logical conclusion is "compiler error".
We can confirm (hopefully) by looking at a disassembly of fh_verify.

Maybe because nfsd_acceptable is 'static' and never explicitly called,
gcc gets confused and optimises it away.  Maybe a disassembly of 
nfsd_acceptable would be informative ... particularly if it turns out
to be empty.

Could you try removing the 'static' declaration for nfsd_acceptable
and recompile?
Or maybe try a different compiler?

Thanks,
NeilBrown
