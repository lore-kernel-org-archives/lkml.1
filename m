Return-Path: <linux-kernel-owner+w=401wt.eu-S1760545AbZFXAJl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760545AbZFXAJl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 20:09:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757996AbZFXAJe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 20:09:34 -0400
Received: from hera.kernel.org ([140.211.167.34]:44291 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755788AbZFXAJe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 20:09:34 -0400
Message-ID: <4A416E5B.5060206@kernel.org>
Date: Wed, 24 Jun 2009 09:07:55 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, fuse-devel@lists.sourceforge.net,
       miklos@szeredi.hu, npiggin@suse.de
Subject: Re: [PATCH 3/4] FUSE: implement fuse_req->prep()
References: <1245317073-24000-1-git-send-email-tj@kernel.org>	<1245317073-24000-4-git-send-email-tj@kernel.org> <20090623165657.5e42cd71.akpm@linux-foundation.org>
In-Reply-To: <20090623165657.5e42cd71.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 24 Jun 2009 00:07:57 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Andrew Morton wrote:
> On Thu, 18 Jun 2009 18:24:32 +0900
> Tejun Heo <tj@kernel.org> wrote:
> 
>> Implement ->prep() which is the opposite equivalent of ->end().
> 
> The opposite of "end" is "begin".  I'd expect to see a sequence like
> 
> 	-> prep
> 	-> begin
> 	-> end
> 
> so the naming choice here is unexpected.

Yes, indeed.  I'll look for a better name.

>>  It's
>> called right before the request is passed to userland server in the
>> kernel context of the server.  ->prep() can fail the request without
>> disrupting the whole channel.
>>
>> This will be used by direct mmap implementation.
> 
>> ...
>>
>> --- a/fs/fuse/fuse_i.h
>> +++ b/fs/fuse/fuse_i.h
>> @@ -292,6 +292,12 @@ struct fuse_req {
>>  	/** Link on fi->writepages */
>>  	struct list_head writepages_entry;
>>  
>> +	/** Request preparation callback.  Called from the kernel
>> +	    context of the FUSE server before passing the request to
>> +	    the FUSE server.  Non-zero return from this function will
>> +	    fail the request. */
>> +	int (*prep)(struct fuse_conn *, struct fuse_req *);
>> +
>>  	/** Request completion callback.  This function is called from
>>  	    the kernel context of the FUSE server if the request isn't
>>  	    being aborted.  If the request is being aborted, it's
> 
> Why the strange comment layout?  Does kerneldoc actually recognise and
> appropriately process this text?  if not, please do
> 
> 	/*
> 	 * Request preparation callback.  Called from the kernel
> 	 * context of the FUSE server before passing the request to
> 	 * the FUSE server.  Non-zero return from this function will
> 	 * fail the request.
> 	 */
> 
> If that looks odd then, well, that wasn't your fault ;)

I usually try to conform to the surrounding style so that new stuff at
least is consistent with the rest (and maintainers tend to feel
happier that way) but yeah this can cause confusion to kerneldoc
handling.  I'll add a patch to change the style.

Thanks.

-- 
tejun
