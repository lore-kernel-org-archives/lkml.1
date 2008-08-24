Return-Path: <linux-kernel-owner+w=401wt.eu-S1754895AbYHXLBn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754895AbYHXLBn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2008 07:01:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752698AbYHXLBe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Aug 2008 07:01:34 -0400
Received: from wf-out-1314.google.com ([209.85.200.174]:17147 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751850AbYHXLBd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2008 07:01:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=vYxlyWOF3SDQEvFsnkTUnuSi0wYFAyNPUEbuNEtyhG1W804aF/nji4b1QfWZ8QB4Lc
         cArgdZ+Q6A2FgylaCLXtMShE+GKrBV5rKjbjSNMpDcEmPP3tu2dxc0xyhHfPvl5+D1hF
         2gxDlkVhjrCyLCQ6CjedveatNHljKu+NtFV+Y=
Message-ID: <48B13F88.3080306@gmail.com>
Date: Sun, 24 Aug 2008 04:01:28 -0700
From: Zev Weiss <zevweiss@gmail.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
       Rodolfo Giometti <giometti@enneenne.com>,
       David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH] [MTD] mtdchar.c: Fix regression in MEMGETREGIONINFO ioctl()
References: <48ABCC0B.40607@gmail.com>	<20080822153451.bb79bd1f.akpm@linux-foundation.org>	<48AFC5ED.50005@gmail.com> <20080823222707.2fb972b5.akpm@linux-foundation.org>
In-Reply-To: <20080823222707.2fb972b5.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
 > On Sat, 23 Aug 2008 01:10:21 -0700 Zev Weiss <zevweiss@gmail.com> wrote:
 >
 >> Hmm.  Well, I may be misunderstanding what you're saying (again, I'm very much
 >> a newbie to kernelspace), but I *think* the "copying four u32's out to
 >> userspace" thing isn't really a problem with my patch.  It does certainly copy
 >> those four u32's, but given that `ur' (struct mtd_region_info_user) is
 >> initialized by copying from userspace, its fourth u32 (the `regionindex'
 >> member) should be identical when copied back out to userspace, given that it's
 >> not touched in the memberwise modification of the struct.
 >
 > OK, that's fortuitously bug-free in single-threaded userspace but
 > fantastically-improbably-buggy if userspace is threaded.
 >
 > But it's something the kernel shouldn't be doing.
 >

Ah, good point -- that hadn't occurred to me at all.  Though it looks pretty
clumsy/simpleminded to me, I guess something like this would avoid copying and 
rewriting the fourth u32 ("Well, duh" may be the appropriate response here):

diff --git a/drivers/mtd/mtdchar.c b/drivers/mtd/mtdchar.c
index 13cc67a..424f318 100644
--- a/drivers/mtd/mtdchar.c
+++ b/drivers/mtd/mtdchar.c
@@ -410,16 +410,20 @@ static int mtd_ioctl(struct inode *inode, struct file *file,

         case MEMGETREGIONINFO:
         {
-               struct region_info_user ur;
+               u32 ur_idx;
+               struct mtd_erase_region_info *kr;
+               struct region_info_user *ur = (struct region_info_user *) argp;

-               if (copy_from_user(&ur, argp, sizeof(struct region_info_user)))
+               if (get_user(ur_idx,&(ur->regionindex)))
                         return -EFAULT;

-               if (ur.regionindex >= mtd->numeraseregions)
-                       return -EINVAL;
-               if (copy_to_user(argp, &(mtd->eraseregions[ur.regionindex]),
-                               sizeof(struct mtd_erase_region_info)))
+               kr = &(mtd->eraseregions[ur_idx]);
+
+               if (put_user(kr->offset, &(ur->offset))
+                   || put_user(kr->erasesize, &(ur->erasesize))
+                   || put_user(kr->numblocks, &(ur->numblocks)))
                         return -EFAULT;
+
                 break;
         }


[Note: this is not even so much as compile-tested, and will remain that way
until Monday, but I think you get the picture.]

 >>  So yes, it is
 >> copying 4 bytes more than is strictly necessary, but it seemed like a
 >> reasonably clean way of going about it (to me, for what that's worth).
 >>
 >> In my particular situation it didn't do anything unexpected in my testing (and
 >> restored the normal behavior I had when previously running 2.6.17.7).
 >>
 >> On the other hand, if I'm missing something completely, please let me know,
 >> and perhaps I can prepare a more suitable fix.
 >
 > "good enough" is never good enough ;)
 >
 > What is the ideal implementation?  Let's implement that.
 >
 >

Well that, I'm afraid, is a question that I think would require somewhat
greater depth of understanding than I possess (and I very much doubt the above
patch is it).  Given what you said earlier, it seems like the ideal solution
would involve a reworking of the patch that added the `lockmap' member to
struct mtd_erase_region_info, but I'm probably not the person to be messing
around with that.  So...anyone-who-knows-mtd-better-than-I, care to comment?


