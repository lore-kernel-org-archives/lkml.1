Return-Path: <linux-kernel-owner+w=401wt.eu-S1761052AbYFXRQx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761052AbYFXRQx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 13:16:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759437AbYFXRQZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 13:16:25 -0400
Received: from el-out-1112.google.com ([209.85.162.180]:36581 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758769AbYFXRQX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 13:16:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=MJbcFOIACxOJaqKn0kxw0m9qixUc8QNsYSJbDI874n561BrBYgODRooTUZ4tJvKFwN
         agYkzc2JwPEJEhigW6r3WXRVSh9GBvGimDCyZB2J+fhBHgY70ldYLp1tIrqSCf9Ay0fe
         uyHNWP3H6G0Rsq9eLeEjHml+D2Ab47ZO/B+ZQ=
Message-ID: <e9e943910806241016v743ce19s28bdf34177154799@mail.gmail.com>
Date: Tue, 24 Jun 2008 18:16:21 +0100
From: "Duane Griffin" <duaneg@dghda.com>
To: "Jan Kara" <jack@suse.cz>
Subject: Re: [PATCH] ext3: handle corrupted orphan list at mount
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, sct@redhat.com, adilger@clusterfs.com,
       "Sami Liedes" <sliedes@cc.hut.fi>
In-Reply-To: <20080624160810.GC22586@atrey.karlin.mff.cuni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080607121940.8ee6044a.akpm@linux-foundation.org>
	 <1214258200-16623-1-git-send-email-duaneg@dghda.com>
	 <20080624160810.GC22586@atrey.karlin.mff.cuni.cz>
X-Google-Sender-Auth: 0f7f9a74ed7bc894
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/6/24 Jan Kara <jack@suse.cz>:
>> +     /*
>> +      * If the orphans has i_nlinks > 0 then it should be able to be
>> +      * truncated, otherwise it won't be removed from the orphan list
>> +      * during processing and an infinite loop will result.
>> +      */
>> +     if (inode->i_nlink && !ext3_can_truncate(inode))
>> +             goto bad_orphan;
>> +
>  Maybe I miss something but shouldn't above rather be ||?

No, it is correct. If i_nlink == 0 the orphan will be deleted in the
cleanup loop by the iput. If i_nlink > 0 then ext3_truncate is called,
which usually calls ext3_orphan_del on the way out, thereby removing
the node from the orphan list. However, if it exits too early
(basically if the ext3_can_truncate check fails, although there are
other failure conditions such as OOM that can also cause it to exit
early) then it doesn't, hence we end up in the infinite loop. So the
check here says, if this node is not going to be deleted or truncated
then it is invalid.

Cheers,
Duane.

-- 
"I never could learn to drink that blood and call it wine" - Bob Dylan
