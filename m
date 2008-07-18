Return-Path: <linux-kernel-owner+w=401wt.eu-S1760701AbYGRRSB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760701AbYGRRSB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 13:18:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760259AbYGRRRs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 13:17:48 -0400
Received: from wf-out-1314.google.com ([209.85.200.173]:29852 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761136AbYGRRRr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 13:17:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=RCc8i94+zOkGWZQdLHmCNEL9ZRsdCVUbGvHAuf+cPPcMIaSczTxh9W40pTOJFYqkyt
         PQdygqNg/B+8hVddngE7z44yqgQxqWN3pZEysbXd49EJgZqXxBWDYB7V4+fYkxMDCGFj
         7Q1DtjUSOIdwDzzJ6sVEOwh7m+zcZUIIEIILE=
Message-ID: <19f34abd0807181017i2fac8291n439c23843c55afd6@mail.gmail.com>
Date: Fri, 18 Jul 2008 19:17:44 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Dave Kleikamp" <shaggy@linux.vnet.ibm.com>
Subject: Re: latest -git: BUG at fs/jfs/namei.c:512 assert(ip->i_nlink)
Cc: jfs-discussion@lists.sourceforge.net,
       "Johannes Weiner" <hannes@saeurebad.de>, linux-kernel@vger.kernel.org
In-Reply-To: <1216401356.11215.15.camel@norville.austin.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <19f34abd0807171135m4a3b39e6v4065ed676720ae46@mail.gmail.com>
	 <1216336164.32175.3.camel@norville.austin.ibm.com>
	 <19f34abd0807180110k5a19e525y463b59208f0587b2@mail.gmail.com>
	 <1216401356.11215.15.camel@norville.austin.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 18, 2008 at 7:15 PM, Dave Kleikamp
<shaggy@linux.vnet.ibm.com> wrote:
> On Fri, 2008-07-18 at 10:10 +0200, Vegard Nossum wrote:
>
>> But whether it truly helped or not, I don't know. I got something different now:
>>
>> jfs_unlink: dtDelete returned -116
>> jfs_unlink: dtDelete returned -116
>> ------------[ cut here ]------------
>> kernel BUG at fs/inode.c:262!
>
>        BUG_ON(inode->i_data.nrpages);
>
>> invalid opcode: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
>> Pid: 387, comm: jfsCommit Not tainted (2.6.26-03415-gdf3030b #45)
>> EIP: 0060:[<c01b96f9>] EFLAGS: 00010206 CPU: 0
>> EIP is at clear_inode+0x149/0x160
>> EAX: 00000005 EBX: f56e283c ECX: f7242fd0 EDX: 00000000
>> ESI: f56e2568 EDI: 00000000 EBP: f79f9f0c ESP: f79f9f04
>>  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
>> Process jfsCommit (pid: 387, ti=f79f8000 task=f7242fd0 task.ti=f79f8000)
>> Stack: 00000001 f56e283c f79f9f24 c02de258 c08f7ba0 f79f9f24 c02de220 f56e283c
>>        f79f9f34 c01b9ba1 f56e283c 00000000 f79f9f44 c01b9d67 f56e283c 00000000
>>        f79f9f50 c01b8be7 f56e283c f79f9f9c c02fd5b5 f88261bc f79f9f70 c0159173
>
>>
>> ...but it might just be a different error altogether.
>
> I think it is.  Your test corrupt more than just di_nlink, right?  There
> is a test in jfs_delete_inode() for JFS_IP(inode)->fileset ==
> FILESYSTEM_I.  If the test fails, we don't call truncate_inode_pages().
> Nowhere do we validate that fileset = FILESYSTEM_I when we read the
> inode from disk.
>
> I'm pondering whether it would be okay to remove the silly test in
> jfs_delete_inode(), or whether I need to validate the field when we read
> in the inode.
>
> Hmm.  The fileset is written to the journal, so it really should be
> validated.
>
> Here's another patch
>
> JFS: validate di_fileset when reading inode from disk.

Thanks. On top of the previous one, I presume?


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
