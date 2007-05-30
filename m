Return-Path: <linux-kernel-owner+w=401wt.eu-S1760473AbXE3Vt2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760473AbXE3Vt2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 17:49:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759593AbXE3Vsb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 17:48:31 -0400
Received: from mx1.redhat.com ([66.187.233.31]:35554 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759642AbXE3Vsa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 17:48:30 -0400
Message-ID: <465DF0B4.2050203@sandeen.net>
Date: Wed, 30 May 2007 16:46:28 -0500
From: Eric Sandeen <sandeen@sandeen.net>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Jan Kara <jack@suse.cz>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Cyrill Gorcunov <gorcunov@gmail.com>
Subject: Re: [PATCH 2/2] Fix possible leakage of blocks in UDF
References: <20070524165935.GB19709@duck.suse.cz> <20070524170554.GC19709@duck.suse.cz> <20070524203653.GA7693@duck.suse.cz>
In-Reply-To: <20070524203653.GA7693@duck.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Kara wrote:
>   Hello,
> 
> On Thu 24-05-07 19:05:54, Jan Kara wrote:
>>   Hello,
>>
>>   attached is a patch that fixes possible leakage of free blocks / use of
>> free blocks in UDF (which spilled nice assertion failures I've added in my
>> first round of patches). More details in the changelog. Andrew, please apply.
>> Both changes have survived some time of fsx and fsstress testing so they
>> should be reasonably safe.
>   Sorry for replying to myself but this patch had a minor problem of
> printing some bogus warnings when directories were deleted (I wonder why
> fsstress didn't find it). Attached is a new version of the patch without
> this problem.

Jan, something seems busted here.  I'm getting lockups when testing udf
on a single cpu with this last patch in place...

I think it's the BKL stumbling on itself.

for example...

static int udf_symlink(struct inode * dir, struct dentry * dentry, const
char * symname)
{
...
        lock_kernel();
...
out:
        unlock_kernel();
        return err;

out_no_entry:
        inode_dec_link_count(inode);
        iput(inode);
        goto out;
}

but iput goes
iput->iput_final->drop_inode->udf_drop_inode->lock_kernel() again

looking for the right way around it but figured I'd ping you early :)

-Eric
