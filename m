Return-Path: <linux-kernel-owner+w=401wt.eu-S934692AbYCFOgc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934692AbYCFOgc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 09:36:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934079AbYCFOgK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 09:36:10 -0500
Received: from viefep18-int.chello.at ([213.46.255.22]:3969 "EHLO
	viefep18-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932238AbYCFOgG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 09:36:06 -0500
X-SourceIP: 78.42.105.25
Message-ID: <47D0014D.1060901@trash.net>
Date: Thu, 06 Mar 2008 15:35:57 +0100
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla-Thunderbird 2.0.0.6 (X11/20071008)
MIME-Version: 1.0
To: Pekka J Enberg <penberg@cs.helsinki.fi>
CC: Netfilter Development Mailinglist 
	<netfilter-devel@vger.kernel.org>,
       clameter@sgi.com, joe@perches.com, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [PATCH] netfilter: replace horrible hack with ksize()
References: <Pine.LNX.4.64.0803052319210.15759@sbz-30.cs.Helsinki.FI> <47CFF9B7.5060803@trash.net> <Pine.LNX.4.64.0803061612290.4202@sbz-30.cs.Helsinki.FI> <Pine.LNX.4.64.0803061618090.4378@sbz-30.cs.Helsinki.FI>
In-Reply-To: <Pine.LNX.4.64.0803061618090.4378@sbz-30.cs.Helsinki.FI>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pekka J Enberg wrote:
> On Thu, 6 Mar 2008, Pekka J Enberg wrote:
>>>> -	if (newlen >= ct->ext->real_len) {
>>>> +	if (newlen >= ksize(ct->ext)) {
>>> This needs to look at the currently allocated size, otherwise
>>> it will always realloc when adding new extensions after having
>>> used up ksize(ct->ext) space.
>> Lets say you
>>
>>   p = kmalloc(8, ...);
>>
>> Then ksize(p) will return the currently allocated size which is 32 bytes 
>> when page size is 4 KB, and not 8 bytes. So it should be equivalent of 
>> what the current code does.
>>
>> What am I missing here?
> 
> Ok, it's not equivalent. We have two sizes: object size (8 bytes) and 
> buffer size (32 bytes) here. In netfilter, ->real_len is same as object 
> size, not buffer size as ksize() is.
> 
> But now I am officially even more confused, why does the netfilter code 
> decided whether to reallocate based on _object size_ and not _buffer size_ 
> (as krealloc() does, for example)?


It decides to reallocate when the remaining space isn't enough
to hold the new data. NF_CT_EXT_MIN_SIZE is used to make sure it
doesn't allocate anything smaller than the minimum slab size and
hopefully avoid reallocations in the future. Unless I'm
misunderstanding what ksize() does, the easiest way to get
rid of this would be to replace NF_CT_EXT_MIN_SIZE by ksize(0).

Even better would be to not only avoid waste on the first allocation,
but also on reallocations. This would look something like this:

__nf_ct_ext_add():
{
         struct nf_ct_ext *new;
-       int i, newlen, newoff;
+	int i, newlen, newoff, reallen;
...
         if (newlen >= ct->ext->real_len) {
+		reallen = ksize(newlen);
-               new = kmalloc(newlen, gfp);
+		new = kmalloc(reallen, gfp);
                 if (!new)
                         return NULL;
...
-               new->real_len = newlen;
+		new->real_len = reallen;
                 ct->ext = new;
         }

