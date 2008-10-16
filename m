Return-Path: <linux-kernel-owner+w=401wt.eu-S1755667AbYJPN77@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755667AbYJPN77 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 09:59:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750920AbYJPN7v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 09:59:51 -0400
Received: from ey-out-2122.google.com ([74.125.78.27]:44320 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753394AbYJPN7v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 09:59:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=MZcruhpiFtgOjTSorWV2C4Fg1hvaZ/ZOxNfPzmxGIRwvFi6NNsBZu4RwaDq5DSaSs4
         ZOHKcKq0NrGddeTOPXaBlwsKwnY94CKz6HH7hmDLDBjseG+0XYn+Ut9b3piex4XLxH2e
         iUSAFsZxZLTykbcfhYzl9uqa1WlGC43kFH0u4=
Date: Thu, 16 Oct 2008 14:59:26 +0100
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Jianjun Kong <jianjun@zeuux.org>
Cc: Tim Shimmin <tes@sgi.com>, stable@kernel.org, linux-kernel@vger.kernel.org,
       xfs@oss.sgi.com
Subject: Re: [PATCH] XFS fix remount rw with unrecognized options
Message-ID: <20081016135926.GC13374@hack.voiplan.pt>
References: <20081016002926.D912558FA22B@chook.melbourne.sgi.com> <20081016134112.GA8773@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081016134112.GA8773@ubuntu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 16, 2008 at 09:41:12PM +0800, Jianjun Kong wrote:
>On Thu, Oct 16, 2008 at 11:29:26AM +1100, Tim Shimmin wrote:
>>Resending as I mangled sending the mail from home last time. Sorry.
>>
>>Please include the following patch for 2.6.27.1 stable release as
>>suggested by Christoph Hellwig and Eric Sandeen.
>>It fixes a regression in the recent remount recoding
>>where remounting say from ro to rw allows the xfs flags to
>>be out of sync with the vfs flags, resulting
>>in failures for some programs such as touch (which end up calling xfs_setattr).
>>The fix is a very minor and clear.
>>
>>Thanks,
>>Tim.
>>
>>Date: Sun, 12 Oct 2008 14:30:44 +0200
>>From: Christoph Hellwig <hch@lst.de>
>>To: xfs@oss.sgi.com
>>Subject: [PATCH] fix remount rw with unrecognized options
>>
>>When we skip unrecognized options in xfs_fs_remount we should just break
>>out of the switch and not return because otherwise we may skip clearing
>>the xfs-internal read-only flag.  This will only show up on some
>>operations like touch because most read-only checks are done by the VFS
>>which thinks this filesystem is r/w.  Eventually we should replace the
>>XFS read-only flag with a helper that always checks the VFS flag to make
>>sure they can never get out of sync.
>>
>>Bug reported and fix verified by Marcel Beister on #xfs.
>>Bug fix verified by updated xfstests/189.
>>
>>Signed-off-by: Christoph Hellwig <hch@lst.de>
>>Acked-by: Eric Sandeen <sandeen@sandeen.net>
>>Signed-off-by: Timothy Shimmin <tes@sgi.com>
>>
>>Index: mainline/fs/xfs/linux-2.6/xfs_super.c
>>===================================================================
>>--- mainline.orig/fs/xfs/linux-2.6/xfs_super.c	2008-10-15 17:59:26.542652847 +1100
>>+++ mainline/fs/xfs/linux-2.6/xfs_super.c	2008-10-15 17:59:45.376217172 +1100
>>@@ -1323,7 +1323,7 @@ xfs_fs_remount(
>> 	"XFS: mount option \"%s\" not supported for remount\n", p);
>> 			return -EINVAL;
>> #else
>>-			return 0;
>>+			break;
>> #endif
>> 		}
>> 	}
>
>
>And the code above "return 0" can not be executed, so delete them.


return 0; is in the removed part... so it's already removed.


>__________________________________________
>#if 0
>                        printk(KERN_INFO
>        "XFS: mount option \"%s\" not supported for remount\n", p);
>                        return -EINVAL;
>#else                                                                                                            
>                        return 0;
>-----------------------------------------
>
>
>Signed-off-by: Jianjun Kong <kongjianjun@gmail.com>
>---
> fs/xfs/linux-2.6/xfs_super.c |    7 +------
> 1 files changed, 1 insertions(+), 6 deletions(-)
>
>diff --git a/fs/xfs/linux-2.6/xfs_super.c b/fs/xfs/linux-2.6/xfs_super.c
>index e390136..bd5ec81 100644
>--- a/fs/xfs/linux-2.6/xfs_super.c
>+++ b/fs/xfs/linux-2.6/xfs_super.c
>@@ -1318,12 +1318,7 @@ xfs_fs_remount(
> 			 * every remount request, and silently ignore all
> 			 * options that we can't actually change.
> 			 */
>-#if 0
>-			printk(KERN_INFO
>-	"XFS: mount option \"%s\" not supported for remount\n", p);
>-			return -EINVAL;
>-#else
>-			break;
>+			break 0;


break 0; doesn't make any sense in C...


-- 
"Sometimes the only way to stay sane is to go a little crazy."

