Return-Path: <linux-kernel-owner+w=401wt.eu-S1756824AbYKCVsw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756824AbYKCVsw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 16:48:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755219AbYKCVsm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 16:48:42 -0500
Received: from smtp2.riverbed.com ([206.169.144.7]:39433 "EHLO
	smtp2.riverbed.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752568AbYKCVsl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 16:48:41 -0500
Date: Mon, 3 Nov 2008 13:48:40 -0800
From: Arthur Jones <ajones@riverbed.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: "sandeen@redhat.com" <sandeen@redhat.com>,
       "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
       "sct@redhat.com" <sct@redhat.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ext3: wait on all pending commits in ext3_sync_fs
Message-ID: <20081103214840.GA3371@ajones-laptop.nbttech.com>
References: <4908C951.2000309@redhat.com> <20081103184426.GA31894@ajones-laptop.nbttech.com> <20081103113318.35b0c266.akpm@linux-foundation.org> <20081103201428.GB30565@ajones-laptop.nbttech.com> <20081103123750.67c96224.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20081103123750.67c96224.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew, ...

On Mon, Nov 03, 2008 at 12:37:50PM -0800, Andrew Morton wrote:
> [...]
> OK.  But still, questions remain.
> 
> - should we clear s_dirt if log_wait_commit() didn't work?
> 
> - ext3_force_commit() clears s_dirt also

I'm not sure if it makes sense, but ATM I don't think it
hurts anything given that ext3_write_super is just sb->s_dirt = 0;

> - should ext3_sync_fs() be dropping the ext3_force_commit() return
>   value on the floor?

Something like this (tested)?

diff --git a/fs/ext3/super.c b/fs/ext3/super.c
index 2b48b85..743acf1 100644
--- a/fs/ext3/super.c
+++ b/fs/ext3/super.c
@@ -2386,13 +2386,15 @@ static void ext3_write_super (struct super_block * sb)
 
 static int ext3_sync_fs(struct super_block *sb, int wait)
 {
+	int ret = 0;
+
 	sb->s_dirt = 0;
 	if (wait)
-		ext3_force_commit(sb);
+		ret = ext3_force_commit(sb);
 	else
 		journal_start_commit(EXT3_SB(sb)->s_journal, NULL);
 
-	return 0;
+	return ret;
 }
 
 /*

Arthur
