Return-Path: <linux-kernel-owner+w=401wt.eu-S1759565AbZKYTUU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759565AbZKYTUU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 14:20:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759457AbZKYTUT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 14:20:19 -0500
Received: from ey-out-2122.google.com ([74.125.78.26]:49553 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759171AbZKYTUR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 14:20:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=rkUIUvI33M6UfKB3KoBjpBnF42IWkJpUdYy2JKTP7WlGVEp6rcBRCEmXSiROmZFfvi
         1db0OPjQmgU6d0UqeONbN0mvhutGDUMbT0NH/TeBrnDLy7oVa8OGyQ0wuGuAgaxjf1qb
         bGFk9PCeChA58X/X4CGAnuZAgogUgyR2Z6XTE=
MIME-Version: 1.0
In-Reply-To: <20091125141505.GH9482@parisc-linux.org>
References: <200911252209432039291@gmail.com> <20091125141505.GH9482@parisc-linux.org>
From: =?ISO-8859-1?Q?J=E9r=E9my_Cochoy?= <jeremy.cochoy@gmail.com>
Date: Wed, 25 Nov 2009 20:20:02 +0100
Message-ID: <a229bc400911251120y220066afjb10d391198c5807c@mail.gmail.com>
Subject: Re: [PATCH 1/3]fs/inode: iunique() Optimize Performance
To: Matthew Wilcox <matthew@wil.cx>
Cc: Liuweni <qingshenlwy@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       strongzgy <strongzgy@gmail.com>, xgr178 <xgr178@163.com>,
       Liu Hui <onlyflyer@gmail.com>, viro <viro@zeniv.linux.org.uk>,
       akpm <akpm@linux-foundation.org>, jack <jack@suse.cz>,
       npiggin <npiggin@suse.de>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

There is something strange in iunique : what will happend if all inode
between max_reserved+1 and (unsinged in)(0-1) ? Will it make an
infinite loop or an interruption can happen and make an inode become
free?

In that case, it will be better to stop search when counter overflow, no?

Will it not be better to use a field max_ino_used (in superblock, for
exemple) where we store the last inode allocated with iunique and make
a search only if max_ino_used become to (unsigned)(-1) ?

But, if iunique is here to provide a solution in order to generate
unused inode in filesystem which have various inode number, it's
better to use a list of used ino, in a short hash table which use the
first 8 bits of the inode, always use the same function to create a
new inode and look at the head if we can add a new inode with bigger
ino and still in the range. (But i think filesystems developper prefer
to write ther own functions in order to do that, no?)

Well, if we want to stop in case of full inode filesystem, we can put
the first condition in the head and add change return as :
return inode->i_ino > max_reserved ? res : 0; // 0 might "i can't find
an inode after max_reserved"

2009/11/25 Matthew Wilcox <matthew@wil.cx>:
> On Wed, Nov 25, 2009 at 10:09:45PM +0800, Liuweni wrote:
>> ---
>> move the if condition out the while{}.
>> While the function executing, the if
>> condition won't check again and again.
>> And this code won't change the function
>> of iunique().
>
> That's not true.
>
>> @@ -838,9 +838,10 @@ ino_t iunique(struct super_block *sb, ino_t max_reserved)
>>       ino_t res;
>>
>>       spin_lock(&inode_lock);
>> +
>> +     if (counter <= max_reserved)
>> +             counter = max_reserved + 1;
>>       do {
>> -             if (counter <= max_reserved)
>> -                     counter = max_reserved + 1;
>>               res = counter++;
>
> 'counter' is incremented here, so if it wraps around, we'll blunder into
> the reserved space again.
>
>>               head = inode_hashtable + hash(sb, res);
>>               inode = find_inode_fast(sb, head, res);
>>
>>
>> --------------
>> Best Regards,
>> Liuweni
>> 2009-11-25
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
> --
> Matthew Wilcox                          Intel Open Source Technology Centre
> "Bill, look, we understand that you're interested in selling us this
> operating system, but compare it to ours.  We can't possibly take such
> a retrograde step."
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
Jérémy Cochoy - L1 MI (Lyon1)
Mail : jeremy.cochoy@gmail.com
Tel : 06-43-01-74-02
Alias Zenol - http://zenol.fr
