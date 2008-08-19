Return-Path: <linux-kernel-owner+w=401wt.eu-S1757140AbYHSBSU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757140AbYHSBSU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 21:18:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753873AbYHSBSD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 21:18:03 -0400
Received: from wr-out-0506.google.com ([64.233.184.236]:52479 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753131AbYHSBSB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 21:18:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=MiGWhHV4pUou0AblU5PwAIFMOAxfxRelsDfeeFYgt05WLY/UyW8pgoVoJAOWlRGUVU
         IfxVEJrijeL7pMs6UjBuLG+VDMWWx/rmKl4OFdAHjJQ9g8g2JMFddj4+GalnPCMBoQYD
         wHKmH84kXvmpPoj3ANKYHN/tD1Rhq8/rl2+Xg=
Message-ID: <21d7e9970808181817n1d67dc33s58b8d07f63e411a7@mail.gmail.com>
Date: Tue, 19 Aug 2008 11:17:59 +1000
From: "Dave Airlie" <airlied@gmail.com>
To: "Nick Piggin" <nickpiggin@yahoo.com.au>
Subject: Re: [PATCH] Export shmem_file_setup and shmem_getpage for DRM-GEM
Cc: "Keith Packard" <keithp@keithp.com>,
       "Christoph Hellwig" <hch@infradead.org>,
       "Eric Anholt" <eric@anholt.net>, linux-kernel@vger.kernel.org
In-Reply-To: <200808051443.11858.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1217573919-7496-1-git-send-email-eric@anholt.net>
	 <200808041902.23970.nickpiggin@yahoo.com.au>
	 <1217887116.24714.118.camel@koto.keithp.com>
	 <200808051443.11858.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 5, 2008 at 2:43 PM, Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> On Tuesday 05 August 2008 07:58, Keith Packard wrote:
>> On Mon, 2008-08-04 at 19:02 +1000, Nick Piggin wrote:
>> > > I suppose we could have user space allocate the shmem file (either via
>> > > tmpfs or sysv ipc). tmpfs suffers from the maxfd issue, while sysv ipc
>> > > runs up against the SHMMAX value.
>> >
>> > This is how I'd suggested it work as well. I think a little bit
>> > more effort should be spent looking at making this work.
>>
>> Well, I've spent a day thinking about using existing user-space APIs to
>> get at shmem files. While it's nice that we've discovered a
>> filesystem-independent mechanism to pin file pages, we haven't found
>> anything similar for creating the files. In particular, what I want is:
>>
>>  1) Anonymous files backed by swap
>>  2) Freed when the last process using them exits
>>  3) That never appear in the file system
>>  4) Do not consume a low FD (yeah, I know, rewrite the desktop)
>>
>> So, what I could do is
>>
>>       char    template[] = "/dev/shm/drm-XXXXXX";
>>       int     fd;
>>       fd = mkstemp (template);
>>       unlink (template);
>>       ftruncate (fd, size)
>>       object = drm_create_an_object_for_a_file (fd);
>>       close (fd);
>>
>> While I haven't written any code yet, this should work and will even be
>> compatible with my current user-space API. I have to create a DRM object
>> for the file in any case, and so I don't need to hold onto the fd.
>> Releasing the fd also eliminates any ulimit issues.
>>
>> The drm_create_an_object_for_a_file call could return another fd. But,
>> note that the original shmem fd has no real value to the application in
>> this case.
>>
>> I can imagine other cases where mapping non-shmem files would make sense
>> though, in particular it's fairly easy to envision mapping an image file
>> to the GTT and having the graphics process decode and display it without
>> any additional copies. I think this demonstrates the potential utility
>> of the general file mapping operation.
>>
>> But, I'd like to have you reconsider whether it makes sense for user
>> space to go through the above dance to create anonymous shared objects
>> when the kernel already supports precisely the desired semantics and
>> even exposes them to the ipc/shm implementation.
>
> In my opinion, doing this little song and dance (which is a few lines
> of quite well defined APIs, btw) in userspace is preferable to adding
> a single line or exporting a single function in kernel space. Unless
> there is a better reason than eliminating a few lines of userspace code.

Now I also have to do the same song and dance for in-kernel allocated objects?
still think this is acceptable... I'm not even sure what vfs calls I
really need in-kernel to do that.

If someone codes up the in-kernel path to do this using 4-5 API calls
instead of one exported
function that IPC/SHM already does then maybe we can gauge the uglyness vs that.

Dave.

>
> I'm absolutely not against exporting a nice API for a swappable, object
> based memory allocator using ipc or shm to the wider kernel (with a nice
> API rather than just using shmem functions directly of course). But the
> fact that most or all of this seems to be able to be done in userspace
> just tells me that's where it should be prototyped first. It adds
> nothing to maintainence costs of the kernel code, and might actually be
> helpful to show some shortcomings of our user API definition or
> implementation.
>
> In the worst case it completely fails, the effort will still show much
> better how and why it needs to be done in kernel.
