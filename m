Return-Path: <linux-kernel-owner+w=401wt.eu-S1754932AbXE3NrR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754932AbXE3NrR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 09:47:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754383AbXE3NrB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 09:47:01 -0400
Received: from wr-out-0506.google.com ([64.233.184.235]:16333 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754400AbXE3NrA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 09:47:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=En5SM0FK8pFplozkNiFUYO2TlevPDFGi9ft7vJnmSbE3CboRmOM1DmrZcJe8HYM5Ia1TKE5O5fykd6+hPH84vB/i+0/ysiAXv/LHuSmVhZfGCHE1WtdgxBQXqXiWwjNCGvAjEaeayYRXAwVqydfzk03UrzBZl4k4X8IDdVyMfiU=
Message-ID: <465D800B.2050502@gmail.com>
Date: Wed, 30 May 2007 22:45:47 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Cornelia Huck <cornelia.huck@de.ibm.com>
CC: gregkh@suse.de, dmitry.torokhov@gmail.com, oneukum@suse.de,
       rpurdie@rpsys.net, stern@rowland.harvard.edu, maneesh@in.ibm.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/6] sysfs: use sysfs_lock to protect the sysfs_dirent
 tree
References: <11803701861778-git-send-email-htejun@gmail.com>	<1180370187803-git-send-email-htejun@gmail.com> <20070530133329.4a10a892@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <20070530133329.4a10a892@gondolin.boeblingen.de.ibm.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Cornelia Huck wrote:
> On Tue, 29 May 2007 01:36:27 +0900,
> Tejun Heo <htejun@gmail.com> wrote:
> 
>> @@ -795,6 +822,8 @@ static int sysfs_readdir(struct file * f
>>  			i++;
>>  			/* fallthrough */
>>  		default:
>> +			spin_lock(&sysfs_lock);
>> +
>>  			pos = &parent_sd->s_children;
>>  			while (*pos != cursor)
>>  				pos = &(*pos)->s_sibling;
>> @@ -827,6 +856,8 @@ static int sysfs_readdir(struct file * f
>>  			/* put cursor back in */
>>  			cursor->s_sibling = *pos;
>>  			*pos = cursor;
>> +
>> +			spin_unlock(&sysfs_lock);
>>  	}
>>  	return 0;
>>  }
> 
> Here's the cause of the "sleeping function called" I saw. filldir() is
> called under sysfs_lock, but calls copy_to_user()... This means you
> can't use sysfs_lock for protection here.

Ouch, right.  I think we can get away with a temp buffer there.  Thanks.

-- 
tejun
