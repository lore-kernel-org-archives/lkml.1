Return-Path: <linux-kernel-owner+w=401wt.eu-S1756119AbYEPK0P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756119AbYEPK0P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 06:26:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754144AbYEPKZ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 06:25:57 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:41303 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753941AbYEPKZ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 06:25:56 -0400
X-AuditID: 0ac90650-ad3d8ba000005a29-62-482d613237ce
Message-ID: <482D6128.6060200@hitachi.com>
Date: Fri, 16 May 2008 19:25:44 +0900
From: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja-JP; rv:1.4) 
    Gecko/20030624 Netscape/7.1 (ax)
X-Accept-Language: ja
MIME-Version: 1.0
To: Jan Kara <jack@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, sct@redhat.com,
       adilger@clusterfs.com, linux-kernel@vger.kernel.org,
       linux-ext4@vger.kernel.org, Josef Bacik <jbacik@redhat.com>,
       Mingming Cao <cmm@us.ibm.com>,
       Satoshi OSHIMA <satoshi.oshima.fk@hitachi.com>,
       sugita <yumiko.sugita.yf@hitachi.com>
Subject: Re: [PATCH 2/4] jbd: ordered data integrity fix (rebased)
References: <482A6E00.6080303@hitachi.com> <482A6F2B.3020605@hitachi.com> 
    <20080514131007.GD24363@duck.suse.cz>
In-Reply-To: <20080514131007.GD24363@duck.suse.cz>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Thanks for your comment.

Jan Kara wrote:

> On Wed 14-05-08 13:48:43, Hidehiro Kawai wrote:
> 
>>Subject: [PATCH 2/4] jbd: ordered data integrity fix
>>
>>In ordered mode, if a buffer being dirtied exists in the committing
>>transaction, we write the buffer to the disk, move it from the
>>committing transaction to the running transaction, then dirty it.
>>But we don't have to remove the buffer from the committing
>>transaction when the buffer couldn't be written out, otherwise it
>>breaks the ordered mode rule.
> 
>   Hmm, could you elaborate a bit more what exactly is broken and how does
> this help to fix it? Because even if we find EIO happened on data buffer,
> we currently don't do anything else than just remove the buffer from the
> transaction and abort the journal. And even if we later managed to write
> the data buffer from other process before the journal is aborted, ordered
> mode guarantees are satisfied - we only guarantee that too old data cannot
> be seen, newer can be seen easily... Thanks.

In the case where I stated the above, error checking is postponed to
the next (currently running) transaction because the buffer is removed
from the committing transaction before checked for an error.  This can
happen repeatedly, then the error won't be detected "for a long time".
However, finally the error is detected by, for example,
journal_commit_transaction(), we can abort the journal.  So this
problem is not so serious than the other patches which I sent.

Thanks,

-- 
Hidehiro Kawai
Hitachi, Systems Development Laboratory
Linux Technology Center

