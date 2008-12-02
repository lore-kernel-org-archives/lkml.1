Return-Path: <linux-kernel-owner+w=401wt.eu-S1755916AbYLBRJ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755916AbYLBRJ0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 12:09:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754826AbYLBRJP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 12:09:15 -0500
Received: from mail.tmr.com ([64.65.253.246]:40342 "EHLO partygirl.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751631AbYLBRJO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 12:09:14 -0500
Message-ID: <49356B96.7070900@tmr.com>
Date: Tue, 02 Dec 2008 12:08:38 -0500
From: Bill Davidsen <davidsen@tmr.com>
Organization: TMR Associates Inc, Schenectady NY
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.18) Gecko/20081112 Fedora/1.1.13-1.fc9 SeaMonkey/1.1.13
MIME-Version: 1.0
To: Theodore Tso <tytso@mit.edu>, roel kluin <roel.kluin@gmail.com>,
       davidsen@tmr.com, adilger@sun.com, linux-ext4@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] ext3, ext4: do_split() fix loop, with obvious	unsigned
 wrap
References: <49343AD9.4020606@gmail.com> <20081202132441.GC16172@mit.edu>
In-Reply-To: <20081202132441.GC16172@mit.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Theodore Tso wrote:
> On Mon, Dec 01, 2008 at 02:28:25PM -0500, roel kluin wrote:
>   
>> Fix loop, with obvious unsigned wrap
>>
>> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
>>     
>
> Um, no.  Sorry, I didn't have a chance to reply earlier but this is
> obviously wrong.
>
>   
Sorry, you are reading it wrong, the i values inside the loop are 
identical to those in the original. The value of i starts at count, and 
the test comes *before* the value is used inside the loop. The values of 
i inside the loop start at count-1 and go to zero, just as it did in the 
original. That's why the "i--" is there, the test is on the 
unincremented value range count to one, but the value inside the loop is 
correct (or at least is the same as the original patch).
>> ---
>> diff --git a/fs/ext3/namei.c b/fs/ext3/namei.c
>> index 3e5edc9..b0dcfb3 100644
>> --- a/fs/ext3/namei.c
>> +++ b/fs/ext3/namei.c
>> @@ -1188,7 +1188,7 @@ static struct ext3_dir_entry_2 *do_split(handle_t *handle, struct inode *dir,
>>  	/* Split the existing block in the middle, size-wise */
>>  	size = 0;
>>  	move = 0;
>> -	for (i = count-1; i >= 0; i--) {
>> +	for (i = count; i--; ) {
>>  		/* is more than half of this entry in 2nd half of the block? */
>>  		if (size + map[i].size/2 > blocksize/2)
>>  			break;
>>     
>
> Note that i is actually **used** in the loop?  So changing the
> starting value of the counter without also adjusting all of the places
> where i is used will cause the code to break, and in hard to find
> ways...
>
>   
As I said, the values used are identical, and the code works correctly.
> Given that there are two loop termination conditions, and in fact the
> one in the loop is the one that actually gets used 99% of the time
> (which is why we've never noticed the problem in real life), probably
> the best way of handling this is to recast it not as a for loop, but
> as a while loop.
>
> 						- Ted
>
>   


-- 
Bill Davidsen <davidsen@tmr.com>
  "Woe unto the statesman who makes war without a reason that will still
  be valid when the war is over..." Otto von Bismark 


