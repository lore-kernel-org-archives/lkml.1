Return-Path: <linux-kernel-owner+w=401wt.eu-S1752089AbZLAFB4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752089AbZLAFB4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 00:01:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751139AbZLAFBw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 00:01:52 -0500
Received: from mail-iw0-f171.google.com ([209.85.223.171]:44865 "EHLO
	mail-iw0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750815AbZLAFBw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 00:01:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=QlQ4k971Bry014NgSuJXw8v9bVGFqjBLvnzByUpAliB4WySpDm2k9h3Rkf8rj6iGiQ
         3YFeJ9aSQ2XBwyL5oKQoN/XXPgLxk3BIvUeSzA8hafMTKXv+CGkjOmKxN3BX7ZEEIkSF
         89Dej1QtlMx1klqned2eaROFJjEBynfgu7zP4=
MIME-Version: 1.0
In-Reply-To: <20091125195256.GL9482@parisc-linux.org>
References: <200911252209432039291@gmail.com>
	 <20091125141505.GH9482@parisc-linux.org>
	 <a229bc400911251120y220066afjb10d391198c5807c@mail.gmail.com>
	 <20091125195256.GL9482@parisc-linux.org>
Date: Tue, 1 Dec 2009 13:01:57 +0800
Message-ID: <b3657a100911302101t59a07518tddfd0a267d4ce64c@mail.gmail.com>
Subject: Re: [PATCH 1/3]fs/inode: iunique() Optimize Performance
From: liu weni <qingshenlwy@gmail.com>
To: Matthew Wilcox <matthew@wil.cx>
Cc: strongzgy <strongzgy@gmail.com>, xgr178 <xgr178@163.com>,
       Liu Hui <onlyflyer@gmail.com>, viro <viro@zeniv.linux.org.uk>,
       akpm <akpm@linux-foundation.org>, jack <jack@suse.cz>,
       npiggin <npiggin@suse.de>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks, I will try others way to improve the performance.


2009/11/26 Matthew Wilcox <matthew@wil.cx>:
> On Wed, Nov 25, 2009 at 08:20:02PM +0100, J?r?my Cochoy wrote:
>> Hello,
>>
>> There is something strange in iunique : what will happend if all inode
>> between max_reserved+1 and (unsinged in)(0-1) ? Will it make an
>> infinite loop or an interruption can happen and make an inode become
>> free?
>
> Another process can free an inode while this loop is executing.
>
>> In that case, it will be better to stop search when counter overflow, no?
>
> If you have all four billion inodes allocated, you have significantly
> bigger problems than this loop.  For a start, at 600 bytes per inode,
> I'd like to see your machine with 2.4TB of memory.  Then there's the
> size of your inode hash, and the depth of the chains within it.
>
>> Will it not be better to use a field max_ino_used (in superblock, for
>> exemple) where we store the last inode allocated with iunique and make
>> a search only if max_ino_used become to (unsigned)(-1) ?
>>
>> But, if iunique is here to provide a solution in order to generate
>> unused inode in filesystem which have various inode number, it's
>> better to use a list of used ino, in a short hash table which use the
>> first 8 bits of the inode, always use the same function to create a
>> new inode and look at the head if we can add a new inode with bigger
>> ino and still in the range. (But i think filesystems developper prefer
>> to write ther own functions in order to do that, no?)
>>
>> Well, if we want to stop in case of full inode filesystem, we can put
>> the first condition in the head and add change return as :
>> return inode->i_ino > max_reserved ? res : 0; // 0 might "i can't find
>> an inode after max_reserved"
>
> Gloves.
>
> http://thedailywtf.com/Articles/The_Complicator_0x27_s_Gloves.aspx
>
> --
> Matthew Wilcox                          Intel Open Source Technology Centre
> "Bill, look, we understand that you're interested in selling us this
> operating system, but compare it to ours.  We can't possibly take such
> a retrograde step."
>
